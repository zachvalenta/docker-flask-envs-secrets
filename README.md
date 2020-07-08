# overview

Bare bones implementation of:

* a Flask app
* dealing with multiple environments
* using secrets
* Dockerized

## how to run?

To run as a container, have DockerCE installed and use the `Makefile`:

```sh
# create image
make image

# run container using image
make start

# hit Flask server healthcheck
make hc

# stop container
make stop
```

Of course, you can still work with the app locally (outside of a container, on your own operating system) by running `poetry install` and starting the server with `make flask`.

## FYI

I have [another branch that uses `venv` for dependency management](https://github.com/zachvalenta/docker-flask-skeleton/tree/poetry).

I have a few other projects like this:

* [Docker + Flask](https://github.com/zachvalenta/docker-flask)
* [Docker + Flask + Postgres](https://github.com/zachvalenta/docker-flask-postgres)
* [Docker + Flask + SQLite](https://github.com/zachvalenta/docker-flask-sqlite)
* [Docker + Flask + SQLite + gunicorn](https://github.com/zachvalenta/docker-flask-sqlite-gunicorn)

Here are the Docker versions I'm working with:

```sh
$ docker --version  # Docker version 18.09.2, build 6247962
$ docker-compose --version  # docker-compose version 1.23.2, build 1110ad01
$ docker-machine --version  # docker-machine version 0.16.1, build cce350d7
```
