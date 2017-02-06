# notes
Notes, Writeups, Howtos

## How to command line resize images for display on website

```
  find . -name "*.JPG" -exec convert {} -resize 1000x1000 -auto-orient ../resized/{} \;
```
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






