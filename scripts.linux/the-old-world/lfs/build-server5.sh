cd /sources

# linux api headers

tar -jxf linux-2.6.27.4.tar.bz2
cd linux-2.6.27.4
make mrproper
make headers_check
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /usr/include
cd ..
rm -rf linux-2.6.27.4

# man
tar -jxf man-pages-3.11.tar.bz2
cd man-pages-3.11
make install
cd ..
rm -rf man-pages-3.11

# glibc
tar -jxf glibc-2.8-20080929.tar.bz2
cd glibc-2.8-20080929
sed -i '/vi_VN.TCVN/d' localedata/SUPPORTED
patch -Np1 -i ../glibc-2.8-20080929-iconv_tests-1.patch
patch -Np1 -i ../glibc-2.8-20080929-ildoubl_test-1.patch
sed -i 's|@BASH@|/bin/bash|' elf/ldd.bash.in
mkdir -v ../glibc-build
cd ../glibc-build
echo "CFLAGS += -march=i486 -mtune=native" > configparms
../glibc-2.8-20080929/configure --prefix=/usr --disable-profile --enable-add-ons --enable-kernel=2.6.0 --libexecdir=/usr/lib/glibc
make
cp -v ../glibc-2.8-20080929/iconvdata/gconv-modules iconvdata
make -k check 2>&1 | tee glibc-check-log
grep Error glibc-check-log
touch /etc/ld.so.conf
make install
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
make localedata/install-locales

# glibc configuration

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tzselect

cp -v --remove-destination /usr/share/zoneinfo/Europe/London /etc/localtime

# configuring the dynamic loader

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

# End /etc/ld.so.conf
EOF

cd ..
rm -rf glibc-2.8-20080929
rm -rf glibc-build

# re-adjusting the toolchain

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

gcc -dumpspecs | sed \
    -e 's@/tools/lib/ld-linux.so.2@/lib/ld-linux.so.2@g' \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B1 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

# binutils
tar -jxf binutils-2.18.tar.bz2
cd binutils-2.18
expect -c "spawn ls"
patch -Np1 -i ../binutils-2.18-configure-1.patch
patch -Np1 -i ../binutils-2.18-GCC43-1.patch
rm -fv etc/standards.info
sed -i.bak '/^INFO/s/standards.info //' etc/Makefile.in
mkdir -v ../binutils-build
cd ../binutils-build
../binutils-2.18/configure --prefix=/usr --enable-shared
make tooldir=/usr
make check
make tooldir=/usr install
cp -v ../binutils-2.18/include/libiberty.h /usr/include
cd ..
rm -rf binutils-2.18
rm -rf binutils-build

