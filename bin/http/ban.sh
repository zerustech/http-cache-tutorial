#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../bootstrap.sh

# This script sends an http BAN request to the remote server from the command
# line.
# 
# @author Michael Lee <michael.lee@zerustech.com>

host=localhost
port=80
url=^/
tags=''

# The command line usage of this script.
function usage()
{
    printf "ban.sh: usage: ban.sh [-h host] [-p port] [-l regex] [-t tags] [arguments ...]\n"
    exit 0
}

if [ $# == 0 ]; then

    usage

fi

while getopts "h:p:l:t:" opt; do

    case $opt in 

        h) host="$OPTARG";;

        p) port="$OPTARG";;

        l) url="$OPTARG";;

        t) tags="$OPTARG";;

        *) usage
           ;;

    esac

done

shift $((OPTIND - 1))

http_data=""
http_data=`http_pack "$http_data" "BAN $url HTTP/1.1"`
http_data=`http_pack "$http_data" "Host: $host:$port"`

if [ "$tags" != "" ]; then

    http_data=`http_pack "$http_data" "X-Cache-Tags: $tags"`

fi


for data in "$@"
do

   http_data=`http_pack "$http_data" "$data"`

done

http_send "$host" "$port" "$http_data"

printf "\n\n"
