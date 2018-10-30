
Ext.ns('is.panel.MainPanel');

is.panel.MainPanel = function() {
	is.panel.MainPanel.superclass.constructor.call(this, {
		autoDestroy: true,
		id:'main-panel',
		region:'center',
		margins:'0 4 4 0',
		resizeTabs: true,
		minTabWidth:125,
		tabWidth:125,
		enableTabScroll:true,
		defaults: {autoScroll:true},
		activeTab:0,
		items: [{
			id: 'summary-panel',
			title: 'ժҪ',
			autoLoad: {
				url: 'welcome.html',
				callback: Ext.emptyFn,
				scripts: true,
				discardUrl: false,
				text: clsys.form.Util.waitMsg,
				nocache: true
			},
			iconCls:'icon-docs'
			//autoScroll: true
		}]
	});	
};

Ext.extend(is.panel.MainPanel, Ext.TabPanel, {
	openTable : function(id, text, href) {
		var panel = this.getComponent(id);
		if (panel) {
			this.setActiveTab(panel);
		} else {
			var autoLoad = {
				callback:Ext.emptyFn,
				scripts: true,
				nocache: true,
				discardUrl: false,
				text: clsys.form.Util.waitMsg,
				url: href
			};
						
			var p = this.add(new Ext.Panel({
				id: id + '-mainpanel',
				title:text,
				layout: 'anchor',    
				autoLoad: autoLoad,
				autoScroll:true,
				autoDestroy: true,
				iconCls:'icon-cls',
				closable:true,
				tbar:[],bbar:[]
			}));
			this.setActiveTab(p);
		}
	}
});

Ext.reg('is-main-panel', is.panel.MainPanel);