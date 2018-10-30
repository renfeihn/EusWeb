
Ext.ns('is.form.SalesDataview');

is.form.SalesDataview = function(config) {
	/*
	 * sales store.
	 */
	this.salesStore = new Ext.data.JsonStore({
		url: 'getSales.action',
		root: 'Sales',
		baseParams: {
			status: ['Using']
		},
		fields: ['id','code','name', 'memo',
			{name:'signdate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'deliverydate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'state', type:'int'}, 
			{name:'prepayed', type:'float'},
			{name:'employee', mapping:'employee.name'},
			{name:'payment', mapping:'payment.name'},
			{name:'client', mapping:'client.name'},
			'cars']
	});
	
	/*
	 * dataview store.
	 */
	this.dataviewStore = new Ext.data.JsonStore({
		fields: ['id', 'code', 'contract', 'car',
		         {name:'carid', mapping:'car.id'},
		         {name:'contractid', mapping:'contract.id'},
		         {name:'contractCode', mapping:'contract.code'},
		         {name:'clientname', mapping:'contract.client.name'},
		         {name:'clientid', mapping:'contract.client.id'},
		         {name:'carframe', mapping:'car.car.frame'}
		],
		root: 'Sales',
		data: {
			Sales: [{
				id:'', code: '选择销售单', car: {id:'', car:{frame:''}}, contract: {id:'',code:'', client: {id:'', name:''}}
			}]
		}
	});
	
	this.salesTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="sales-info">',
		'<p><a href="#" onclick="dataviewOpenSalesSelector(\'' + config.id + '\','+ '\'' + config.states + '\');">{code} {client} {payment}</a></p>',
		'<tpl if="contractCode != \'\'"><p>合同编号:<a href="#" onclick="dataviewOpenContractInfo(\'{contractid}\');">{contractCode}</a></p></tpl>',
		'<tpl if="carframe != \'\'"><p>车辆车架号:<a href="#" onclick="dateviewOpenCarInfo(\'{car}\');">{carframe}</a></p></tpl>',
		'<tpl if="clientid != \'\'"><p>客户:<a href="#" onclick="dataviewOpenClientInfo(\'{clientid}\');">{clientname}</a></p></tpl>',
		'</div>',
		'</tpl>'
	);
	
	is.form.SalesDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.salesTpl,
		itemSelector: 'div.sales-info'		
	});

	this.addEvents({'salesChanged':true});
};

Ext.extend(is.form.SalesDataview, Ext.DataView, {	
	/*
	 * open sales dataview.
	 */
	open: function(id) {
		this.salesStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData({
						Sales: [records[0].json]
					});
				}
			},
			scope: this
		});
	},
	/*
	 * convert value to empty string.
	 */
	nonEmptyName: function(value) {
		return value? value.name: '';
	},
	/*
	 * on sales selected.
	 */
	onSalesSelected: function(attr) {
		this.dataviewStore.loadData({
			Sales: [{
				id: attr.record.get('id'),
				code: attr.record.get('code'),
				contract: attr.record.get('contract'),
				car: attr.record.get('car')
			}]
		});
		this.clientId = attr.record.get('contract').client.id;
		this.fireEvent('salesChanged', this.clientId);
	},
	/*
	 * get client id.
	 */
	getClientId: function() {
		return this.clientId;
	},
	/*
	 * get sales id.
	 */
	getSalesId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-sales-dataview', is.form.SalesDataview);