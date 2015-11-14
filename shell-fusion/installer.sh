#!/bin/bash

# exit if script is sourced
[ -n "$BASH_SOURCE" ] && [ "$(basename -- "$0")" != "installer.sh" ] && exit 1

################################################################################
# variables

GITHUB_REPOSITORY_ACCOUNT="stefaniuk"
GITHUB_REPOSITORY_NAME="shell-fusion"
SHELL_FUSION_HOME=${SHELL_FUSION_HOME-/usr/local/shell-fusion}
program_dir=$(cd "$(dirname "$0" 2> /dev/null)"; pwd)
arg_do_not_run_tests=$(echo "$*"  | grep -o -- "--do-not-run-tests")
arg_skip_selected_tests=$(echo "$*"  | grep -o -- "--skip-selected-tests")
arg_force_download=$(echo "$*" | grep -o -- "--force-download")
arg_sudo=$(echo "$*" | grep -o -- "--sudo")
arg_help=$(echo "$*" | grep -o -- "--help")

################################################################################
# functions

function usage {

    local file=$(basename $0 2> /dev/null)

    echo "
File: ${file}

Usage:
    ${file} [options]

Options:
    --do-not-run-tests
    --skip-selected-tests
    --force-download
    --sudo
    --help
"

    exit 0
}

function sudo_keep_alive {

    # update user's time stamp, prompting for password if necessary
    sudo -v
    # keep-alive until script has finished then invalidate sudo session
    while true; do
        sudo -n true
        sleep 1
        if ! kill -0 "$$"; then
            sudo -k
            exit
        fi
    done 2>/dev/null &
}

function program_download {

    printf "Download $GITHUB_REPOSITORY_NAME\n\n"

    sudo mkdir -p $SHELL_FUSION_HOME
    sudo chown $USER $SHELL_FUSION_HOME
    curl -L \
        "https://github.com/${GITHUB_REPOSITORY_ACCOUNT}/${GITHUB_REPOSITORY_NAME}/tarball/master" \
        -o $SHELL_FUSION_HOME/$GITHUB_REPOSITORY_NAME.tar.gz
    tar -zxf $SHELL_FUSION_HOME/$GITHUB_REPOSITORY_NAME.tar.gz -C ~
    rm -f $SHELL_FUSION_HOME/$GITHUB_REPOSITORY_NAME.tar.gz
    sudo cp -rf ~/$GITHUB_REPOSITORY_ACCOUNT-$GITHUB_REPOSITORY_NAME-*/* $SHELL_FUSION_HOME
    rm -rf ~/$GITHUB_REPOSITORY_ACCOUNT-$GITHUB_REPOSITORY_NAME-*
}

function program_synchronise {

    printf "Synchronise $GITHUB_REPOSITORY_NAME\n\n"

    sudo mkdir -p $SHELL_FUSION_HOME
    sudo rsync -rav \
        --include=/ \
        --exclude=/.git* --exclude=/README.md --exclude=/LICENCE \
        $program_dir/* \
        $SHELL_FUSION_HOME

    printf "\n"
}

function program_configure {

    [ ! -d $SHELL_FUSION_CACHE_DIR ] && mkdir -p $SHELL_FUSION_CACHE_DIR

    find $SHELL_FUSION_HOME -maxdepth 2 -type f -iname '.git*' | xargs rm -f
    sudo chmod +x $SHELL_FUSION_HOME/installer.sh

    [ -d $SHELL_FUSION_HOME/bin ] && sudo chmod +x $SHELL_FUSION_HOME/bin/*
    [ -d $SHELL_FUSION_HOME/test ] && sudo chmod +x $SHELL_FUSION_HOME/test/*.test
    sudo chmod +x $SHELL_FUSION_HOME/lib/json.sh

    [ "$OS" == "linux" ] && sudo rm $SHELL_FUSION_HOME/bin/{md5sum,sha*sum} 2> /dev/null
}

################################################################################
# main

[ -n "$arg_help" ] && usage
[ -n "$arg_sudo" ] && sudo_keep_alive

if [ -z "$BASH_SOURCE" ] || [ -n "$arg_force_download" ]; then

    # download from repository
    program_download

elif [[ $program_dir == */projects/$GITHUB_REPOSITORY_NAME ]]; then

    # synchronise with project
    program_synchronise

    arg_skip_selected_tests="--skip-selected-tests"

fi

# includes
source $SHELL_FUSION_HOME/shell-fusion.sh

# perform post-install configuration
program_configure

# run tests
if [ -z "$arg_do_not_run_tests" ]; then
    system_test "$arg_skip_selected_tests"
    exit $?
fi

exit 0
