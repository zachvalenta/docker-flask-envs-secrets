.PHONY: test

name = "docker-flask-envs-secrets"

help:
	@echo
	@echo "🌓 ENVIRONMENT"
	@echo
	@echo "env-list:    show current environment"
	@echo "env-dev:     link env var for dev environment"
	@echo "env-prod:    link env var for production environment"
	@echo
	@echo "🍶 FLASK"
	@echo
	@echo "flask:       start app"
	@echo "hc:          healthcheck"
	@echo
	@echo "🚢 DOCKER"
	@echo
	@echo "build:       build image"
	@echo "rebuild:     rebuild image after stopping/removing containers of same name"
	@echo "start:       start container"
	@echo "stop:        stop container"
	@echo "restart:     restart container"
	@echo "rm:          remove container"
	@echo "shell:       open shell inside container"
	@echo "list:        list all containers/images/volumes"
	@echo "clean:       stop containers, rm all containers/images/volumes"
	@echo
	@echo "📦 DEPENDENCIES"
	@echo
	@echo "dep-ex:      export Poetry dependencies to requirements.txt"
	@echo "dep-dir:     show environment info"
	@echo "dep-list:    list prod dependencies"
	@echo

#
# 🌓 ENVIRONMENT
#

env-list:
	ls -al | grep '>'

env-dev:
	ln -sf .env.dev .env

env-prod:
	ln -sf .env.prod .env

#
# 🍶 FLASK
#

flask:
	export "SECRET_KEY=$(key)"; poetry run flask run

hc:
	http http://localhost:5000/healthcheck

#
# 🚢 DOCKER
#

build:
	docker build -t $(name) .

rebuild: stop rm
	docker build -t $(name) .

start:
	docker run -e "SECRET_KEY=$(key)" --name $(name) -p 5000:5000 $(name)

stop:
	docker stop $(name)

restart:
	docker start $(name); docker logs $(name) --follow

rm: stop
	docker rm $(name)

shell:
	docker exec -it $(name) bash

list:
	docker ps -a; docker images; docker volume ls

clean:
	docker ps -qa | xargs docker stop; docker system prune --volumes -f; docker image prune -af

#
# 📦 DEPENDENCIES
#

dep-ex:
	poetry export -f requirements.txt > requirements.txt

dep-dir:
	poetry env info

dep-list:
	poetry show --tree --no-dev
