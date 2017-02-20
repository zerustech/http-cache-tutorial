#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

http_base=`cd $(dirname $BASH_SOURCE) && pwd`
source $http_base/tty.sh

# This script provides functions that perform variant http related tasks, such
# as preparing an http data packet, sending an http request, parsing session
# cookie.
# 
# @author Michael Lee <michael.lee@zerustech.com>

# This function packs one line of http data to the buffer.
# 
# Usage: http_pack <buffer> <line>
# 
# @param buffer The data buffer.
# @param line The line of data to be packed.
# @return The updated data buffer.
function http_pack(){

    local target="$1"

    if [ "$target" != "" ]; then

       target="$1\n$2"

    else

       target="$2"

    fi

    target=`printf "$target" | sed -E 's/^ *//' | sed -E 's/ *$//'`

    printf "$target"
}

# This function sends an http request to the remote server.
#
# Usage: http_send <host> <port> <data>
# 
# @param host The host name or ip address of the remote server.
# @param port The port number of the remote server.
# @param data The raw http data packet.
function http_send() {

    local host=$1

    local port=$2

    tty_printf "\nRequest:\n"
    tty_print_line -c ">"
    printf "$3\n\n"

    tty_printf "\nResponse:\n"
    tty_print_line -c "<"
nc "$host" "$port" << EOF
$3

EOF

}

# This function sends an http request to the remote server.
#
# Usage: http_send <host> <port> <data>
# 
# @param host The host name or ip address of the remote server.
# @param port The port number of the remote server.
# @param data The raw http data packet.
function http_load_session_cookie() {

    local session_file=$1

    local session_cookie_name=$2

    local session_cookie_value=''

    local cookie=''

    if [ -f "$session_file" ]; then

        session_cookie_value=`cat $session_file`

    fi

    if [ "$session_cookie_value" != "" ]; then

        cookie="Cookie: $session_cookie_name=$session_cookie_value"

    fi

    printf "$cookie"
}

# This function parses and return the value of session cookie from a 'Set-Cookie' response
# header field.
#
# Usage: http_parse_session_cookie <body> <cookie_name>
# 
# @param body The payload body of the response.
# @param cookie_name Name of the session cookie (e.g, PHPSESSID). 
# @return The parsed value or '' if 'Set-Cookie' header field is not present or
# no valid cookie value is found.
function http_parse_session_cookie() {

    local http_body=$1

    local session_cookie_name=$2

    local session_cookie_value=`echo "$http_body" | grep "Set-Cookie" | sed -E "s/^Set-Cookie: $session_cookie_name=([^;]+);.*$/\1/"`

    printf "$session_cookie_value"
}

# This function parses the value of of session cookie from response and stores
# the value to a specified file.
#
# Usage: http_store_session_cookie <file> <name> <body>
# 
# @param file Path to the file for storing the value of the session cookie.
# @param name Name of the session cookie (e.g, PHPSESSID). 
# @param body The payload body of the response.
function http_store_session_cookie() {

    local session_file=$1
    local session_cookie_name=$2
    local http_body=$3

    local session_cookie_value=`http_parse_session_cookie "$http_body" "$session_cookie_name"`

    if [ "$session_cookie_value" != "" ]; then

        printf "$session_cookie_value" > $session_file

    fi
}

# This function generates a representation of current date adjusted by the given
# number of seconds (positive or minus) in RFC7231 format.
#
# Example: Thu, 01 Dec 1994 16:00:00 GMT
#
# Usage: http_gmt_date <offset>
# 
# @param offset The number of seconds (positive or minus) to be adjusted on
# current date.
# @return The GMT representation of the adjusted time.
function http_gmt_date() {

    local offset=0

    if [ "$1" != "" ]; then

        offset=$1

    fi

    local date=`$php_home/bin/php $http_base/../bin/php/gmtdate.php $offset`

    printf "$date"
}
