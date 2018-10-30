
/* ----------------------------------------------------------
 *         Car Selector.                                    *
 * ---------------------------------------------------------*/

Ext.ns('is.window.ContractSelector');

is.window.ContractSelector = function(states) {
	this.datastore = new Ext.data.JsonStore({
		url: 'findContract.action',
		root: 'ContractList',
		baseParams: {
			status: ['Using'],
			states: states
		},
		fields: ['id','code','name', 'memo',
			{name:'signdate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'deliverydate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'state', type:'int'}, 
			{name:'prepayed', type:'int'},
			'employee',
			{name:'payment', mapping:'payment.name'},
			'client',
			'cars']
	});

	this.sm = new Ext.grid.CheckboxSelectionModel();

	/*
	 * Contract render.
	 */
	this.contractSelectorContractRender = function(id) {
		var store = Ext.getCmp('contract-car-selector-grid').getStore();
		var record = store.getById(id);
		if (record) {
			return '<span><a href="#" onclick="gridOpenContractInfo(\'' + id + '\');">' +  record.get('code') + '</a></span>';
		} else {
			return '<span></span>';
		}
	};
	
	this.results = new Ext.grid.GridPanel({
		id: 'contract-car-selector-grid',
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
 	        columns: [
  	            {header: '��ͬ���', renderer: this.contractSelectorContractRender, dataIndex: 'id' },
       	        {header: '���㷽ʽ', dataIndex: 'payment'},
       	        {header: '�ͻ�', renderer: clsys.grid.columnrender.ClientRender, dataIndex: 'client'},
       	        {header: 'Ԥ����', dataIndex: 'prepayed'},
       	        {header: 'ǩ������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'signdate'},
       	        {header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'deliverydate'},
       	        {header: '���۹���', renderer: clsys.grid.columnrender.EmployeeRender, dataIndex: 'employee'},
       	        {header: '״̬', renderer:clsys.grid.columnrender.ContractStatusRender, dataIndex: 'state'}
 	   	 	]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.ContractSelector.superclass.constructor.call(this, {
		title: 'ѡ���ͬ',
		id: 'contract-selector-window',
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
			id: 'contract-selector-search',
			//emptyText: '�����ѯ����,���س�������ѯ',
			store: this.datastore,
			paramName: 'search',
			width: 400,
			height:30,
			tooltip: '�����ѯ����,���س�������ѯ.'
		}, '->', {
			text: '����',
			iconCls: 'icon-prop',
			handler: function(button, event) {
				var search = Ext.getCmp('contract-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('contract-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			handler: function(button) {
				this.fireEvent('contractSelected', {
					record: this.sm.getSelected()
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

	this.addEvents({'contractSelected':true});
};

Ext.extend(is.window.ContractSelector, Ext.Window, {
});

Ext.reg('is-contract-selector-window', is.window.ContractSelector);
