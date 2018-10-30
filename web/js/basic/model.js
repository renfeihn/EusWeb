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
				vtypeText: '编码只能是数字或字母！',
				allowBlank:false,
				blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'model_name',
				name: 'name',
				allowBlank:false,
				blankText:"名称不能为空",
				fieldLabel: '名称'
			}, {
    			xtype: 'combo',
    			id: 'model_category',
				width: 140,
				allowBlank:false,
				blankText:"品牌不能为空",
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
				emptyText: '选择品牌',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'category',
				fieldLabel: '品牌'
    			
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
				emptyText: '选择类别',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'types',
				fieldLabel: '类别'
    			
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
				emptyText: '选择制造商',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'manufacturer',
				fieldLabel: '制造商'
    			
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
		this.modelForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-model', is.window.Model);