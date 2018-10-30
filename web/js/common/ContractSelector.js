
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
  	            {header: '合同编号', renderer: this.contractSelectorContractRender, dataIndex: 'id' },
       	        {header: '结算方式', dataIndex: 'payment'},
       	        {header: '客户', renderer: clsys.grid.columnrender.ClientRender, dataIndex: 'client'},
       	        {header: '预付款', dataIndex: 'prepayed'},
       	        {header: '签订日期', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'signdate'},
       	        {header: '交车日期', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'deliverydate'},
       	        {header: '销售顾问', renderer: clsys.grid.columnrender.EmployeeRender, dataIndex: 'employee'},
       	        {header: '状态', renderer:clsys.grid.columnrender.ContractStatusRender, dataIndex: 'state'}
 	   	 	]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.ContractSelector.superclass.constructor.call(this, {
		title: '选择合同',
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
			text: '确定',
			handler: function(button) {
				this.fireEvent('contractSelected', {
					record: this.sm.getSelected()
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

	this.addEvents({'contractSelected':true});
};

Ext.extend(is.window.ContractSelector, Ext.Window, {
});

Ext.reg('is-contract-selector-window', is.window.ContractSelector);
