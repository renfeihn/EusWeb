
Ext.ns('is.window.ContactInfo');

is.window.ContactInfo = function() {
	this.datastore = new Ext.data.JsonStore({
		url: 'getContact.action',
		root: 'Contact',
		fields: ['id', 'code','name', 'sex', 'tel', 'mobile', 'idnum']
	});
	
	this.contactForm = new Ext.form.FormPanel({
		id: 'contact-infor-form',
		width: 450,
		labelAlign: 'right',
		border: false,
		frame: false,
		items: [{
			layout: 'column',
			border: false,
			frame: false,
			items: [{
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '����',
					id: 'contact-info-code'
				}, {
					fieldLabel: '����',
					id: 'contact-info-name'
				}, {
					fieldLabel: '�Ա�',
					id: 'contact-info-sex'
				}]
			}, {
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '�ֻ�',
					id: 'contact-info-mobile'
				}, {
					fieldLabel: '�绰',
					id: 'contact-info-tel'
				}, {
					fieldLabel: '֤������',
					id: 'contact-info-idnum'
				}]
			}]
		}]
	});
	
	is.window.ContactInfo.superclass.constructor.call(this, {
		id: 'contact-info-window',
		width: 480,
		title: '��ϵ����Ϣ',
		items: this.contactForm
	});
};

Ext.extend(is.window.ContactInfo, Ext.Window, {
	/*
	 * open contact information window.
	 */
	open: function(id) {
		this.datastore.load({
			params: { id: id },
			callback: function() {
				var record = this.datastore.getAt(0);
				if (record) {
					clsys.form.Util.updateField('contact-info-code', record.get('code'));
					clsys.form.Util.updateField('contact-info-sex', record.get('sex'));
					clsys.form.Util.updateField('contact-info-name', record.get('name'));
					clsys.form.Util.updateField('contact-info-tel', record.get('tel'));
					clsys.form.Util.updateField('contact-info-mobile', record.get('mobile'));
					clsys.form.Util.updateField('contact-info-idnum', record.get('idnum'));
				}
			},
			scope: this
		});
	}
});

Ext.reg('is-contact-info-window', is.window.ContactInfo);