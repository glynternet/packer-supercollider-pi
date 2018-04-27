IMAGE_NAME ?= supercollider-pi-builder
TAG ?= unversioned
IMAGE ?= $(IMAGE_NAME):$(TAG)

image-builder:
	docker build -t $(IMAGE) .

build:
	# docker run -it -v $(PWD):/$(IMAGE_NAME) --entrypoint pwd $(IMAGE)
	docker run -it -v $(PWD):/$(IMAGE_NAME) $(IMAGE) build /$(IMAGE_NAME)/packer.json

dependencies:
	sudo apt install kpartx qemu-user-static

download-arm-builder:
	go get github.com/solo-io/packer-builder-arm-image

build-arm-builer:
	GOOS=linux go build github.com/solo-io/packer-builder-arm-image