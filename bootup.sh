#!/bin/bash

FGW_HOME=/Users/junemp/WorkSpace/fgw
FGW_APP_DIR=$FGW_HOME/apps
FGW_APP_NAME=FinnqGateWay-0.0.1-SNAPSHOT.jar
FGW_PID_DIR=$FGW_HOME/bin
FGW_PID_NAME=fgw.pid
FGW_APP_PROFILE=dev

JAVA=java
JAVA_OPTS="-Dspring.profiles.active=$FGW_APP_PROFILE"

case "$1" in 
start)
	if [ -e "$FGW_PID_DIR/$FGW_PID_NAME" ]; then
		echo "PID file exist. Check the Process[`cat $FGW_PID_DIR/$FGW_PID_NAME`]."
		exit 1
	else
		$JAVA -jar $JAVA_OPTS $FGW_APP_DIR/$FGW_APP_NAME &
		echo $!>$FGW_PID_DIR/$FGW_PID_NAME
	fi
   ;;
stop)
	if [ -e "$FGW_PID_DIR/$FGW_PID_NAME" ]; then
		kill -0 `cat $FGW_PID_DIR/$FGW_PID_NAME` >/dev/null 2>&1
		if [ $? -gt 0 ]; then
			echo "PID file exist. but Process[`cat $FGW_PID_DIR/$FGW_PID_NAME`] not found!!"
			exit 1
		else
   			kill `cat $FGW_PID_DIR/$FGW_PID_NAME`

			echo "Success to Stop Process[`cat $FGW_PID_DIR/$FGW_PID_NAME`]"

   			rm "$FGW_PID_DIR/$FGW_PID_NAME"

			exit 0
		fi
	else
		echo "$FGW_PID_DIR/$FGW_PID_NAME file not exist. Stop aborted."
		exit 1
	fi
   ;;
restart)
   $0 stop
   $0 start
   ;;
status)
   if [ -e $FGW_PID_DIR/$FGW_PID_NAME ]; then
      echo FGW is running, pid=`cat $FGW_APP_DIR/$FGW_PID_NAME`
   else
      echo FGW is NOT running
      exit 1
   fi
   ;;
clear)
	if [ -e "$FGW_PID_DIR/$FGW_PID_NAME" ]; then
		kill -0 `cat $FGW_PID_DIR/$FGW_PID_NAME` >/dev/null 2>&1
		if [ $? -gt 0 ]; then
   			rm "$FGW_PID_DIR/$FGW_PID_NAME"
			echo "Success remove PID file"
			exit 0
		else
			echo "Process[`cat $FGW_APP_DIR/$FGW_PID_NAME`] alive!! You MUST use stop command!!"
			exit 1
		fi
	else
		echo "$FGW_PID_DIR/$FGW_PID_NAME file not exist. Clear aborted."
		exit 1
	fi
	;;
*)
   echo "Usage: $0 {start|stop|status|restart|clear}"
esac

exit 0
