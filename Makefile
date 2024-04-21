GIT_COMMIT_SHORT := $(shell git rev-parse --short HEAD) 
K8S_NS = tsthelm
IMAGE_NAME = hello_nginx
LOCAL_IMAGE = stafwag/$(IMAGE_NAME):$(GIT_COMMIT_SHORT)

default: build

.PHONY: build
build: deps
	podman build -t $(LOCAL_IMAGE) .

.PHONY: 
deps:
	which podman
