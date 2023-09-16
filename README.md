# README

An application to classify document and to be able to do full search inside pdf and text document with Solr

## Install

Run `./bin/setup`

It works under Tails. It will soon provide a way to publish easly a Tor Hidden Service under Tails

## Usage

You can import documents from a folder by running the following command:

`rails import:doc[folder/where/live/your/docs]`

You have an admin interface under http://YOURIP:PORT/admin To access it, you have to create a first manager with the console:

Run: `rails console`

and then:

`Manager.create(email: 'valid@email.com', password: '123456', approved: true).save!`

It is advised to run in production, either when using it locally, because Postgres is better than using SQLite with rails
and it is faster.

1. Set the env var: `RAILS_ENV=production` 
2. create and migrate the database: `rails db:create db:migrate`
3. start the server: `rails s`

## Caution

It is actually running with old dependency with critical vulnerabilities. Update in progress.

Enjoy!