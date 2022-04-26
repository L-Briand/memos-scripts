#!/bin/sh

APPLICATION_NAME="application"

# alpine defaults
JSVC_BIN="/usr/bin/jsvc"
JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
COMMON_DAEMON_JAR="/usr/share/java/commons-daemon.jar"

FILE_PID="/var/run/$APPLICATION_NAME.pid"
FILE_OUT="/tmp/$APPLICATION_NAME.out"
FILE_ERR="/tmp/$APPLICATION_NAME.err"

CWD="/root"
APPLICATION_JAR="/path/to.jar"
APPLICATION_CLASS="com.example.application"

do_execute() {
    set -x
    sudo $JSVC_BIN \
        -home $JAVA_HOME \
        -pidfile $FILE_PID \
        -outfile $FILE_OUT \
        -errfile $FILE_ERR \
        -cwd $CWD \
        $1 \
        -cp "$COMMON_DAEMON_JAR":"$APPLICATION_JAR" $APPLICATION_CLASS \
        $ARGS
}

ACTION="$1"
shift
ARGS="$*"

case $ACTION in
    start)
        do_execute
            ;;
    stop)
        do_execute "-stop"
            ;;
    restart)
        if [ -f "$PID" ]; then
            do_execute "-stop"
            do_execute
        else
            echo "service not running, will do nothing"
            exit 1
        fi
            ;;
    *)
            echo "usage: {start|stop|restart}" >&2
            exit 3
            ;;
esac
