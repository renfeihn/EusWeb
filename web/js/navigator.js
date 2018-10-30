
Ext.ns('is.panel.Navigator');

is.panel.Navigator = function() {	
	is.panel.Navigator.superclass.constructor.call(this, {
		id:'navigator',
		region:'west',
		title:'µ¼º½À¸',
		split:true,
		width:225,
		minSize:175,
		maxSize:400,
		//border:false,
		//bodyBorder:false,
		frame:false,
		collapsible:true,
		autoScroll:true,
		layout:'accordion',
		margins:'0 0 4 4',
		//activeItem:0,
		layoutConfig: {
			animate:true
		}
		//items: [storage, dacManager]
	});
	
};

Ext.extend(is.panel.Navigator, Ext.Panel, {});

Ext.reg('navigator', is.panel.Navigator);
