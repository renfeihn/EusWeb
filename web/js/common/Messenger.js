
Ext.ns('is.window.Messenger');

is.window.Message = Ext.extend(Ext.Window, {
	id: 'message-window',
	width: 400,
	height: 300,
	title: '消息',
	items: [{
		xtype: 'form',
		items: [{
			xtype: 'displayfield',
			id: 'message-title',
			fieldLabel: '标题'
		}, {
			xtype: 'textarea',
			id: 'message-content',
			hideLabel: true,
			width: 380,
			height: 250
		}]
	}],
	
	open: function(record) {
		Ext.getCmp('message-title').setValue(record.get('title'));
		Ext.getCmp('message-content').setValue(record.get('content'));
	}
});

is.window.Messenger = function(store) {
	this.store = store;
	
	is.window.Messenger.superclass.constructor.call(this, {
		width: 200,
		height: 400,
		id: 'messenger-window',
		title: '消息',
		tbar: [{
			xtype: 'button',
			id: 'messenger-view',
			iconCls: 'icon-update',
			text: '查看',
			handler: function() {
				var msg = Ext.getCmp('message-window');
				if (!msg) {
					msg = new is.window.Message();
				}
				msg.open(Ext.getCmp('messenger-grid').getSelectionModel().getSelected());
				msg.show();
			},
			scope: this
		}, {
			xtype: 'button',
			iconCls: 'icon-remove',
			text: '删除',
			handler: function() {
				this.store.remove(Ext.getCmp('messenger-grid').getSelectionModel().getSelected());
			},
			scope: this
		}],
		items: [{
			xtype: 'grid',
			id: 'messenger-grid',
			autoScroll: true,
			border: false,
			frame: false,
			//autoHeight: true,
			height: 335,
			store: this.store,
			stripeRows: true,
			cm: new Ext.grid.ColumnModel({
				columns: [
			          {header: '标题', dataIndex: 'title'}
				]
			}),
     		viewConfig: {
     			forceFit: true
    		},
			sm: new Ext.grid.RowSelectionModel({single:true})
		}]
	});
};

Ext.extend(is.window.Messenger, Ext.Window, {});

Ext.reg('is-messenger', is.window.Messenger);