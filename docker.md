# Docker

Notes, common usages I forget, and tips for Docker

* image = Static filesystem, may layers of filesystems, based on dockerfile and build args
* container = An image this is running currently / ran in the past.  Has state
  not described by the Dockerfile

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

## Running Docker Images in Containers

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

To see what containers / images are running...

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

To download a docker image from dockerhub

```
docker image pull pwncollege:challenge-legacy
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

## Building Docker Images

In your folder you are building image from, you can specify a .dockerignore
to have docker build ignore certain files

* ARG = Lets you set a variable in dockerfile from the builder command line
```
ARG email="docker_master@pants.com"
```
* CMD = Command to start container with, and it's args.  This can be overridden
  when containers started by specifying a command after the container name / tag
```
CMD [ "/runme.sh", "arg1", "arg2" ]
```

## Docker image repository / dockerhub

Login to the repo (if you don't specify a registry URL, it will use dockerhub
by default.

```
docker login your_docker_registry.com
```

You can push your image to the registry:

```
docker image push username/docker-image-name:latest
```

You can now run or pull the image from the registry...
```
docker image build -t repo/username/docker-image-name:latest .
docker image pull username/docker-image-name:latest



## Podman

Docker without all the root

```
podman login docker.com
podman pull docker.io/mwales/chal_test:latest

podman run --rm -it docker.io/mwales/chal_test:latest /bin/bash
podman run -v ./:/mnt --rm -it docker.io/mwales/chal_test:latest /bin/bash

