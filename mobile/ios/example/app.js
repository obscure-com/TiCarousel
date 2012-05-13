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
views.push(Ti.UI.createView({ height: 60, width: 30, backgroundColor: 'blue' }));
views.push(Ti.UI.createView({ height: 60, width: 50, backgroundColor: 'yellow' }));
views.push(Ti.UI.createView({ height: 60, width: 40, backgroundColor: 'red' }));
views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'green' }));
views.push(Ti.UI.createView({ height: 60, width: 20, backgroundColor: 'gray' }));

var view = TiCarousel.createCarouselView({
  carouselType: TiCarousel.CAROUSEL_TYPE_CYLINDER,
  views: views,
  backgroundColor: '#ccc',
  width: Ti.UI.FILL,
  height: 200,
  horizontalPadding: 30,
});
view.addEventListener('scroll', function(e) {
  label.text = String.format('scrolled to %d', e.currentPage)
})
win.add(view);

win.open();

setTimeout(function() {
  view.scrollToIndex(3);
}, 5000);