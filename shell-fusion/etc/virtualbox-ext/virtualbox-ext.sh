#!/bin/bash

VBoxManage extpack install --replace $cache_dir/$PKG_FILE

which VBoxManage > /dev/null 2>&1 || exit 2

exit 0
