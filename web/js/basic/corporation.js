Ext.ns('is.window.Corporation');

is.window.Corporation = function() {
	this.addNew = true;
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getCorporation.action',
		root: 'Corporation',
		fields: ['id', 'code','name','factory','tel','shortname','address','manager','mobil']			 
	});
	
	this.corporationForm = new Ext.form.FormPanel({

		frame:true,
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'corporation_id',
				name: 'id'
			}, {
				id: 'corporation_code',
				name: 'code',
				vtype: 'alphanum',
				vtypeText: '编码只能是数值或字母！',
				allowBlank:false,
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'corporation_name',
				name: 'name',
				allowBlank:false,
				regex : /[\u4e00-\u9fa5]/,
                regexText:"只能输入中文！",
    			blankText:"名称不能为空",
				fieldLabel: '名称'
			}, {
				id: 'corporation_factory',
				name: 'factory',
				allowBlank:false,
    			blankText:"厂商不能为空",
				fieldLabel: '厂商'
			}, {
				id: 'corporation_shortname',
				name: 'shortname',
				fieldLabel: '简称'
			}, {
				id: 'corporation_address',
				name: 'address',
				fieldLabel: '地址'
			}, {
				id: 'corporation_tel',
				name: 'tel',
				regex : /^(\(\d{3,4}\)|\d{3,4}-)?\d{7,8}$/,
                regexText:"正确格式为：XXX-XXXXXXXX",
				fieldLabel: '电话'
			}, {
				id: 'corporation_manager',
				name: 'manager',
				regex : /[\u4e00-\u9fa5]/,
                regexText:"只能输入中文！",
				fieldLabel: '主管'
			}, {
				id: 'corporation_mobil',
				name: 'mobil',
				regex : /^\d{8,16}$/,
                regexText:"移动电话最少8位最多16位！",
				fieldLabel: '移动电话'
			}]
	});
	
	is.window.Corporation.superclass.constructor.call(this, {
		id: 'newCorporationWindow',
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
		items: [this.corporationForm]
	});
};

Ext.extend(is.window.Corporation, Ext.Window, {	
	open: function(id) {
		this.addNew = false,
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('corporation_id').setValue(record.get('id'));
					Ext.getCmp('corporation_code').setValue(record.get('code'));
					Ext.getCmp('corporation_name').setValue(record.get('name'));
					Ext.getCmp('corporation_tel').setValue(record.get('tel'));
					Ext.getCmp('corporation_factory').setValue(record.get('factory'));
					Ext.getCmp('corporation_shortname').setValue(record.get('shortname'));
					Ext.getCmp('corporation_address').setValue(record.get('address'));
					Ext.getCmp('corporation_manager').setValue(record.get('manager'));
					Ext.getCmp('corporation_mobil').setValue(record.get('mobil'));
				}
			},
			scope: this
		});
	},
	
	submit: function() {
//		alert(Ext.getCmp('corporation-find-type').getXType());
		
		this.corporationForm.getForm().submit({
			url: this.addNew ? 'addCorporation.action' : 'updateCorporation.action',
			success:function(form, action) {
				this.hide();
				var grid = Ext.getCmp('corporationGrid');
				if (grid) {
					grid.getStore().reload();
				}
			},
			failure:function(form, action)  {
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
		this.corporationForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-corporation', is.window.Corporation);