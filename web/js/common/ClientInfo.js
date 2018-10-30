
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
					fieldLabel: '编码',
					id: 'client-info-code'
				}, {
					fieldLabel: '名称',
					id: 'client-info-name'
				}, {
					fieldLabel: '电话',
					id: 'client-info-tel'
				}, {
					fieldLabel: '性别',
					id: 'client-info-sex'
				}]
			}, {
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '地址',
					id: 'client-info-address'
				}, {
					fieldLabel: '邮政编码',
					id: 'client-info-zipcode'
				}, {
					fieldLabel: '类别',
					id: 'client-info-individual'
				}, {
					fieldLabel: '证件号码',
					id: 'client-info-idnum'
				}]
			}]
		}, {
			xtype: 'grid',
			id: 'client-info-contacts',
			autoScroll: true,
			height: 200,
			tbar: [ '联系人列表' ],
			store: new Ext.data.JsonStore({
				root: 'contacts',
				fields: ['id', 'code','name', 'sex','tel','mobile','idnum']
			}),
    		colModel: new Ext.grid.ColumnModel({
    			defaults: {
    				sortable: true
    			},	        
     	        columns: [
        		  {header: '编号', dataIndex: 'id'},
 	 	          {header: '编码', dataIndex: 'code'},
 	 	          {header: '姓名', dataIndex: 'name'},
 	 	          {header: '性别', dataIndex: 'sex'},
 	 	          {header: '电话', dataIndex: 'tel'},
 	 	          {header: '移动电话', dataIndex: 'mobile'},
 	 	          {header: '证件号码', dataIndex: 'idnum'}
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
		title: '客户信息',
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