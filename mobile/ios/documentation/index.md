# TiCarousel Module

## Description

The TiTouchDB module wraps the [iCarousel](https://github.com/nicklockwood/iCarousel)
library written by Nick Lockwood and provides a customizable, data-driven 3D carousel
view for Titanium apps.

TiCarousel is currently only available for iOS.

The reference section follows these conventions:

* Text in `code font` refer to module objects.  For example, database is a generic term
  but `database` refers to a TiCarousel object.
* Object functions are listed with parentheses and properties without.  Constants are
  implemented as read-only properties.

## Accessing the Module

To access this module from JavaScript, you would do the following:

	var TiCarousel = require("com.obscure.ticarousel");

The TiCarousel variable is a reference to the Module object.  You can create new carousel
views by calling `TiCarousel.createCarouselView()` with the appropriate options listed below.

## Examples

Create a simple carousel:

    var itemViews = [
      Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'blue' }),
      Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'yellow' }),
      Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'red' }),
      Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'green' }),
      Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'gray' }),
    ];

    var carousel = TiCarousel.createCarouselView({
      carouselType: TiCarousel.CAROUSEL_TYPE_LINEAR,
      width: Ti.UI.FILL,
      height: 200,
      itemWidth: 68,
      numberOfVisibleItems: 5,
      views: itemViews
    });

    win.add(carousel);

## TiCarousel Reference

### Functions

**createCarouselView([Dictionary<com.obscure.CarouselView> parameters])** : com.obscure.CarouselView

Creates and returns an instance of a CarouselView.

* `parameters`: [Dictionary<com.obscure.CarouselView> parameters]

  Properties to set on a new object, including any defined by CarouselView except those marked
  not-creation or read-only.

### Constants

#### Carousel Type

* CAROUSEL\_TYPE\_LINEAR
* CAROUSEL\_TYPE\_ROTARY
* CAROUSEL\_TYPE\_INVERTED\_ROTARY
* CAROUSEL\_TYPE\_CYLINDER
* CAROUSEL\_TYPE\_INVERTED\_CYLINDER
* CAROUSEL\_TYPE\_WHEEL
* CAROUSEL\_TYPE\_INVERTED\_WHEEL
* CAROUSEL\_TYPE\_COVER\_FLOW
* CAROUSEL\_TYPE\_COVER\_FLOW2
* CAROUSEL\_TYPE\_TIME\_MACHINE
* CAROUSEL\_TYPE\_INVERTED\_TIME\_MACHINE
* CAROUSEL\_TYPE\_CUSTOM

## CarouselView

### Functions

**indexOfItemView(Ti.UI.View view)** : Number

Returns the index of the provided item view in the carousel.  This method only works
for item views that are visible; if the specified view is not visible, the method returns
null.

**indexOfItemViewOrSubview(Ti.UI.View view)** : Number

Returns the index of the provided item view or the item view containing the provided
view in the carousel.  If the item view is not visible, returns null.

**insertItemAtIndex(Number index, [Boolean animated])**

Inserts a new item into the carousel.  The new item must be in the `views` array prior
to calling this method.

**itemViewAtIndex(Number index)** : Ti.UI.View

Returns the visible item view with the provided index.  This method returns null if the
view at the specified index is not visible.

**offsetForItemAtIndex(Number index)** : Number

Returns the positive or negative offset of the specified item index in multiples of
`itemWidth` from the center position.

**reloadData()**

Reload all carousel items from the view array.  This function must be called
if the carousel needs to be refreshed due to changes to properties or the underlying
data.  Properties and methods that require a call to `reloadData()` will indicate
that in their documentation.

**reloadItemAtIndex(Number index, [Boolean animated])**

Reload the item view at the specified index.  If `animated` is true, the carousel will
cross-fade from the old item to the new item.

**removeItemAtIndex(Number index)**

Remove the item at the specified index from the carousel.  This does *not* remove the
item from the underlying view array, so a call to `reloadData()` will restore the view
to the carousel.

**scrollByNumberOfItems(Number count, Number duration)**

Scroll the carousel by a fixed distance.

* `count`: Number, the number of items to scroll.  Can be positive or negative.
* `duration`: Number, the duration of the scroll animation in seconds.

**scrollToIndex(Number index, [Dictionary options])**

