
Ext.ns('is.window.RoleInfo');

is.window.RoleInfo = function(role) {
	is.window.RoleInfo.superclass.constructor.call(this, {
		id: 'role-info-window',
		title: '��ɫ��Ϣ - ����Ԥ��',
		width: 400,
		height: 500,
		items: [{
			xtype: 'treepanel',
			id: 'role-info-tree-panel',
			root: {
				nodeType: 'async'
			},
			rootVisible: false,
			autoScroll:true,
			border: true,
			//width: 400,
			height: 410,
			collapseFirst: false,
			loader: new Ext.tree.TreeLoader({
				dataUrl: 'systemFunctions',
				baseParams: {
					role: role
				}
			})
		}]
	});
	
	Ext.getCmp('role-info-tree-panel').getRootNode().expand(true);
};

Ext.extend(is.window.RoleInfo, Ext.Window, {
	/*
	 * �򿪽�ɫ��ϸ��Ϣ.
	 */
	open: function(id) {
		//this.datastore.load({params:{id:id}});
		//var loader = Ext.getCmp('role-info-tree-panel').getLoader()
	}
});

Ext.reg('is-role-info-window', is.window.RoleInfo);