#!/bin/sh

################################################################################
# functions

function system_detect {

    # set defalut values
    OS=$(uname)
    DIST="unknown"
    DIST_BASED_ON="unknown"
    PSEUDO_NAME="unknown"
    VERSION="unknown"
    ARCH=$(uname -m)
    ARCH_NAME="unknown" # can be "i386" or "amd64"
    KERNEL=$(uname -r)

    # mac os x
    if [[ "$OSTYPE" == "darwin"* ]]; then

        OS="unix"
        DIST="macosx"
        DIST_BASED_ON="bsd"
        [[ $(sw_vers -productVersion | \grep 10.8  | wc -l) -gt 0 ]] && PSEUDO_NAME="Mountain Lion"
        [[ $(sw_vers -productVersion | \grep 10.9  | wc -l) -gt 0 ]] && PSEUDO_NAME="Mavericks"
        [[ $(sw_vers -productVersion | \grep 10.10 | wc -l) -gt 0 ]] && PSEUDO_NAME="Yosemite"
        VERSION=$(sw_vers -productVersion)
        ARCH_NAME="i386"
        [[ $(uname -m | \grep 64 | wc -l) -gt 0 ]] && ARCH_NAME="amd64"

    # debian family
    elif [[ -f /etc/debian_version ]]; then

        local id=$(cat /etc/os-release | \grep "^ID=" | awk -F= '{ print $2 }')
        if [[ "$id" == "debian" ]] || [[ "$id" == "raspbian" ]]; then
            DIST=$id
            PSEUDO_NAME=$(cat /etc/os-release | \grep "^VERSION=" | awk -F= '{ print $2 }' | \grep -oEi '[a-z]+')
            VERSION=$(cat /etc/debian_version)
        else
            DIST=$(cat /etc/lsb-release | \grep '^DISTRIB_ID' | awk -F= '{ print $2 }')
            PSEUDO_NAME=$(cat /etc/lsb-release | \grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }')
            VERSION=$(cat /etc/lsb-release | \grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }')
        fi
        DIST_BASED_ON="debian"
        ARCH_NAME="i386"
        [[ $(uname -m | \grep 64 | wc -l) -gt 0 ]] && ARCH_NAME="amd64"

    # redhat family
    elif [[ -f /etc/redhat-release ]]; then

        DIST=$(cat /etc/redhat-release | sed s/\ release.*// | tr "[A-Z]" "[a-z]")
        [[ "$DIST" == *"red"* ]] && DIST="redhat"
        [[ "$DIST" == *"centos"* ]] && DIST="centos"
        [[ "$DIST" == *"scientific"* ]] && DIST="scientific"
        DIST_BASED_ON="redhat"
        PSEUDO_NAME=$(cat /etc/redhat-release | sed s/.*\(// | sed s/\)//)
        VERSION=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
        ARCH_NAME="i386"
        [[ $(uname -m | \grep 64 | wc -l) -gt 0 ]] && ARCH_NAME="amd64"

    # cygwin
    elif [[ "$OSTYPE" == "cygwin"* ]]; then

        OS="windows"
        DIST="cygwin"
        DIST_BASED_ON="linux"
        PSEUDO_NAME="Windows"
        VERSION=$(cmd /c ver | \grep -oEi '[0-9]+\.[0-9]+\.[0-9]+')
        ARCH_NAME="i386"
        [ $(uname -m | \grep 64 | wc -l) -gt 0 ] && ARCH_NAME="amd64"
        KERNEL=$(uname -r | \grep -oEi '[0-9]+\.[0-9]+\.[0-9]+')

    fi

    # convert it to lowercase
    export OS=$(echo $OS | tr "[A-Z]" "[a-z]")
    export DIST=$(echo $DIST | tr "[A-Z]" "[a-z]")
    export DIST_BASED_ON=$(echo $DIST_BASED_ON | tr "[A-Z]" "[a-z]")
    export PSEUDO_NAME=$(echo $PSEUDO_NAME | tr "[A-Z]" "[a-z]")
    export VERSION=$(echo $VERSION | tr "[A-Z]" "[a-z]")
    export ARCH=$(echo $ARCH | tr "[A-Z]" "[a-z]")
    export ARCH_NAME=$(echo $ARCH_NAME | tr "[A-Z]" "[a-z]")
    export KERNEL=$(echo $KERNEL | tr "[A-Z]" "[a-z]")
}

function system_info {

    echo "OS: $OS"
    echo "DIST: $DIST"
    echo "DIST BASED ON: $DIST_BASED_ON"
    echo "PSEUDO NAME: $PSEUDO_NAME"
    echo "VERSION: $VERSION"
    echo "ARCH: $ARCH"
    echo "ARCH NAME: $ARCH_NAME"
    echo "KERNEL: $KERNEL"
}

function system_test {

    # get optional parameters
    local skip_selected_tests="n"
    while [ "$1" != "" ]; do
        case $1 in
            --skip-selected-tests)  skip_selected_tests="y"
                                    ;;
        esac
        shift
    done

    source $SHELL_FUSION_HOME/lib/asserts.sh

    print_h1 "Run tests...\n"
    system_info
    printf "\n"

    local log=$SHELL_FUSION_TMP_DIR/shell-fusion-test-log.$$
    trap "rm -f $log" EXIT

    (
        assert_prog_exists "awk"
        assert_prog_exists "bc"
        assert_prog_exists "cat"
        assert_prog_exists "chmod"
        assert_prog_exists "cut"
        assert_prog_exists "du"
        assert_prog_exists "echo"
        assert_prog_exists "expr"
        assert_prog_exists "find"
        assert_prog_exists "grep"
        assert_prog_exists "head"
        assert_prog_exists "ln"
        assert_prog_exists "ls"
        assert_prog_exists "pcregrep"
        assert_prog_exists "perl"
        assert_prog_exists "printf"
        assert_prog_exists "sed"
        assert_prog_exists "sort"
        assert_prog_exists "strip"
        assert_prog_exists "sudo"
        assert_prog_exists "test"
        assert_prog_exists "tr"
        assert_prog_exists "wc"
        if [ "$DIST" == "macosx" ]; then
            assert_prog_exists "dscl"
            assert_prog_exists "dseditgroup"
            assert_prog_exists "ruby"
        fi
        if [ "$OS" == "linux" ]; then
            assert_prog_exists "groupadd"
            assert_prog_exists "useradd"
            assert_prog_exists "userdel"
        fi
    ) 2>&1 | tee -a $log
    local count_programs_found=$(cat $log | removecc | \grep "^program " | \grep "ok$" | wc -l | sed "s/^[ ]*//g")
    local count_programs_missing=$(cat $log | removecc | \grep "^program " | \grep -v "ok$" | wc -l | sed "s/^[ ]*//g")
    if [ $count_programs_missing -gt 0 ]; then
        print_h2 "$count_programs_found programs found, $count_programs_missing missing\n"
        return 1
    else
        print_h2 "$count_programs_found programs found\n"
    fi

    for file in $(\ls -1 $SHELL_FUSION_HOME/test/*.test 2> /dev/null); do
        [ -x $file ] && $file $skip_selected_tests 2>&1 | tee -a $log
    done
    local count_passed=$(cat $log | removecc | \grep "^test " | \grep "ok$" | wc -l | sed "s/^[ ]*//g")
    local count_skipped=$(cat $log | removecc | \grep "^test " | \grep " skip" | wc -l | sed "s/^[ ]*//g")
    local count_failed=$(cat $log | removecc | \grep "^test " | \grep -v "ok$" | \grep -v " skip" |  wc -l | sed "s/^[ ]*//g")
    if [ $count_failed -gt 0 ]; then
        print_h2 "$count_passed tests passed, $count_skipped skipped, $count_failed failed\n"
        return 1
    else
        print_h2 "$count_passed tests passed, $count_skipped skipped\n"
    fi

    return 0
}

################################################################################
# exports

export SHELL_FUSION_VERSION="0.5.0.BUILD-SNAPSHOT"
export SHELL_FUSION_HOME=${SHELL_FUSION_HOME-/usr/local/shell-fusion}
export SHELL_FUSION_CACHE_DIR=$SHELL_FUSION_HOME/.cache
export SHELL_FUSION_TMP_DIR=/tmp

################################################################################
# main

# detect system
system_detect

# update PATH variable
if [[ $(echo $PATH | \grep $SHELL_FUSION_HOME | wc -l) -eq 0 ]]; then
    export PATH=$SHELL_FUSION_HOME/bin:$PATH
fi
