# TiCarousel

by Paul Mietz Egli (paul@obscure.com)
based on iCarousel by Nick Lockwood (https://github.com/nicklockwood/iCarousel)

**TiCarousel** is an Appcelerator Titanium module which wraps iCarousel, a class designed to simplify
the implementation of various types of paged and scrolling views on iOS.

## Using the Module

See the Wiki pages for usage instructions and the samples directory for example apps.

## Requirements

* Titanium SDK 1.8.2 or later
* Xcode 4.2 or later to build
* Runtime requirement is iOS 5+

## License

* TiCarousel is under the Apache License 2.0
* iCarousel is Copyright (c) 2011 Charcoal Design.  See their license file.

## Development Status

**first pass complete**

Carousels can be created and added to a view.  I was stuck for a while on a problem that occurred
when views were set after carousel creation using the setViews() method, but I think that's working
ok now.

Next steps are to put together a sample app and add custom carousel transform handling to the
module.
