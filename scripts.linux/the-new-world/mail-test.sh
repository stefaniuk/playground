#!/bin/bash

echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@gmail.com
echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@inbox.com
echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@onet.pl
echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@wp.pl
echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@yahoo.com
echo "MTA test on `hostname -f`" | /usr/local/postfix/bin/mailx -s "MTA test on `hostname -f`" daniel.stefaniuk@hotmail.co.uk
