# notes
Notes, Writeups, Howtos

## Separate Notes

For subjects that had enough notes for their own pages...

* [Virtualization](virtualization.md)
* [Android and ADB](Android.md)
* [Embedded](embedded.md)
* [Docker](docker.md)
* [Git](git_notes.md)
* [Python and VENV](python.md)
* [Storage / NAS](storage_nas.md)

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


