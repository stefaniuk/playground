#!/bin/bash

files=$(find ./ -iname *.mp3)
for file in $files; do
    mkdir -p $(dirname ~/mp3.conv/$file)
    lame --mp3input -b 48 $file ~/mp3.conv/$file
done
