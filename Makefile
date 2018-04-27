dependencies:
	sudo apt install kpartx qemu-user-static

download-arm-builder:
	go get github.com/solo-io/packer-builder-arm-image

build-arm-builer:
	go build github.com/solo-io/packer-builder-arm-image

jack2:
	git clone git://github.com/jackaudio/jack2 --depth 1

supercollider:
	git clone --recursive git://github.com/supercollider/supercollider
	cd supercollider && \
	git checkout 3.9 && \
	git submodule init && \
	git submodule update
	cp SC_TerminalClient.cpp-replacement supercollider/lang/LangSource/SC_TerminalClient.cpp

build:
	sudo packer build -var wifi_name=SSID -var wifi_password=PASSWORD ./packer.json
