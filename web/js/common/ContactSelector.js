
/***********************************************************
 *            Contact Selector.                             *
 ***********************************************************/
Ext.ns('is.window.ContactSelector');

is.window.ContactSelector = function() {
	this.clientStore = new Ext.data.JsonStore({
		url: 'getClient.action',
		root: 'Client',
		fields: ['id', 'contacts']
	});
	
	this.datastore = new Ext.data.JsonStore({
		root: 'contacts',
		fields: ['id', 'code', 'name', 'sex', 'idnum', 'mobile', 'tel']
	});

	this.results = new Ext.grid.GridPanel({
		id: 'contact-selector-result-grid',
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
	        	{header: '����', dataIndex: 'code'},
	        	{header: '����', dataIndex: 'name'},
	        	{header: '�Ա�', dataIndex: 'sex'},
	        	{header: '���֤����', dataIndex: 'idnum'},
	        	{header: '�ƶ��绰', dataIndex: 'mobile'},
	        	{header: '�绰', dataIndex: 'tel'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	
	is.window.ContactSelector.superclass.constructor.call(this, {
		title: 'ѡ����ϵ��',
		id: 'contact-selector',
		width: 600,
		height: 400,
		resizable: false,
		plain: true,
		modal: true,
		autoScroll: true,
		items: [ this.results ], 
		buttonAlign: 'center',
		buttons: [{
			text: 'ȷ��',
			id: 'contact-selector-select',
			handler: function() {
				this.fireEvent('contactSelected', {
					Contact: [Ext.getCmp('contact-selector-result-grid').getSelectionModel().getSelected().json]
				});
				this.destroy();
			},
			scope: this,
			disabled: true
		}, {
			text: 'ȡ��',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
	
	Ext.getCmp('contact-selector-result-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('contact-selector-select').setDisabled(sm.getCount()< 1);
	});
	
	this.addEvents({'contactSelected':true});
};

Ext.extend(is.window.ContactSelector, Ext.Window, {
	/*
	 * open contact selector.
	 * @param id client id.
	 */
	open: function(id) {
		this.clientStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.datastore.loadData(records[0].json);
				}
			},
			scope: this
		});
	}
});

Ext.reg('contact-selector-window', is.window.ContactSelector);
