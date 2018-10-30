
Ext.ns('is.form.ClientDataview');

is.form.ClientDataview = function(config) {
	/*
	 * client store.
	 */
	this.clientStore = new Ext.data.JsonStore({
		url: 'getClient.action',
		root: 'Client',
		fields: ['id', 'name', 'code', 'individual']
	});
	
	/*
	 * dataview store.
	 */
	this.dataviewStore = new Ext.data.JsonStore({
		fields: ['id', 'code','name', 'individual'],
		root: 'Client',
		data: {
			Client: [{
				id:'', name:'选择客户', code: '', individual: ''
			}]
		}
	});
	
	this.clientTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="client-info">',
		config.readOnly ? '<p><a href="#" onclick="dataviewOpenClientInfo(\'{id}\');">{code} {name}</a></p>' 
				: '<p><a href="#" onclick="dataviewOpenClientSelector(\'' + config.id + '\');">{code} {name}</a></p>',
		'</div>',
		'</tpl>'
	);
	
	this.addEvents({'clientSelected':true});
	
	is.form.ClientDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.clientTpl,
		itemSelector: 'div.client-info'		
	});
};

Ext.extend(is.form.ClientDataview, Ext.DataView, {	
	/*
	 * open client dataview.
	 */
	open: function(id) {
		if (!this.loadMask) {
			this.loadMask = new Ext.LoadMask(this.el, {
				store: this.clientStore,
				msg: '正在加载...'
			});
		}
		this.clientStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData({
						Client: [records[0].json]
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
	 * on client selected.
	 */
	onClientSelected: function(attr) {
		this.dataviewStore.loadData(attr.client);
	},
	/*
	 * get client id.
	 */
	getClientId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-client-dataview', is.form.ClientDataview);