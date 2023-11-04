see which flavers are available:

```ruby
git branch
```

create a branch

```ruby
git checkout -b rails_7_1_ruby_3_2_2
```

update vars

ACCOUNT
REPO

Update `Dockerfile.template` to specific rails and ruby versions

```ruby
FROM arm64v8/ruby:3.1.2
...
gem install rails --version "7.0.2.3" && \
```

update database.yml

```ruby
host: db
username: postgres
password: postgres

```

update:

vars

```ruby
DB_EXPOSE=5432
DB_LOCAL_PORT=5432
```

docker-compose.template