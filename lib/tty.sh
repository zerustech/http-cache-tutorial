#!/bin/bash

# This file is part of the ZerusTech HTTP Cache Tutorial package.
# 
# (c) Michael Lee <michael.lee@zerustech.com>
#
# For the full copyright and license information, please view the LICENSE file 
# that was distributed with this source code.

tty_base=`cd $(dirname $BASH_SOURCE) && pwd`

# This script provides tty related functions, such as printing text in ansi
# colors, "drawing" a colored line.
#  
# @author Michael Lee <michael.lee@zerustech.com>

# The ansi foreground color table.
tty_ansi_color_fg=(
    'black::30'
    'red::31'
    'green::32'
    'yellow::33'
    'blue::34'
    'magenta::35'
    'cyan::36'
    'white::37'
)

# The ansi background color table.
tty_ansi_color_bg=(
    'black::40'
    'red::41'
    'green::42'
    'yellow::43'
    'blue::44'
    'magenta::45'
    'cyan::46'
    'white::47'
)

# This function finds a color code from foreground or background color table by
# the given color name.
#
# Usage: tty_get_ansi_color_by_name <color_type> <color_name>
# 
# @param color_type A flag indicates where to find the color code: 'fg' stands for
# the foreground color table, 'bg' for the background one.
# @param color_name The color name.
# @return The color code for the given color name, or '' if no match is found.
function tty_get_ansi_color_by_name() {

    local color_table=''

    if [ "$1" == "fg" ]; then

        color_table=${tty_ansi_color_fg[@]}

    else

        color_table=${tty_ansi_color_bg[@]}

    fi

    local color=''

    for i in ${color_table}; do

        color_name="${i%%::*}"

        color_code="${i##*::}"

        if [ "$color_name" == "$2" ]; then

            color="$color_code"

            break
        fi

    done

    printf "$color"
}

# This function prints colored text in the terminal window. It conforms to the
# specification of 'printf' function, so any arguments that work for 'printf'
# can be passed to this function as well.
# 
# Usage: tty_printf [-f fg_color] [-b bg_color] [arguments ...]
#
# @param fg_color The ansi code of the foreground color.
# @param bg_color The ansi code of the background color.
# @param arguments The arguments for a stanard 'printf' function. 
function tty_printf() {

    local fg_color_name='yellow'

    local bg_color_name='black'

    local OPTIND=1

    while getopts 'f:b:' arg 

    do
        case ${arg} in 

            f) fg_color_name=${OPTARG};;

            b) bg_color_name=${OPTARG};;

        esac

    done

    local fg_color=`tty_get_ansi_color_by_name "fg" ${fg_color_name}`

    local bg_color=`tty_get_ansi_color_by_name "bg" ${bg_color_name}`

    local color_prefix="\033[$fg_color;$bg_color""m"

    local color_suffix="\033[0m"

    shift $((OPTIND - 1))

    printf "${color_prefix}" && printf "$@" && printf "${color_suffix}"

}

# This function "draws" a line in the terminal window by repeating a character
# for the given number of times.
#
# Usage: tty_print_line [-f fg_color] [-b bg_color] [-c char]
#        [ -l length]
# 
# @param fg_color The foreground color of the characters.
# @param bg_color The background color.
# @param char The character for "drawing" the line.
# @param length The number of times the given character will repeat.
function tty_print_line() {

    local fg_color_name='yellow'
    local bg_color_name='black'
    local char='='
    local length=56
    local OPTIND=1

    while getopts 'f:b:c:l:' arg

    do
        case ${arg} in 

            f) fg_color_name=${OPTARG};;

            b) bg_color_name=${OPTARG};;

            c) char=${OPTARG};;

            l) length=${OPTARG};;

        esac

    done

    local line=`printf "$char%.0s" $(seq 1 $length)`

    tty_printf -f "$fg_color_name" -b "$bg_color_name" "$line\n"

}
