#!/bin/bash

[ -f ~/.ff-vdr-elec-options ] && source ~/.ff-vdr-elec-options

if [ -n "${FF_VDR_DISTRO_DIR}" ] ; then
	source ${FF_VDR_DISTRO_DIR}/config.sh
elif [ -f ~/ff-vdr-elec/config.sh ] ; then
	source ~/ff-vdr-elec/config.sh
else
	echo "could not find config.sh" && exit 1
fi

ln -sf -T ${FF_VDR_DISTRO_DIR}/addons ${DISTRO_DIR}/packages/ff-vdr-elec

for p in `ls ${FF_VDR_DISTRO_DIR}/${DISTRO}/patches/*.patch` ; do
  echo "Apply patch $p"
  patch -d $DISTRO_DIR -i $p -p 1
done
