
Ext.ns('is.form.ContactDataview');

is.form.ContactDataview = function(config) {	
	/*
	 * dataview store.
	 */
	this.dataviewStore = new Ext.data.JsonStore({
		fields: ['id', 'code','name', 'sex', 'tel', 'mobile', 'idnum'],
		root: 'Contact',
		data: {
			Contact: [{
				id:'', name:'选择联系人', code: '', idnum: '', sex:'', tel:'', mobile:''
			}]
		}
	});
	
	this.contactTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="contact-info">',
		config.readOnly ? '<p><a href="#" onclick="dataviewOpenContactInfo(\'{id}\');">{code} {name}</a></p>' 
				: '<p><a href="#" onclick="dataviewOpenContactSelector(\'' + config.id + '\');">{code} {name}</a></p>',
		'<tpl if="tel != \'\'"><p><span>电话:{tel}</span></p></tpl>',
		'<tpl if="mobile != \'\'"><p><span>手机:{mobile}</span></p></tpl>',
		'<tpl if="idnum != \'\'"><p><span>证件号码:{idnum}</span></p></tpl>',
		'</div>',
		'</tpl>'
	);
	
	this.addEvents({'contactSelected':true});
	
	is.form.ContactDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.contactTpl,
		itemSelector: 'div.contact-info'		
	});
};

Ext.extend(is.form.ContactDataview, Ext.DataView, {
	/*
	 * get client id.
	 */
	getClientId: function() {
		return this.clientId;
	},
	/*
	 * set client id.
	 */
	setClientId: function(id) {
		this.clientId = id;
	},
	/*
	 * convert value to empty string.
	 */
	nonEmptyName: function(value) {
		return value? value.name: '';
	},
	/*
	 * on contact selected.
	 */
	onContactSelected: function(attr) {
		this.dataviewStore.loadData(attr);
	},
	/*
	 * get contact id.
	 */
	getContactId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-contact-dataview', is.form.ContactDataview);