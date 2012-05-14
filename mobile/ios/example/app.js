// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white',
	layout: 'vertical',
});

var TiCarousel = require('com.obscure.TiCarousel');
Ti.API.info("module is => " + TiCarousel);

var label = Ti.UI.createLabel({ text: 'status' });
win.add(label);

var views = [];
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'blue' }));
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'yellow' }));
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'red' }));
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'green' }));
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'gray' }));

var carousel = TiCarousel.createCarouselView({
  carouselType: TiCarousel.CAROUSEL_TYPE_CUSTOM,
  backgroundColor: '#ccc',
  width: Ti.UI.FILL,
  height: 200,
  itemWidth: 68,
  numberOfVisibleItems: 5,
});
carousel.addEventListener('scroll', function(e) {
  label.text = String.format('scrolled to %d', e.currentIndex)
})
win.add(carousel);

win.addEventListener('open', function(e) {
  carousel.setViews(views);
  carousel.reloadData();
  carousel.scrollToIndex(3);
})

win.open();

/*
setTimeout(function() {
  carousel.scrollToIndex(3);
}, 5000);
*/