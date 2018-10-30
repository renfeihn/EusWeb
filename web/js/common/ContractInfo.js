
Ext.ns('is.window.ContractInfo');

is.window.ContractInfo = function() {
	this.datastore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getContract.action',
		root: 'Contract',
		fields: ['id', 'code', 'memo',
			{name:'signdate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'deliverydate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'state', type:'int'}, 
			{name:'prepayed', type:'float'},
			{name:'employee', mapping:'employee.id'},
			{name:'payment', mapping:'payment.name'},
			{name:'client', mapping:'client.id'},
			'cars']
	});
	
//	this.contractTpl = new Ext.XTempalte(
//		'<tpl for=".">',
//		'<div id="contract-info">',
//		'</div>',
//		'</tpl>'
//	);
	
	this.contractForm = new Ext.form.FormPanel({
		id: 'contract-info-form',
		labelAlign: 'right',
		width: 500,
		autoHeight: true,
		border: false,
		frame: false,
		items: [{
			layout: 'column',
			border: false,
			frame: false,
			items: [{
				columnWidth: 0.5,
				layout: 'form',
				border: false,
				frame: false,
				defaultType: 'displayfield',
				items: [{
					fieldLabel: '���',
					ctCls: 'res-block-inner',
					id: 'contract-info-code'
				}, {
					fieldLabel: 'ǩ������',
					ctCls: 'res-block-inner',
					id: 'contract-info-signdate'
				}, {
					fieldLabel: '��������',
					ctCls: 'res-block-inner',
					id: 'contract-info-deliverty-date'
				}, {
					xtype: 'is-client-dataview',
					fieldLabel: '�ͻ�',
					ctCls: 'res-block-inner',
					id: 'contract-info-client',
					readOnly: true
				}]				
			} , {
				columnWidth: 0.5,
				layout: 'form',
				border: false,
				frame: false,
				defaultType: 'displayfield',
				items: [{
					fieldLabel: 'Ԥ����',
					ctCls: 'res-block-inner',
					id: 'contract-info-prepayed'
				}, {
					fieldLabel: '֧����ʽ',
					ctCls: 'res-block-inner',
					id: 'contract-info-payment'
				}, {
					fieldLabel: '���۹���',
					id: 'contract-info-salesman',
					ctCls: 'res-block-inner',
					xtype: 'is-employee-dataview',
					readOnly: true
				}]
			}]
		}, {
			xtype: 'displayfield',
        	fieldLabel: '����Ԥ������',
			ctCls: 'res-block-inner',
			id: 'contract-info-memo'
		}, {
			xtype: 'grid',
			id: 'contract-info-cars-grid',
			autoScroll: true,
			height: 200,
			tbar: [ '��ͬ�����б�' ],
			store: new Ext.data.JsonStore({
				autoDestroy: true,
				root: 'cars',
				fields: ['id',
			 		{name:'model', mapping:'model.name'},
			 		{name:'suite', mapping:'suite.name'},
					{name:'color', mapping:'color.name'},
					{name:'decoration', mapping:'decoration.name'},
					{name:'engine', mapping:'car.engine'},
					{name:'frame', mapping:'car.frame'},
					{name:'productDate', type:'date', mapping:'car.productDate', dateFormat:'Y-m-d'}, 
					{name:'certificate', mapping:'car.certificate'},
					{name:'state', type:'int'}, 
					{name:'carstate', mapping:'car.state', type:'int'}]
			}),
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
	 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		}]
	});
	
	/*this.dataview = new Ext.DataView({
		id: 'contract-info-dataview',
		store: new Ext.data.JsonStore({
			
		}),
		tpl: this.contractTpl,
		itemSelector: 'div.contract-info'
	});*/
	
	is.window.ContractInfo.superclass.constructor.call(this, {
		id: 'contract-info-window',
		width: 520,
		title: '���ۺ�ͬ��Ϣ',
		items: this.contractForm
	});
};

Ext.extend(is.window.ContractInfo, Ext.Window, {
	/*
	 * open contract information window.
	 */
	open: function(id) {
		if (!this.loadMask) {
			this.loadMask = new Ext.LoadMask(this.body, {
				store: this.datastore,
				msg: clsys.form.Util.waitMsg
			});
		}
		this.datastore.load({
			params: { id: id },
			callback: function() {
				var record = this.datastore.getAt(0);
				if (record) {
					clsys.form.Util.updateField('contract-info-code', record.get('code'));
					clsys.form.Util.updateField('contract-info-signdate', record.get('signdate').toLocaleString());
					clsys.form.Util.updateField('contract-info-deliverty-date', record.get('deliverydate').toLocaleString());
					clsys.form.Util.updateField('contract-info-prepayed', record.get('prepayed'));
					clsys.form.Util.updateField('contract-info-payment', record.get('payment'));
					clsys.form.Util.updateField('contract-info-memo', record.get('memo'));
					Ext.getCmp('contract-info-salesman').open(record.get('employee'));
					Ext.getCmp('contract-info-client').open(record.get('client'));
					Ext.getCmp('contract-info-cars-grid').getStore().loadData(record.json);
				}
			},
			scope: this
		});
	}
});

Ext.reg('is-contract-info', is.window.ContractInfo);