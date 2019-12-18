# sustainable-rails-docker

In my book, [Sustainable Web Development with Ruby on Rails](https://sustaiable-rails.com), I have the reader set
up a Docker-based development environment in which to run the examples.

This is that environment, cloneable so the reader doesn't have to type in a ton of stuff.

## Install

* Clone the repo
* Make sure you have Docker installed
* `bin/build` - This will use `Dockerfile.template` and `docker-compose.yml.template` to create `Dockerfile` and
`docker-compose.yml`, and then `docker build` the `Dockerfile`.  This last bit will take a while.

## Usage

* Do not edit `Dockerfile` or `docker-compose.yml` directly.  Edit `bin/vars` or the templates instead, and then
re-run `bin/build`
* `bin/start` in one terminal. This is a wrapper around `docker-compose up`
* In another terminal, you can do something like `bin/exec bash` to "log in" to the running container.  `bin/exec`
will run any command you give it in the container, so you can do `bin/exec gem install rails` or whatever.

### Note

When you run Rails, you need to tell it to bind to `0.0.0.0`, so you can't just do `bin/rails c`.  Instead you
must:
```
> bin/rails c -b0.0.0.0
```

When you do that, your Rails app should be available to your localhost on port 9000 (or whatever value you set in `bin/vars` for `EXPOSE`)

