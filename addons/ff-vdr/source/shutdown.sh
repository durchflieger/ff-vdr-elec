#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
#
# VDR Shutdown Script
# -------------------
#

SHUTDOWN_HOOKS_DIR=/storage/.config/vdr/shutdown-hooks/
SHUTDOWNCMD="systemctl poweroff"

log="logger -t ff-vdr/shutdown.sh"

osdmsg()
{
    # OSD message must be deferred, to let VDR display it AFTER the
    # shutdown script has been executed
    sleep 2
    echo "MESG $1" | nc -w 20 localhost 6419 >/dev/null 2>&1
}

shutdownhooks=`find -L $SHUTDOWN_HOOKS_DIR -maxdepth 1 -type f | sort`

for shutdownhook in $shutdownhooks; do
    TRY_AGAIN=0

    if [ -x $shutdownhook ]; then
        $log "executing $shutdownhook"
        result_data=`$shutdownhook "$@"`
    else
        $log "executing $shutdownhook as shell script"
        result_data=`/bin/sh $shutdownhook "$@"`
    fi
    result=$?
    eval $result_data
    if [ $result -ne 0 ] ; then 
        $log "Shutdown aborted by $shutdownhook with exitcode $result"
        osdmsg "Shutdown aborted!" &
        [ -z "$ABORT_MESSAGE" ] || osdmsg "$ABORT_MESSAGE" &
        exit $result
    fi

    if [ $TRY_AGAIN -gt 0 ]
    then
        $log "$shutdownhook requests to try again in $TRY_AGAIN minutes" 
        nohup sh -c "( sleep $(( $TRY_AGAIN * 60 )) && echo \"HITK Power\" | nc -w 20 localhost 6419)" >/dev/null 2>&1 & 
        osdmsg "Shutdown aborted. Retry in $TRY_AGAIN minutes." &
        exit 0
    fi
done 

eval $SHUTDOWNCMD
