#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
#
# VDR Recording Action Script
# ---------------------------
#
# This script gets executed by VDR before a recording starts, after a
# recording ends and after a recording has been edited.
# In order to allow other addons to hook into this process, this script will
# search for any executables in /storage/.vdr/recording-hooks. These
# hooks are called in their alphabetical order and should follow this
# naming scheme:
#
# R<XX>.<identifier>
#
# Where <XX> is a two digit number, that mainly specifies the execution order
# and <identifier> is a unique descriptor.
#
# Two parameters are passed to each recording hook:
#
# Parameter 1 can have the values "before", "after" and "edited", depending
# on whether the recording hook is called before the recording starts,
# after the recording ends or after the recording has been edited.
#
# Parameter 2 is the directory of the recording. Be aware, that this directory
# doesn't exist before the recording starts.
#

REC_HOOKS_DIR=/storage/.config/vdr/recording-hooks

log="logger -t ff-vdr/record.sh"

recordinghooks=`find -L $REC_HOOKS_DIR -maxdepth 1 -type f | sort`

for recordinghook in $recordinghooks; do
    case $1 in
        before|after)
            action="$1 recording $2"
            ;;
        edited)
            action="after cutting recording $2 from $3"
            ;;
    esac
    if [ -x $recordinghook ]; then
        $log "executing $recordinghook $action"
        $recordinghook "$@"
    else
        $log "executing $recordinghook $action as shell script"
        /bin/sh $recordinghook "$@"
    fi
    [ $? -ne 0 ] && $log "error when executing $recordinghook"
done
