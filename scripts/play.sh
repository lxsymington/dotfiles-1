#!/bin/bash

if [ $(uname) == 'Darwin' ]; then
    spotify play
else
    SPOTIFY=`ps aux | grep 'spotify\|Spotify' | grep -v grep`

    if [ "$SPOTIFY" ]; then
        playerctl play-pause
    else
        spotify
    fi
fi
