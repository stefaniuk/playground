#!/bin/bash

JAVA_HOME=/usr/local/jdk
CATALINA_HOME=/usr/local/www/tomcat8080

CLASSPATH=$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar 
CLASSPATH=${CLASSPATH}:$CATALINA_HOME/bin/commons-daemon.jar
CLASSPATH=${CLASSPATH}:$JAVA_HOME/lib/tools.jar
JAVA_OPTS='-Xms64m -Xmx256m -server'
JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
#JAVA_OPTS=${JAVA_OPTS} ${JAVA_DEBUG_OPTS}

TOMCAT_USER=tomcat8080

TMPDIR=/var/tmp

RC=0

case $1 in
	start)	$CATALINA_HOME/bin/jsvc \
				-debug \
				-user $TOMCAT_USER \
				-home $JAVA_HOME \
				-jvm server \
				-Dcatalina.home=$CATALINA_HOME \
				-Xmx256m \
				-Djava.io.tmpdir=$TMPDIR \
				-Djava.awt.headless=true \
				-outfile $CATALINA_HOME/logs/catalina.out \
				-errfile $CATALINA_HOME/logs/catalina.err \
				-cp $CLASSPATH \
				org.apache.catalina.startup.Bootstrap
			RC=$?
			[ $RC = 0 ] && touch /var/lock/subsys/tomcat
			;;

	stop)	PID=`cat /var/run/jsvc.pid`
			kill $PID
			RC=$?
			[ $RC = 0 ] && rm -f /var/lock/subsys/tomcat /var/run/jsvc.pid
			;;
	*)		echo "Usage: $0 {start|stop}"
			exit 1
esac

exit $RC