Centers the carousel on the specified item.  For wrapped carousels, the view will
use the shortest route to scroll if the scroll is animated.  To control the direction
of the scroll or to scroll more than one full revolution, use **scrollByNumberOfItems()**.

* `index`: Number

   The index of the item to center in the carousel.

* `options`: [Dictionary]

   Dictionary with the following scroll options:
   
   * `animated`: Boolean, default true.
   * `duration`: Number, the duration of the scroll animation in seconds.

### Properties

**bounceDistance** : Number, read/write

The maximum distance the carousel will bounce when it overshoots either end, measured
in multiples of `itemWidth`.  This property only affects carousels which have the `wrap`
property set to false.

**bounces** : Boolean, read/write

If true, the carousel will bounce past the end and return.  This only affects carousels
which have the `wrap` property set to false.

**centerItemWhenSelected** : Boolean, read/write

If set to true, a tap on an item that is not currently centered will cause the carousel to
scroll that item to the center.  Default is true.

**clipsToBounds** : Boolean, read/write

If set to true, the carousel will not display items that fall outside of its own boundaries.
Default is false.

**contentOffset** : Dictionary, read/write

Adjusts the center of the carousel without changing the perspective.  This has the
effect of moving the carousel without changing the viewpoint.  The dictionary
should contain the following values:

* `x` the x offset of the center of the carousel, default 0.0
* `y` the y offset of the center of the carousel, default 0.0

**currentItemIndex** : Number, read-only

The index of the currently-centered item in the carousel.

**currentItemView** : Ti.UI.View, read-only

The view that is currently centered in the carousel.

**decelerationRate** : Number, read/write

The rate at which the carousel decelerates when flicked.  Value should be between 0.0
(carousel stops immediately) and 1.0 (carousel continues indefinitely until it reaches
the end).

**ignorePerpendicularSwipes** : Boolean, read/write

If set to true, the carousel will ignore swipe gestures that are perpendicular to the
direction of scrolling. This is useful for item views that scroll within the carousel.
Default is true.

**itemWidth** : Number, read-write

The display width of the items in the carousel.  If a value is not provided, it is determined
from the width of the first item view in the `views` array.  To add spacing between carousel
items, set this property to a value greater than your item view width.

**numberOfItems** : Number, read-only

The number of visible items in the carousel.

**perspective** : Number, read/write

Tweaks the perspective foreshortening effect of the 3D carousel views.  Should be a negative
number between 0 and -0.01; default is -0.005.

**scrollEnabled** : Boolean, read/write

Enable user scrolling of the carousel.  Default is true.

**scrollOffset** : Number, read-only

The current offset in pixels of the carousel; can be used to position other screen elements
while the carousel is scrolling.

**scrollSpeed** : Number, read/write

A multiplier for the speed of scrolling when the user flicks the carousel.  Default is 1.0.

**scrollToItemBoundary** : Boolean, read/write

When true, the carousel will automatically scroll to the nearest item boundary.  When set to
false, the carousel will stop wherever scrolling ends, even if it isn't aligned with an item
view.

**stopAtItemBoundary** : Boolean, read/write

When set to true, the carousel will come to rest at an exact item boundary when scrolled.  If
set to false, the carousel will stop scrolling naturally and, if `scrollToItemBoundary` is true,
scroll back or forward to the nearest boundary.

**transformOptions** : Dictionary, read/write

Get or set transform options for the built-in carousel types.  See the "Transform Options"
section below for a list of which options can be set for each carousel type.

**type** : Number, read/write

The carousel display type.  Must be one of the constants defined in the `TiCarousel`
object.

**vertical** : Boolean, read/write

Toggles whether the carousel is displayed horizontally (default) or vertically.

**viewpointOffset** : Dictionary, read/write

Adjusts the camera viewpoint relative to the carousel items.  Where `contentOffset` moves
the carousel in space, `viewpointOffset` moves the user in space.  This has the effect of
changing the perspective of the carousel. The dictionary should contain the following values:

* `x` the x offset of the center of the viewpoint, default 0.0
* `y` the y offset of the center of the viewpoint, default 0.0

### Events

**scroll** : fired when the carousel ends an animated scroll.

**change** : fired whenever the carousel scrolls far enough for the currentItemIndex property
to change. It is called regardless of whether the item index was updated programatically or
through user interaction. 

