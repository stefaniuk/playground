#!/bin/bash

hashes_add_dir /bin
hashes_add_dir /boot
hashes_add_dir /lib
hashes_add_dir /sbin
hashes_add_dir /usr/bin
hashes_add_dir /usr/lib
hashes_add_dir /usr/sbin

# hash files
hashes_create_list

# send hashes by e-mail
if [ "$NOTIFY" == "Y" ] && [ -x $INSTALL_DIR/postfix/bin/mailx ]; then
    (   echo -e "Time: `date +\"%T %Z (%d %b %G)\"`" && \
        echo -e "\nHash:" $(sha1sum $HASH_FILES_FILE | awk '{print $1}') && \
        echo -e "\nFile hashes:\n" && \
        cat $HASH_FILES_FILE \
    ) | $INSTALL_DIR/postfix/bin/mailx -r "admin@$(hostname).$DOMAIN" -s "`hostname -f` - build: system hashes" $ADMIN_MAIL
fi

exit 0
