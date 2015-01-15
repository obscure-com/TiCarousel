var TiCarousel = require('com.obscure.ticarousel'),
    utils = require('./utils'),
    txopts = {
      arc: Math.PI / 2.0,
      radius: 500.0,
      tilt: 0.9,
      spacing: 1.0,
      yoffset: 20.0,
      zoffset: -400.0
    },
    views = [];

for (i=0; i < 20; i++) {
  // NOTE the views provided to the carousel cannot currently use
  // Ti.UI.SIZE or Ti.UI.FILL (or 'auto', for that matter).
  r = ((i + 1) * 12);
  var bg = utils.toHexString(r, (255 - r), 128);
  var view = Ti.UI.createView({
    height: 100,
    width: 100,
    backgroundColor: bg,
    borderColor: 'black',
    borderWidth: 2,
  });
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
    height: Ti.UI.FILL,
    borderTop: true,
    borderBottom: false,
  });
  
  return self;
}

function createArcView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });
  
  var label = Ti.UI.createLabel({
    text: String.format('arc: %.2f', txopts.arc)
  })
  result.add(label);
  
  var slider = Ti.UI.createSlider({
    min: -2 * Math.PI,
    max: 2 * Math.PI,
    value: txopts.arc,
  });
  slider.addEventListener('change', function(e) {
    txopts.arc = e.value;
    label.text = String.format('arc: %.2f', txopts.arc);
    carousel.transformOptions = txopts;
    carousel.reloadData();
  });
  result.add(slider);
  
  return result;
}

function createRadiusView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });
  
  var label = Ti.UI.createLabel({
    text: String.format('radius: %.2f', txopts.radius)
  })
  result.add(label);
  
  var slider = Ti.UI.createSlider({
    min: 0,
    max: 10 * carousel.itemWidth,
    value: txopts.radius,
  });
  slider.addEventListener('change', function(e) {
    txopts.radius = e.value;
    label.text = String.format('radius: %.2f', txopts.radius);
    carousel.transformOptions = txopts;
    carousel.reloadData();
  });
  result.add(slider);
  
  return result;
}

function createTiltView(carousel) {
  var result = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
  });
  
  var label = Ti.UI.createLabel({
    text: String.format('tilt: %.2f', txopts.tilt)
  })
  result.add(label);
  
  var slider = Ti.UI.createSlider({
    min: -2 * Math.PI,
    max: 2 * Math.PI,
    value: txopts.tilt,
  });
  slider.addEventListener('change', function(e) {
    txopts.tilt = e.value;
    label.text = String.format('tilt: %.2f', txopts.tilt);
    carousel.transformOptions = txopts;
    carousel.reloadData();
  });
  result.add(slider);
  
  return result;
}

exports.createWindow = function() {
  var win = Ti.UI.createWindow({
    title: 'Tx Options',
  	backgroundColor:'white',
  	layout: 'vertical',
  });
  
  var container = Ti.UI.createView({
    height: 200
  });

  var typeLabel = Ti.UI.createLabel({
    top: 0,
    height: 24,
    text: 'ROTARY',
  });
  
	var carousel = TiCarousel.createCarouselView({
    carouselType: TiCarousel.CAROUSEL_TYPE_ROTARY,
    views: views,
    height: 190,
    itemWidth: 108,
    numberOfVisibleItems: 12,
    wrap: false,
    transformOptions: txopts,
	});

  var toolbar = createToolbar(container, typeLabel, carousel);

  win.add(typeLabel);
  
  container.add(carousel);
  win.add(container);

  win.add(createArcView(carousel));
  win.add(createRadiusView(carousel));
  win.add(createTiltView(carousel));
  win.add(toolbar);

  return win;
};