#!/bin/bash

# `readlink -f` alternative
function abspath() { pushd . > /dev/null; if [ -d "$1" ]; then cd "$1"; dirs -l +0; else cd "`dirname \"$1\"`"; cur_dir=`dirs -l +0`; if [ "$cur_dir" == "/" ]; then echo "$cur_dir`basename \"$1\"`"; else echo "$cur_dir/`basename \"$1\"`"; fi; fi; popd > /dev/null; }

# constants
GITHUB_REPOSITORY_ACCOUNT="stefaniuk"
GITHUB_REPOSITORY_NAME="mintleaf"
[ -z "$MINTLEAF_HOME" ] && MINTLEAF_HOME=$(dirname $(dirname $(abspath $0)))
_LOG_NAME="mintleaf-install"

result=0

# check if it runs from the installation path
if [ -f $MINTLEAF_HOME/bin/bootstrap ] && [ $(basename $(dirname $(dirname $(abspath $0)))) != "src" ]; then

    if which sudo &> /dev/null; then
        # update the user's cached credentials, authenticating the user if necessary
        sudo -v
        # keep-alive: update existing `sudo` time stamp until script has finished
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi

    # $args variable is used globally
    args=$*

    # includes
    source $MINTLEAF_HOME/bin/bootstrap

    # generic install function
    count_installed=0
    function __install_module() {

        local module=$1

        # flags
        download_parse_args $module "$args"

        # check
        if [ $module != "mintleaf" ] && \
                [ "$arg_skip_installed_packages" == $result_pos ] && \
                [ $(_is_module_installed $module $args) == $result_pos ]; then
            return;
        fi

        # install
        printf "\n"
        echo "Installing $module module..."
        _install_module $module $args
        result=${PIPESTATUS[0]}
        if [ $result -ne 0 ] && [ $arg_ignore_tests == $result_neg ]; then
            exit $result
        fi

        # test
        printf "\n"
        chmod +x $MINTLEAF_HOME/bin/test.sh
        (. $MINTLEAF_HOME/bin/test.sh --module $module $args)
        result=${PIPESTATUS[0]}
        if [ $result -ne 0 ] && [ $arg_ignore_tests == $result_neg ]; then
            exit $result
        fi

        # load
        _load_module $module

        let count_installed++
    }

    logger_info "Parse arguments"

    # arguments
    arg_ignore_tests=$(_argument_exists "--ignore-tests")
    arg_update_system=$(_argument_exists "--update-system")
    arg_update_packages=$(_argument_exists "--update-packages")
    arg_skip_installed_packages=$(_argument_exists "--skip-installed")
    arg_remove_unsupported_modules=$(_argument_exists "--remove-unsupported-modules")
    arg_remove_not_installed_modules=$(_argument_exists "--remove-not-installed-modules")
    arg_update_profile=$(_argument_exists "--update-profile")

    arg_mintleaf=$(_argument_exists "--mintleaf")
    arg_git=$(_argument_exists "--git")

    arg_httpd=$(_argument_exists "--httpd")
    arg_php=$(_argument_exists "--php")
    arg_composer=$(_argument_exists "--composer")
    arg_postgresql=$(_argument_exists "--postgresql")
    arg_openldap=$(_argument_exists "--openldap")
    arg_java7=$(_argument_exists "--java7")
    arg_java8=$(_argument_exists "--java8")
    arg_groovy=$(_argument_exists "--groovy")
    arg_spring_cli=$(_argument_exists "--spring-cli")
    arg_ant=$(_argument_exists "--ant")
    arg_maven=$(_argument_exists "--maven")
    arg_gradle=$(_argument_exists "--gradle")
    arg_ruby=$(_argument_exists "--ruby")
    arg_nodejs=$(_argument_exists "--nodejs")
    arg_subversion=$(_argument_exists "--subversion")
    arg_ddclient=$(_argument_exists "--ddclient")
    arg_scm_manager=$(_argument_exists "--scm-manager")
    arg_jenkins=$(_argument_exists "--jenkins")
    arg_nexus=$(_argument_exists "--nexus")
    arg_tomcat7=$(_argument_exists "--tomcat7")
    arg_tomcat8=$(_argument_exists "--tomcat8")
    arg_splunk=$(_argument_exists "--splunk")
    arg_activemq=$(_argument_exists "--activemq")
    arg_virtualbox=$(_argument_exists "--virtualbox")
    arg_vagrant=$(_argument_exists "--vagrant")
    arg_packer=$(_argument_exists "--packer")
    arg_spring_sts=$(_argument_exists "--spring-sts")
    arg_android_sdk=$(_argument_exists "--android-sdk")
    arg_android_studio=$(_argument_exists "--android-studio")

    # print info
    _print_system_info

    # install
    (

        logger_info "Start installation"

        # install core module
        if [ $(_is_module_installed "mintleaf") == $result_neg ] || [ "$arg_mintleaf" == $result_pos ]; then
            __install_module "mintleaf"
        fi

        [ "$arg_git" == $result_pos ] && \
            __install_module "git"

        [ "$arg_httpd" == $result_pos ] && \
            __install_module "httpd"
        [ "$arg_php" == $result_pos ] && \
            __install_module "php"
        [ "$arg_composer" == $result_pos ] && \
            __install_module "composer"
        [ "$arg_postgresql" == $result_pos ] && \
            __install_module "postgresql"
        [ "$arg_openldap" == $result_pos ] && \
            __install_module "openldap"
        [ "$arg_java7" == $result_pos ] && \
            __install_module "java7"
        [ "$arg_java8" == $result_pos ] && \
            __install_module "java8"
        [ "$arg_groovy" == $result_pos ] && \
            __install_module "groovy"
        [ "$arg_spring_cli" == $result_pos ] && \
            __install_module "spring-cli"
        [ "$arg_ant" == $result_pos ] && \
            __install_module "ant"
        [ "$arg_maven" == $result_pos ] && \
            __install_module "maven"
        [ "$arg_gradle" == $result_pos ] && \
            __install_module "gradle"
        [ "$arg_ruby" == $result_pos ] && \
            __install_module "ruby"
        [ "$arg_nodejs" == $result_pos ] && \
            __install_module "nodejs"
        [ "$arg_subversion" == $result_pos ] && \
            __install_module "subversion"
        [ "$arg_ddclient" == $result_pos ] && \
            __install_module "ddclient"
        [ "$arg_scm_manager" == $result_pos ] && \
            __install_module "scm-manager"
        [ "$arg_jenkins" == $result_pos ] && \
            __install_module "jenkins"
        [ "$arg_nexus" == $result_pos ] && \
            __install_module "nexus"
        [ "$arg_tomcat7" == $result_pos ] && \
            __install_module "tomcat7"
        [ "$arg_tomcat8" == $result_pos ] && \
            __install_module "tomcat8"
        [ "$arg_splunk" == $result_pos ] && \
            __install_module "splunk"
        [ "$arg_activemq" == $result_pos ] && \
            __install_module "activemq"
        [ "$arg_virtualbox" == $result_pos ] && \
            __install_module "virtualbox"
        [ "$arg_vagrant" == $result_pos ] && \
            __install_module "vagrant"
        [ "$arg_packer" == $result_pos ] && \
            __install_module "packer"
        [ "$arg_spring_sts" == $result_pos ] && \
            __install_module "spring-sts"
        [ "$arg_android_sdk" == $result_pos ] && \
            __install_module "android-sdk"
        [ "$arg_android_studio" == $result_pos ] && \
            __install_module "android-studio"

        [ $count_installed -eq 0 ] && exit 255 || exit 0
    )
    result=${PIPESTATUS[0]}

    if [ $result -eq 0 ] || [ $result -eq 255 ]; then

        # remove unsupported modules
        if [ "$arg_remove_unsupported_modules" == $result_pos ]; then
            logger_info "Remove unsupported modules"
            printf "\n"
            echo "Removing unsupported modules..."
            for module in $(list_modules --all); do
                if [ "$module" != "mintleaf" ] && [ $(_is_module_supported $module) != $result_pos ]; then
                    logger_debug "Remove $module"
                    echo "$module"
                    rm -rf $module_dir/$module
                fi
            done
        fi

        # remove not installed modules
        if [ "$arg_remove_not_installed_modules" == $result_pos ]; then
            logger_info "Remove not installed modules"
            printf "\n"
            echo "Removing not installed modules..."
            for module in $(list_modules --all); do
                if [ "$module" != "mintleaf" ] && [ $(_is_module_installed $module) != $result_pos ]; then
                    logger_debug "Remove $module"
                    echo "$module"
                    rm -rf $module_dir/$module
                fi
            done
        fi

        # update user profile file
        if [ "$arg_update_profile" == $result_pos ]; then
            logger_info "Update user profile file"
            [ -f $HOME/.bash_profile ] && file_remove_str "\n# BEGIN: load MintLeaf\n(.)*# END: load MintLeaf\n" $HOME/.bash_profile --multiline
            [ -f $HOME/.profile ] && file_remove_str "\n# BEGIN: load MintLeaf\n(.)*# END: load MintLeaf\n" $HOME/.profile --multiline
            if [ -f $HOME/.bash_profile ]; then
                cat << EOF >> $HOME/.bash_profile

