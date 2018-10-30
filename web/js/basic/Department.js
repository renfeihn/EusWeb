
Ext.ns('is.window.Department');

is.window.Department = function() {
	this.mode = 'add';
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getDepartment.action',
		root: 'Department',
		fields: 
			['id', 'code','name','startdate','status','enddate',
			 {name:'parent', mapping:'parent.name'},
			 {name:'corporation', mapping:'corporation.name'}]			 
	});
	
	this.departmentForm = new Ext.form.FormPanel({
		border: false,
		frame: false,
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'department_id',
				name: 'id'
			}, {
				id: 'department_code',
				name: 'code',
				vtype: 'alphanum',
				vtypeText: '����ֻ�������ֻ���ĸ��',
				allowBlank:false,
    			blankText:"���벻��Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'department_name',
				name: 'name',
				regex : /[\u4e00-\u9fa5]/,
                regexText:"��������ֻ���������ģ�", 
				allowBlank:false,
    			blankText:"���Ʋ���Ϊ��",
				fieldLabel: '����'
			}, {
    			xtype: 'combo',
    			id: 'department_corporation',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'corporationId',
                    url: 'findCorporation.action',
                    root: 'CorporationList',
                    baseParams: {
						states: ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name','state','status']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ�����',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'corporation',
				fieldLabel: '����'   			
    		}, {
				xtype: 'datefield',
				width: 140,
				id: 'department_startdate',
				fieldLabel: '��������'
			}, {
				xtype: 'datefield',
				width: 140,
				id: 'department_enddate',
				fieldLabel: '��������'
			}, {
    			xtype: 'combo',
    			id: 'department_parent',
				width: 140,
                store:  new Ext.data.JsonStore({
                    url: 'findDepartment.action',
                    root: 'DepartmentList',
                    baseParams: {
						states : ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ���ϼ�����',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'parent',
				fieldLabel: '�ϼ�����'   			
    		}]
	});
	
	is.window.Department.superclass.constructor.call(this, {
		id: 'department-window',
		title: '��������',
		buttonAlign: 'center',
		autoHeight: true,
		width:350,
		resizable:false,
		plain:true,
		//modal:true,
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
		items: [this.departmentForm]
	});
	
	this.addEvents({'departmentSaved':true});
};

Ext.extend(is.window.Department, Ext.Window, {
	open: function(id) {
		this.mode = 'update';
		this.title = '�޸Ĳ���';
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('department_id').setValue(record.get('id'));
					Ext.getCmp('department_code').setValue(record.get('code'));
					Ext.getCmp('department_name').setValue(record.get('name'));
					Ext.getCmp('department_startdate').setValue(record.get('startdate'));
					Ext.getCmp('department_enddate').setValue(record.get('enddate'));
					Ext.getCmp('department_status').setValue(record.get('status'));
					clsys.form.Util.updateCombo('department_corporation', record.json.corporation.id);
					clsys.form.Util.updateCombo('department_parent', record.json.parent.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
		this.departmentForm.getForm().submit({
			url: this.mode == 'add' ? 'addDepartment.action' : 'updateDepartment.action',
			params: {
				startdate: Ext.getCmp('department_startdate').getValue(),
				enddate: Ext.getCmp('department_enddate').getValue()
			},
			success: function(form, action) {
				this.fireEvent('departmentSaved', {});
				this.destroy();
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
		this.departmentForm.getForm().reset();
	}
});

Ext.reg('is-department-window', is.window.Department);
