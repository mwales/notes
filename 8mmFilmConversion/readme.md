# Notes on converting 8mm Film to video

Need a projector with a variable frame rate.  My film was around 18 FPS, and when the camera tried to record it, I had 
lots of flickering.  Upping the framerate to around 22 FPS helped the flickering but makes the audio high-pitch.

I also had the luck of having a projector with a headphone output.  I have seen many other conversions where you can
hear the projector noise in the background.

Put the projector somewhere steady, get it precisely focused (I find that one it is up and running, I do not need to ever
touch the focus.  I put my DSLR as close as I can to the center of the screen without interfering with the projection
to reduce the keystone effect.  I run the projector headphone output directly into the DSLR microphone input.  This also
has the advantage that when you watch the digital movies you will not have to listen to the sound of the projector!

I put a 50mm fast prime lens on my camera and moved it to where the top and bottom of the video frame were roughly at
the top and bottom of the projected image.  I manually focused the camera so it would not ever try to auto-focus
during a movie.  The projectors focus would occasionally require touch adjustments.  My cameras tripod ended up
directly in front of the projector, and the projected a screen of about 20 inches.

I projected onto a screen, but I have read on some discussions that projecting onto a white matte finished poster
board would be best.

## Post processing 

I use Avidemux to trim the front and end of the video to fit the content exactly.  It can copy the input video and
audio stream exactly, so the video is not recompressed.

I then use mencoder to fix the frame rate and audio pitch.  I could not find a solution very easily that would change
the speed of the audio and video.  I eventually searched around for posts where people complained about chaning the
speed ruining the pitch of the audio (which was exactly the effect I needed).

My mencoder command:

    mencoder 363-trimmed.mov -ovc copy -oac pcm -speed .82 -o final.avi

Also controlling a script I used to convert the videos.
