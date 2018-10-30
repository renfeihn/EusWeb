
Ext.ns('is.form.ContractDataview');


is.form.ContractDataview = function(config) {
	/*
	 * contract store.
	 */
	this.contractStore = new Ext.data.JsonStore({
		url: 'getContract.action',
		root: 'Contract',
		baseParams: {
			status: ['Using'],
			states: ['Executing']
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
		fields: ['id', 'code', 'cars', {name:'client', mapping:'client.name'},
		     {name:'payment', mapping:'payment.name'}],
		root: 'Contract',
		data: {
			Contract: [{
				id:'', code: 'Ñ¡ÔñºÏÍ¬', cars:{}, client: { name: ''}, payment: {name:''}
			}]
		}
	});
	
	this.contractTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="contract-info">',
		'<p><a href="#" onclick="dataviewOpenContractSelector(\'' + config.id + '\','+ '\'' + config.states + '\');">{code} {client} {payment}</a></p>',
		'</div>',
		'</tpl>'
	);
	
	is.form.ContractDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.contractTpl,
		itemSelector: 'div.contract-info'		
	});

	this.addEvents({'contractSelected':true, 'contractChanged':true});
};

Ext.extend(is.form.ContractDataview, Ext.DataView, {	
	/*
	 * open contract dataview.
	 */
	open: function(id) {
		this.contractStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData({
						Contract: [records[0].json]
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
	 * on contract selected.
	 */
	onContractSelected: function(attr) {
		this.dataviewStore.loadData({
			Contract: [{
				id: attr.record.get('id'),
				code: attr.record.get('code'),
				client: attr.record.get('client'),
				payment: attr.record.get('payment'),
				cars: attr.record.get('cars')
			}]
		});
		this.fireEvent('contractChanged', attr.record.get('id'));
	},
	/*
	 * get contract id.
	 */
	getContractId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-contract-dataview', is.form.ContractDataview);