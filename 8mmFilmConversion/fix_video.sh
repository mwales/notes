#!/bin/bash

# This script will convert video that I recorded with my Canon T5i at 30fps
# from a project displaying 18fps video at 22-ish fps.  The resultant video
# will be 25fps and 1080p.

# Use avidemux to trim the ends of the video

if [ $# -ne 2 ]
then
	echo "Usage: $0 movie.mov outputfolder"
	exit 1
fi

if [ ! -d $2 ]
then
	echo "Directory $2 doesn't exist"
	exit 1
fi

echo "mencoder $1 -ovc copy -oac pcm -speed .82 -o $2/$1"
mencoder $1 -ovc copy -oac pcm -speed .91 -o $2/$1

