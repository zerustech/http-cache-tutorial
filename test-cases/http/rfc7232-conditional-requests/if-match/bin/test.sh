#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh

# This script runs the test cases of 'If-Match' conditional requests.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# if-match
tty_printf -f green "Test Case: 'If-Match' conditional requests\n"
tty_print_line -f green

tty_printf "Remove session.txt and version.txt.\n\n"
rm -f $web/session.txt $web/version.txt

tty_printf "Post with no body: fails with a 412 response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -s $web/session.txt

tty_printf "Remove all files and use entity tag '*' when update the contents of
asset.txt: fails with a 404 response.\n"
rm -f $web/asset.txt $web/version.txt $web/session.txt && $app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a001" -s $web/session.txt 'If-Match: "*"'

tty_printf "Create asset.txt and include 'If-Match: \"*\"' header in the request: receives a 200 response.\n"
touch $web/asset.txt && $app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a001" -s $web/session.txt 'If-Match: "*"'

tty_printf "Include 'If-Match: \"1\"' header in the request: receives a 200 response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a002" -s $web/session.txt 'If-Match: "1"'

tty_printf "Include 'If-Match: \"1\", \"2\"' header in the request: receives a 200 response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a003" -s $web/session.txt 'If-Match: "1", "2"'

tty_printf "Include 'If-Match: \"1\", \"2\"' header in the request to update
the contents of asset.txt with duplicated contents: receives a 200 response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a003" -s $web/session.txt 'If-Match: "1", "2"'

tty_printf "Remove session.txt, include 'If-Match: \"1\", \"2\"' header in the
request to update the contents of asset.txt with duplicated contents: receives 
a 200 response.\n"
tty_printf -f red "NOTE: This time, 'Etag' header field is not present in the
response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a003" -s $web/session.txt 'If-Match: "1", "2"'

tty_printf "Include 'If-Match: \"10\"' header in the request to update the
contents of asset.txt: receives a 412 response.\n"
$app_vendor_zerustech_cli_bin/http/http.post -l /index.php -b "body=a010" -s $web/session.txt 'If-Match: "10"'

$service/php.stop && $service/varnish.stop
