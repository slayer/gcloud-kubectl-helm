all: build

DOCKER_IMAGE = umongous/gcloud-kubectl-helm

# shoutcuts
push: docker-push
build: #### build docker image
	docker build -t $(DOCKER_IMAGE) .

push: #### push docker image
	docker push $(DOCKER_IMAGE)

