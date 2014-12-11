#!/bin/csh 
# used locally. 

set LOCAL_SVN_HOST='192.168.1.122'

set MW_BUILDPATH=/usr/m0n0wall/build84
setenv MW_BUILDPATH $MW_BUILDPATH
setenv MW_ARCH `uname -m`

# ensure prerequisite tools are installed, usually for the newly installed system.
if ( ! -x /usr/local/bin/bash ) then
	pkg_add -r bash
endif
if ( ! -x /usr/local/bin/svn ) then
	pkg_add -r subversion
endif

echo "Creating build directory $MW_BUILDPATH."
mkdir -p $MW_BUILDPATH

svn export svn://${LOCAL_SVN_HOST}/pisense/dep/freebsd/ports/head $MW_BUILDPATH/tmp/ports/tree

echo "Exporting repository to $MW_BUILDPATH/freebsd8."
/usr/local/bin/svn co --force svn://${LOCAL_SVN_HOST}/pisense/trunk $MW_BUILDPATH/freebsd8

echo "Changing directory to $MW_BUILDPATH/freebsd8/build/scripts"
cd $MW_BUILDPATH/freebsd8/build/scripts
chmod +x *.sh

echo 
echo "----- Build environment prepared -----"
echo "I will leave you in a bash shell now"
echo "To start the build, execute doall.sh or run 1makebuildenv.sh , then 2makebinaries.sh, then 3patchtools.sh etc"
setenv PS1 "m0n0wall-build# "
/usr/local/bin/bash
