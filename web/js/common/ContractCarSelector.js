
Ext.ns('is.window.ContractCarSelector');

is.window.ContractCarSelector = function() {
	this.contractStore = new Ext.data.JsonStore({
		url: 'getContract.action',
		root: 'Contract',
		fields: ['id', 'cars']
	});
	
	this.carStore = new Ext.data.JsonStore({
		root: 'cars',
		fields: ['id',
			 {name:'model', mapping:'model.name'}, 
			 {name:'suite', mapping:'suite.name'},
			 {name:'color', mapping:'color.name'}, 
			 {name:'decoration', mapping:'decoration.name'},
			 {name: 'state', type:'int'},
			 {name:'frame', mapping:'car.frame'},
			 {name:'engine', mapping:'car.engine'},
			 {name:'certificate', mapping:'car.certificate'},
			 {name:'productDate', mapping:'car.productDate', type:'date', dateFormat: 'Y-m-d'},
			 {name:'carstate', mapping:'car.state', type:'int'}]
	});
	
	this.sm = new Ext.grid.RowSelectionModel({singleSelect:true});
	
	this.grid = new Ext.grid.GridPanel({
		id: 'contract-car-selector-grid',
		width: 700,
		height: 400,
		store: this.carStore,
		autoScroll: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
	        	{header: '����', dataIndex: 'model'},
	        	{header: '����', dataIndex: 'suite'},
	        	{header: '��ɫ', dataIndex: 'color'},
	        	{header: '����', dataIndex: 'decoration'},
	        	{header: '���ܺ�', dataIndex: 'frame'},
	        	{header: '��������', dataIndex: 'engine'},
	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
	        	{header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'},
	        	{header: '״̬', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: 'ʵ��״̬', renderer: clsys.grid.columnrender.CarStatusRender, dataIndex: 'carstate'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});
	
	is.window.ContractCarSelector.superclass.constructor.call(this, {
		title: 'ѡ���ͬ�еĳ���',
		id: 'contract-car-selector-window',
		items: this.grid,
		buttonAlign: 'center',
		buttons: [{
			text: 'ȷ��',
			id: 'contract-car-select',
			disabled: true,
			handler: function() {
				this.fireEvent('contractCarSelected', {
					Car: [ this.sm.getSelected().json ]
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
	
	this.sm.on('selectionchange', function(sm) {
		Ext.getCmp('contract-car-select').setDisabled(sm.getCount() < 1);
	});
	
	this.addEvents({'contractCarSelected':true});
};

Ext.extend(is.window.ContractCarSelector, Ext.Window, {
	/*
	 * open contract selector.
	 * @param id contract id.
	 */
	open: function(id) {
		this.contractStore.load({
			params: {
				id: id
			},
			callback: function() {
				var record = this.contractStore.getAt(0);
				this.carStore.loadData(record.json);
			},
			scope: this
		});
	}
});

Ext.reg('is-contract-car-selector', is.window.ContractCarSelector);