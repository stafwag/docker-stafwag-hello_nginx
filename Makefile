GIT_COMMIT_SHORT := $(shell git rev-parse --short HEAD) 
K8S_NS = tsthelm
IMAGE_NAME = hello_nginx
LOCAL_IMAGE = stafwag/$(IMAGE_NAME)

default: build

.PHONY: build
build:
	podman build -t $(LOCAL_IMAGE):$(GIT_COMMIT_SHORT) .
