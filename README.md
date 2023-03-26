# Dev Environment for Sustainable Web Development with Ruby on Rails

This is a basis for creating a Ruby on Rails development environment using Docker.  It is based on the development environment used for my book [Sustainable Web Development with Ruby on Rails](https://sustainable-rails.com) and can be used and customized to meet any needs for doing local development.

## What problem does this solve?

* Setting up dependencies for developing Rails apps is not easy, especially as operating systems change.
* Although Docker can solve this, it is difficult to use and difficult to configure.

## How does it solve it?

This provides a base `Dockerfile` to define an image in which your app can run, a base `docker-compose.yml` file that will start a
container based on that image, along with a Postgres and Redis accessible to the container, and several helper scripts to make
dealing with everything much simpler.

Once everything is started up, you execute your `rails` commands inside the container, but can edit your code on your computer
using whatever editor you like.

## Example

```
> bin/init # one time only, does some setup for you
> bin/start # Postgres & Redis are now running, and a third container
            # is running that has Ruby, Node, Chromium, and Rails in it
            # along with access to your app's source code
```

In another terminal:

```
> bin/exec bash
root@4d1ac12d40db:~/work# bin/rails test
# Runs all your tests
```

## How to Use

1. Make sure Docker is installed
1. Clone this repo
1. `bin/init`
   - This will ask several questions that will name your project, name the image you'll create where you
     can run your app, and set your platform so you run images that match your processor.
1. `bin/start`
1. In another terminal: `bin/exec bash`

You should be able to run all your development commands such as `bin/rails c`, `bin/dev`, `npm install the-world` and so forth.
You should see that `/root/work` (where you are placed immediately after running `bin/bash`) contains the files from your computer.

## Customizing

This repo is intended to be the basis for *your* dev environment, so my recommendation is to create a new repo
where you manage your dev-environment and seed it with these files.

There are four main points where you can customize things, starting from most common to least common:

* `Dockerfile` - This controls what is available on the image where your app is run.  The default sets up Node, Chromium, the
Postgres client, and Ruby.  If you don't need those, remove them. If you need other stuff, like wkhtmltopdf, add the requisite
`RUN` directives to install them.
* `docker-compose.yml` - This controls the services available to your app. If you don't need Redis, remove it. If you need elasticsearch, add it.  DockerHub has tons of service you can quickly plug in and run.
* `docker-compose.env` - This is well-documented and controls the name of your project, name of your image, and your architecture.
`bin/init` should've walked you through setting it up.
* The scripts in `bin/` - These all wrap Docker commands so you don't have to type a lot or remember the various flags needed to
get things working.  You can just change these!

## Where is this being used?

This was extracted from the toolchain I created for my book, [Sustainable Web Development with Ruby on Rails](https://sustainable-rails.com).  All the examples and code in that book were executed many times in this development environment.  I have also been using this for the past two years at my startup to manage the development of two Rails apps and a Zendesk sidebar app.

## The World's Quickest Docker Tutorial

Docker is confusing, poorly documented, and poorly designed, so if it makes you feel as stupid as it makes me feel, that is OK.  Here is a bit of conceptual grounding to help understand what is going on.

* A `Dockerfile` is a set of instructions for a computer you would like to run.
* *Building* a `Dockerfile` produces an *Image*.  This is a set of bytes on your hard drive and you could consider
this to be a clone of the hard drive of a computer you want to run.
* *Starting* an image produces a *Container*.  This is a virtualized computer running the image
* In `docker-compose.yml`, there are services, which describe the containers you want to run in unision. Because a
container is a virtualized computer running an image, each service requires an image that will be run.  All the
containers are run on the same network and can see each other.
* When you see the word *Host* that is *your computer*. That is where Docker is running. I cannot think of a more confusing and
unintuitive term  but that is what they went with.

To make another analogy, `Dockerfile` is like source code to a class. An image is the class itself, and a container
is an object you created from that class. `docker-compose.yml` is your program that integrates objects of several
classes together.

## Helpful Notes

Inside the container, you can connect to Postgres like so:

```
> PGPASSWORD=password psql -Hdb -Upostgres -p5432
postgres=#
```

When you run Rails, you need to tell it to bind to `0.0.0.0`, so you can't just do `bin/rails c`.  Instead you
must:
```
> bin/rails c -b0.0.0.0
```

When you do that, your Rails app should be available to your localhost on port 9999 (or whatever value you set in `bin/vars` for `EXPOSE`)

## Core Values

* As few dependencies as possible
* Your computer is not your development environment, it *runs* your development environment
* Useful for working professionals
* Programmers should understand how their development environment works

### Non-Values

* Flexibility
* Production Deployments
* Hiding details about how this works from the user


### Things That Could be Improved

* A way to QA this on other platforms like Linux or Windows without me having to buy a Linux machine or a Windows
machine.
* Ability to target more than just ARM64 without a lot of customizations
* Probably some Docker best practices I'm not aware of needing to consider

## FAQ

### Why is this ARM64?

When running Chrome inside an AMD-based Docker container, Apple Silicon is unable to emulate certain system calls
it needs, thus you cannot run Rails system tests in an AMD-based Docker container running on Apple Silicon.

### Why is this using Chromium?

See the answer above.  Chrome is not available for ARM64-based Linux operating systems, however Chromium is.

### How can I use AMD-based Images?

Change this:

```
FROM arm64v8/ruby:3.1
```

to whatever base image you like, such as `amd64/ruby:3.1`.

If you do that, you don't have to use chromium. You can remove this line:

```
RUN apt-get -y install chromium chromium-driver
```

You will need to replace it with a more convoluted set of invocations that has changed many times since I first
created this repo, so I will not document them here, as they are likely to be out of date. I'm sorry about that,
but Google does not care about making this process easy.

### What about that docked rails thing?

The Rails GitHub org has a repo called [docked](https://github.com/rails/docked) that ostensibly sets up a dev
environment for Rails.  It may evolve to be more useful, but here are the problems it has that this repo does not:

* It will not work on Apple Silicon for reasons mentioned above re: Chrome
* It does not provide a solution for running dependent infrastructure like Postgres which, in my experience, is much
harder to do than getting Rails running.
* It requires setting up shell aliases, which I dislike.
* It uses an odd-numbered version of Node, and it's not a good idea to use that for development or production
  unless you are working on Node itself.  Odd-numbered versions go end-of-life frequently and become unsupported. It's better and safer to use even-numbered versions.
* It is designed for beginners to programming and Rails, which is great because we need more Rails developers, but
that is a different use-case than a development environment for professional, experienced Rails developers. And
yes, I mean "professional" in the sense of "getting paid to write Rails" and not in whatever stupid way Uncle Bob
means it.

### Why is this all generated from templates?

`docker-compose.yml` and `Dockerfile` share some values, but Docker provides no easy mechanism for that that I could figure out. So, the files are generated.

### Why not use Vagrant?

Docker is a more generally useful skill to have, so I decided to focus on this and not learn Vagrant, which is less
useful.

## Contributions

I would love some!  I am not a Docker expert and I only have used this for the way I do Rails. I'd love for this to
be more useful (see above).

A few things I am not interested in:

* Adding dependencies.  I love Ruby and love writing command line apps in Ruby but Ruby's exsitence is not
reliable, which is why the scripts are in bash.
* Non-Rails web development. I want this to be about Rails
* Deprecated or unsupported versions of things
