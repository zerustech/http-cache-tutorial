#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of 'If-Unmodified' conditional requests.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# if-unmodified-since
tty_printf -f green "Test Case: 'If-Unmodified-Since' conditional requests\n"
tty_print_line -f green

tty_printf "Remove session.txt and version.txt.\n\n"
rm -f $web/session.txt $web/version.txt

tty_printf "Post with no body: fails with a 412 response.\n"
$app_bin/http/post.sh -l /index.php -s $web/session.txt

tty_printf "Remove all files and use current date as the value of
'If-Unmodified-Since' header field: fails with a 404 response.\n"
rm -f $web/asset.txt $web/version.txt $web/session.txt && $app_bin/http/post.sh -l /index.php -b "body=a001" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date`"

tty_printf "Create asset.txt and use current date as the value of
'If-Unmodified-Since' header field: receives a 200 response.\n"
touch $web/asset.txt && $app_bin/http/post.sh -l /index.php -b "body=a001" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date`"


tty_printf "Sleep for 2 seconds and use the date of 1 second ago as the value of
'If-Unmodified-Since' header field: receives a 200 response.\n"
sleep 2 && $app_bin/http/post.sh -l /index.php -b "body=a002" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date \"-1\"`"

tty_printf "Use a date of 100 seconds ago as the value of 'If-Unmodified-Since' header field: fails with a 412 response.\n"
$app_bin/http/post.sh -l /index.php -b "body=a003" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date \"-100\"`"

tty_printf "Use a date of 100 seconds ago as the value of 'If-Unmodified-Since'
header field and update the contents of asset.txt with duplicated changes:
receives a 200 response with the original 'Last-Modified' field value.\n"
$app_bin/http/post.sh -l /index.php -b "body=a002" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date \"-100\"`"

tty_printf "Remove session.txt, use a date of 100 seconds ago as the value of
'If-Unmodified-Since' header field and update the contents of asset.txt with
duplicated changes: receives a 200 response.\n"
tty_printf -f red "NOTE: This time, 'Last-Modified' header field is not present
in the response.\n"
rm $web/session.txt && $app_bin/http/post.sh -l /index.php -b "body=a002" -s $web/session.txt "If-Unmodified-Since: `http_gmt_date \"-100\"`"

$service/php.stop && $service/varnish.stop
