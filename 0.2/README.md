# Coffee

Keep up-to-date with news and weather with Coffee.

## Download 

You download and install in Ubuntu from the Coffee site

[Download](https://nick92.github.io/coffee/#download)

## Building and Installing from code

You'll need the following dependencies:

	libglib2.0-dev
	libgtk-3-dev
	libjson-glib-dev
	libsoup2.4-dev
	libwebkit2gtk-4.0-dev
	libgee-0.8-dev
	libgeocode-glib-dev
	libgeoclue-2-dev

### Build with Meson 

	mkdir build
	meson build --prefix=/usr
	ninja

### Install & Run

	sudo ninja install
	./src/com.github.nick92.coffee