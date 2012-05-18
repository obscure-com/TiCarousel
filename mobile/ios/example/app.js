var win = Ti.UI.createWindow();
var base = Ti.UI.createWindow();

var nav = Ti.UI.iPhone.createNavigationGroup({
  window: base
});
win.add(nav);

var data = [
  { title: 'Transform Types', module: require('./types') },
  { title: 'Scrolling', module: require('./scroll') },
  { title: 'Viewpoint', module: require('./viewcenter') },
  { title: 'Custom Transform', module: require('./custom') },
];

var table = Ti.UI.createTableView({
  data: data
});

table.addEventListener('click', function(e) {
  nav.open(e.row.module.createWindow());
});

base.add(table);

win.open();
