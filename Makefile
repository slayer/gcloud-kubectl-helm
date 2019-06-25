all: build

DOCKER_IMAGE = umongous/gcloud-kubectl-helm

build:
	docker build -t $(DOCKER_IMAGE) .

push:
	docker push $(DOCKER_IMAGE)

run: build
	docker run -it --rm $(DOCKER_IMAGE) /bin/sh

