MintLeaf
========

**MintLeaf** is an improved (to its predecessor) set of scripts and programs to extend functionality of Bash shell and to create highly customisable scripting environment. The main focus has been put on delivering a simple, modular project and unit tested routines.

It serves as a installation/deployment tool for number of applications I use frequently. Also it has a potential to automate server administration tasks across multiple platforms.

Installation
------------

Execute the following line in a terminal window to install the main module along with some virtualisation packages:

    wget https://raw.githubusercontent.com/stefaniuk/mintleaf/master/src/bin/install.sh -O - | /bin/bash -s -- \
        --mintleaf \
        --update-system --update-packages --update-profile

or if you already have downloaded and unpacked the archive to `/usr/local/mintleaf` directory you could run the following commands:

    cd /usr/local/mintleaf
    chmod +x ./bin/install.sh
    LOG_LEVEL=DEBUG ./bin/install.sh \
        --mintleaf \
        --update-system --update-packages --update-profile \
        --remove-unsupported-modules --remove-not-installed-modules \
        --java8 --groovy --spring-cli --ant --maven --gradle

Some of the functionality is not supported on all the systems. You may want to use `--ignore-tests` flag to make sure the installation process will still carry on despite the test results. If you want to update your operating system use `--update-system` flag. If you want to update system packages just add `--update-packages` flag.

You should see an output similar to this:

    OS: linux
    DIST: ubuntu
    DIST BASED ON: debian
    PSEUDO NAME: trusty
    VERSION: 14.04
    ARCH: x86_64
    ARCH NAME: amd64
    KERNEL: 3.13.0-32-generic

    Installing mintleaf module...
    [ ... ]
    Testing prerequisites...
    program awk ok
    program bash ok
    program bc ok
    program curl ok
    program expect ok
    program find ok
    program gcc ok
    program grep ok
    program md5sum ok
    program mount ok
    program openssl ok
    program pcregrep ok
    program perl ok
    program sed ok
    program sha1sum ok
    program sha256sum ok
    program sha384sum ok
    program sha512sum ok
    program sort ok
    program stat ok
    program umount ok
    program uniq ok
    program unzip ok
    program wc ok
    program wget ok
    program xargs ok
    program ldd ok
    program groupadd ok
    program useradd ok

    Testing mintleaf module...
    test_list_modules ok
    test_print_module_info ok
    test_list_functions ok
    test_create_module ok
    test_func_exists ok
    test_usleep ok
    test_h2d ok
    test_d2h ok
    test_random ok
    test_trim ok
    test_lower ok
    test_upper ok
    test_str_sanitise ok
    test_str_sanitise ok
    test_str_substring ok
    test_str_contains ok
    test_str_begins ok
    test_str_ends ok
    test_str_split_part ok
    test_str_compare_ver ok
    test_str_compare_ver ok
    test_str_compare_ver ok
    test_sort_ver ok
    test_sort_ver_rev ok
    test_file_escape_name ok
    test_file_contains ok
    test_file_replace_str ok
    test_file_replace_str ok
    test_file_replace_str ok
    test_file_replace_str ok
    test_file_replace_str ok
    test_file_remove_str ok
    test_file_remove_str ok
    test_file_remove_str ok
    test_file_remove_str ok
    test_file_remove_str ok
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100 5120k  100 5120k    0     0  11.1M      0 --:--:-- --:--:-- --:--:-- 11.1M
    test_file_download ok
    test_file_valid_hash ok
    test_dir_find_str ok
    test_dir_replace_str ok
    test_dir_remove_str ok
    test_chroot_dependency_list ok
    test_chroot_dependency_list_all ok
    test_chroot_dependency_copy ok
    test_chroot_mount_dir ok
    test_chroot_mount_dir ok
    test_chroot_create_remove_env ok
    test_chroot_create_remove_env ok
    test_is_chroot ok
    test_user_exists ok
    test_user_exists ok
    test_group_exists ok
    test_group_exists ok
    test_user_create ok
    test_user_create ok
    test_user_delete ok
    test_sec_generate_cert ok
    test_net_get_external_ip ok
    test_www_get ok
    test_config_option_set ok
    test_config_option_get ok
    61 tests passed

    [...]

    Removing unsupported modules...
    [...]

    Installation performed successfully

Installation may fail due to not passed tests. However, if the installation was successful your profile file should contain a block of code that loads MintLeaf scripts:

    # BEGIN: load MintLeaf
    MINTLEAF_HOME=/usr/local/mintleaf
    LOG_LEVEL=INFO source $MINTLEAF_HOME/bin/bootstrap
    # END: load MintLeaf

Modules
-------

Some of the currently available modules are:

 * mintleaf (main module)

###### Modules written on top of software packages

 * git
 * java8
 * packer
 * vagrant
 * virtualbox

###### Other modules that customise software packages functionality

 * web-dev
 * mobile-dev
 * hypervisor
 * container

All of the modules are loaded with their configuration when `$MINTLEAF_HOME/bin/bootstrap` file is sourced. For more information on each module and installation/update command line arguments, please consult the documentation written in Markdown provided along with the source code i.e. `$MINTLEAF_HOME/etc/${module_name}/${module_name}.md`

Structure
---------

