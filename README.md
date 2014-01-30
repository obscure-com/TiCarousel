# TiCarousel

by Paul Mietz Egli (paul@obscure.com)
based on iCarousel by Nick Lockwood (https://github.com/nicklockwood/iCarousel)

**TiCarousel** is an Appcelerator Titanium module which wraps iCarousel, a class designed to simplify
the implementation of various types of paged and scrolling views on iOS.

## Using the Module

See the Wiki pages for usage instructions and the samples directory for example apps.

## Requirements

* Titanium SDK 3.1.2 or later
* Xcode 5.0 or later to build
* Runtime requirement is iOS 5+

## Building

1. `git clone https://github.com/pegli/TiCarousel.git`
2. `cd TiCarousel`
3. `git submodule update --init`
4. `cd mobile/ios`
5. Edit `titanium.xcconfig` and set the Ti SDK version and paths if necessary.
5. `./build.py`

## License

* TiCarousel is under the Apache License 2.0
* iCarousel is Copyright (c) 2011 Charcoal Design.  See their license file.

## Development Status

**1.0.1**

* new "bump" carousel type
* changed module name to lowercase for better compatibility with Titanium Studio

**1.0**

* built-in carousel types are working
* can now set views after the carousel is created
* custom carousel types can be defined in JavaScript (!)

Next step is to put together a sample app that showcases all of this...
