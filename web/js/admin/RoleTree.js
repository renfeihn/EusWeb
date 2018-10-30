
Ext.ns('is.window.RoleTree');

is.window.RoleTree = function() {
	this.treePanel = new Ext.tree.TreePanel({
		id: 'role-window-tree-panel',
		root: {
			nodeType: 'async'
		},
		rootVisible: false,
		autoScroll:true,
		border:false,
		width: 485,
		height: 335,
		//borderWidth:0,
		collapseFirst: false,
		loader: new Ext.tree.TreeLoader({
			dataUrl: 'systemFunctions.action'
		})
	});
	
	this.treePanel.getRootNode().expand(true);
	
	is.window.RoleTree.superclass.constructor.call(this, {
		id: 'role-tree-window',
		title: '角色权限',
		width: 500,
		height: 400,
		buttonAlign: 'center',
		items: [ this.treePanel],
		buttons: [{
			text: '应用',
			iconCls: 'icon-commit',
			handler: function(button) {
			}
		}, {
			text: '取消',
			iconCls: 'icon-commit',
			handler: function(button) {
			}
		}]
	});
};

Ext.extend(is.window.RoleTree, Ext.Window, {});

Ext.reg('is-role-tree', is.window.RoleTree);