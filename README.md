# overview

Bare bones implementation of:

* a Flask app
* dealing with multiple environments
* using secrets
* Dockerized

## the basic idea

The basic idea is:

* same file
* different config

For example:

* same file (`.env`)
* different config (`db=sqlite.db` for dev, `db=postgresql://user:pw@db:5432/db_name` for prod)

## the basic idea - with some code

We'll use Flask's built-in dev server. The server will load a `.env` file if it's there and if we have `python-dotenv` installed (we do).

* We'll have an env file for each environment
```sh
├── .env.dev      # env var for dev
├── .env.prod     # env var for prod
```

* Each env file has its own values
```sh
# DEV
$ cat .env.dev

ENV=dev
FLASK_ENV=development

# PROD
$ cat .env.prod

ENV=prod
FLASK_ENV=production
```

* We point `.env` to whichever env file we want to use
```sh
# link to dev
$ ln -sf .env.dev .env

# .env now points to .env.dev
$ ls -al

lrwxr-xr-x   .env -> .env.dev
```

* Our server can read values from that env file
```sh
$ curl http://localhost:5000/healthcheck

docker-flask-envs-secrets running from: *** dev ***
```

## the basic idea - step by step using the Makefile

* Let's use the Makefile to try this out
```sh
make env-dev  # symlink `.env` to `.env.dev`
make build  # build image
make start  # run container
```

* when you hit the container's healthcheck, the healthcheck reads from the environment
```sh
$ make hc
http http://localhost:5000/healthcheck
HTTP/1.0 200 OK

docker-flask-envs-secrets running from: *** dev ***
```

* Now let's swap to prod
```sh
make env-prod  # symlink `.env` to `.env.prod`
make rebuild  # rebuild image and rm containers associated with old image
make start  # run container from rebuilt image
```

* the healthcheck now shows we've switched to using our prod config
```sh
$ make hc
http http://localhost:5000/healthcheck
HTTP/1.0 200 OK

docker-flask-envs-secrets running from: *** prod *** and the secret key is ***  ***
```

Notice how the message changes when we're in prod. The prod env uses an environment variable that we can't store in version control. Another way to say this is that prod uses a secret. Let's get to that in the next section.

## adding secrets to the mix

Things are somewhat trickier when it comes to secrets, but not too bad.

We're going to pass secrets to the container at runtime. What that means is that the secrets won't be present in the image we've built. Secrets that are present in the image itself are known as [buildtime secrets](https://pythonspeed.com/articles/build-secrets-docker-compose). We'll just work with runtime secrets, meaning secrets that only exist in the running container.

* Let's run the container again, this time with a runtime secret
```sh
make rm  # rm current container
make start key=testing123  # run new container
```

* and now our prod env has the secret it needs
```sh
$ make hc
http http://localhost:5000/healthcheck
HTTP/1.0 200 OK

docker-flask-envs-secrets running from: *** prod *** and the secret key is *** testing123 ***
```

## FYI

Here's the full list of projects I have in this vein:

* [base: Docker + Flask](https://github.com/zachvalenta/docker-flask)
* [base + config management](https://github.com/zachvalenta/docker-flask-envs-secrets)
* [base + config management + SQLite](https://github.com/zachvalenta/docker-flask-sqlite)
* [base + config management + SQLite + gunicorn](https://github.com/zachvalenta/docker-flask-sqlite-gunicorn-config)
* [base + SQLite](https://github.com/zachvalenta/docker-flask-sqlite)
* [base + SQLite + gunicorn](https://github.com/zachvalenta/docker-flask-sqlite-gunicorn)
* [base + Postgres](https://github.com/zachvalenta/docker-flask-postgres)

Here are the Docker versions I'm working with:

```sh
$ docker --version  # Docker version 18.09.2, build 6247962
$ docker-compose --version  # docker-compose version 1.23.2, build 1110ad01
$ docker-machine --version  # docker-machine version 0.16.1, build cce350d7
```

You can still work with the app locally (outside of a container, on your own operating system) by running `poetry install` and starting the server with `make flask` (or `make flask key=secret_key_value` for the prod environment).
