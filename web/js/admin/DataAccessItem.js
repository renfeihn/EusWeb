
Ext.ns('is.window.DataAccessItem');

is.window.DataAccessItem = function() {
	is.window.DataAccessItem.superclass.constructor.call(this, {
		id: 'data-access-item-window',
		title: '数据权限项目',
		modal: true,
		width: 400,
		height: 100,
		resizable: false,
		items: [{
			xtype: 'form',
			labelAlign: 'right',
			border: false,
			frame: false,
			style: {
				marginTop: 3
			},
			items: [{
				xtype: 'combo',
				id: 'data-access-item-selector',
				fieldLabel: '数据权限项',
				name: 'data-access-item',
				width: 175,
				displayField: 'name',
				valueField: 'code',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['code', 'name'],
					data: [
						['Contract', '合同'],
						['Schedule', '计划'],
						['StorageIncoming', '入库']
					]
				}),
				emptyText: '选择数据权限项'
			}]
		}],
		buttons: [{
			text: '确定',
			handler: function() {
				this.fireEvent('dataAccessItemAdded', {
					item: {
						code: Ext.getCmp('data-access-item-selector').getValue(),
						name: Ext.getCmp('data-access-item-selector').getRawValue()
					}
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
	
	this.addEvents({'dataAccessItemAdded':true});
};

Ext.extend(is.window.DataAccessItem, Ext.Window, {});

Ext.reg('is-data-access-item', is.window.DataAccessItem);