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
				vtypeText: '编码只能是数值或字母！',
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'category_name',
				name: 'name',
				allowBlank:false,
    			blankText:"名称不能为空",
				fieldLabel: '名称'
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
				emptyText: '选择供应商',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'supplier',
				fieldLabel: '供应商'   			
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
		this.categoryForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-category', is.window.Category);
