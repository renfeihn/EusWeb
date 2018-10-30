Ext.ns('is.window.Client');
is.window.Client = function() {

	this.mode = 'add';	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getClient.action',
		root: 'Client',
		fields: 
			['id', 'code','name','address','tel','zipcode','individual','ContactList']			 
	});

	this.clientForm = new Ext.form.FormPanel({
        frame: false,
        border: false,
        labelAlign: 'right',
        items: [{
            layout:'column',
            frame: false,
            border: false,
            items:[{
                frame: false,
                border: false,
                columnWidth: .5,
                layout: 'form',
                defaultType: 'textfield',
                items: [{
    				xtype: 'hidden',
    				id: 'client_id',
    				width: 150,
    				name: 'id'
    			}, {
    				id: 'client_code',
    				name: 'code',
    				width: 150,
    				allowBlank:false,
    				blankText:"编码不能为空",
    				fieldLabel: '编码'
    			}, {
    				id: 'client_name',
    				name: 'name',
    				width: 150,
    				allowBlank:false,
    				blankText:"姓名不能为空",
    				fieldLabel: '姓名'
    			}, {
    				id: 'client_tel',
    				name: 'tel',
    				width: 150,
    				fieldLabel: '电话'
    			}]
            },{
                frame: false,
                border: false,
                columnWidth: .5,
                layout: 'form',
                defaultType: 'textfield',
                items: [{
    				id: 'client_address',
    				name: 'address',
    				width: 150,
    				fieldLabel: '地址'
    			}, {
    				id: 'client_zipcode',
    				name: 'zipcode',
    				width: 150,
    				fieldLabel: '邮政编码'
    			}, {
        			xtype: 'combo',
        			id: 'client_individual',
        			width: 150,
        			allowBlank:false,
    				blankText:"客户类别不能为空",
                    store: ['私人','公司'],
    				triggerAction: 'all',
    				editable:false,
    				forceSelection: true,
    				emptyText: '选择类别',
    				valueField: 'id',
    				displayField: 'name',
    				hiddenName: 'individual',
    				fieldLabel: '客户类别'   			
        			}]
            }]
        }, {
            xtype: 'grid',
            id: 'client-contact-grid',
            stripeRows: true,
    		autoScroll: true,
    		height: 200,
            store: new Ext.data.JsonStore({
        		root: 'ContactList',
        		fields: ['id', 'code','name','sex','tel','mobile','idnum','client']
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
    		sm: new Ext.grid.RowSelectionModel(),
     		tbar: [{
         		text: '选择联系人',
         		iconCls: 'icon-add',
         		handler: function(button) {
         			var win = Ext.getCmp('contact-selector-window');
         			if (!win) {
             			win = new is.window.ContactSelector();
             			win.on('contactsSelected', this.onSelection, this);
         			}
         			win.show();
     			},
     			scope: this
     		},{
     			text: '删除',
         		iconCls: 'icon-remove',
     			handler: function(button) {
     				var grid = Ext.getCmp('client-contact-grid');
     				grid.getStore().remove(grid.getSelectionModel().getSelections());
     			},
     			scope: this
     		}]
        }]
	});
	
	is.window.Client.superclass.constructor.call(this, {
		title: '客户',
		id: 'newClientWindow',
		buttonAlign: 'center',
		autoHeight: true,
		width:550,
		resizable:false,
		plain:true,
		modal:true,
		autoScroll:true,
		buttons:[{
			text:'确定',
			iconCls: 'icon-commit',
			handler:this.submit,
			scope:this
		},{
			text:'重置',
			handler:this.reset,
			scope:this
		},{
			text: '取消',
			iconCls: 'icon-remove',
			handler: this.hide.createDelegate(this, []),
			scope:this
		}],
		items: [this.clientForm]
	});
};

Ext.extend(is.window.Client, Ext.Window, {
	onSelection: function(attr) {
		var grid = Ext.getCmp('client-contact-grid');
		var store = grid.getStore();

		var contacts = []; 
		for (var i = 0; i < attr.records.length; i++) {
			if (store.find('id', attr.records[i].id) == -1) {
				contacts.push(attr.records[i]);
			}
		} 
		store.add(contacts);
	},

	fillClient: function(data) {
		var store = Ext.getCmp('client-contact-grid').getStore();
		store.loadData(data);
    },
	open: function(id) {
    	this.mode = 'update';
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('client_id').setValue(record.get('id'));
					Ext.getCmp('client_code').setValue(record.get('code'));
					Ext.getCmp('client_name').setValue(record.get('name'));
					Ext.getCmp('client_tel').setValue(record.get('tel'));
					Ext.getCmp('client_address').setValue(record.get('address'));
					Ext.getCmp('client_zipcode').setValue(record.get('zipcode'));
					Ext.getCmp('client_individual').setValue(record.get('individual'));
					//clsys.form.Util.updateCombo('client_contact', record.get('contact'));
					this.fillClient(record.json);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
//		alert(Ext.getCmp('client-find-type').getXType());

		var store = Ext.getCmp('client-contact-grid').getStore();
		var count = store.getCount();
/*		if (count == 0) {
			clsys.message.info('请选择联系人.');
			return;
		}*/
		var contacts = [];
		for (var i = 0; i < count; i++) {
			contacts.push(store.getAt(i).get('id'));
		}
		
		this.clientForm.getForm().submit({
			clientValidation: true,
			url: this.mode == 'add'? 'addClient.action' : 'updateClient.action',
			params: {
				contacts: contacts
			},
			success:function(form, action) {
				this.hide();
				var grid = Ext.getCmp('client-clients-grid');
				if (grid) {
					grid.getStore().reload();
				}
			},
			failure:function(form, action) {
				if (!form.isValid()) {
					clsys.message.info('数据不完整.');
				} else {
					clsys.message.error(action.result.msg);
				}
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	reset: function() {
		this.clientForm.getForm().reset();

	}
});

Ext.reg('window-client', is.window.Client);
