
Ext.ns('is.window.ClientInfo');

is.window.ClientInfo = function() {
	this.datastore = new Ext.data.JsonStore({
		url: 'getClient.action',
		root: 'Client',
		fields: ['id', 'code','name','address','tel', 'zipcode',
	         {name:'individual',type:'int'},
	         'contacts',{name:'state',type:'int'}]
	});
	
	this.clientForm = new Ext.form.FormPanel({
		id: 'client-infor-form',
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
					id: 'client-info-code'
				}, {
					fieldLabel: '����',
					id: 'client-info-name'
				}, {
					fieldLabel: '�绰',
					id: 'client-info-tel'
				}, {
					fieldLabel: '�Ա�',
					id: 'client-info-sex'
				}]
			}, {
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '��ַ',
					id: 'client-info-address'
				}, {
					fieldLabel: '��������',
					id: 'client-info-zipcode'
				}, {
					fieldLabel: '���',
					id: 'client-info-individual'
				}, {
					fieldLabel: '֤������',
					id: 'client-info-idnum'
				}]
			}]
		}, {
			xtype: 'grid',
			id: 'client-info-contacts',
			autoScroll: true,
			height: 200,
			tbar: [ '��ϵ���б�' ],
			store: new Ext.data.JsonStore({
				root: 'contacts',
				fields: ['id', 'code','name', 'sex','tel','mobile','idnum']
			}),
    		colModel: new Ext.grid.ColumnModel({
    			defaults: {
    				sortable: true
    			},	        
     	        columns: [
        		  {header: '���', dataIndex: 'id'},
 	 	          {header: '����', dataIndex: 'code'},
 	 	          {header: '����', dataIndex: 'name'},
 	 	          {header: '�Ա�', dataIndex: 'sex'},
 	 	          {header: '�绰', dataIndex: 'tel'},
 	 	          {header: '�ƶ��绰', dataIndex: 'mobile'},
 	 	          {header: '֤������', dataIndex: 'idnum'}
      	 	    ]
    		}),
     		viewConfig: {
     			forceFit: true
    		},    
     		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		}]
	});
	
	is.window.ClientInfo.superclass.constructor.call(this, {
		id: 'client-info-window',
		width: 480,
		title: '�ͻ���Ϣ',
		items: this.clientForm
	});
};

Ext.extend(is.window.ClientInfo, Ext.Window, {
	/*
	 * open client information window.
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
					clsys.form.Util.updateField('client-info-code', record.get('code'));
					clsys.form.Util.updateField('client-info-sex', record.get('sex'));
					clsys.form.Util.updateField('client-info-name', record.get('name'));
					clsys.form.Util.updateField('client-info-tel', record.get('tel'));
					clsys.form.Util.updateField('client-info-address', record.get('address'));
					clsys.form.Util.updateField('client-info-zipcode', record.get('zipcode'));
					clsys.form.Util.updateField('client-info-individual', record.get('individual'));
					clsys.form.Util.updateField('client-info-idnum', record.get('idnum'));
					Ext.getCmp('client-info-contacts').getStore().loadData(record.json);
				}
			},
			scope: this
		});
	}
});

Ext.reg('is-client-info-window', is.window.ClientInfo);