**select** : fired if the user taps any carousel item view, including the currently selected view.
This event will not fire if the user taps a control within the currently selected view.

## Transform Options

Several of the built-in transforms can be customized using the transform options dictionary.
Rotary and cylinder carousels can be adjusted using the `arc` and `radius` properties.
For these carousel types, `arc` controls the curvature of the receding views on either side
of the center and `radius` the width of the carousel.  Wheel carousels are also customized
with `arc` and `radius`, though the effect is as if you are looking at a cylinder carousel
from above.  CoverFlow and TimeMachine-like carousels can be customized using the `tilt`
and `spacing` properties.  Finally, the bump carousel can be customized with the `yoffset`
and `zoffset` properties.  The example app contains a screen where you can try out different
values for these properties.

## Custom Transforms

*IMPORTANT NOTE*

Custom transforms should be considered experimental and are not recommended for production
use.  Use the transform options to customize an existing carousel type if possible before
trying the custom transform feature.  If you really, really need a new, unique carousel type,
consider using the custom transform feature to prototype it, then request that your
transform be added to TiCarousel by filing an issue on Github.

* * *

In addition to the standard set of carousel types, TiCarousel lets you create your own custom
carousel types.  A custom carousel type is created by specifying of a set of 3D transforms to 
apply to the item views based on their position in the carousel.  In addition, can control the
transparency of the item view to "fade out" based on the view's position.

The custom transform functions are implemented in your Titanium JavaScript file.  To use a custom
carousel type, create a new carousel object with a `carouselType` property set to
`CAROUSEL_TYPE_CUSTOM`:

    var carousel = TiCarousel.createCarouselView({
      carouselType: TiCarousel.CAROUSEL_TYPE_CUSTOM,
      width: Ti.UI.FILL,
      height: 200,
      itemWidth: 68,
      numberOfVisibleItems: 5,
    });

Next, create a function that returns one or more transformation descriptors.  A transformation
descriptor is a JavaScript object with a `type` property containing the name of the transform and
a `values` property containing an array of numbers whose meaning depends on the transform type.
The following descriptor types are currently supported:

* **translate** move the view without changing its orientation.  The values array must contain:
  1. delta-x : positive or negative change in the x coordinate
  2. delta-y : positive or negative change in the y coordinate
  3. delta-z : positive (away from view) or negative (towards view) change in the z coordinate
* **rotate** rotation of the view around the specified point.  The values array must contain:
  1. angle : the angle of rotation in radians
  2. center-x : the center of rotation x coordinate
  2. center-y : the center of rotation y coordinate
  2. center-z : the center of rotation z coordinate
* **scale** change the size of the view.  The values array must contain:
  1. scale-x : the scale multiplier for the x size
  2. scale-y : the scale multiplier for the y size
  3. scale-z : the scale multiplier for the z size

For example, the Linear carousel type would be implemented as follows:

    var itemWidth = carousel.itemWidth;
    
    function transform(offset) {
      return [
        { type: 'translate', values: [ offset * itemWidth, 0, 0 ] }
      ];
    }
    
    carousel.itemTransformForOffset = transform;

The transform function receives a parameter named `offset` which is the current positive or negative
offset of the view from the center of the carousel.

*Transform functions run in an isolated JavaScript context!* This means that you cannot reference
the Titanium API or any objects that were created in your application's context.  Primitive values
are fine, however, which is why we are setting a primitive named `itemWidth` in the example
above.

If you want to change the alpha transparency of the item view based on the offset, create a function
that returns a value between 0.0 and 1.0 for each item based on offset.  Here's an alpha function that
fades views which are more than one unit away from center to 60% opacity:

    function alpha(offset) {
      var absoffset = Math.abs(offset);
      return absoffset < 1.0 ? (1.0 - 0.4 * absoffset) : 0.6;
    }
    
    carousel.itemAlphaForOffset = alpha;

**Important Note**

Custom transform callbacks are expensive and are not recommended for very large carousels.  If
you have a transform type that you would like to have implemented in native code, please file an
issue describing the transform or, better yet, fork the code and send a pull request.

## Author

Paul Mietz Egli (paul@obscure.com)

based on iCarousel by Nick Lockwood

## License

Apache License 2.0.
