SUPERCOLLIDER_IMAGE_OUTPUT_DIR ?= supercollider-pi
SUPERCOLLIDER_IMAGE ?= $(SUPERCOLLIDER_IMAGE_OUTPUT_DIR)/image

dependencies:
	sudo apt install kpartx qemu-user-static

arm-builder:
	$(MAKE) arm-builder-download
	$(MAKE) arm-builder-build

arm-builder-download:
	go get github.com/solo-io/packer-builder-arm-image

arm-builder-build:
	go build github.com/solo-io/packer-builder-arm-image

jack2:
	git clone git://github.com/jackaudio/jack2 --depth 1

supercollider:
	git clone --recursive git://github.com/supercollider/supercollider
	cd supercollider && \
	git checkout 3.9 && \
	
supercollider-singlebranch:
	git clone -b 3.9 --single-branch --recursive git://github.com/supercollider/supercollider

supercollider-modify:
	cd supercollider && \
	git submodule init && \
	git submodule update
	cp SC_TerminalClient.cpp-replacement supercollider/lang/LangSource/SC_TerminalClient.cpp

build-supercollider-pi:
	time sudo packer build ./packer-supercollider.json

AUTOSTART_IMAGE_OUTPUT_DIR ?= autostart

build-autostart: AUTOSTART_BASEIMAGE_CHECKSUM ?= $(shell sha256sum $(SUPERCOLLIDER_IMAGE) | awk '{ print $$1 }')
build-autostart:
	sudo \
	AUTOSTART_IMAGE_OUTPUT_DIR=$(AUTOSTART_IMAGE_OUTPUT_DIR) \
	BASE_IMAGE_URL=$(SUPERCOLLIDER_IMAGE) \
	BASE_IMAGE_CHECKSUM=$(AUTOSTART_BASEIMAGE_CHECKSUM) \
	packer build ./packer-autostart.json	

FLASH_DEVICE ?=

flash: AUTOSTART_IMAGE ?= $(AUTOSTART_IMAGE_OUTPUT_DIR)/image
flash:
	sudo dd bs=4M status=progress if=$(AUTOSTART_IMAGE) of=$(FLASH_DEVICE)