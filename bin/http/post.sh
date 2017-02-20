#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../bootstrap.sh

# This script sends an http POST request to the remote server from the command
# line.
# 
# @author Michael Lee <michael.lee@zerustech.com>

host=localhost
port=80
url=/
body=''
length=0
session_file=
session_name="PHPSESSID"

function usage()
{
    printf "post.sh: usage: post.sh [-h host] [-p port] [-l url] [-b body] [-s session_file] [-n session_name] [arguments ...]\n"
    exit 0
}

if [ $# == 0 ]; then

    usage

fi

while getopts "h:p:l:b:s:n:" opt; do

    case $opt in 

        h) host="$OPTARG";;

        p) port="$OPTARG";;

        l) url="$OPTARG";;

        b) body="$OPTARG";;

        s) session_file="$OPTARG";;

        n) session_name="$OPTARG";;

        *) usage;;

    esac

done

if [ "$session_file" == "" ]; then

    printf "Invalid session file name!\n"

    usage

fi

shift $((OPTIND - 1))

length=${#body}

http_data=""
http_data=`http_pack "$http_data" "POST $url HTTP/1.1"`
http_data=`http_pack "$http_data" "Host: $host:$port"`
http_data=`http_pack "$http_data" "Cache-Control: max-age-0, must-revalidate"`
http_data=`http_pack "$http_data" "Content-Type: application/x-www-form-urlencoded"`
http_data=`http_pack "$http_data" "Content-Length: $length"`

for data in "$@"
do

   http_data=`http_pack "$http_data" "$data"`

done

cookie=`http_load_session_cookie "$session_file" "$session_name"`

if [ "$cookie" != "" ]; then

   http_data=`http_pack "$http_data" "$cookie"`

fi

http_data=`http_pack "$http_data" "\n$body"`

response=`http_send "$host" "$port" "$http_data"`

http_store_session_cookie "$session_file" "$session_name" "$response"

printf "$response"

printf "\n\n"
