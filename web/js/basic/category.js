Ext.ns('is.window.Category');

is.window.Category = function() {
	this.addNew = true;
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getCategory.action',
		root: 'Category',
		fields: 
			['id', 'code','name',{name:'supplier', mapping:'supplier.name'}]			 
	});
	
	this.categoryForm = new Ext.form.FormPanel({

		frame:true,
		id:'categoryForm',
		labelAlign: 'right',
		defaultType: 'textfield',
/*	   	keys:{ 
	         key:Ext.EventObject.ENTER, 
             fn:sub 
    			},   */       
		items:[{
				xtype: 'hidden',
				id: 'category_id',
				name: 'id'
			}, {
				id: 'category_code',
				name: 'code',
				allowBlank:false,
				vtype: 'alphanum',
				vtypeText: '����ֻ������ֵ����ĸ��',
    			blankText:"���벻��Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'category_name',
				name: 'name',
				allowBlank:false,
    			blankText:"���Ʋ���Ϊ��",
				fieldLabel: '����'
			}, {
    			xtype: 'combo',
    			id: 'category_supplier',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'supplierId',
                    url: 'findBasic.action',
                    root: 'SupplierList',
                    baseParams: {
						type: 'Supplier',states : ['Using'], status: ['Using']
				  },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ��Ӧ��',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'supplier',
				fieldLabel: '��Ӧ��'   			
    		}]
	});
	
	is.window.Category.superclass.constructor.call(this, {
		id: 'newCategoryWindow',
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
		items: [this.categoryForm]
	});
};

Ext.extend(is.window.Category, Ext.Window, {	
	open: function(id) {
		this.addNew = false,
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('category_id').setValue(record.get('id'));
					Ext.getCmp('category_code').setValue(record.get('code'));
					Ext.getCmp('category_name').setValue(record.get('name'));
					clsys.form.Util.updateCombo('category_supplier', record.json.supplier.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
//		alert(Ext.getCmp('category-find-type').getXType());
		
		this.categoryForm.getForm().submit({
			url: this.addNew ? 'addCategory.action' : 'updateCategory.action',
			success:function(form, action) {
				this.destroy();
				var grid = Ext.getCmp('categoryGrid');
				if (grid) {
					grid.getStore().reload();
				}
			},
			failure:function(form, action) {
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
		this.categoryForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-category', is.window.Category);
