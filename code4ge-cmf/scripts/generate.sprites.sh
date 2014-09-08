#!/bin/bash

echo Generate sprites from option file $2
java -classpath $1/utils/com.code4ge.webtools.jar:$1/utils/com.code4ge.json.jar:$1/utils/com.code4ge.args4j.jar:$1/utils/commons-lang-2.5.jar \
	com.code4ge.webtools.sprite.Build --image-magick-dir /usr/bin --option-file $2
