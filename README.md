# Elevate Backend API Code

We're going to build a RESTful backend for an existing mobile app. The mobile app allows a user to log in, submit game completion information, and see some basic summary statistics. Assume that the mobile app is already built and we need to match with its expectations for the API.

API using Ruby on Rails 7 and PostgreSql.

### Requirements

You can run this project using docker-compose. The guide below will be for using docker-compose.

### Installation

Follow the steps below
```sh
git clone git@github.com:zaffalon/elevate_backend.git
```
Open the folder
```sh
cd elevate_backend
```
Build the project in docker
```sh
docker-compose build
```
Create the tables in PostgreSql
```sh
docker-compose run api rake db:create
```
Migrate the tables
```sh
docker-compose run api rake db:migrate
```
Run the server in docker
```sh
docker-compose up
```

If you want some Game data to test the API you can run the command below to create some data in the database.
```sh
docker-compose run api rake db:seed
```
If you want enable cache in the API you can run the command below. We will cache the user stats
```sh
docker-compose run api rails dev:cache
```

### Running Tests

Use the following commands to run the automated tests.

```sh
docker-compose run api rspec
```

### API Endpoint

#### Running Localy
http://localhost:3000/


1. You need to create a User `POST /api/user`
2. You can create a session for this user `POST /api/sessions`
3. Using the token provided you can request the other routes.

For more informations about the API and params use the documentation below.

### API Endpoint Documentation (Swagger)

#### Running Localy
Visit: http://localhost:3000/api-docs/index.html to go directly to the documentation of the api.

# Test coverage report

You can open on the browser the test coverage report:

```
coverage/index.html
```
