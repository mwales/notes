# Docker

Notes, common usages I forget, and tips for Docker

## Docker Setup

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

## Debugging docker containers

```
docker run --it --rm image_tag /bin/sh
```

Note: This will only work if the docker container process is started by the CMD
command, not ENTRYPOINT.

The O'Reilly Docker book also mentions nsenter as a good debug command, but I'm
not sure why I would use it over simply running the shell command.

## Multi-arch Builders

Per O'Reilly book:

```
docker container run --rm --privileged multiarch/qemu-user-static \
--reset -p yes

docker buildx create --name builder --driver docker-container --use builder
```

The second command didn't work for me.  Afterwards, you are supposed to be
able to make multiarch builds, for example:

```
docker buildx build --platform linux/amd64,linux/arm64 \
--tag wordchain:test .
```



