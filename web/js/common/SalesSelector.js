
/* ----------------------------------------------------------
 *         Sales Selector.                                    *
 * ---------------------------------------------------------*/

Ext.ns('is.window.SalesSelector');

is.window.SalesSelector = function(states) {
	this.datastore = new Ext.data.JsonStore({
		url: 'findSales.action',
		root: 'SalesList',
		baseParams: {
			states: states
		},
		fields: [ 'id', 'code', {name:'selldate', type:'date', dateFormat:'Y-m-d'},
	  		'contract', 
	  		{name:'client', mapping:'contract.client'}, 
	  		'employee', 'car', 
	  		{name:'resstate', mapping:'car.state', type:'int'},
	  		{name:'model', mapping:'car.model.name'},
	  		{name:'suite', mapping:'car.suite.name'},
	  		{name:'color', mapping:'car.color.name'},
	  		{name:'decoration', mapping:'car.decoration.name'},
	  		{name:'carstate', mapping:'car.car.state', type:'int'},
	  		{name:'frame', mapping:'car.car.frame'},
	  		{name:'certificate', mapping:'car.car.certificate'},
	  		{name:'engine', mapping:'car.car.engine'},
	  		{name:'productDate', mapping:'car.car.productDate', type:'date', dateFormat:'Y-m-d'}
	  		]
	});

	this.sm = new Ext.grid.CheckboxSelectionModel();
	    
	this.results = new Ext.grid.GridPanel({
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
 	        columns: [
      	        {header: '���۵����', dataIndex: 'code'},
      	        {header: '���ۺ�ͬ', renderer: clsys.grid.columnrender.ContractRender, dataIndex: 'contract'},
      	        {header: '�ͻ�', renderer: clsys.grid.columnrender.ClientRender, dataIndex: 'client'},
       	        {header: '���۹���', renderer: clsys.grid.columnrender.EmployeeRender, dataIndex: 'employee'},
 	        	{header: '����', dataIndex: 'model'},
 	        	{header: '��ɫ', dataIndex: 'color'},
 	        	{header: '����', dataIndex: 'decoration'},
 	        	{header: '���ܺ�', dataIndex: 'frame'},
 	        	{header: '��������', dataIndex: 'engine'},
 	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
 	        	{header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'}
 	   	 	    ]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.SalesSelector.superclass.constructor.call(this, {
		title: 'ѡ�����۵�',
		id: 'sales-selector-window',
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
			id: 'sales-selector-search',
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
				var search = Ext.getCmp('sales-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('sales-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			handler: function(button) {
				this.fireEvent('salesSelected', {
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

	this.addEvents({'salesSelected':true});
};

Ext.extend(is.window.SalesSelector, Ext.Window, {
});

Ext.reg('is-sales-selector-window', is.window.SalesSelector);
