var TiCarousel = require('com.obscure.ticarousel'),
    utils = require('./utils');


function createViewpointOffsetView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });

  var xl = Ti.UI.createLabel({
    text: String.format('viewpoint offset X: %.1f', carousel.viewpointOffset.x),
  });
  result.add(xl);
  
  var xs = Ti.UI.createSlider({
    min: -200,
    max: 200,
    value: carousel.viewpointOffset.x
  });
  xs.addEventListener('change', function(e) {
    var o = carousel.viewpointOffset;
    o.x = e.value;
    carousel.viewpointOffset = o;
    xl.text = String.format('viewpoint offset X: %.1f', carousel.viewpointOffset.x);
  });
  result.add(xs);
  
  var yl = Ti.UI.createLabel({
    text: String.format('viewpoint offset Y: %.1f', carousel.viewpointOffset.y),
  });
  result.add(yl);
  
  var ys = Ti.UI.createSlider({
    min: -200,
    max: 200,
    value: carousel.viewpointOffset.y
  });
  ys.addEventListener('change', function(e) {
    var o = carousel.viewpointOffset;
    o.y = e.value;
    carousel.viewpointOffset = o;
    yl.text = String.format('viewpoint offset Y: %.1f', carousel.viewpointOffset.y);
  });
  result.add(ys);
  
  return result;
}

function createContentOffsetView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });

  var xl = Ti.UI.createLabel({
    text: String.format('content offset X: %.1f', carousel.contentOffset.x),
  });
  result.add(xl);
  
  var xs = Ti.UI.createSlider({
    min: -100,
    max: 100,
    value: carousel.contentOffset.x
  });
  xs.addEventListener('change', function(e) {
    var o = carousel.contentOffset;
    o.x = e.value;
    carousel.contentOffset = o;
    xl.text = String.format('content offset X: %.1f', carousel.contentOffset.x);
  });
  result.add(xs);
  
  var yl = Ti.UI.createLabel({
    text: String.format('content offset Y: %.1f', carousel.contentOffset.y),
  });
  result.add(yl);
  
  var ys = Ti.UI.createSlider({
    min: -100,
    max: 100,
    value: carousel.contentOffset.y
  });
  ys.addEventListener('change', function(e) {
    var o = carousel.contentOffset;
    o.y = e.value;
    carousel.contentOffset = o;
    yl.text = String.format('content offset Y: %.1f', carousel.contentOffset.y);
  });
  result.add(ys);
  
  return result;
}
exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Center/Viewpoint',
  	backgroundColor:'white',
  	layout: 'vertical',
  });
  
  var views = [];
  for (r = 0; r < 256; r += 64) {
    for (g = 0; g < 256; g += 64) {
      for (b = 0; b < 256; b += 64) {
        views.push(Ti.UI.createView({
          height: 100,
          width: 100,
          backgroundColor: utils.toHexString(r, g, b),
        }));
      }
    }
  }
  
  var carousel = TiCarousel.createCarouselView({
    carouselType: TiCarousel.CAROUSEL_TYPE_CYLINDER,
    width: Ti.UI.FILL,
    height: 240,
    itemWidth: 108,
    numberOfVisibleItems: 7,
    views: views,
  });

  win.add(carousel);
  win.add(createViewpointOffsetView(carousel));
  win.add(createContentOffsetView(carousel));

  return win;
};