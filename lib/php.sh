#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

php_base=`cd $(dirname $BASH_SOURCE) && pwd`
source $php_base/tty.sh

# This script provides functions for starting and stopping the php builtin web
# sever.
# 
# @author Michael Lee <michael.lee@zerustech.com>

# This function starts a php bulitin web server.
#
# Usage: http_start <php_home> <host> <port> <doc_root> <log_file> <pid_file>
#
# @param php_home The home directory of php.
# @param host The host name or ip address the web server will be listening at.
# @param port The port number the web server will be listening at.
# @param doc_root The document root of the web server.
# @param log_file The log file.
# @param pid_file The file that stores the web server's PID.
function php_start {

    local php_home=$1
    local host=$2
    local port=$3
    local doc_root=$4
    local log_file=$5
    local pid_file=$6

    tty_printf "Starting php builtin server ... "

    $php_home/bin/php -S $host:$port -t $doc_root >> $log_file 2>&1 &

    echo $! > $pid_file

    tty_printf -f green "done"
}

# This function stops a php bulitin web server.
#
# Usage: http_stop <pid_file> <log_file>
# 
# @param pid_file The file that stores the PID of the running web server.
# @param log_file The log file.
function php_stop {

    local pid_file=$1
    local log_file=$2

    if [ -f $pid_file ]; then

        tty_printf "Stopping php builtin server ... "

        sudo kill -9 `cat $pid_file` >& /dev/null && sudo rm -f $pid_file $log_file
    
        tty_printf -f green "done"

    fi
}
