
var TiCarousel = require('com.obscure.ticarousel'),
    utils = require('./utils'),
    views = [];

for (i=0; i < 20; i++) {
  // NOTE the views provided to the carousel cannot currently use
  // Ti.UI.SIZE or Ti.UI.FILL (or 'auto', for that matter).
  r = ((i + 1) * 12);
  var bg = utils.toHexString(r, (255 - r), 128);
  var view = Ti.UI.createView({
    height: 200,
    width: 200,
    backgroundColor: bg,
    borderColor: 'black',
    borderWidth: 2,
  });
  view.add(Ti.UI.createLabel({
    center: { x: 100, y: 100 },
    font: {
      fontSize: 24
    },
    text: String.format('#%d', i),
    textAlign: 'center',
  }));
  views.push(view);
}

function createTypePickerView(carousel) {
  var self = Ti.UI.createView({
    bottom: -240,
    height: 240,
    backgroundColor: '#ccc',
    zIndex: 100,
  });
  
  var rows = [
    Ti.UI.createPickerRow({ title: 'LINEAR', type: TiCarousel.CAROUSEL_TYPE_LINEAR }),
    Ti.UI.createPickerRow({ title: 'ROTARY', type: TiCarousel.CAROUSEL_TYPE_ROTARY }),
    Ti.UI.createPickerRow({ title: 'INVERTED_ROTARY', type: TiCarousel.CAROUSEL_TYPE_INVERTED_ROTARY }),
    Ti.UI.createPickerRow({ title: 'CYLINDER', type: TiCarousel.CAROUSEL_TYPE_CYLINDER }),
    Ti.UI.createPickerRow({ title: 'INVERTED_CYLINDER', type: TiCarousel.CAROUSEL_TYPE_INVERTED_CYLINDER }),
    Ti.UI.createPickerRow({ title: 'WHEEL', type: TiCarousel.CAROUSEL_TYPE_WHEEL }),
    Ti.UI.createPickerRow({ title: 'INVERTED_WHEEL', type: TiCarousel.CAROUSEL_TYPE_INVERTED_WHEEL }),
    Ti.UI.createPickerRow({ title: 'COVER_FLOW', type: TiCarousel.CAROUSEL_TYPE_COVER_FLOW }),
    Ti.UI.createPickerRow({ title: 'COVER_FLOW2', type: TiCarousel.CAROUSEL_TYPE_COVER_FLOW2 }),
    Ti.UI.createPickerRow({ title: 'TIME_MACHINE', type: TiCarousel.CAROUSEL_TYPE_TIME_MACHINE }),
    Ti.UI.createPickerRow({ title: 'INVERTED_TIME_MACHINE', type: TiCarousel.CAROUSEL_TYPE_INVERTED_TIME_MACHINE }),
    Ti.UI.createPickerRow({ title: 'BUMP', type: TiCarousel.CAROUSEL_TYPE_BUMP }),
  ];
  
  var picker = Ti.UI.createPicker({
    top: 10
  });
  
  picker.add(rows);
  
  picker.addEventListener('change', function(e) {
    carousel.carouselType = e.row.type;
    self.fireEvent('done', {
      title: e.row.title
    });
  });
  
  self.add(picker);
  return self;
}


function createToolbar(parentView, typeLabel, carousel) {
  var typeButton = Ti.UI.createButton({
    title: 'Type',
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED,
  });
  var typePickerView = createTypePickerView(carousel);
  typePickerView.addEventListener('done', function(e) {
    typeLabel.text = e.title;
    typePickerView.animate({
      bottom: typePickerView.bottom,
      duration: 200,
    });
  });
  parentView.add(typePickerView);
  
  typeButton.addEventListener('click', function(e) {
    typePickerView.animate({
      bottom: 0,
      duration: 200,
    });
  });
  
  var wrapButton = Ti.UI.createButton({
    title: 'Wrap: OFF',
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED,
  });
  wrapButton.addEventListener('click', function(e) {
    carousel.wrap = !carousel.wrap;
    carousel.reloadData();
    wrapButton.title = carousel.wrap ? 'Wrap: ON' : 'Wrap: OFF';
  });
  
  var verticalButton = Ti.UI.createButton({
    title: carousel.vertical ? 'Vertical' : 'Horizontal',
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED,
  });
  verticalButton.addEventListener('click', function(e) {
    carousel.vertical = !carousel.vertical;
    setTimeout(function() {
      verticalButton.title = carousel.vertical ? 'Vertical' : 'Horizontal';
    }, 200);
  });
  
  var flexSpace = Ti.UI.createButton({
    systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE,
  });
  
  var self = Ti.UI.iOS.createToolbar({
    items: [typeButton, flexSpace, verticalButton, wrapButton],
    bottom: 0,
    borderTop: true,
    borderBottom: false,
  });
  
  return self;
}

exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Carousel Types',
  	backgroundColor:'white',
  	layout: 'vertical',
  });
  
  var container = Ti.UI.createView();

  var typeLabel = Ti.UI.createLabel({
    top: 0,
    height: 24,
    text: 'LINEAR',
  });
  container.add(typeLabel);
  
  var statusLabel = Ti.UI.createLabel({
    top: 24,
    height: 24,
    text: ''
  });
  container.add(statusLabel);

	var carousel = TiCarousel.createCarouselView({
	  top: 48,
    carouselType: TiCarousel.CAROUSEL_TYPE_LINEAR,
    views: views,
    itemWidth: 220,
    numberOfVisibleItems: 12,
    wrap: false,
	});

  carousel.addEventListener('select', function(e) {
    statusLabel.text = String.format('selectedIndex: %d, currentIndex: %d', e.selectedIndex, e.currentIndex);
  });

  var toolbar = createToolbar(container, typeLabel, carousel);

  container.add(carousel);
  container.add(toolbar);

  win.add(container);

  return win;
};