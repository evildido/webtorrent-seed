#!/bin/bash
shopt -s expand_aliases
alias webtorrent-sh="docker run --net host --name webtorrent-seed -d -it --rm -v $PWD/downloads:/downloads -u $(id -u):$(id -g) webtorrent-seed"

SOURCE=`tr '\n' ' ' < source.txt`

if [ ! "$(docker images -q -f reference=webtorrent-seed)" ]; then
    echo "Webtorrent image does not exist. Build it first"
    docker build -t webtorrent-seed .
fi

if [ ! "$(docker ps -q -f name=webtorrent-seed)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=webtorrent-seed)" ]; then
        # cleanup
        docker rm webtorrent
    fi
    # run your container
    webtorrent-sh --keep-seeding download $SOURCE
fi
