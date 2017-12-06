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

## T-mux Tip

To save a scroll-back buffer in tmux, do the following:

```
<CTRL-B> :
capture-pane -S -3000
<CTRL-B> :
save-buffer filename.txt
```

Note:  It's really easy to forget the negative in the number of lines to capture!

## udev and Android Debug Bridge notes

A blog entry with some good notes about this:

https://androidonlinux.wordpress.com/2013/05/12/setting-up-adb-on-linux/

### udev rule format:

```
#ZTE (Ubuntu community rule format)
SUBSYSTEM==usb, SYSFS{idVendor}==19d2, MODE=0664, GROUP=plugdev
#DJI (Andorid dev documentation rule format)
SUBSYSTEM==usb, ATTR{idVendor}==2ca3, ATTR{idProduct}==001f, MODE=0666, GROUP=plugdev
```

### Restarting udev

I'm wondering now if this stuff still works with systemd

```
sudo service udev restart
sudo udevadm contorl --reload-rules
```

### ADB commands

Sometimes I have different success with the Ubuntu pre-packaged adb versus the Android tools binary

```
./adb kill-server
./adb start-server
./adb devices
```

## Previewing Github Style Markdown

Not all markdown is created equal, so in an effort to reduce the number of commits I have to make
to github repos that have issues with the markdown, I should preview the markdown locally before
I commit it.

There is a python tool that can be used to render the markdown:

```
pip install grip

# Or what I had to do
pip install grip --user
```

There documentation says you can just type grip in a directory and it pick a port number and setup
a web server and start serving the HTML version of the markdown for you.

```
grip
```

I wasn't able to do that, but they show you how to write a quick python application that will serve
the markdown for you, and this is what I ended up doing.  Create a python script preview.py, and add
the following contents to it:

```
#!/usr/bin/env python

from grip import serve

serve(port=8080)
```

Make it executeable, and then execute the script.  Then you just open browser, and head to 127.0.0.1:8080


