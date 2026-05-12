#!/bin/bash

set -e

echo "*** Copy root dir for systemd-repart ***"

echo "myfile" > /buildroot/root/.myfile

mkdir /buildroot/.rootdir
cp -al /buildroot/* /buildroot/.rootdir/
mv -v /buildroot/.rootdir /buildroot/rootdir/
cp -al /buildroot/.??* /buildroot/rootdir/

# mkosi should not create directories here...
rm -rf /buildroot/rootdir/work

# Replace /etc with symlink, else fstab will not be
# written in /etc/fstab
rm -rf /buildroot/etc
ln -sf rootdir/etc /buildroot/etc

# cleanup subvolumes and directories which will be over-mounted
# in the running system with the real data
for subvol in .snapshots boot opt root srv usr/local var ; do
	find /buildroot/rootdir/${subvol} -mindepth 1 -delete
done
