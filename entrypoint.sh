#!/bin/sh

mkdir -p /usr/local/etc/mfs/
chown mfs:mfs -R /usr/local/

for configFiles in $(ls /usr/local/*.cfg)
do
        if [ ! -f /usr/local/etc/mfs/mfsmaster.cfg ]
        then
                echo "copy initial $configFiles"
                cp /usr/local/$(basename "$configFiles") /usr/local/etc/mfs/
        fi
done
CFG_FILE=/usr/local/etc/mfs/mfsmetalogger.cfg

echo "Set master host as $MFSM_MASTERHOST"
sed -i "s/^MASTER_HOST = .*\|# MASTER_HOST = mfsmaster/MASTER_HOST = $MFSM_MASTERHOST/g" $CFG_FILE
echo "Set backlogs to $MFSM_BACKLOG"
sed -i "s/^BACK_LOGS = .*|# BACK_LOGS = .*/BACK_LOGS = $MFSM_BACKLOGS/g" $CFG_FILE
echo "Set download frequency to $MFSM_DLFREQ"
if [ $(($MFSM_BACKLOGS/2)) -gt $MFSM_DLFREQ ]
then
	sed -i "s/^META_DOWNLOAD_FREQ = .*|# META_DOWNLOAD_FREQ = .*/META_DOWNLOAD_FREQ = $MFSM_DLFREQ/g" $CFG_FILE
else
	echo "Download frequency is to high, it should be at most $(($MFSM_BACKLOGS/2))"
	echo "Setting download frequency to $((($MFSM_BACKLOGS/2)-1))"
	sed -i "s/^META_DOWNLOAD_FREQ = .*|# META_DOWNLOAD_FREQ = .*/META_DOWNLOAD_FREQ = $((($MFSM_BACKLOGS/2)-1))/g" $CFG_FILE
fi

echo ""
mfsmetalogger -d
