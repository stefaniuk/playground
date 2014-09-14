#!/bin/bash

if [ "$SERVER_PROVIDER" == "linode" ]; then

    # /etc/fstab
    [ ! -f /etc/fstab.old ] && cp /etc/fstab /etc/fstab.old
    cat <<EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>                                   <dump> <pass>
proc            /proc           proc    defaults                                    0       0
dev             /dev            tmpfs   rw                                          0       0
cgroup          /sys/fs/cgroup  cgroup  defaults                                    0       0
EOF

    # /etc/fstab
    cat <<EOF >> /etc/fstab
/dev/xvda       /               ext3    noatime,nobarrier,errors=remount-ro         1       2
/dev/xvdb       none            swap    sw                                          0       0
EOF

fi

exit 0
