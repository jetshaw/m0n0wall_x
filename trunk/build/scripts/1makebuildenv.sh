#!/usr/local/bin/bash

set -e

if [ -z "$MW_BUILDPATH" -o ! -d "$MW_BUILDPATH" ]; then
	echo "\$MW_BUILDPATH is not set"
	exit 1
fi

# get build env ready
if [ ! -x /usr/local/bin/mkisofs ]; then
	pkg_add -r cdrtools
fi
if [ ! -x /usr/local/bin/autoconf-2.13 ]; then
	pkg_add -r autoconf213
fi
if [ ! -x /usr/local/bin/autoconf-2.69 ]; then
	pkg_add -r autoconf
fi

cd $MW_BUILDPATH

# ensure system time is correct
pgrep ntpd > /dev/null || ntpdate pool.ntp.org

# make filesystem structure for image
if [ ! -d m0n0fs ]; then
	mkdir  m0n0fs
fi
if [ ! -d images ]; then
	mkdir images
fi
cd m0n0fs
if [ -d etc ]; then
	rm -rf etc
fi
mkdir -p etc/rc.d/ bin cf conf.default dev etc/mpd-modem ftmp mnt proc root sbin tmp libexec lib /var/etc/dnsmasq usr/bin usr/lib usr/libexec usr/local usr/sbin usr/share usr/local/bin usr/local/captiveportal usr/local/lib usr/local/sbin/.libs usr/local/www usr/share/misc boot/kernel usr/data
 
# insert svn files to filesystem
cp -r $MW_BUILDPATH/freebsd8/phpconf/rc.* etc/
cp -r $MW_BUILDPATH/freebsd8/phpconf/inc etc/
cp -r $MW_BUILDPATH/freebsd8/etc/* etc
chmod 600 etc/ssh/*_key # the ssh_host*_key files should be setted to be readed by nobody but root
cp -r $MW_BUILDPATH/freebsd8/webgui/ usr/local/www/
cp -r $MW_BUILDPATH/freebsd8/captiveportal usr/local/
cp -r $MW_BUILDPATH/freebsd8/cpdata/*  usr/data/
cp -r $MW_BUILDPATH/freebsd8/bindata/* bin/
cp -r $MW_BUILDPATH/freebsd8/bindata/* usr/bin/
cp -r $MW_BUILDPATH/freebsd8/libdata/* lib/
cp -r $MW_BUILDPATH/freebsd8/usrlibdata/* usr/lib/
cp -r $MW_BUILDPATH/freebsd8/boot/* boot/

# set permissions
chmod -R 0755 usr/local/www/* usr/local/captiveportal/*
chmod a+rx etc/rc.reboot
chmod a+x etc/*
 
# create links
echo $(pwd)
rm -f conf
ln -s /cf/conf conf
rm -f usr/local/www/.htpasswd
ln -s /var/run/htpasswd usr/local/www/.htpasswd
 
# configure build information
date > etc/version.buildtime
date +%s > etc/version.buildtime.unix
VERSION=`cat $MW_BUILDPATH/freebsd8/version`

if [ -r $MW_BUILDPATH/freebsd8/svnrevision ]; then
	# replace character '%' in version with repository revision
	SVNREV=`cat $MW_BUILDPATH/freebsd8/svnrevision`
	VERSION=${VERSION/\%/$SVNREV}
fi

echo $VERSION > etc/version
 
# get and set current default configuration
cp $MW_BUILDPATH/freebsd8/phpconf/config.xml conf.default/config.xml
 
# insert termcap and zoneinfo files
cp /usr/share/misc/termcap usr/share/misc
 
# do zoneinfo.tgz and dev fs
cd tmp 
cp $MW_BUILDPATH/freebsd8/build/files/zoneinfo.tgz $MW_BUILDPATH/m0n0fs/usr/share
perl $MW_BUILDPATH/freebsd8/build/minibsd/mkmini.pl $MW_BUILDPATH/freebsd8/build/minibsd/m0n0wall.files  / $MW_BUILDPATH/m0n0fs/

# create php.ini	
cp $MW_BUILDPATH/freebsd8/build/files/php.ini $MW_BUILDPATH/m0n0fs/usr/local/lib/php.ini

# create login.conf
cp $MW_BUILDPATH/freebsd8/build/files/login.conf $MW_BUILDPATH/m0n0fs/etc/
	
# create missing etc files
tar -xzf $MW_BUILDPATH/freebsd8/build/files/etcadditional.tgz -C $MW_BUILDPATH/m0n0fs/
cp $MW_BUILDPATH/freebsd8/build/files/mpd-modem.script $MW_BUILDPATH/m0n0fs/etc/mpd-modem/mpd.script

echo "Finished Stage 1"
