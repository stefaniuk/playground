#!/bin/bash

# `readlink -f` alternative
function abspath() { pushd . > /dev/null; if [ -d "$1" ]; then cd "$1"; dirs -l +0; else cd "`dirname \"$1\"`"; cur_dir=`dirs -l +0`; if [ "$cur_dir" == "/" ]; then echo "$cur_dir`basename \"$1\"`"; else echo "$cur_dir/`basename \"$1\"`"; fi; fi; popd > /dev/null; }

# constants
[ -z "$MINTLEAF_HOME" ] && MINTLEAF_HOME=$(dirname $(dirname $(abspath $0)))
_LOG_NAME="mintleaf-test"

# $args variable is used globally
args=$*

# includes
source $MINTLEAF_HOME/bin/bootstrap

# arguments
all=$result_neg
module=""
while [ "$1" != "" ]; do
    case $1 in
        -a|--all)       all=$result_pos
                        ;;
        -m|--module)    shift; module=$1
    esac
    shift
done

# run tests
log=/tmp/mintleaf-test.$$
if [ "$all" == $result_neg ] && [ -z "$module" ]; then
    # test mintleaf module
    echo "Testing mintleaf module..."
    _test_module "mintleaf" $args 2>&1 | tee -a $log
elif [ "$all" == $result_neg ] && [ -n "$module" ]; then
    # test selected module
    echo "Testing $module module..."
    _test_module "$module" $args 2>&1 | tee -a $log
elif [ "$all" == $result_pos ]; then
    # test all modules
    echo "Testing all modules..."
    for module in $(list_modules); do
        _test_module "$module" $args 2>&1 | tee -a $log
    done
fi

# process result
count_failed=$(cat $log | grep "^test_" | grep -v "ok$" | wc -l | sed 's/^[ ]*//g')
count_passed=$(cat $log | grep "^test_" | grep "ok$" | wc -l | sed 's/^[ ]*//g')
rm -f $log
if [ $count_failed -gt 0 ]; then
    echo "$count_passed tests passed, $count_failed tests failed"
    result=1
else
    echo "$count_passed tests passed"
    result=0
fi

exit $result
