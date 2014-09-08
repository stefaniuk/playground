#!/bin/bash

[ -h $2 ] && rm $2
ln -s $1 $2 && echo Create link from $2 to $1
