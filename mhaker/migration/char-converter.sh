#!/bin/bash

FILE_IN=$1
FILE_OUT=$2
MODE=$3

if [ "$FILE_IN" == "" ] || [ "$FILE_OUT" == "" ] || [ "$MODE" == "" ]; then
    echo "Usage: char-converter.sh src_file dest_file mode"
    exit 1
fi

HEX_ARRAY=
COUNT=0
CHARS=`cat $HOST4GE_DIR/tools/letters-unknown.txt`
for CHAR in $CHARS; do
    HEX=`echo $CHAR | od -tx2 | grep "000a" | awk '{ print $2 }'`
    HEX_ARRAY[$COUNT]=$HEX
    COUNT=`expr $COUNT + 1`
done

HEX_UNICODE_ARRAY=
COUNT=0
CHARS_UNICODE=`cat $HOST4GE_DIR/tools/letters-unicode.txt`
for CHAR in $CHARS_UNICODE; do
    HEX=`echo $CHAR | od -tx2 | grep "000a" | awk '{ print $2 }'`
    HEX_UNICODE_ARRAY[$COUNT]=$HEX
    COUNT=`expr $COUNT + 1`
done

HEX_NORMAL_ARRAY=
COUNT=0
CHARS_NORMAL=`cat $HOST4GE_DIR/tools/letters-normal.txt`
for CHAR in $CHARS_NORMAL; do
    HEX=`echo $CHAR | od -tx2 | grep "0a" | awk '{ print $2 }'`
    HEX_NORMAL_ARRAY[$COUNT]=$HEX
    COUNT=`expr $COUNT + 1`
done

echo "processing file $FILE_IN"
#echo "  output file $FILE_OUT"
cp -f $FILE_IN $FILE_OUT
COUNT=0
for CHAR in $CHARS; do

    FROM_B1=${HEX_ARRAY[$COUNT]}
    FROM_B1=${FROM_B1:2:2}
    FROM_B2=${HEX_ARRAY[$COUNT]}
    FROM_B2=${FROM_B2:0:2}

    TO_B1=${HEX_UNICODE_ARRAY[$COUNT]}
    TO_B1=${TO_B1:2:2}
    TO_B2=${HEX_UNICODE_ARRAY[$COUNT]}
    TO_B2=${TO_B2:0:2}

    TO_N=${HEX_NORMAL_ARRAY[$COUNT]}
    TO_N=${TO_N:2:2}

    NUMBER=`printf "%02d" $COUNT`

    if [ "$MODE" == "1" ]; then
        #echo "  ($NUMBER) replacing '\x${FROM_B1}\x${FROM_B2}' with '\x${TO_B1}\x${TO_B2}'"
        sed "s/\x${FROM_B1}\x${FROM_B2}/\x${TO_B1}\x${TO_B2}/g" $FILE_OUT > $FILE_OUT.tmp
    fi
    if [ "$MODE" == "2" ]; then
        #echo "  ($NUMBER) replacing '\x${FROM_B2}' with '\x${TO_B1}\x${TO_B2}'"
        sed "s/\x${FROM_B2}/\x${TO_B1}\x${TO_B2}/g" $FILE_OUT > $FILE_OUT.tmp
    fi
    if [ "$MODE" == "3" ]; then
        #echo "  ($NUMBER) replacing '\x${FROM_B1}\x${FROM_B2}' with '\x${TO_N}'"
        sed "s/\x${FROM_B1}\x${FROM_B2}/\x${TO_N}/g" $FILE_OUT > $FILE_OUT.tmp
    fi

    mv $FILE_OUT.tmp $FILE_OUT

    COUNT=`expr $COUNT + 1`
done
