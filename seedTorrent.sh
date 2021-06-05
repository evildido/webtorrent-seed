#!/bin/bash
shopt -s expand_aliases
# First torrent port to be used by webtorrent docker 
PORT=45000

alias webtorrent-sh="docker run --net host --rm -v $PWD/downloads:/downloads -d -it -e port=1000 -u $(id -u):$(id -g) webtorrent-seed"

if [ ! -f "source.txt" ]; then
    cp source-example.txt source.txt
fi

SOURCE=`tr '\n' ' ' < source.txt`

if [ ! "$(docker images -q -f reference=webtorrent-seed)" ]; then
    echo "Webtorrent image does not exist. Build it first"
    docker build -t webtorrent-seed .
fi

if [ "$(docker ps -q -f ancestor=webtorrent-seed)" ]; then
    # cleanup if exist
    docker rm -f $(docker ps -q -f ancestor=webtorrent-seed)
fi

while read p; do
    # run on container by torrent link
    echo $p
    webtorrent-sh --torrent-port $PORT --keep-seeding download $p
    PORT=$((PORT+1))
done < source.txt