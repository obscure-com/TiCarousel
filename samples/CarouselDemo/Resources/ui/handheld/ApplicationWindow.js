
function ApplicationWindow() {
	var CarouselView = require('ui/common/CarouselView');
		
	var self = Ti.UI.createWindow({
		backgroundColor:'#ffffff'
	});
		
	//construct UI
	var view = new CarouselView();
	self.add(view);
	
	return self;
}

module.exports = ApplicationWindow;
