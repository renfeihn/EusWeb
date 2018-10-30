Ext.ns('is.window.Model');

is.window.Model = function() {
	this.addNew = true;
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getModel.action',
		root: 'Model',
		fields: 
			['id', 'code','name','manufacturer',
			 {name:'type', mapping:'type.name'},
			 {name:'category', mapping:'category.name'}]			 
	});
	
	this.modelForm = new Ext.form.FormPanel({

		frame:true,
		//id: 'modelForm',
		//url: 'addModel.action',
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'model_type',
				name: 'type'
			},{
				xtype: 'hidden',
				id: 'model_id',
				name: 'id'
			}, {
				id: 'model_code',
				name: 'code',
				vtype: 'alphanum',
				vtypeText: '����ֻ�������ֻ���ĸ��',
				allowBlank:false,
				blankText:"���벻��Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'model_name',
				name: 'name',
				allowBlank:false,
				blankText:"���Ʋ���Ϊ��",
				fieldLabel: '����'
			}, {
    			xtype: 'combo',
    			id: 'model_category',
				width: 140,
				allowBlank:false,
				blankText:"Ʒ�Ʋ���Ϊ��",
                store:  new Ext.data.JsonStore({
                    idProperty: 'id',
                    url: 'findCategory.action',
                    root: 'CategoryList',
                    baseParams: {
						states : ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ��Ʒ��',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'category',
				fieldLabel: 'Ʒ��'
    			
    		}, {
    			xtype: 'combo',
    			id: 'model_types',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'typeId',
                    url: 'findBasic.action',
                    root: 'TypeList',
                    baseParams: {
						type: 'Type', states : ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ�����',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'types',
				fieldLabel: '���'
    			
    		}, {
    			xtype: 'combo',
    			id: 'model_manufacturer',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'manufacturerId',
                    url: 'findBasic.action',
                    root: 'ManufacturerList',
                    baseParams: {
						type: 'Manufacturer', states : ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ��������',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'manufacturer',
				fieldLabel: '������'
    			
    		}]
	});
	
	is.window.Model.superclass.constructor.call(this, {
		id: 'newModelWindow',
		buttonAlign: 'center',
		autoHeight: true,
		width:350,
		resizable:false,
		plain:true,
		modal:true,
		autoScroll:true,
		buttons:[{
			text:'ȷ��',
			iconCls: 'icon-commit',
			handler:this.submit,
			scope:this
		},{
			text:'����',
			handler:this.reset,
			scope:this
		},{
			text: 'ȡ��',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope:this
		}],
		items: [this.modelForm]
	});
};

Ext.extend(is.window.Model, Ext.Window, {	
	open: function(id) {
		this.addNew = false,
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('model_id').setValue(record.get('id'));
					Ext.getCmp('model_code').setValue(record.get('code'));
					Ext.getCmp('model_name').setValue(record.get('name'));
					clsys.form.Util.updateCombo('model_category', record.json.category.id);
					//clsys.form.Util.updateCombo('model_manufacturer', record.manufacturer.id);
					clsys.form.Util.updateCombo('model_types', record.json.type.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
//		alert(Ext.getCmp('model-find-type').getXType());
		
		this.modelForm.getForm().submit({
			url: this.addNew ? 'addModel.action' : 'updateModel.action',
			success:function(form, action) {
				this.destroy();
				var grid = Ext.getCmp('modelGrid');
				if (grid) {
					grid.getStore().reload();
				}
			},
			failure:function(form, action){
				if (!form.isValid()) {
					clsys.message.info('���ݲ�����.');
				} else {
					clsys.message.error(action.result.msg);
				}
			},
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	reset: function() {
		this.modelForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-model', is.window.Model);