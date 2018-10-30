
Ext.ns('is.form.ContractCarDataview');


is.form.ContractCarDataview = function(config) {
	/*
	 * dataview store.
	 */
	this.dataviewStore = new Ext.data.JsonStore({
		root: 'Car',
		fields: ['id', 
		         {name:'model', mapping:'model.name'},
		         {name:'suite', mapping:'suite.name'},
		         {name:'color', mapping:'color.name'}, 
		         {name:'decoration', mapping:'decoration.name'},
		         {name:'frame', mapping:'car.frame'}, 
		         {name:'certificate', mapping:'car.certificate'}, 
		         {name:'productDate', mapping:'car.productDate', type:'date', dateFormat:'Y-m-d'}],
		data: {
			Car: [{
				id:'', model: {name:'选择合同中的车辆'}, color: {name:''}, suite: {name:''},
				decoration: {name:''}, car: {
					frame: '', certificate: '', productDate: ''
				}
			}]
		}
	});
	
	this.carTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="car-info">',
		'<p><a href="#" onclick="dataviewOpenContractCarSelector(\'' + config.id + '\');">{model} {suite} {color} {decoration} </a></p>',
		'<p>',
		'<tpl if="frame != \'\'"><span>车架号:{frame}</span></tpl>',
		'<tpl if="certificate != \'\'"><span>合格证:{certificate}</span></tpl>',
		'</p>',
		'</div>',
		'</tpl>'
	);
	
	this.addEvents({'carSelected':true});
	
	is.form.ContractCarDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.carTpl,
		itemSelector: 'div.car-info'		
	});
};

Ext.extend(is.form.ContractCarDataview, Ext.DataView, {
	/*
	 * get contract id.
	 */
	getContractId: function() {
		return this.contractId;
	},
	/*
	 * get contract store.
	 */
	getContractStore: function() {
		return this.contractStore;
	},
	/*
	 * set contract id.
	 */
	setContractId: function(id) {
		this.contractId = id;
	},
	/*
	 * open car dataview.
	 */
	open: function(id) {
		this.carStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData({
						Car: [records[0].json]
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
	 * on car selected.
	 */
	onCarSelected: function(attr) {
		this.dataviewStore.loadData(attr);
	},
	/*
	 * get car id.
	 */
	getCarId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-car-dataview', is.form.ContractCarDataview);