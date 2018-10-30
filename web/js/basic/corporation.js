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
				vtypeText: '����ֻ������ֵ����ĸ��',
				allowBlank:false,
    			blankText:"���벻��Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'corporation_name',
				name: 'name',
				allowBlank:false,
				regex : /[\u4e00-\u9fa5]/,
                regexText:"ֻ���������ģ�",
    			blankText:"���Ʋ���Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'corporation_factory',
				name: 'factory',
				allowBlank:false,
    			blankText:"���̲���Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'corporation_shortname',
				name: 'shortname',
				fieldLabel: '���'
			}, {
				id: 'corporation_address',
				name: 'address',
				fieldLabel: '��ַ'
			}, {
				id: 'corporation_tel',
				name: 'tel',
				regex : /^(\(\d{3,4}\)|\d{3,4}-)?\d{7,8}$/,
                regexText:"��ȷ��ʽΪ��XXX-XXXXXXXX",
				fieldLabel: '�绰'
			}, {
				id: 'corporation_manager',
				name: 'manager',
				regex : /[\u4e00-\u9fa5]/,
                regexText:"ֻ���������ģ�",
				fieldLabel: '����'
			}, {
				id: 'corporation_mobil',
				name: 'mobil',
				regex : /^\d{8,16}$/,
                regexText:"�ƶ��绰����8λ���16λ��",
				fieldLabel: '�ƶ��绰'
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
		this.corporationForm.getForm().reset();
		this.addNew = true;
	}
});

Ext.reg('window-corporation', is.window.Corporation);