# Storage and NAS Topics

Disk images, ZFS, LUKS, backup scripts / notes

## NFS Quick How-to (for working with embedded hardware)

These instruction somewhat adopted from Digital Ocean guide:  https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04

To install:
```
sudo apt-get install nfs-kernel-server
```

Create a directory to export
```
sudo mkdir /exports
cd /exports
sudo mkdir embedded
sudo chown nobody:nogroup embedded
sudo chmod a+rwx embedded
```

Update the exports configuration file /etc/exports, and add the following line:
```
/exports/embedded 192.168.1.50(rw,sync,no_root_squash,no_subtree_check)
```
Restart NFS and what not:
```
sudo exportfs -a
# This next step is obviously upstart specific (Ubuntu 14.04 and variants, or earlier)
sudo service nfs-kernel-server start
```

## Working with disk images

kpartx will automatically scan a dd image of a drive for partitions, and mount the partitions to loop devices

Use kpartx -d to delete the loop devices (in /dev/mapper) when done

## LUKS open and close

cryptsetup luksFormat /dev/sdb1

cryptsetup luksOpen /dev/sdb1 encrypted-drive-name

mount /dev/mapper/encrypted-drive-name /mount/point

cryptsetup luksClose encrypted-drive-name

