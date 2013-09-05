var TiCarousel = require('com.obscure.ticarousel'),
    utils = require('./utils');

exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Reload',
  	backgroundColor:'white',
  	layout: 'vertical',
  });
  
  var carousel = TiCarousel.createCarouselView({
    carouselType: TiCarousel.CAROUSEL_TYPE_CYLINDER,
    width: Ti.UI.FILL,
    height: 240,
    itemWidth: 108,
    numberOfVisibleItems: 7,
  });

  win.add(carousel);
  
  var button = Ti.UI.createButton({
    title: 'Set Items',
  });
  button.addEventListener('click', function(e) {
    var items = [];
    for (r = 0; r < 256; r += 64) {
      for (g = 0; g < 256; g += 64) {
        for (b = 0; b < 256; b += 64) {
          var color = utils.toHexString(r, g, b);
          
          var view = Ti.UI.createView({
            height: 100,
            width: 100,
            backgroundColor: color,
            layout: 'vertical',
          });
          view.add(Ti.UI.createLabel({
            text: color,
            color: "white",
          }));
          items.push(view);
        }
      }
    }

    carousel.setItems(items);
  });
  win.add(button);

  return win;
};