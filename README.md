# notes
Notes, Writeups, Howtos

## How to command line resize images for display on website

```
  find . -name "*.JPG" -exec convert {} -resize 1000x1000 -auto-orient ../resized/{} \;
```


