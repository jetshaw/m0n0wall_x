#!/usr/local/bin/bash

set -e

if [ -z "$MW_BUILDPATH" -o ! -d "$MW_BUILDPATH" ]; then
	echo "$MW_BUILDPATH is not set"
	exit 1
fi

VERSION=`cat $MW_BUILDPATH/m0n0fs/etc/version`

if [ -z "/dev/da0" ];then
    echo "the /dev/da0 can not be found !!! "
    exit
fi

if [ -z "$MW_BUILDPATH/freebsd8/build/tools/usb_slices_config" ];then
    echo "the $MW_BUILDPATH/freebsd8/build/tools/usb_slices_config can not be found !!!"
    exit
fi

/bin/dd if=/dev/zero of=/dev/da0 bs=64k count=100
if [ -e "/dev/da0s1" ];then
    echo "dd /dev/da0 failed !!!"
    exit
fi

/sbin/fdisk -i -b $MW_BUILDPATH/m0n0fs/boot/mbr -f $MW_BUILDPATH/freebsd8/build/tools/usb_slices_config /dev/da0
if [ -z /dev/da0s1 -o -z /dev/da0s2 ];then
    echo "fdisk /dev/da0 failed !!!"
    exit
fi

if [ -z $MW_BUILDPATH/images/generic-pc-usb-$VERSION.img ];then
    echo " $MW_BUILDPATH/images/generic-pc-usb-$VERSION.img can not be found !!!"
    exit
fi

/usr/bin/gunzip -S \"\" -c $MW_BUILDPATH/images/generic-pc-usb-$VERSION.img | dd of=/dev/da0s1 ibs=64k obs=64k
/sbin/newfs /dev/da0s2
/sbin/mount /dev/da0s2 /mnt
mkdir /mnt/conf
cp $MW_BUILDPATH/m0n0fs/conf.default/config.xml /mnt/conf/config.xml
cp $MW_BUILDPATH/images/generic-pc-cf-$VERSION.img /mnt/firmware.img
cp $MW_BUILDPATH/freebsd8/build/tools/cf_slices_config /mnt/cf_slices_config
/sbin/umount /mnt

exit

