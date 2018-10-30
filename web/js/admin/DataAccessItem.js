
Ext.ns('is.window.DataAccessItem');

is.window.DataAccessItem = function() {
	is.window.DataAccessItem.superclass.constructor.call(this, {
		id: 'data-access-item-window',
		title: '����Ȩ����Ŀ',
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
				fieldLabel: '����Ȩ����',
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
						['Contract', '��ͬ'],
						['Schedule', '�ƻ�'],
						['StorageIncoming', '���']
					]
				}),
				emptyText: 'ѡ������Ȩ����'
			}]
		}],
		buttons: [{
			text: 'ȷ��',
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
			text: 'ȡ��',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
	
	this.addEvents({'dataAccessItemAdded':true});
};

Ext.extend(is.window.DataAccessItem, Ext.Window, {});

Ext.reg('is-data-access-item', is.window.DataAccessItem);