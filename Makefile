REGISTRY := registry.srelab.xyz
IMAGE_NAME := games/quakejs
VERSION := 1.0.0
FULL_IMAGE_NAME := $(REGISTRY)/$(IMAGE_NAME):$(VERSION)
LATEST_TAG := $(REGISTRY)/$(IMAGE_NAME):latest

.PHONY: all
all: build tag push

.PHONY: build
build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME):$(VERSION) .

.PHONY: build-no-cache
build-no-cache:
	@echo "Building Docker image without cache..."
	docker build --no-cache -t $(IMAGE_NAME):$(VERSION) .
	@echo "Tagging latest image..."
	docker tag $(IMAGE_NAME):$(VERSION) $(LATEST_TAG)
	@echo "Pushing latest image to registry..."
	docker push $(LATEST_TAG)

.PHONY: tag
tag:
	@echo "Tagging image..."
	docker tag $(IMAGE_NAME):$(VERSION) $(FULL_IMAGE_NAME)
	docker tag $(IMAGE_NAME):$(VERSION) $(LATEST_TAG)

.PHONY: push
push:
	@echo "Pushing image to registry..."
	docker push $(FULL_IMAGE_NAME)
	docker push $(LATEST_TAG)

.PHONY: clean
clean:
	@echo "Cleaning up local images..."
	docker rmi $(FULL_IMAGE_NAME) $(LATEST_TAG) $(IMAGE_NAME):$(VERSION) || true

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all           - Build, tag and push image (default)"
	@echo "  build         - Build the Docker image"
	@echo "  build-no-cache - Build the Docker image without using cache, tag as latest and push to registry"
	@echo "  tag           - Tag the built image"
	@echo "  push          - Push the image to registry"
	@echo "  clean         - Remove local images"
	@echo "  help          - Show this help message"
