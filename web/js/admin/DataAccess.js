
Ext.ns('is.window.DataAccess');

is.window.DataAccess = function() {
	this.datastore = new Ext.data.JsonStore({
		autoDestroy: true,
		autoLoad: true,
		url: 'getDataAccess.action',
		root: 'DataAccessList',
		fields: ['id', 'code', 'name', {name:'state',type:'int'}]
	});
	
	is.window.DataAccess.superclass.constructor.call(this, {
		id: 'data-access-window',
		title: '系统数据权限',
		modal: true,
		width: 400,
		height: 300,
		buttonAlign: 'center',
		items: [{
			xtype: 'grid',
			id: 'data-access-grid',
			autoScroll: true,
			height: 200,
			store: this.datastore,
			cm: new Ext.grid.ColumnModel({
				columns: [
				    {header: '编码', dataIndex: 'code'},
				    {header:'名称', dataIndex: 'name'},
				    {header:'状态', renderer:clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
			}),
			viewConfig: {
				forceFit: true
			},
			sm: new Ext.grid.RowSelectionModel({single:true})
		}],
		tbar: [{
			text: '增加',
			iconCls: 'icon-add',
			handler: function() {
				var win = Ext.getCmp('data-access-item-window');
				if (!win) {
					win = new is.window.DataAccessItem();
					win.on('dataAccessItemAdded', this.onDataAccessItemAdded, this);
				}
				win.show();
			},
			scope: this
		},/* {
			text: '删除',
			id: 'data-access-item-remove',
			disabled: true,
			iconCls: 'icon-remove',
			handler: function() {
				var grid = Ext.getCmp('data-access-grid');
				grid.getStore().remove(grid.getSelectionModel().getSelected());
			},
			scope: this
		}, */{
			text: '启用',
			id: 'data-access-item-enable',
			disabled: true,
			handler: function() {
				var grid = Ext.getCmp('data-access-grid');
				grid.getSelectionModel().getSelected().set('state', 0);
			},
			scope: this
		}, {
			text: '禁用',
			id: 'data-access-item-disable',
			disabled: true,
			handler: function() {
				var grid = Ext.getCmp('data-access-grid');
				grid.getSelectionModel().getSelected().set('state', 1);
			},
			scope: this
		}],
		buttons: [{
			text: '应用',
			iconCls: 'icon-commit',
			handler: this.submit,
			scope: this
		}, {
			text: '取消',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
	
	Ext.getCmp('data-access-grid').getSelectionModel().on('selectionchange', function(sm) {
		//Ext.getCmp('data-access-item-remove').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			Ext.getCmp('data-access-item-enable').setDisabled(record.get('state') == 0);
			Ext.getCmp('data-access-item-disable').setDisabled(record.get('state') == 1);
		}
	});
};

Ext.extend(is.window.DataAccess, Ext.Window, {
	/*
	 * data access item added event handler.
	 */
	onDataAccessItemAdded: function(attr) {		
		var store = Ext.getCmp('data-access-grid').getStore();
		if (store.findExact('code', attr.item.code) == -1) {
			var Record = store.recordType;
			var record = new Record({
				id: '',
				code: attr.item.code,
				name: attr.item.name,
				state: 0
			});
			store.add(record);
		}
	},	
	/*
	 * submit form.
	 */
	submit: function() {
		var items = [], names = [], states = [];
		var store = Ext.getCmp('data-access-grid').getStore();
		for (var i = 0; i < store.getCount(); i++) {
			items.push(store.getAt(i).get('code'));
			names.push(store.getAt(i).get('name'));
			states.push(store.getAt(i).get('state'));
		}
		
		if (items.length > 0) {
			Ext.Ajax.request({
				url: 'updateDataAccess.action',
				params: {
					items: items,
					names: names,
					states: states
				},
				success: function(response, opts) {
					var result = Ext.decode(response.responseText);
					if (result.success) {
						this.destroy();
					} else {
						clsys.message.error(result.msg);
					}
				},
				failure: function(response, opts) {
					clsys.message.systemerror(Ext.decode(response.responseText).msg);
				},
				scope: this
			});
		} else {
			this.destroy();
		}
	}
});

Ext.reg('is-data-access', is.window.DataAccess);