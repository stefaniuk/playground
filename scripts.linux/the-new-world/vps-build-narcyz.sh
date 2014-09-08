#!/bin/bash
#
# usage:
#
#	./vps-build-narcyz.sh && source ~/.profile

./vps-build.sh --site londynek.uk.net mysql apache 80 443 2>&1 | tee vps-build.site-londynek.uk.net.out
./vps-build.sh --site polecam.cc mysql apache 80 443 2>&1 | tee vps-build.site-polecam.cc.out
./vps-build.sh --site przystanek.co.uk mysql apache 80 443 2>&1 | tee vps-build.site-przystanek.co.uk.out
./vps-build.sh --site wypadek.cc mysql apache 80 443 2>&1 | tee vps-build.site-wypadek.cc.out
