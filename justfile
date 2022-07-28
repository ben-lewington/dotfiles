container_name := "app"

@_default:
  just --list --unsorted

# uses docker compose to start the application
start-into: _down _up _run && _down

# rebuilds the docker images, then starts the container
restart-into: _down _build _up _run && _down

_down:
	docker compose down -v --remove-orphans
_build:
	docker compose build
_up: 
	docker compose up -d
_run:
	docker compose run {{ container_name }} /bin/bash
