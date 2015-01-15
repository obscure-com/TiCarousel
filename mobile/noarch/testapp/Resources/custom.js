

exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Custom Carousel',
  	backgroundColor:'white',
  	layout: 'vertical',
  });

  var TiCarousel = require('com.obscure.ticarousel');

  var label = Ti.UI.createLabel({ text: 'status' });
  win.add(label);

  var views = [];
  views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'blue' }));
  views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'yellow' }));
  views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'red' }));
  views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'green' }));
  views.push(Ti.UI.createView({ height: 60, width: 60, backgroundColor: 'gray' }));


  // build a custom transform matrix
  var f = function(offset) {
    var dx = offset * 68.0,
        dy = -70.0,
        dz = -400.0;
  
    if (Math.abs(offset) < 1.0) {
      dy = dy * Math.abs(offset);
      dz = dz * Math.abs(offset);
    }
  
    return [
      { type: 'translate', values: [dx, dy, dz] }
    ];
  };

  var carousel = TiCarousel.createCarouselView({
    carouselType: TiCarousel.CAROUSEL_TYPE_CUSTOM,
    backgroundColor: '#ccc',
    width: Ti.UI.FILL,
    height: 200,
    itemWidth: 68,
    numberOfVisibleItems: 5,
    itemTransformForOffset: f,
  });
  carousel.addEventListener('scroll', function(e) {
    label.text = String.format('scrolled to %d', e.currentIndex)
  })
  win.add(carousel);

  win.addEventListener('open', function(e) {
    carousel.setViews(views);
    carousel.reloadData();
  })

  return win;
}