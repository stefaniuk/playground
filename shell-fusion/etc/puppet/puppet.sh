#!/bin/bash

if [ $DIST == "macosx" ]; then

    :

elif [ $DIST == "ubuntu" ]; then

    :

fi

which puppet > /dev/null 2>&1 || exit 2

exit 0
