# README

## Ruby version
  2.6.1

## Bundle Install

    bundle install

## Setup Dependencies

    bundle exec figaro install

## SetUp Environment Variable

    RAILS_MAX_THREADS: 5
	DATABASE_HOST: localhost
	DATABASE_USERNAME: postgres
	DATABASE_PASSWORD: postgres
	HOST: 'localhost:3000'

## SetUp Database

	rake db:create db:migrate	


## How to run the test suite
	
	rspec spec

## Start Server

	rails s

## Check the server
	http://localhost:3000/
