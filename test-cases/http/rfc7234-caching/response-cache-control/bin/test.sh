#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of response Cache-Control directives.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php-start && $service/varnish-start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# no-cache
tty_printf -f green "Test Case: the 'no-cache' response directive:\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /no-cache.php

tty_printf "Sleep for 1 second and test: recevies a fresh 200 response (miss).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /no-cache.php


# no-store
tty_printf -f green "Test Case: the 'no-store' response directive:\n"
tty_print_line -f green
tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /no-store.php

tty_printf "Sleep for 1 second and test: recevies a fresh 200 response (miss).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /no-store.php


# private
tty_printf -f green "Test Case: the 'private' response directive:\n"
tty_print_line -f green
tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /private.php

tty_printf "Sleep for 1 second and test: recevies a fresh 200 response (miss).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /private.php

# public
tty_printf -f green "Test Case: the 'public' response directive:\n"
tty_print_line -f green
tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /public.php

tty_printf "Sleep for 1 second and test: recevies a cached 200 response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /public.php

# max-age
tty_printf -f green "Test Case: the 'max-age' response directive:\n"
tty_print_line -f green
tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /max-age.php

tty_printf "Sleep for 1 second and test: recevies a cached 200 response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /max-age.php

tty_printf "Sleep for 5 second and test: recevies a fresh 200 response (miss).\n"
sleep 5 && $app_vendor_zerustech_cli_bin/http/http-get -l /max-age.php

tty_printf "Test again: recevies a cached 200 response (hit).\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /max-age.php

# s-maxage
tty_printf -f green "Test Case: the 's-maxage' response directive:\n"
tty_print_line -f green
tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /s-maxage.php

tty_printf "Sleep for 1 second and test: recevies a cached 200 response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /s-maxage.php

tty_printf "Sleep for 3 second and test: recevies a fresh 200 response (miss).\n"
sleep 3 && $app_vendor_zerustech_cli_bin/http/http-get -l /s-maxage.php

tty_printf "Test again: recevies a fresh 200 response.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /s-maxage.php

# must-revalidate
tty_printf -f green "Test Case: the 'must-revalidate' response directive:\n"
tty_print_line -f green

tty_printf "Restart varnish and reset default_grace to 10 seconds.\n"
$service/varnish-stop && $service/varnish-start ""

tty_printf "Initialize cache.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /must-revalidate.php

tty_printf "Sleep for 1 second and test: recevies a cached 200 response (hit).\n"
sleep 1 && $app_vendor_zerustech_cli_bin/http/http-get -l /must-revalidate.php

tty_printf "Sleep for 5 second and test: receives a fresh 200 response (miss).\n"
tty_printf "Varnish fetches/validates contents from the origin server, instead of
serving the stale response, because 'must-revalidate' directive is present,
event though the value of 'default_grace' is 10 seconds now."
sleep 5 && $app_vendor_zerustech_cli_bin/http/http-get -l /must-revalidate.php

tty_printf "Restart varnish and set default_grace to 0 seconds.\n"
$service/varnish-stop && $service/varnish-start "-p default_grace=0"

# no-transform
tty_printf -f green "Test Case: the 'no-transform' response directive:\n"
tty_print_line -f green

tty_printf "Access /max-age.php and use gzip as the value of Accept-Encoding heade
field: receives a 200 gzip-encoded response.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /max-age.php "Accept-Encoding: gzip"

tty_printf "Access /no-transform.php and also use gzip as the value of Accept-Encoding
heade field: receives a 200 plain text response.\n"
$app_vendor_zerustech_cli_bin/http/http-get -l /no-transform.php "Accept-Encoding: gzip"

$service/php-stop && $service/varnish-stop
