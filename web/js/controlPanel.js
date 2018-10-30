
Ext.ns('is.panel.ControlPanel');

is.panel.ControlPanel = function(id, text) {
	this.root = new Ext.tree.AsyncTreeNode({
		text:text,
		id:id
	});
	
	this.treeloader = new Ext.tree.TreeLoader({
		dataUrl:'categoryFunctions.action?category=' + id
	});
	
	is.panel.ControlPanel.superclass.constructor.call(this, {
		id:id,
		title:text,
		root:this.root,
		rootVisible:false,
		autoScroll:true,
		border:false,
		//borderWidth:0,
		collapseFirst:false,
		loader:this.treeloader,
		listeners: {
			click : function(node) {
				if (node.isLeaf()) {
					this.openTable(node.attributes.id, node.attributes.text, node.attributes.url);
				}
			}
		}
	});

    this.getSelectionModel().on('beforeselect', function(sm, node){
        return node.isLeaf();
    });
};

Ext.extend(is.panel.ControlPanel, Ext.tree.TreePanel, {
	openTable : function(id, text, url) {		
		var mainPanel = Ext.getCmp('main-panel');
		mainPanel.openTable(id, text, url);	
	},

	afterRender : function() {
		is.panel.ControlPanel.superclass.afterRender.call(this);
		this.expandAll();
	}
});

Ext.reg('control-panel', is.panel.ControlPanel);
