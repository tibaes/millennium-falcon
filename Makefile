SHELL=/bin/bash

PORT=8888
SSH=2222
RAPTOR_TAG=testing

DOCKER_BIN = `if command -v nvidia-docker 2>&1 > /dev/null; then echo 'nvidia-docker'; else echo 'docker'; fi`

help:
	@echo "BloodyBunny make to orchastrate containers"
	@echo "Using docker command: ${DOCKER_BIN}"
	@echo "ssh:${SSH}, jupyter:${PORT}, raptor:${RAPTOR_TAG}"

generate_raptor:
	@echo "Building RAPTOR:${RAPTOR_TAG}..."
	cd docker/raptor;																					\
	docker build -t raptor:latest .;																	\
	docker build -t raptor:${RAPTOR_TAG} .

push:
	@echo "TODO... "
	docker push ...;

pull:
	@echo "TODO... "
	docker pull ...;

raptor: pull
	${DOCKER_BIN} run -it --rm -p ${PORT}:${PORT} -p ${SSH}:22 -v `pwd`:/playground/ raptor:latest fish 

jupyter:
	jupyter-lab --ip='*' --port ${PORT} --no-browser --allow-root

clean_images:
	@echo "Removing all docker images..."
	docker rmi -f `docker images -q`

clean_containers:
	@echo "Removing all docker containers..."
	docker rm -f `docker ps -aq`

clean_all: clean-containers clean-images
