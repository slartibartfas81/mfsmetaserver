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
MASTER_CFG=/usr/local/etc/mfs/mfsmetalogger.cfg

echo "Set master host as $MFSM_MASTERHOST"
sed -i "s/^MASTER_HOST = .*\|# MASTER_HOST = mfsmaster/MASTER_HOST = $MFSM_MASTERHOST/g" $MASTER_CFG

echo ""
echo "here we go..."
mfsmetalogger -d
