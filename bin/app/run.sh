#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

base=`cd $(dirname $BASH_SOURCE) && pwd` && source $base/../../bootstrap.sh

# This script runs test cases from command line.
# 
# @author Michael Lee <michael.lee@zerustech.com>

# The command line usage of this script.
# 
# Usage: usage
function usage()
{
    printf "run.sh: usage: run.sh [-iasv] [-l log_file] test_directory\n"
    printf "The options are as follows:\n"
    printf "\t-i - Request confirming before running each test case.\n"
    printf "\t-a Run all test cases automatically.\n"
    printf "\t-s Run all test cases in silent mode (default): do not display any output from the test cases.\n"
    printf "\t-v Run all test cases in verbose mode: display output from test cases to stdout.\n"

    exit 0
}

# This function checks if the given path is a valid directory.
# 
# Usage: test_directory <path>
#
# @param path The path to be tested.
# @return 0 if the path is a valid directory, 1 otherwise.
function test_directory()
{
    if [ ! -d $1 ]; then

        printf "Directory $1 does not exist!\n"

        exit 1

    fi
}

log_file=$app_var/tests.log
verbose=0
interactive=1
test_base=

if [ $# == 0 ]; then

    usage

fi

while getopts "iasvl:" opt; do

    case $opt in

        i) interactive=1;;

        a) interactive=0;;

        s) verbose=0;;

        v) verbose=1;;

        l) log_file="$OPTARG";;

        *) usage;;

    esac

done

shift $((OPTIND -1))

test_base=$1

test_directory `dirname $log_file` && test_directory $test_base  || exit $?

for f in `find $test_base -name 'test.sh'`

do
    full_path=`cd -P $(dirname $f) && pwd`/`basename "$f"`

    run=0

    if [ "$interactive" == "1" ]; then

        tty_printf -f yellow "%s " $full_path

        printf "Do you want to run it ? (y/n)"

        old=`stty -g < $(tty)`

        # disable echo and icanon for current tty.
        stty -echo -icanon min 1 time 0 < `tty`

        # read only 1 character, so no need to press enter.
        read -n 1 answer

        # restore the original tty configuration.
        stty "$old" < `tty`

        if [ "$answer" == "y" ]; then

            if [ "$verbose" == "1" ]; then

                tty_printf "\n\n"

            fi

            run=1

        else 

            tty_printf " ... "

            tty_printf -f green "[skip]\n"

        fi

    else

        if [ "$verbose" == "1" ]; then

            tty_printf -f yellow "Running %s ... \n" $full_path

        else

            tty_printf -f yellow "%s " $full_path

        fi

        run=1

    fi

    if [ "$run" == "0" ]; then

        continue

    fi

    if [ "$verbose" == "1" ]; then

        $f | tee $log_file

    else

        tty_printf " ... " $f

        $f >> $log_file 2>&1

        tty_printf -f green "[done]\n"

    fi

done
