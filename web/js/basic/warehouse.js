Ext.ns('is.window.Warehouse');

is.window.Warehouse = function() {
	this.addNew = true;
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getWarehouse.action',
		root: 'Warehouse',
		fields: 
			['id', 'code','name','capcity']			 
	});
	
	this.warehouseForm = new Ext.form.FormPanel({

		frame:true,
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'warehouse_id',
				name: 'id'
			}, {
				id: 'warehouse_code',
				name: 'code',
				vtype: 'alphanum',
				vtypeText: '编码只能是数字或字母！',
				allowBlank:false,
				blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'warehouse_name',
				name: 'name',
				allowBlank:false,
				blankText:"名称不能为空",
				fieldLabel: '名称'
			},{
				id: 'warehouse_capcity',
				name: 'capcity',
				regex : /^[0-9]*$/,
                regexText:"库容只能是数字！", 
				fieldLabel: '库容'
			} ]
	});
	
	is.window.Warehouse.superclass.constructor.call(this, {
		id: 'newWarehouseWindow',
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
			handler: this.hide.createDelegate(this, []),
			scope:this
		}],
		items: [this.warehouseForm]
	});
};

Ext.extend(is.window.Warehouse, Ext.Window, {	
	open: function(id) {
		this.addNew = false,
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('warehouse_id').setValue(record.get('id'));
					Ext.getCmp('warehouse_code').setValue(record.get('code'));
					Ext.getCmp('warehouse_name').setValue(record.get('name'));
					Ext.getCmp('warehouse_capcity').setValue(record.get('capcity'));
				}
			},
			scope: this
		});
	},
	
	submit: function() {
//		alert(Ext.getCmp('warehouse-find-type').getXType());
		
		this.warehouseForm.getForm().submit({
			url: this.addNew ? 'addWarehouse.action' : 'updateWarehouse.action',
			success:function(form, action) {
				this.hide();
				var grid = Ext.getCmp('warehouseGrid');
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
		this.warehouseForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-warehouse', is.window.Warehouse);
