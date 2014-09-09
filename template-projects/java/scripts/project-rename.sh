#!/bin/bash

function replace_in_file() {

    local file=/tmp/replace_in_file.$$
    sed "s/$1/$2/g" $3 > $file && mv $file $3
}

function file_replace_in() {

    local str1=$1
    local str2=$2

    echo "Replace \"${str1}\" with \"${str2}\" in ${PWD}"

    for file in $(find . -type f -name "*"); do
        echo "   $file"
        replace_in_file $str1 $str2 $file
    done
}

file_replace_in "example-project-java-module-web" "$3"
file_replace_in "example-project-java" "$1"
file_replace_in "module-core" "$2"
file_replace_in "module-web" "$3"
file_replace_in "org.stefaniuk.example.project.java" "$4"

exit 0

