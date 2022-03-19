#!/bin/bash
set -u # stop if variables are not set
set -e # stop if error is encountered
set -o pipefail # prevents pipes from masking errors
IFS=$'\n\t' # only newline and tabs are separators


BINPATH=$(dirname "$(readlink -f "$0")" )
BBSQ="$BINPATH/bbsq.exe"
NUTCRACKER="$BINPATH/nutcracker.exe"


function HELP {
    echo -e "  bbmod.sh - Linux version of mass compile and decompile scripts \\n"
    echo -e "  Usage: $0"
    echo -e "  -c   compile one or more files or folders"
    echo -e "  -d   decompile one or more files or folders"
    echo -e "  -r   remove old files after compilation/decompilation to save space"
    echo -e "  -h   prints this message and exists"\\n
    }

function decrypt_and_decompile {
    local FILE="$1"
    local TEMP="$FILE.temp"

    # operate on a copy to preserve the original file
    cp "$FILE" "$TEMP"
    decrypt "$TEMP"
    decompile "$TEMP" "${1/cnut}nut"
    rm "$TEMP"
    }


function compile_and_encrypt {
    local FILE=$1
    local TEMP="$FILE.temp"

    # operate on a copy to preserve the original file    
    cp "$FILE" "$TEMP"
    compile "$TEMP"
    # When compiling, bbsq.exe consumes a single extension
    mv "${TEMP/temp}cnut" "${FILE/nut}cnut"
    rm "$TEMP"
    }


function get_cnut {
    find "$1" -iname "*.cnut"
    }


function get_nut {
    find "$1" -iname "*.nut"
    }

function decrypt {
    wine "$BBSQ" -d "$1"
    }

function decompile {
    wine "$NUTCRACKER" "$1" > "$2"
    }

function compile {
    wine "$BBSQ" -e "$1"
    }


# These functions could be merged into one by using a lot of global values
# or by passing a lot of parameters.
# This would make them a bit hard to read.

function compile_files {
    for INPUT in "$@"; do
        # if INPUT is a folder do recursion:
        if [[ -d "$INPUT" ]]; then
            compile_files "$(get_nut "$INPUT")"
            continue # skip to next item
        fi

        compile_and_encrypt "$INPUT"

        # this depends on the global value of REMOVE
        # is not performed on folders due to the continue statement
        if $REMOVE; then
            rm "$INPUT"
        fi
    done
    }


function decompile_files {
    for INPUT in "$@"; do
        # if INPUT is a folder, do recursion:
        if [[ -d "$INPUT" ]]; then
            decompile_files "$(get_cnut "$INPUT")"
            continue # skip to next item
        fi
        
        decrypt_and_decompile "$INPUT"
        
        # this depends on the global value of REMOVE
        # is not performed on folders due to the continue statement
        if $REMOVE; then
            rm "$INPUT"
        fi
    done
    }


COMPILE=false
DECOMPILE=false
REMOVE=false

while getopts :cdrh FLAG; do
    case $FLAG in
        h)
            HELP
            exit 0
        ;;
        # : in the start of optargs is actually extra, because non of our
        # flags require an argument
        :)
            echo -e "\\nERROR: Must supply an argument to -$OPTARG." >&2
            exit 1
        ;;
        c)
            COMPILE=true
        ;;
        d)
            DECOMPILE=true
        ;;
        r)
            REMOVE=true
        ;;
        \?)
            HELP
            echo -e "\\nERROR: Option -$OPTARG not recognized." >&2
            exit 1
        ;;
    esac
done

shift $((OPTIND-1))


if [[ "$COMPILE" == "$DECOMPILE" ]]; then
    echo -e "\\rERROR: Must select either compilation (-c) or decompilation (d)" >&2
    HELP
    exit 1
fi


if $COMPILE; then
    compile_files "$@"
fi


if $DECOMPILE; then
    decompile_files "$@"
fi
