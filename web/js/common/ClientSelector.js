
/***********************************************************
 *            Client Selector.                             *
 ***********************************************************/

Ext.ns('is.window.ClientSelector');

is.window.ClientSelector = function(singleSelect) {
	this.status = status;
	
	this.datastore = new Ext.data.JsonStore({
		url: 'findClient.action',
		root: 'ClientList',
		baseParams: {
			status: this.status
		},
		fields: ['id', 'code','name','address','tel','zipcode',{name:'individual', type:'int'}, 'ContactsList']
	});
	
	this.sm = new Ext.grid.CheckboxSelectionModel({singleSelect: singleSelect ? true: false});
	    
	this.results = new Ext.grid.GridPanel({
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
				this.sm,
				  {header: '���', dataIndex: 'id'},
				  {header: '����', dataIndex: 'code'},
				  {header: '����', dataIndex: 'name'},
				  {header: '�绰', dataIndex: 'tel'},
				  {header: '��ַ', dataIndex: 'address'},
				  {header: '��������', dataIndex: 'zipcode'},
				  {header: '����', renderer: clsys.grid.columnrender.ContactRender, dataIndex: 'individual'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.ClientSelector.superclass.constructor.call(this, {
		title: 'ѡ��ͻ�',
		id: 'client-selector-window',
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
			id: 'client-selector-search',
			store: this.datastore,
			paramName: 'search',
			width: 200,
			height:30,
			tooltip: '�����ѯ����,���س�������ѯ.'
		}, '->', {
			text: '����',
			iconCls: 'icon-prop',
			handler: function(button, event) {
				var search = Ext.getCmp('client-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('client-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			id: 'contract-selector-ok',
			handler: function(button) {
				var json = {
					Client:[  this.sm.getSelected().json  ]
				};
				var data = singleSelect? json : this.sm.getSelections();
				this.fireEvent('clientsSelected', {
					client: data
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

	this.addEvents({'clientsSelected':true});

	this.sm.on('selectionchange', function(sm) {
		Ext.getCmp('contract-selector-ok').setDisabled(sm.getCount() < 1);
	});
};

Ext.extend(is.window.ClientSelector, Ext.Window, {
	updateStatus: function(status) {
		this.status = status;
		this.datastore.removeAll();
	}
});

Ext.reg('is-client-selector-window', is.window.ClientSelector);