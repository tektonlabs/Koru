# Koru

Koru is an open source project that connects needs of people affected after a disaster with people looking to send help, in a way that informed actions can be taken and help can be better distributed.

Koru assists during the humanitarian aid and reconstruction stage after a disaster, with the objective to accelerate and organize the recovery of affected areas by quickly gathering and processing the needs of affected communities.

# Explore the project

This branch host the web app and the API built to support the requirements that Koru offers. Web app and API was built in Ruby on Rails, and we use Bootstrap and Semantic UI as support for the frontend.


## Ruby version

Ruby 2.3.0


## Rails version

Rails 5.0.2


## System dependencies

* Install RVM (https://rvm.io/rvm/install)

Install GPG keys

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

Install RVM stable with ruby

```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

To start using RVM you need to run source 

```
/home/<user>/.rvm/scripts/rvm
```

* Install Ruby version 2.3.0 by RVM

Run from server:
```
rvm install ruby-2.3.0
```

## Configuration

* Gemset and bundler

From server, go to the directory app and run:
```
rvm --ruby-version --create 2.3.0@< gemset name >
```
e.g.: 
```
rvm --ruby-version --create 2.3.0@saas-rails-api
```
then:
```
gem install bundler
```

Use bundler to install gems
```
bundle install
```

## Database creation

* DB on development environment

```
rails db:create
```

## Database initialization

* DB on development environment

```
rails db:migrate
rails db:seed
```

## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

Run server locally

```
rails server
```