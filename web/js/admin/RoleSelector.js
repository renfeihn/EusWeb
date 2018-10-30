
Ext.ns('is.window.RoleSelector');

/*
 * 打开角色详细.
 */
openRoleInfo = function(id) {
	var win = Ext.getCmp('role-info-window');
	if (!win) {
		win = new is.window.RoleInfo(id);
	}
	//win.open(id);
	win.show();
}

is.window.RoleSelector = function() {
	this.datastore = new Ext.data.JsonStore({
		url: 'findRole.action',
		root: 'RoleList',
		fields: ['id', 'code', 'name']
	});
	
	this.roleRender = function(value) {
		var record = Ext.getCmp('role-selector-result').getStore().getById(value);
		if (record) {
			return '<span><a href="#" onclick="openRoleInfo(\'' + value + '\');">' + record.get('name') + '</a></span>';
		} else {
			return '<span></span>';
		}
	};

	this.sm = new Ext.grid.CheckboxSelectionModel();
	    
	this.results = new Ext.grid.GridPanel({
		id: 'role-selector-result',
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
				this.sm,
				{header: '编码', dataIndex: 'code'},
				{header: '名称', renderer: this.roleRender, dataIndex: 'id'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.RoleSelector.superclass.constructor.call(this, {
		title: '选择角色',
		id: 'role-selector-window',
		width: 600,
		height: 400,
		resizable: false,
		plain: true,
		modal: true,
		autoScroll: true,
		buttonAlign: 'center',

		items: [ this.results ], 
		tbar: [{
			xtype: 'is-search-field',
			id: 'role-selector-search',
			//emptyText: '输入查询条件,按回车或点击查询',
			store: this.datastore,
			paramName: 'search',
			width: 400,
			height:30,
			tooltip: '输入查询条件,按回车或点击查询.'
		}, '->', {
			text: '所有',
			iconCls: 'icon-prop',
			handler: function(button, event) {
				var search = Ext.getCmp('role-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('role-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: '确定',
			handler: function(button) {
				this.fireEvent('rolesSelected', {
					roles: this.sm.getSelections()
				});
				this.destroy();
			},
			scope: this
		}, {
			text: '取消',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});

	this.addEvents({'rolesSelected':true});
};

Ext.extend(is.window.RoleSelector, Ext.Window, {
});

Ext.reg('is-role-selector', is.window.RoleSelector);