# BEGIN: load MintLeaf
MINTLEAF_HOME=$MINTLEAF_HOME
LOG_LEVEL=INFO source \$MINTLEAF_HOME/bin/bootstrap
# END: load MintLeaf
EOF
            elif [ -f $HOME/.profile ]; then
                cat << EOF >> $HOME/.profile

# BEGIN: load MintLeaf
MINTLEAF_HOME=$MINTLEAF_HOME
LOG_LEVEL=INFO source \$MINTLEAF_HOME/bin/bootstrap
# END: load MintLeaf
EOF
            elif [ ! -f $HOME/.profile ] && [ ! -f $HOME/.bash_profile ]; then
                cat << EOF >> $HOME/.bash_profile
# BEGIN: load MintLeaf
MINTLEAF_HOME=$MINTLEAF_HOME
LOG_LEVEL=INFO source \$MINTLEAF_HOME/bin/bootstrap
# END: load MintLeaf
EOF
            fi
        fi

        # update log configuration file
        logger_info "Update log configuration file"
        file_replace_str "log4sh.rootLogger = INFO, syslog" "log4sh.rootLogger = INFO, log, syslog" $MINTLEAF_HOME/conf/log4sh.conf
        file_replace_str "#log4sh.appender.log" "log4sh.appender.log" $MINTLEAF_HOME/conf/log4sh.conf
        file_replace_str "log4sh.appender.log.File = mintleaf.log" "log4sh.appender.log.File = $log_file" $MINTLEAF_HOME/conf/log4sh.conf

        if [ $result -ne 255 ]; then
            logger_info "Installation performed successfully"
            printf "\n"
            echo "Installation performed successfully"
        else
            result=0
        fi
    else
        logger_error "Installation failed due to the errors"
        printf "\n"
        echo "Installation failed due to the errors"
    fi

    if [ "$arg_ignore_tests" == $result_pos ]; then
        echo "Test results were ignored"
        set +xv
    fi

