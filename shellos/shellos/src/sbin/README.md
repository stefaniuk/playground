This directory contains installation scripts.

Installation:
-------------

    sbin/config --initialise
        sbin/config.d/config-a*-*
        sbin/config-${DEVICE}/config-a*-*
    sbin/install-${DEVICE}
        pkg/${package}/install
    sbin/config --finalise
        sbin/config.d/config-z*-*
        sbin/config-${DEVICE}/config-z*-*

Update:
-------

    TODO

