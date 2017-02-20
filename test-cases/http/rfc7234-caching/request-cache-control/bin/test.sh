#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../../../../bootstrap.sh                                     

# This script runs the test cases of request Cache-Control directives.
# 
# @author Michael Lee <michael.lee@zerustech.com>

service=$base/../service                                                                                                 
web=$base/../web

# For testing purpose, set default_grace to 0, otherwise, varnish will serve
# stale contents.
$service/php.start && $service/varnish.start "-p default_grace=0"

# wait for the php builtin server to start
sleep 1

# max-age
tty_printf -f green "Test Case: request 'max-age' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Access index.php with no arguments: receives a cached 200 response
(hit).\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Sleep for 2 seconds, include 'max-age=1' Cache-Control
directive in the request and test: receives a fresh 200 response (miss).\n"
sleep 2 && $app_bin/http/get.sh -l /index.php "Cache-Control: max-age=1"

tty_printf "Include 'max-age=0' Cache-Control directive in the request
and test: receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: max-age=0"

# no-cache
tty_printf -f green "Test Case: request 'no-cache' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Ban and initialize cache.\n"
$app_bin/http/ban.sh -l ^/ && $app_bin/http/get.sh -l /index.php

tty_printf "Include 'no-cache' Cache-Control directive in the request and test:
receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: no-cache"

# no-store
tty_printf -f green "Test Case: request 'no-store' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Ban and initialize cache.\n"
$app_bin/http/ban.sh -l ^/ && $app_bin/http/get.sh -l /index.php

tty_printf -f green "Include 'no-store' Cache-Control directive in the request
and test: receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: no-store"

# only-if-cached
tty_printf -f green "Test Case: request 'only-if-cached' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Ban and initialize cache.\n"
$app_bin/http/ban.sh -l ^/ && $app_bin/http/get.sh -l /index.php

tty_printf "Include 'only-if-cached' Cache-Control directive in the request and
test: receives a cached 200 response (hit).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: only-if-cached"

tty_printf "Ban and test again: fails with a 503 response.\n"
$app_bin/http/ban.sh -l ^/ && $app_bin/http/get.sh -l /index.php "Cache-Control: only-if-cached"

# min-fresh
tty_printf -f green "Test Case: request 'min-fresh' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Ban and initialize cache.\n"
$app_bin/http/ban.sh -l ^/ && $app_bin/http/get.sh -l /index.php

tty_printf "Include 'min-fresh=1' Cache-Control directive in the request and
test: receives a cached 200 response (hit).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: min-fresh=1"

tty_printf "Sleep for 3 seconds, include 'min-fresh=3' Cache-Control directive
in the request and test: receives a fresh 200 response (miss).\n"
sleep 3 && $app_bin/http/get.sh -l /index.php "Cache-Control: min-fresh=3"

# max-stale
tty_printf -f green "Test Case: request 'max-stale' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Restart varnish and reset 'default_grace' to 10 seconds.\n"
$service/varnish.stop && $service/varnish.start ""

tty_printf "Initialize cache.\n"
$app_bin/http/get.sh -l /index.php

tty_printf -f green "Sleep for 8 seconds, include 'max-stale=5'
Cache-Control directive in the request and test: receives a cached 200 response
(hit).\n"
sleep 8 && $app_bin/http/get.sh -l /index.php "Cache-Control: max-stale=5"

tty_printf -f green "Include 'max-stale=1' Cache-Control directive in the
request and test: receives a fresh 200 response (miss).\n"
$app_bin/http/get.sh -l /index.php "Cache-Control: max-stale=1"

tty_printf "Restart varnish and set 'default_grace' to 0.\n"
$service/varnish.stop && $service/varnish.start "-p default_grace=0"

# no-transform
tty_printf -f green "Test Case: request 'no-transform' Cache-Control directive.\n"
tty_print_line -f green

tty_printf "Initialize cache.\n"
$app_bin/http/get.sh -l /index.php

tty_printf "Include 'Accept-Encoding: gzip' and 'max-age=0' Cache-Control
directive header in the request and test: receives a gzip encoded 200 response.\n"
$app_bin/http/get.sh -l /index.php "Accept-Encoding: gzip" "Cache-Control: max-age=0"

tty_printf "Include 'Accept-Encoding: gzip' header and 'max-age=0, no-transform'
Cache-Control directives in the request and test: receives a plain text 200
response.\n"
$app_bin/http/get.sh -l /index.php "Accept-Encoding: gzip" "Cache-Control: max-age=0,no-transform"

$service/php.stop && $service/varnish.stop
