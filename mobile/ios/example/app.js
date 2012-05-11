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

var view = TiCarousel.createCarouselView({
  backgroundColor: 'yellow',
  width: Ti.UI.FILL,
  height: 200,
});
view.addEventListener('scroll', function(e) {
  label.text = JSON.stringify(e);
})
win.add(view);

win.open();
