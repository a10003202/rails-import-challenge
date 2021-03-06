# README

This README would normally document whatever steps are necessary to get the
application up and running.

### Things you may want to cover:

* Ruby version

  - 2.5.1

* System dependencies

  - MySql 8.0.25

## Install

### Clone the repository

```shell
git clone git@github.com:a10003202/rails-import-challenge.git
cd rails-import-challenge
```

Note: If you use [Docker Compose](https://docs.docker.com/compose/install/) you must follow next steps:

  - Build image with: docker-compose build
  - Change database.yml host to db
  - Start container with: docker-compose up
  - Follow steps starting from Database creation prepending to the commands 'docker-compose run --rm webapp'. Example: docker-compose run --rm webapp rake db:create

### Check your Ruby version

```shell
ruby -v
```

The output should start with something like `ruby 2.5.1`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 2.5.1
```
### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
bundle && yarn
```

### Database creation
```shell
  rake db:create
```

### Database initialization
```shell
  rake db:migrate
  rake db:seed
```

### Compile assets
```shell
  rake assets:precompile
```

### Add heroku remotes

Using [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```shell
heroku git:remote -a rails-import-challenge
heroku git:remote --remote heroku-staging -a rails-import-challenge-staging
```

## Serve

```shell
rails s
```

# Login

Open in browser http://localhost:3000/login if running the project locally or http://your-domain.com/login for production environments.
You can login with the default admin user credentials:

```shell
  email: admin@email.com
  password: admin
```

## Run tests
```shell
  rails test
```

## Deployment instructions

### With Heroku pipeline (recommended)

Push to Heroku staging remote:

```shell
git push heroku-staging
```

Go to the Heroku Dashboard and [promote the app to production](https://devcenter.heroku.com/articles/pipelines) or use Heroku CLI:

```shell
heroku pipelines:promote -a rails-import-challenge-staging
```

### Directly to production (not recommended)

Push to Heroku production remote:

```shell
git push heroku
```