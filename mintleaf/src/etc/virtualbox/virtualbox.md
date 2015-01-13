## virtualbox

#### Description

This module automatically installs the VirtualBox application that is a
general-purpose full virtualizer for x86 hardware, targeted at server, desktop
and embedded use.

#### Usage

 * [How to run virtual machines on a headless Ubuntu server](http://www.howtoforge.com/vboxheadless-running-virtual-machines-with-virtualbox-4.3-on-a-headless-ubuntu-14.04-lts-server)

#### Problems

 * In case of `VERR_VMX_UNABLE_TO_START_VM` error while starting a virtual machine execute the following commands:

        vboxmanage modifyvm "Ubuntu 14.04 Server" --hwvirtex off
        vboxmanage modifyvm "Ubuntu 14.04 Server" --vtxvpid off

#### Supported Platforms

 * Ubuntu
 * Mac OS X
