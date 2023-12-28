[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-swag.svg)]()

[Russian readme](README.ru.md).

# README

## Task

The mobile application generates a unique client ID at startup (which is saved between sessions) and requests a list of
experiments, adding the Device-Token HTTP header. In response, the server returns a list of experiments. For each
experiment, the client receives:

* Key: the name of the experiment. The client has code that will change some behavior depending on the value of this
  key.
* Value: a string, one of the possible options (see below).
*
    * It is important that the device falls into one group and always remains in it.

## Solution

The solution is actually pretty simple. We can
use [Weighted random distribution algorithm](https://dev.to/jacktt/understanding-the-weighted-random-algorithm-581p#:~:text=Simple%20Explanation,in%20which%20this%20point%20falls.)
to take care of everything.
The algorithm is pretty simple:

1. We have a list of experiments with their weights(chances).
2. We generate a random number from 0 to the sum of all weights.
3. We iterate through the list of experiments and subtract the weight of the current experiment from the random number.
4. If the random number is less than 0, we return the current experiment.
5. If the random number is greater than 0, we continue iterating.

This way we can get a random experiment with a chance proportional to its weight with a slight spread.

As for showing the statistics I decided to use SQL [Views](/db/views/distributions_v01.sql) to make it easier to query
the data.
This way we can always have the latest results on each query.
Ideally I would add a websocket that would stream the latest results, but this wasn't in the scope of the task.

## Usage

### Installation with sources

1. Get ruby 3.x.x
2. Clone the repository

```bash
git clone git@github.com:urumo/experiments_api.git
```

3. Install dependencies

```bash
bundle install
```

4. Create database

```bash
rails db:prepare
```

5. Run the server

```bash
rails s
```

That's it, you're all set!
All that's left is to go to [localhost:3000](http://localhost:3000) to see the admin panel.

### Installation with docker

1. Get docker
2. pull the image

```bash
docker pull ghcr.io/urumo/experiments_api/experiments_api:latest
```

3. Run the image

```bash
docker run -p 3000:3000 ghcr.io/urumo/experiments_api/experiments_api:latest
```

Env variables are:

* POSTGRES_DB
* POSTGRES_USER
* POSTGRES_PASSWORD

The latest build is always deployed on my personal server [svck.dev](https://ab.svck.dev)

## API

### Experiments

I have decided to make the API part a separate application from the admin page for future scalability.
It's located in `vendor/Api` folder.
At the moment all it does is injects one endpoint to the server, which, provided a Device-Token(UUID) will return the
device with it's experiments.
The endpoint is `/api/distribution` and it accepts `GET` requests with `Device-Token` header, which should be of UUID
kind.
Swagger endpoint is located at `/api-docs` and it's available from the main app.
