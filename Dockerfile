# This is generated, please edit
# Dockerfile.template if you want to
# make changes. Also note that some
# values come from bin/vars, so check that out as well
# This is using Docker's official Ruby base image.  It is
# a multi-architecture image, so it should build
# the image using the architecture for what machine you
# are on, which is what you want.
FROM ruby:3.2

# apt-get is used to install various software packages, and it assumes you are
# doing this on a command line that a human is watching.  We want to tell
# it not to ask questions.  Setting the env var does that. Note that it will
# tell apt-get to answer all yes/no questions with "no", so we still need
# to use -y when installing. I don't make the rules.
ENV DEBIAN_FRONTEND noninteractive

# This installs the latest supported verison of Node. It should be
# an even numbered version unless you are doing Node development.
# It also installs yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Installs the Postgres client, which is needed for the Postgres gem.  We don't need
# the entire Postgres server in here.
# These instructions are from https://www.postgresql.org/download/linux/ubuntu/
# This is needed because this version of Debian does not have Postgres 15 and we want to be on 
# the latest version.
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
		wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
		apt-get update && \
		apt-get -y install postgresql-client-15

# Next, we install chromium and chromium-driver to facilitate Rails system tests.
# There is no Chrome for ARM linux distributions, so we have to use Chromium in
# order to be cross platform.  In general, this should be fine.
RUN apt-get -y install chromium chromium-driver

# Now, we set up RubyGems to avoid building documentation. We don't need the docs
# inside this image and it slows down gem installation to have them.
# We also install the latest bundler as well as Rails.  Lastly, to help debug stuff inside
# the container, I need vi mode on the command line and vim to be installed.  These can be 
# omitted and aren't needed by the Rails toolchain.
RUN echo "gem: --no-document" >> ~/.gemrc && \
    gem install bundler && \
    gem install rails --version ">= 7.0.0" && \
    echo "set -o vi" >> ~/.bashrc && \
    apt-get -y install vim

# This entrypoint produces a nice help message and waits around for you to do
# something with the container.
COPY ./show-help-in-app-container-then-wait.sh /root
# vim: ft=Dockerfile