Each module should consist of at least the following files and routines:

 * _example.md_ - module information in Markdown
 * _example.config_ - configuration variables mostly used in module routines
 * _example.install_ - installation routines
    * function `is_module_supported` - for example there is not much sense to install Spring STS module on a server box
    * function `install_module` - which is executed from the installation script
    * function `uninstall_module`
    * function `is_module_installed`
    * function `update_module`
    * function `get_module_current_version`
    * function `get_module_latest_version`
 * _example.module_ - module routines available in the userland
 * _example.test_ - unit tests
    * function `test_prerequisites`
    * function `test_module` - which is executed from the test script
 * _example.groovy_ - Java API implementation in Groovy

Non of these files should have an executable block of code.

Usage
-----

All the commands should be available from shell after next login to the system as the user who has performed installation.

To list all the modules:

    $ list_modules

To list all the function available for a module:

    $ list_functions <module name>

To display help information about a function:

    $ <function name> --help

Self explanatory variables that are available globally:

    OS
    DIST
    DIST_BASED_ON
    PSEUDO_NAME
    VERSION
    ARCH
    ARCH_NAME
    KERNEL

You can re-define variables/functions or customise some of the functionality by creating `~/.mintleaf/mintleaf` file that is loaded after all modules have been sourced, e.g.:

    export alternative_download_url=https://www.dropbox.com/your_account

Supported distributions
-----------------------

This project has been tested on Ubuntu however most of the functionality should be available on other distributions or operating systems like CentOS, Mac OS X or even Cygwin.

Who this project is for?
------------------------

Originally it has been started as a bunch of random scripts to manage web hosting services but it has evolved since. Is this project something you could use out of the box? Probably, but it may not solve all the problems you face without further adjustments and still there will be a learning curve to familiarise yourself with all the functions.

High-level goals
----------------

Build management system that provides:

 * common configuration and transparent functionality across multiple platforms
 * web application to manage a node via well defined RESTful API
 * ability to control a number of remote nodes

TODO list
---------

###### Immediately

 * migrate compare directory function
 * move functionality that installs system packages to modules
 * allow to install chosen version of underlying service by giving additional arguments like URL and HASH sum
 * provide a list of well known alternative versions of archives to download in case the newest one is not available
 * improve file download function to get archives from an alternative URL address: $URL/archives/$module/{list,archive.file,...}

###### Packages

 * create [ddclient](https://help.ubuntu.com/community/DynamicDNS) module
 * create [libvirt](http://libvirt.org/) module
 * create hypervisor module that supports KVM and VirtualBox
 * create container module that supports LXC and Docker
 * remaster Ubuntu Core installation image
 * configure Git and Subversion
 * install Apache HTTP Server
 * install PHP, PHP-FPM
 * configure Splunk data directory
 * install Python

###### Modern development packages

 * install Yeoman, Bower and Grunt
 * install Cordova CLI
 * install SonarQube
 * install Selenium
 * install Fitnesse

###### Design

 * modules
    - [bash-it](https://github.com/revans/bash-it)
    - [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
 * cross-platform shell scripts
    - delivered as modules
    - along with common API
    - exposed in Groovy
 * request processor (consumer)
    - consumes job queue
    - executes Groovy scripts
    - accepts or rejects request
    - reports request status if asked
    - updates requester
 * small footprint standalone REST API web application that exposes modules endpoints (producer)
    - receives requests
    - produces job queue
    - returns responses
 * service connector: database, job queue and manager
 * web application

###### Ideas

 * apply [branching model](http://nvie.com/posts/a-successful-git-branching-model/)
 * cron jobs for lightweight scripts, for example dynamic DNS updater
 * create Linux service
 * hooks and events
 * log line numbers, variables $BASH_SOURCE, $BASH_LINENO, $FUNCNAME may help
 * debug detail levels 0..9

###### Caveats

 * Implementation
    - [Messaging with JMS](http://spring.io/guides/gs/messaging-jms/)
    - [ActiveMQ embedded broker](http://activemq.apache.org/how-do-i-embed-a-broker-inside-a-connection.html)
    - [Implementing an Interface in Groovy and using it in Java](https://gist.github.com/schup/5397811)
    - [Embedding Groovy](http://groovy.codehaus.org/Embedding+Groovy)
 * JVM memory
    - [usage](http://stackoverflow.com/questions/561245/virtual-memory-usage-from-java-under-linux-too-much-memory-used)
    - [dumps](http://www.jahia.com/community/blogs/tips-and-tricks-for-analyzing-java-virtual-machine)
    - [Heap Dump Analysis with Memory Analyzer, Part 1: Heap Dumps](http://memoryanalyzer.blogspot.co.uk/2010/01/heap-dump-analysis-with-memory-analyzer.html)
    - [Heap Dump Analysis with Memory Analyzer, Part 2: Shallow Size](http://memoryanalyzer.blogspot.co.uk/2010/02/heap-dump-analysis-with-memory-analyzer.html)
    - [Automated Heap Dump Analysis: Finding Memory Leaks with One Click](http://memoryanalyzer.blogspot.co.uk/2008/05/automated-heap-dump-analysis-finding.html)
    - [Eclipse Memory Analyzer](http://wiki.eclipse.org/index.php/MemoryAnalyzer)
    - [VisualVM](http://visualvm.java.net/)
    - [java command options](http://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html)
