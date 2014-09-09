rem cygwin_setup.bat configuration.
set _PACKAGES=cron,diffutils,inetutils,ncurses,netcat,openssh,p7zip,procps,python,rsync,screen,unzip,vim,zip,w3m
set _ROOTDIR=d:\tools\cygwin
set _SITE=http://mirrors.kernel.org/sourceware/cygwin

rem Enable logging of sshd and it's ilk to /var/log.
set _CONFIG_SYSLOGD=False

rem Enable OpenSSH server.
set _CONFIG_SSHD=False

rem Enable LSA authentication.
rem See http://cygwin.com/cygwin-ug-net/ntsec.html
set _CONFIG_LSA=True