# gmp
tar -jxf gmp-4.2.4.tar.bz2
cd gmp-4.2.4
./configure --prefix=/usr --enable-cxx --enable-mpbsd
make
make check 2>&1 | tee gmp-check-log
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
make install
mkdir -v /usr/share/doc/gmp-4.2.4
cp -v doc/{isa_abi_headache,configuration} doc/*.html /usr/share/doc/gmp-4.2.4
cd ..
rm -rf gmp-4.2.4

# mpfr
tar -jxf mpfr-2.3.2.tar.bz2
cd mpfr-2.3.2
./configure --prefix=/usr --enable-thread-safe
make
make check
make install
cd ..
rm -rf mpfr-2.3.2

# gcc
tar -jxf gcc-4.3.2.tar.bz2
cd gcc-4.3.2
sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
sed -i 's/^XCFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in
sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in
mkdir -v ../gcc-build
cd ../gcc-build
../gcc-4.3.2/configure --prefix=/usr \
    --libexecdir=/usr/lib --enable-shared \
    --enable-threads=posix --enable-__cxa_atexit \
    --enable-clocale=gnu --enable-languages=c,c++ \
    --disable-bootstrap
make
make -k check
../gcc-4.3.2/contrib/test_summary
make install
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

echo 'main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

cd ..
rm -rf gcc-4.3.2
rm -rf gcc-build

# berkeley db
tar -zxf db-4.7.25.tar.gz
cd db-4.7.25
patch -Np1 -i ../db-4.7.25-upstream_fixes-1.patch
cd build_unix
../dist/configure --prefix=/usr --enable-compat185 --enable-cxx
make
make docdir=/usr/share/doc/db-4.7.25 install
chown -Rv root:root /usr/share/doc/db-4.7.25
cd ../..
rm -rf db-4.7.25

# sed
tar -zxf sed-4.1.5.tar.gz
cd sed-4.1.5
./configure --prefix=/usr --bindir=/bin --enable-html
make
make check
make install
cd ..
rm -rf sed-4.1.5

# e2fsprogs
tar -zxf e2fsprogs-1.41.3.tar.gz
cd e2fsprogs-1.41.3
sed -i 's@/bin/rm@/tools&@' lib/blkid/test_probe.in
mkdir -v build
cd build
../configure --prefix=/usr --with-root-prefix="" --enable-elf-shlibs
make
make check
make install
make install-libs
chmod -v u+w /usr/lib/{libblkid,libcom_err,libe2p,libext2fs,libss,libuuid}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
install -v -m644 -D ../doc/libblkid.txt /usr/share/doc/e2fsprogs-1.41.3/libblkid.txt
cd ../..
rm -rf e2fsprogs-1.41.3

# coreutils
tar -zxf coreutils-6.12.tar.gz
cd coreutils-6.12
patch -Np1 -i ../coreutils-6.12-uname-1.patch
patch -Np1 -i ../coreutils-6.12-old_build_kernel-1.patch
patch -Np1 -i ../coreutils-6.12-i18n-2.patch
./configure --prefix=/usr --enable-install-program=hostname --enable-no-install-program=kill,uptime
make
make NON_ROOT_USERNAME=nobody check-root
echo "dummy:x:1000:nobody" >> /etc/group
chown -Rv nobody config.log {gnulib-tests,lib,src}/.deps
su-tools nobody -s /bin/bash -c "make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group
make install
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,hostname,ln,ls,mkdir,mknod,mv,pwd,readlink,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/bin/{head,sleep,nice} /bin
cd ..
rm -rf coreutils-6.12

# iana
tar -jxf iana-etc-2.30.tar.bz2
cd iana-etc-2.30
make
make install
cd ..
rm -rf iana-etc-2.30

# m4
tar -jxf m4-1.4.12.tar.bz2
cd m4-1.4.12
./configure --prefix=/usr --enable-threads
make
make check
make install
cd ..
rm -rf m4-1.4.12

# bison
tar -jxf bison-2.3.tar.bz2
cd bison-2.3
./configure --prefix=/usr
echo '#define YYENABLE_NLS 1' >> config.h
make
make check
make install
cd ..
rm -rf bison-2.3

# ncurses
tar -zxf ncurses-5.6.tar.gz
cd ncurses-5.6
patch -Np1 -i ../ncurses-5.6-coverity_fixes-1.patch
./configure --prefix=/usr --with-shared --without-debug --enable-widec
make
make install
chmod -v 644 /usr/lib/libncurses++w.a
mv -v /usr/lib/libncursesw.so.5* /lib
ln -sfv ../../lib/libncursesw.so.5 /usr/lib/libncursesw.so
for lib in curses ncurses form panel menu ; do \
    rm -vf /usr/lib/lib${lib}.so ; \
    echo "INPUT(-l${lib}w)" >/usr/lib/lib${lib}.so ; \
    ln -sfv lib${lib}w.a /usr/lib/lib${lib}.a ; \
done
ln -sfv libncurses++w.a /usr/lib/libncurses++.a
rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" >/usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so
ln -sfv libncursesw.a /usr/lib/libcursesw.a
ln -sfv libncurses.a /usr/lib/libcurses.a
#mkdir -v /usr/share/doc/ncurses-5.6
#cp -v -R doc/* /usr/share/doc/ncurses-5.6
make distclean
./configure --prefix=/usr --with-shared --without-normal \
  --without-debug --without-cxx-binding
make sources libs
cp -av lib/lib*.so.5* /usr/lib
cd ..
rm -rf ncurses-5.6

# procps
tar -zxf procps-3.2.7.tar.gz
cd procps-3.2.7
patch -Np1 -i ../procps-3.2.7-watch_unicode-1.patch
make
make install
cd ..
rm -rf procps-3.2.7

# libtool
tar -zxf libtool-2.2.6a.tar.gz
cd libtool-2.2.6
./configure --prefix=/usr
make
make check
make install
cd ..
rm -rf libtool-2.2.6

# zlib
tar -jxf zlib-1.2.3.tar.bz2
cd zlib-1.2.3
./configure --prefix=/usr --shared --libdir=/lib
make
make check
make install
rm -v /lib/libz.so
ln -sfv ../../lib/libz.so.1.2.3 /usr/lib/libz.so
make clean
./configure --prefix=/usr
make
make check
make install
chmod -v 644 /usr/lib/libz.a
cd ..
rm -rf zlib-1.2.3

# perl
tar -zxf perl-5.10.0.tar.gz
cd perl-5.10.0
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
patch -Np1 -i ../perl-5.10.0-consolidated-1.patch
sed -i -e "s|BUILD_ZLIB\s*= True|BUILD_ZLIB = False|"           \
       -e "s|INCLUDE\s*= ./zlib-src|INCLUDE    = /usr/include|" \
       -e "s|LIB\s*= ./zlib-src|LIB        = /usr/lib|"         \
    ext/Compress/Raw/Zlib/config.in
sh Configure -des -Dprefix=/usr \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"
make
make test
make install
cd ..
rm -rf perl-5.10.0

# readline
tar -zxf readline-5.2.tar.gz
cd readline-5.2
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
patch -Np1 -i ../readline-5.2-fixes-5.patch
./configure --prefix=/usr --libdir=/lib
make SHLIB_LIBS=-lncurses
make install
mv -v /lib/lib{readline,history}.a /usr/lib
rm -v /lib/lib{readline,history}.so
ln -sfv ../../lib/libreadline.so.5 /usr/lib/libreadline.so
ln -sfv ../../lib/libhistory.so.5 /usr/lib/libhistory.so
cd ..
rm -rf readline-5.2

# autoconf
tar -jxf autoconf-2.63.tar.bz2
cd autoconf-2.63
./configure --prefix=/usr
make
make check
make install
cd ..
rm -rf autoconf-2.63

# automake
tar -jxf automake-1.10.1.tar.bz2
cd automake-1.10.1
patch -Np1 -i ../automake-1.10.1-test_fix-1.patch
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.10.1
make
make check
make install
cd ..
rm -rf automake-1.10.1

# bash
tar -zxf bash-3.2.tar.gz
cd bash-3.2
patch -Np1 -i ../bash-3.2-fixes-8.patch
./configure --prefix=/usr --bindir=/bin --without-bash-malloc --with-installed-readline ac_cv_func_working_mktime=yes
make
sed -i 's/LANG/LC_ALL/' tests/intl.tests
sed -i 's@tests@& </dev/tty@' tests/run-test
chown -Rv nobody ./
su-tools nobody -s /bin/bash -c "make tests"
make install
exec /bin/bash --login +h
cd ..
rm -rf bash-3.2

# bzip2
tar -zxf bzip2-1.0.5.tar.gz
cd bzip2-1.0.5
patch -Np1 -i ../bzip2-1.0.5-install_docs-1.patch
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
cd ..
rm -rf bzip2-1.0.5

# diffutils
tar -zxf diffutils-2.8.1.tar.gz
cd diffutils-2.8.1
patch -Np1 -i ../diffutils-2.8.1-i18n-1.patch
touch man/diff.1
./configure --prefix=/usr
make
make install
cd ..
rm -rf diffutils-2.8.1

# file
tar -zxf file-4.26.tar.gz
cd file-4.26
sed -i -e '197,+1d' \
       -e '189,+1d' \
       -e 's/token$/tokens/' doc/file.man
./configure --prefix=/usr
make
make check
make install
cd ..
rm -rf file-4.26

# gawk
tar -jxf gawk-3.1.6.tar.bz2
cd gawk-3.1.6
./configure --prefix=/usr --libexecdir=/usr/lib ac_cv_func_working_mktime=yes
make
make check
make install
cd ..
rm -rf gawk-3.1.6

# findutils
tar -zxf findutils-4.4.0.tar.gz
cd findutils-4.4.0
./configure --prefix=/usr --libexecdir=/usr/lib/findutils --localstatedir=/var/lib/locate
make
make check
make install
mv -v /usr/bin/find /bin
sed -i -e 's/find:=${BINDIR}/find:=\/bin/' /usr/bin/updatedb
cd ..
rm -rf findutils-4.4.0

# flex
tar -jxf flex-2.5.35.tar.bz2
cd flex-2.5.35
./configure --prefix=/usr
make
make check
make install
ln -sv libfl.a /usr/lib/libl.a
cat > /usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF
chmod -v 755 /usr/bin/lex
cd ..
rm -rf flex-2.5.35

# grub
tar -zxf grub-0.97.tar.gz
cd grub-0.97
patch -Np1 -i ../grub-0.97-disk_geometry-1.patch
patch -Np1 -i ../grub-0.97-256byte_inode-1.patch
./configure --prefix=/usr
make
make check
make install
mkdir -v /boot/grub
cp -v /usr/lib/grub/i386-pc/stage{1,2} /boot/grub
cd ..
rm -rf grub-0.97

# gettext
tar -zxf gettext-0.17.tar.gz
cd gettext-0.17
./configure --prefix=/usr --docdir=/usr/share/doc/gettext-0.17
make
make check
make install
cd ..
rm -rf gettext-0.17

# grep
tar -jxf grep-2.5.3.tar.bz2
cd grep-2.5.3
patch -Np1 -i ../grep-2.5.3-debian_fixes-1.patch
patch -Np1 -i ../grep-2.5.3-upstream_fixes-1.patch
./configure --prefix=/usr --bindir=/bin --without-included-regex
make
make check || true
make install
cd ..
rm -rf grep-2.5.3

# groff
tar -zxf groff-1.18.1.4.tar.gz
cd groff-1.18.1.4
patch -Np1 -i ../groff-1.18.1.4-debian_fixes-1.patch
sed -i -e 's/2010/002D/' -e 's/2212/002D/' -e 's/2018/0060/' -e 's/2019/0027/' font/devutf8/R.proto
PAGE=A4 ./configure --prefix=/usr --enable-multibyte
make
make docdir=/usr/share/doc/groff-1.18.1.4 install
ln -sv eqn /usr/bin/geqn
ln -sv tbl /usr/bin/gtbl
cd ..
rm -rf groff-1.18.1.4

# gzip
tar -zxf gzip-1.3.12.tar.gz
cd gzip-1.3.12
sed -i 's/futimens/gl_&/' gzip.c lib/utimens.{c,h}
./configure --prefix=/usr --bindir=/bin
make
make check
make install
mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
cd ..
rm -rf gzip-1.3.12

# inetutils
tar -zxf inetutils-1.5.tar.gz
cd inetutils-1.5
patch -Np1 -i ../inetutils-1.5-no_server_man_pages-2.patch
sed -i 's@<sys/types.h>@<sys/types.h>\n#include <stdlib.h>@' libicmp/icmp_timestamp.c
./configure --prefix=/usr --libexecdir=/usr/sbin \
    --sysconfdir=/etc --localstatedir=/var \
    --disable-ifconfig --disable-logger --disable-syslogd \
    --disable-whois --disable-servers
make
make install
mv -v /usr/bin/ping /bin
cd ..
rm -rf inetutils-1.5

# iproute2
tar -jxf iproute2-2.6.26.tar.bz2
cd iproute2-2.6.26
make DESTDIR= SBINDIR=/sbin
make DESTDIR= SBINDIR=/sbin MANDIR=/usr/share/man \
     DOCDIR=/usr/share/doc/iproute2-2.6.26 install
mv -v /sbin/arpd /usr/sbin
cd ..
rm -rf iproute2-2.6.26

# kbd
tar -zxf kbd-1.14.1.tar.gz
cd kbd-1.14.1
patch -Np1 -i ../kbd-1.14.1-backspace-1.patch
sed -i -e '1i KEYCODES_PROGS = @KEYCODES_PROGS@' \
    -e '1i RESIZECONS_PROGS = @RESIZECONS_PROGS@' src/Makefile.in
var=OPTIONAL_PROGS
sed -i "s/ifdef $var/ifeq (\$($var),yes)/" man/Makefile.in
unset var
./configure --prefix=/usr --datadir=/lib/kbd
make
make install
mv -v /usr/bin/{kbd_mode,loadkeys,openvt,setfont} /bin
cd ..
rm -rf kbd-1.14.1

# less
tar -zxf less-418.tar.gz
cd  less-418
./configure --prefix=/usr --sysconfdir=/etc
make
make install
cd ..
rm -rf  less-418

# make
tar -jxf make-3.81.tar.bz2
cd make-3.81
./configure --prefix=/usr
make
make check
make install
cd ..
rm -rf make-3.81

# man-db
tar -zxf man-db-2.5.2.tar.gz
cd man-db-2.5.2
sed -i -e '\%\t/usr/man%d' -e '\%\t/usr/local/man%d' src/man_db.conf.in
./configure --prefix=/usr --libexecdir=/usr/lib \
    --sysconfdir=/etc --disable-setuid \
    --enable-mb-groff --with-browser=/usr/bin/lynx \
    --with-col=/usr/bin/col --with-vgrind=/usr/bin/vgrind \
    --with-grap=/usr/bin/grap
make
make install
cat >> convert-mans << "EOF"
#!/bin/sh -e
FROM="$1"
TO="$2"
shift ; shift
while [ $# -gt 0 ]
do
        FILE="$1"
        shift
        iconv -f "$FROM" -t "$TO" "$FILE" >.tmp.iconv
        mv .tmp.iconv "$FILE"
done
EOF
install -m755 convert-mans  /usr/bin
cd ..
rm -rf man-db-2.5.2

# module-init-tools
tar -jxf module-init-tools-3.4.1.tar.bz2
cd module-init-tools-3.4.1
patch -Np1 -i ../module-init-tools-3.4.1-manpages-1.patch
./configure
make check
make clean
./configure --prefix=/ --enable-zlib --mandir=/usr/share/man
make
make INSTALL=install install
cd ..
rm -rf module-init-tools-3.4.1

# patch
tar -zxf patch-2.5.4.tar.gz
cd patch-2.5.4
./configure --prefix=/usr
make
make install
cd ..
rm -rf patch-2.5.4

# psmisc
tar -zxf psmisc-22.6.tar.gz
cd psmisc-22.6
./configure --prefix=/usr --exec-prefix=""
make
make install
mv -v /bin/pstree* /usr/bin
ln -sv killall /bin/pidof
cd ..
rm -rf psmisc-22.6

# shadow
tar -jxf shadow-4.1.2.1.tar.bz2
cd shadow-4.1.2.1
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
sed -i -e 's/ ko//' -e 's/ zh_CN zh_TW//' man/Makefile.in
for i in de es fi fr id it pt_BR; do
    convert-mans UTF-8 ISO-8859-1 man/${i}/*.?
done

for i in cs hu pl; do
    convert-mans UTF-8 ISO-8859-2 man/${i}/*.?
done

convert-mans UTF-8 EUC-JP man/ja/*.?
convert-mans UTF-8 KOI8-R man/ru/*.?
convert-mans UTF-8 ISO-8859-9 man/tr/*.?
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD MD5@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
./configure --sysconfdir=/etc
make
make install
mv -v /usr/bin/passwd /bin
pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
passwd root
cd ..
rm -rf shadow-4.1.2.1

# sysklogd
tar -zxf sysklogd-1.5.tar.gz
cd sysklogd-1.5
make
make install
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
cd ..
rm -rf sysklogd-1.5

# sysvinit
tar -zxf sysvinit-2.86.tar.gz
cd sysvinit-2.86
sed -i 's@Sending processes@& configured via /etc/inittab@g' src/init.c
sed -i -e 's/utmpdump wall/utmpdump/' \
       -e 's/mountpoint.1 wall.1/mountpoint.1/' src/Makefile
make -C src
make -C src install
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc sysinit

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF
cd ..
rm -rf sysvinit-2.86

# tar
tar -jxf tar-1.20.tar.bz2
cd tar-1.20
./configure --prefix=/usr --bindir=/bin --libexecdir=/usr/sbin
make
make check
make install
cd ..
rm -rf tar-1.20

# texinfo
tar -zxf texinfo-4.13a.tar.gz
cd texinfo-4.13
./configure --prefix=/usr
make
make check
make install
make TEXMF=/usr/share/texmf install-tex
cd /usr/share/info
rm dir
for f in *
do install-info $f dir 2>/dev/null
done
cd /sources
rm -rf texinfo-4.13

# udev
tar -jxf udev-130.tar.bz2
cd udev-130
tar -jxf ../udev-config-20081015.tar.bz2
install -dv /lib/{firmware,udev/devices/{pts,shm}}
mknod -m0666 /lib/udev/devices/null c 1 3
mknod -m0600 /lib/udev/devices/kmsg c 1 11
ln -sv /proc/self/fd /lib/udev/devices/fd
ln -sv /proc/self/fd/0 /lib/udev/devices/stdin
ln -sv /proc/self/fd/1 /lib/udev/devices/stdout
ln -sv /proc/self/fd/2 /lib/udev/devices/stderr
ln -sv /proc/kcore /lib/udev/devices/core
./configure --prefix=/usr --exec-prefix= --sysconfdir=/etc
make
make install
install -m644 -v rules/packages/64-*.rules /lib/udev/rules.d/
install -m644 -v rules/packages/40-pilot-links.rules lib/udev/rules.d/
cd udev-config-20081015
make install
make install-doc
make install-extra-doc
cd ..
install -m644 -v -D docs/writing_udev_rules/index.html /usr/share/doc/udev-130/index.html
cd ..
rm -rf udev-130

# util-linux-ng
tar -jxf util-linux-ng-2.14.1.tar.bz2
cd util-linux-ng-2.14.1
sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
    -i $(grep -rl '/etc/adjtime' .)
mkdir -pv /var/lib/hwclock
./configure --enable-arch --enable-partx --enable-write
make
make install
cd ..
rm -rf util-linux-ng-2.14.1

# vim
mkdir -v vim
tar -jxf vim-7.2.tar.bz2
cd vim72
patch -Np1 -i ../vim-7.2-fixes-3.patch
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr --enable-multibyte
make
make test
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim72/doc /usr/share/doc/vim-7.2
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
cd ..
rm -rf vim72
