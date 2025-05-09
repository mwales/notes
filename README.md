# notes
Notes, Writeups, Howtos

## How to command line resize images for display on website

```
  find . -name "*.JPG" -exec convert {} -resize 1000x1000 -auto-orient ../resized/{} \;
```

Convert a movie to an animated GIF from the command line

```
ffmpeg -i input_file.mp4 -vf scale=324:210 -r 10 output_file.gif
```

To get pictures to rotate to match their exif data (my canon camera does this):

```
exiftran -ia *
```
## Removing audio from a video

I use this and kdeenlive to make slideshows for church programs

```
 ffmpeg -i input_video.mp4 -vn -acodec copy output_audio.aac
```

I end up guessing the audio format, and if it is wrong, ffmpeg will fail but
output enough information for me to fix the file extention to the correct
type.

It is basically saying don't use any video codec, output only audio.  And just
copy the audio directly from the input without transcoding it.

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

## Search and replace CLI / Multiple Files

Use sed to manipulate file contents from the command line

```
sed -i -e "s/search for me/replace with me/g" filename.txt
```

Combine with find to process many files at once

```
find . -exec sed -i -e "s/searchString/replaceString/g" {} \;
```

Note: Don't combile -i and -e args into -ie like other linux / unix applications.
Anything immediately after the i is the suffix for file that will be created
instead of replacing in-line

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

### New Way

Visual Studio Code has a pretty awesome markdown preview feature.  Split your view vertically, and
then edit the markdown on the left, and make the right side the preview view of the same document.

### Old Way

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

# XFCE

If the panel taskbar becomes unresponsive, open a shell and type the following to fix:

  xfce4-panel -r 

# Downloading music videos from youtube into MP3s

./youtube-dl -x --audio-format mp3 --playlist-items 1,4,5,10-13,15-16,19-21 InsertPlaylistIdHere

./youtube-dl -x --audio-format mp3 YoutubeUrlOrId

# Desktop sharing / GUI remoting into XFCE Linux system

Remote into the remote system using SSH

Start a vnc server for the the current desktop

```
x11vnc -display :0
```

You can remote into the desktop using vncviewer remote_ip.  If you get a black screen, the screensaver
for the remote system is probably activated.  You have to screen share that as well and unlock the
screensaver

Login to remote system via ssh again, and do the following:

```
sudo bash
cd /run/lightdm/auth
x11vnc -auth \:1 -display :1
```

For whatever reason when I do this, vncviewer / tightvnc wouldn't let me attach to it, but the
xvncviewer would.  On the local system:

```
xvncviewer remote_ip:1
```

You probably should use at minimum password protection the vnc servers, they terminate when you
exit vnc client.

# Docker

To setup docker / get it working

```
sudo apt-get install docker.io
```

This installs docker, and adds the docker group to the system, but it doesn't add the current
user to the docker group.  So you will probably want to do that and then restart.

```
sudo usermod -aG docker ${USER}
sudo reboot
```

To build a docker container, cd into the directory where Dockerfile is and then...

```
docker build --tag tag_for_the_image .
```

List the images on the system

```
docker images
```

Run the docker image

```
# This will block
docker run tag_for_the_image

# This will daemonize / not block
docker run -d tag_for_the_image

# This will let you name the instance
docker run --name instance_name tag_for_the_image
```

To see what images are running...

```
docker ps

# Not sure when I need the -a option, but tutorial showed this...
docker ps -a
```

To stop the image

```
# If you didn't set the instance name, you will have to use ps to find out what the name is
docker stop instance_name
```

See the logs for the instance

```
docker log instance_name

# Also has a -f option to follow
```

To map a port into the container (external port:internal port)

```
docker run -p 5555:1335 tag_for_the_image
```

# Virtualization

Notes about VMWare, virt-manager, and other virtualization stuff.

[Notes about Virtualization](virtualization.md)

# PDF Joining and Splitting

Both of these require PDF toolkit, which seems to be a snap now...

```
sudo apt-get install pdftk
```

## Joing multiple PDFs into 1 document

```
sudo apt-get install pdftk
``

```
pdftk file1.pdf file2.pdf cat output joined.pdf
```

## Seperate multi-page PDF into multiple PDFs

```
pdfseparate input.pdf output-%d.pdf
```

## Removing pages (blank pages) from PDF1

Scanning a mix of double-sided and single sided pages gives me a PDF with a
bunch of blank pages that I need to remove.

```
qpdf input.pdf --pages . 1-3,8,9 -- output.pdf
```

# vi mode for bash

To use vi / vim keybindings in bash shell, execute the following command or
add it to the ~/.bashrc

```
set -o vi
```


