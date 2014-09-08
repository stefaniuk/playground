#!/bin/bash

#   ./convert-outstatding.sh 2>&1 | tee ./convert-outstatding.log

# ą    C485
# Ą    C484
# ć E6 C487
# Ć    C486
# ę AE C499
# Ę    C498
# Ń    C583
# ń F1 C584
# Ł    C581
# ł    C582
# ó F3 C3B3
# Ó    C393
# Ś    C59A
# ś    C59B
# Ź    C5B9
# ź    C5BA
# ż    C5BC
# Ż    C5BB


function convert_file {
    FILE=$1
    sed "s/\xE6/\xC4\x87/g" $FILE > $FILE.tmp1
    mv $FILE.tmp1 $FILE.tmp2
    sed "s/\xEA/\xC4\x99/g" $FILE.tmp2 > $FILE.tmp1
    mv $FILE.tmp1 $FILE.tmp2
    sed "s/\xF1/\xC5\x84/g" $FILE.tmp2 > $FILE.tmp1
    mv $FILE.tmp1 $FILE.tmp2
    sed "s/\xF3/\xC3\xB3/g" $FILE.tmp2 > $FILE.tmp1
    mv $FILE.tmp1 $FILE
    rm $FILE.tmp2
}
WORKING_DIR=`pwd`
cd /srv/hosting/domains/mhaker.pl/usr/local/domains/mhaker.pl
FILES=`find ./ -type f -name "*.php" | sort | uniq`
for FILE in $FILES; do
    echo $FILE
    convert_file $FILE
done
FILES=`find ./ -type f -name "*.html" | sort | uniq`
for FILE in $FILES; do
    echo $FILE
    convert_file $FILE
done
FILES=`find ./ -type f -name "*.js" | sort | uniq`
for FILE in $FILES; do
    echo $FILE
    convert_file $FILE
done
cd $WORKING_DIR
