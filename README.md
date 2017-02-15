# notes
Notes, Writeups, Howtos

## How to command line resize images for display on website

```
  find . -name "*.JPG" -exec convert {} -resize 1000x1000 -auto-orient ../resized/{} \;
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


