
Ext.ns('clsys.window.Basic');

clsys.window.Basic = function() {
	this.addNew = true;
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getBasic.action',
		//root: 'BasicList',
		fields: 
			['id', 'code','name']			 
	});

	this.store.on('load', function(store, records) {
		Ext.getCmp('basic_code').setValue(records[0].get('code'));
		Ext.getCmp('basic_name').setValue(records[0].get('name'));
	});
	
	this.basicForm = new Ext.form.FormPanel({
		id: 'basicForm',
		//url: 'addBasic.action',
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'basic_type',
				name: 'type'
			},{
				xtype: 'hidden',
				id: 'basic_id',
				name: 'id'
			}, {
				id: 'basic_code',
				name: 'code',
				allowBlank:false,
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			},{
				id: 'basic_name',
				name: 'name',   
				allowBlank:false,
    			blankText:"名称不能为空",
				fieldLabel: '名称'
			}]
	});
	
	clsys.window.Basic.superclass.constructor.call(this, {
		id: 'basic-window',
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
		items: [this.basicForm]
	});
	
	this.addEvents({'basicSaved':true});
};

Ext.extend(clsys.window.Basic, Ext.Window, {	
	open: function(id) {
		var type = Ext.getCmp('basic-find-type').getValue();
		Ext.getCmp('basic_type').setValue(type);
		this.addNew = false,
		this.store.baseParams = { 'id': id, 'type': type };
		this.store.reader.meta.root = type;
		delete this.store.reader.ef;
		this.store.reader.buildExtractors();
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('basic_id').setValue(record.get('id'));
					Ext.getCmp('basic_code').setValue(record.get('code'));
					Ext.getCmp('basic_name').setValue(record.get('name'));
				}
			},
			scope: this
		});
	},
	
	submit: function() {
		this.basicForm.getForm().submit({
			url: this.addNew ? 'addBasic.action' : 'updateBasic.action',
			success:function(form, action) {
				this.fireEvent('basicSaved', {});
				this.destroy();
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
		this.basicForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('clsys-basic-window', clsys.window.Basic);