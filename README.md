# docker-dev-template

This is a template for a Docker image that you can do development in, which has access to your local hard drive.

I realize this is likely remedial for most engineers that use Docker a lot, but it's surprisingly hard to figure
out if you don't know anything about Docker and are not trying to set up Kubernetes or some other specialized
system.

## Quick Start

1. Make sure you have Docker installed. Recommend you go to https://docs.docker.com, hover your mouse over “Get
   Docker” and choose your OS. Why there is no install page to link to directly I will never know.
1. Clone this repo
1. `bin/build` - this will build a Docker image and generate a `docker-compose.yml` you can use to run things
1. `bin/start` - A wrapper around `docker-compose up` that you can use to start up everything
1. In another terminal, `bin/exec bash` - Connects to the docker container and starts an interactive `bash` shell
1. `ls -l` - you should see your local directory from withing Docker
1. `exit` - exits `bash` and shuts down the Docker container

There are two more things to validate.

### Validate Filesystem access

The workflow is assuming you edit files on your computer and the Docker container can see them.

1. `bin/sh`
1. `touch foo`
1. `exit`
1. `ls -l foo`

You should see the file `foo` in your local directory. Since you created it inside your Docker container, this
validates that your Docker container can access files on your computer. Nice!

### Validate Networking

Presumably you will write your awesome webapp and run it in the Docker container, but you need to connect to it
from your computer.  The default settings allow you to access the port 9876 on your computer and that will forward
to port 8080 inside the Docker container.  To run a server inside the Docker container, we use
[netcat](http://netcat.sourceforge.net).

1. `bin/sh`
1. `nc -v -v -l -p 8080`
1. You should see a string like `listening on [any] 8080 ...`
1. Open another shell so you can leave the one where you ran `nc` running.
1. `curl localhost:9876`
1. `curl` should sit there paused.  Flip over to the original shell where `nc` is running.
1. You should see something like:

   ```
   172.17.0.1: inverse host lookup failed: Unknown host
   connect to [172.17.0.2] from (UNKNOWN) [172.17.0.1] 48054
   GET / HTTP/1.1
   Host: localhost:9876
   User-Agent: curl/7.54.0
   Accept: */*
   ```

## What This Is

If you look at `bin/start` and `bin/exec`, you will see that they perform various Docker commands. These are to save you from having to remember, write down, or look up the various incantations you will need.

* `bin/build` Creates the necessary stuff from your configuration, which lives in `bin/vars`, `Dockerfile.template`, and `docker-compose.template`. It will also build a Docker image from the generated `Dockerfile`
* `bin/start` will start up the docker image in a container as well as whatever else you have added to `docker-compose.yml`
* `bin/exec` will run commands inside a Docker container based on the image built by `bin/build`. Just remember that the thing you want to run has to be installed in the Docker image.

### Customization

The scripts in `bin/` won't work unless they know a few bits of information that go into the `Dockerfile` and the
build process.  These bits are stored in `bin/vars`. You will most like want to change these depending on your
project.  In particular, you should change the `TAG` if you intend to use this on multiple projects.  Also note
that `WORKDIR` is customizable if you need to work in strange evironments like Golang.

Another avenue of customization is `Dockerfile.template`.  This is exactly like any `Dockerfile`, save for the few
lines that are customized by `bin/build`, which should be obvious.  The most likely thing you will customize is
what software is installed.

Finally, `docker-compose.yml` is used to add other services you want to run, such as databases.
