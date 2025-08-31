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

# Adding physical disks to proxmox / QEMU VMs

Don't add the disks by what SATA controller they are attached to because it 
will change all the time, add them by disk ID.

Enumerate your disks using one of the paths here:
```
ls /dev/disk/by-id
```

To add to VM:

```
qm set vm_id -scsi2 /dev/disk/by-id/my_long_disk_name
```
 
You can get the VM names and numbers by executing the following:

```
qm list --full
```

## Working with disk images

kpartx will automatically scan a dd image of a drive for partitions, and mount the partitions to loop devices

Use kpartx -d to delete the loop devices (in /dev/mapper) when done

## LUKS open and close

cryptsetup luksFormat /dev/sdb1

cryptsetup luksOpen /dev/sdb1 encrypted-drive-name

mount /dev/mapper/encrypted-drive-name /mount/point

cryptsetup luksClose encrypted-drive-name

I didn't have the drive luksOpen with a name, but it was still open...

```
cryptsetup close /dev/mapper/luks-blah blah blah
```

# ZFS storage

Storage filesystem.  Everything has checksums.  Can determine when data
corruption has occured and correct it.  Pool storage, means we can add
storage devices and easily change our storage container sizes separately.
Can compress files on the container too.

Terminology:

* vdev: vdevs can have redundancy
* dataset: a filesystem you can mount.  Don't put the whole pool in a single
  dataset.  Can configure compression per dataset.
* sync
* arc: adaptive replacement cache. memory based read cache.
* l2arc: disk based read cache
* zvol: if datasets are like files/folders, zvols are like block devices. Can
  only be used by 1 client.

We create a storage pool using multiple disk drives.


## Commands

Look at the usage of all my storage tanks / pools

```
zfs list
```

```
zpool list
zpool status
```

Get performance metrics...

```
zpool iostat
zpool iostat -v
```
## Maintenance

Periodically, like once a month, go through the filesystem and check on the
checksums / verify data integrity.

```
zpool scrub storage
```

## Moving

Before moving the container, export it.  Allows the zpool to be easily imported
on another system

```
zfs export my_pool
```

On new system, import all ZFS pools (and let ZFS find them automagically)

```
zfs import -a
```



## One time commands / creation

```
zpool create my_pool_name raidz da0 da1 da2
```

Create a dataset on the new pool

```
zfs create my_pool_name/my_dataset_name
zfs set compression=gzip my_pool_name/my_dataset_name
```


