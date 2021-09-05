# Dev Environment for Sustainable Web Development with Ruby on Rails

This builds a Docker image that is used by my book, [Sustainable Web Development with Ruby on Rails](https://sustainable-rails.com).

If you just want to follow along, I suggest you [pull the image from Docker Hub](https://hub.docker.com/r/davetron5000/sustainable-rails-dev), set up the `docker-compose.yml` file as directed and go from there.

*This* repo is how that image is built, and you can use this to make your own.

## Customizing

1. Clone this repo
2. Make sure you have Docker installed
3. Edit `bin/vars`.  In particular, you will need to modify:
   * `ACCOUNT` - account name on Docker Hub (used for naming the image only, but if you plan to push, make sure this value is accurate)
   * `REPO` - repo name for Docker Hub (again, only used for naming the image, but if you are going to push, make sure you have created this repo on Docker Hub. It does not need to be public)
   * `TAG` - tag for the image. Recommend you come up with a good scheme to avoid confusing locally.
4. Edit `Dockerfile.template` and `docker-compose.yml.template` as needed to change stuff.  *DO NOT* edit `Dockerfile` or `docker-compose.yml` directly as `bin/build` will be using `bin/vars` to make sure that those two files are consistent with one another.
5. `bin/build` will re-generate `Dockerfile` and `docker-compose.yml` based on the contents of the two `.template` files and `bin/vars`.
6. `bin/start` will start up whatever is in `docker-compose.yml`.
7. In another terminal window, `bin/exec bash` with run `bash` inside the image where Ruby and Rails are installed, effectively "logging you in" to the running container.  You should be in `/root/work`, running as `root` and see all the files in this repo mirrored.  If you run `rails new my-app` it will create a new app in this directory.

## Notes

Inside the container, you can connect to Postgres like so:

```
> psql -Hdb -Upostgres -p5432 # password, when promted, is postgres
postgres=#
```

When you run Rails, you need to tell it to bind to `0.0.0.0`, so you can't just do `bin/rails c`.  Instead you
must:
```
> bin/rails c -b0.0.0.0
```

When you do that, your Rails app should be available to your localhost on port 9000 (or whatever value you set in `bin/vars` for `EXPOSE`)

### Q&A

#### Why didn't you use the Ruby base image?

I wanted to be more explicit about what's being installed.

#### Why is this all generated?

`docker-compose.yml` and `Dockerfile` share some values, but Docker provides no mechanism for that. So, the files are generated.

#### Why not use Vagrant?

No reason, but Docker is a more generally useful skill to have.

#### I'm on MacOS and it's SUPER SLOW

Yup.  You can [set up
NFS](https://naildrivin5.com/blog/2020/05/13/fast-disk-access-mac-using-docker-nfs-webpack-dev-server.html) to make it much much
faster.  The only problem is that Webpack dev mode doesn't work.  But that's probably fine because you should using only what
JavaScript you need, right?
