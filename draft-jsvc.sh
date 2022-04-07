#!/bin/sh

JSVC_BIN="/home/l.briand@gop.link/personal/commons-daemon/src/native/unix/jsvc"
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
FILE_PID="/tmp/application.pid"
FILE_OUT="/tmp/application.out"
FILE_ERR="/tmp/application.err"

CWD="/home/l.briand@gop.link/personal/kblog"

COMMON_DAEMON_JAR="/home/l.briand@gop.link/Downloads/commons-daemon-1.3.0-bin/commons-daemon-1.3.0/commons-daemon-1.3.0.jar"
APPLICATION_JAR="/home/l.briand@gop.link/personal/kblog/kblog/build/libs/kblog-0.1.1-fat.jar"
APPLICATION_CLASS="net.orandja.kblog.Main"

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
