#!/bin/bash
#
 # file:  activity.sh
 # author:  Matthew Darby
 # course: CSI 3336
 # assignment: Project 4
 # due date:  02/19/2018
 #
 # date modified:  02/14/2018
 #      - file created
 #
 # date modified:  02/17/2018
 #      - error checking modified
 #
 # date modified:  02/18/2018
 #      - functions optimized, script tested, comments and header added
 #
 # This program will take three path names as required command-line arguments, 
 # exit. The c argument is a destination directory and should be a path to a 
 # new directory that does not exist. If c already exists, your program should 
 # print an error message and exit.

# merge function with no arguments
merge(){
    SOURCE1=$1
    SOURCE2=$2
    DEST=$3
    
    # check if $1 does not exist or is a directory
    if [[ ! -d $SOURCE1 ]]
    then
        echo "Error: Source directory $SOURCE1 does not exist." 1>&2
        exit 1

        # check if $2 does not exist or is a directory
        elif [[ ! -d $SOURCE2 ]]
        then
            echo "Error: Source directory $SOURCE2 does not exist." 1>&2
            exit 1
    
        # check if $3 is exists and is a directory
        elif [[ -d $DEST ]]
        then
            echo "Error: Destination directory already exists." 1>&2
            exit 1
        else
            mkdir $DEST
            cp -ru $SOURCE1 $SOURCE2 $DEST  
    fi
} # end of merge

# merge function with "-keep" argument
mergeKeep(){
    SRCCONTENTS=`find $SOURCE2`
    mkdir $DEST 
    cp  -r $SOURCE1 $DEST
 
    for var in $SRCCONTENTS
    do
        DESTFILE=$DEST/$(basename $var)
        if [[ -f $DESTFILE ]]
        then
            mv $DESTFILE "$DESTFILE.old"
            if [[ -f $DESTFILE.old ]]
            then
                echo "ERROR: $DESTFILE.old already exists in destination directory"
                1>&2
            fi
        else
            cp $var $DEST
        fi     
    done
} # end of mergeKeep

# merge function with "-larger" argument passed
mergeLarger(){
    SRCCONTENTS=`find $SOURCE2`
    mkdir $DEST
    cp  -r $SOURCE1 $DEST

    for var in $SRCCONTENTS
    do
        DESTFILE=$DEST/$(basename $var)
        if [[ -e $DESTFILE ]]
        then
            SRCSIZE=$(stat -c %s $var)
            DESTSIZE=$(stat -c %s $DESTFILE)
            if [[ $SRCSIZE -gt $DESTSIZE ]]
            then
                cp $var $DEST
            fi
        else
            cp $var $DEST
        fi
    done   
} # end of mergeLarger

# merge function if both "-keep" and "-large" are passed 
mergeLargeKeep(){
    $SRCCONTENTS=`find $SOURCE2`
    mkdir $DEST
    cp  -r $SOURCE1 $DEST

    for var in $SRCCONTENTS
    do
        DESTFILE=$DEST/$(basename $var)
        if [[ -e $DESTFILE ]]
        then
            SRCSIZE=$(stat -c %s $var)
            DESTSIZE=$(stat -c %s $DESTFILE)
            if [[ $SRCSIZE -lt $DESTSIZE ]]
            then
                mv $var "$var.small"
            fi
        else
            cp $var $DEST
        fi
    done
} # end of mergeLargeKeep

# data abstraction
PARAMS=$@
SOURCE1=1
SOURCE2=1
DEST=1
ARG1=1
ARG2=1
SRCCONTENTS=1

# regular merge if only 3 positional parameters exist
if [[ $# -eq 3 ]]
then
    merge $1 $2 $3

# otherwise, check for and assign values to path and argument variables
else
    for var in $PARAMS
    do
        if [[ $var == "-keep" ]] || [[ $var == "-larger" ]]
        then
            if [[ $ARG1 -eq 1 ]]
            then
                ARG1=$var
            else
                ARG2=$var
            fi
        fi

        if [[ $SOURCE1 -eq 1 ]]
        then
            SOURCE1=$var
        fi

        if [[ $SOURCE1 -ne 1 ]]
        then
            if [[ $SOURCE2 -eq 1 ]]
            then
                SOURCE2=$var
            else
                DEST=$var
            fi
        fi
    done
    
# error checking
    for var in $PARAMS
    do
        if [[ ! -d $SOURCE1 ]] || [[ ! -d $SOURCE2 ]]
        then
            echo "Error: Source directory does not exist." 1>&2
            exit 1
        fi

        if [[ -d $DEST ]]
        then
            echo "Error: Destination directory already exists." 1>&2
            exit 1
        fi
    done
fi

# call the appropriate function now that values are known
if [[ $ARG1 == "-keep" ]]
then
    mergeKeep $ARG1 $SOURCE1 $SOURCE2 $DEST
fi

if [[ $ARG1 == "-larger" ]]
then
    mergeLarger $ARG1 $SOURCE1 $SOURCE2 $DEST
fi

if [[ $ARG2 -ne 1 ]]
then
    mergeLargeKeep $ARG1 $ARG2 $SOURCE1 $SOURCE2 $DEST
fi  
