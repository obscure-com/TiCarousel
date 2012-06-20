var TiCarousel = require('com.obscure.ticarousel'),
    utils = require('./utils');


function createDecelRateView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });
  
  var label = Ti.UI.createLabel({
    text: String.format('deceleration rate: %.1f', carousel.decelerationRate)
  })
  result.add(label);
  
  var slider = Ti.UI.createSlider({
    min: 0.0,
    max: 1.0,
    value: carousel.decelerationRate,
  });
  slider.addEventListener('change', function(e) {
    carousel.decelerationRate = e.value;
    label.text = String.format('deceleration rate: %.1f', carousel.decelerationRate);
  });
  result.add(slider);
  
  return result;
}

function createScrollSpeedView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });
  
  var label = Ti.UI.createLabel({
    text: String.format('scroll speed: %.1f', carousel.scrollSpeed)
  })
  result.add(label);
  
  var slider = Ti.UI.createSlider({
    min: 0.0,
    max: 10.0,
    value: carousel.scrollSpeed,
  });
  slider.addEventListener('change', function(e) {
    carousel.scrollSpeed = e.value;
    label.text = String.format('scroll speed: %.1f', carousel.scrollSpeed);
  });
  result.add(slider);

  return result;
}

function createScrollToBoundView(carousel) {
  var result = Ti.UI.createView({
    layout: 'horizontal',
    height: Ti.UI.SIZE,
  });
  
  result.add(Ti.UI.createLabel({ text: 'scroll to item boundary:'}));
  
  var sw = Ti.UI.createSwitch({
    value: carousel.scrollToItemBoundary
  });
  sw.addEventListener('change', function(e) {
    carousel.scrollToItemBoundary = e.value;
  });
  result.add(sw);
  
  return result;
}

function createStopAtBoundView(carousel) {
  var result = Ti.UI.createView({
    layout: 'horizontal',
    height: Ti.UI.SIZE,
  });
  
  result.add(Ti.UI.createLabel({ text: 'stop at item boundary:'}));
  
  var sw = Ti.UI.createSwitch({
    value: carousel.stopAtItemBoundary
  });
  sw.addEventListener('change', function(e) {
    carousel.stopAtItemBoundary = e.value;
  });
  result.add(sw);
  
  return result;
}

exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Scrolling',
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
    carouselType: TiCarousel.CAROUSEL_TYPE_LINEAR,
    width: Ti.UI.FILL,
    height: 120,
    itemWidth: 108,
    numberOfVisibleItems: 7,
    views: views,
  });

  win.add(carousel);
  win.add(createDecelRateView(carousel));
  win.add(createScrollSpeedView(carousel));
  win.add(createScrollToBoundView(carousel));
  win.add(createStopAtBoundView(carousel));

  return win;
};