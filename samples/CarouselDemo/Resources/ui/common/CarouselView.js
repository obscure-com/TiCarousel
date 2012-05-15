
var TiCarousel = require('com.obscure.TiCarousel'),
    views = [];

for (i=0; i < 20; i++) {
  // NOTE the views provided to the carousel cannot currently use
  // Ti.UI.SIZE or Ti.UI.FILL (or 'auto', for that matter).
  var view = Ti.UI.createImageView({
    height: 320,
    width: 200,
    image: '/images/page.png',
  });
  view.add(Ti.UI.createLabel({
    center: { x: 100, y: 140 },
    font: {
      fontSize: 24
    },
    text: String.format('#%d', i),
    textAlign: 'center',
  }));
  views.push(view);
}

function CarouselView() {
	var self = TiCarousel.createCarouselView({
    carouselType: TiCarousel.CAROUSEL_TYPE_LINEAR,
    views: views,
    itemWidth: 210,
    numberOfVisibleItems: 3,
	});
	
	return self;
}

module.exports = CarouselView;
