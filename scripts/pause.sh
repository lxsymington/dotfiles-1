#!/bin/bash

if [ $(uname) == 'Darwin' ]; then
    spotify pause
else
    SPOTIFY=`ps aux | grep 'spotify\|Spotify' | grep -v grep`

    if [ "$SPOTIFY" ]; then
        playerctl pause
    else
        spotify
    fi
fi