# if it runs directly from repository
elif [ $(basename $(dirname $(dirname $(abspath $0)))) == "src" ]; then

    # copy
    rm -rf /usr/local/mintleaf/{bin,conf,etc,lib}
    mkdir -p /usr/local/mintleaf
    cp -r $(dirname $(dirname $(abspath $0)))/* /usr/local/mintleaf

    # install
    chmod +x /usr/local/mintleaf/bin/install.sh
    MINTLEAF_HOME=/usr/local/mintleaf /usr/local/mintleaf/bin/install.sh $*
    result=${PIPESTATUS[0]}

# if non of the above then it must have been piped to bash
else

    # download
    rm -rf /usr/local/mintleaf/{bin,conf,etc,lib}
    mkdir -p /usr/local/mintleaf
    wget -O $HOME/$GITHUB_REPOSITORY_NAME.tar.gz "https://github.com/${GITHUB_REPOSITORY_ACCOUNT}/${GITHUB_REPOSITORY_NAME}/tarball/master"
    tar zxf $HOME/$GITHUB_REPOSITORY_NAME.tar.gz -C /usr/local
    mv /usr/local/$GITHUB_REPOSITORY_ACCOUNT-$GITHUB_REPOSITORY_NAME-*/src/* /usr/local/mintleaf
    rm -rf /usr/local/$GITHUB_REPOSITORY_ACCOUNT-$GITHUB_REPOSITORY_NAME-*
    rm -f $HOME/$GITHUB_REPOSITORY_NAME.tar.gz

    # install
    chmod +x /usr/local/mintleaf/bin/install.sh
    /usr/local/mintleaf/bin/install.sh $*
    result=${PIPESTATUS[0]}

fi

exit $result
