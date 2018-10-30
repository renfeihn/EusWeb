/*----------------------------------------------
 * Employee add/update window.
 */

Ext.ns('is.window.Employee');

is.window.Employee = function() {
	this.mode = 'add';
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getEmployee.action',
		root: 'Employee',
		fields: 
			['id', 'code','name','sex','tel', {name:'birthday', type:'date'},
			 {name:'position', mapping:'position.name'}]			 
	});
	
	this.employeeForm = new Ext.form.FormPanel({
		frame:false,
		border:false,
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'employee_id',
				name: 'id'
			}, {
				id: 'employee_code',
				name: 'code',
				vtype: 'alphanum',
				vtypeText: '����ֻ�������ֻ���ĸ��',
				allowBlank:false,
    			blankText:"���벻��Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'employee_name',
				name: 'name',
				allowBlank:false,
    			blankText:"��������Ϊ��",
				fieldLabel: '����'
			}, {
				id: 'employee_tel',
				name: 'tel',
				fieldLabel: '�绰'
			}, {
    			xtype: 'combo',
    			id: 'employee_sex',
				width: 140,
				allowBlank:false,
    			blankText:"�Ա���Ϊ��",
                store: ['��','Ů'],
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ���Ա�',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'sex',
				fieldLabel: '�Ա�'   			
    		}, {
				xtype: 'datefield',
				width: 140,
				id: 'employee_birthday',
				name: 'birthday',
				fieldLabel: '��������'
			}, {
    			xtype: 'combo',
    			id: 'employee_position',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'id',
                    url: 'findPosition.action',
                    root: 'PositionList',
                    baseParams: {
						states : ['Using'], status: ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: 'ѡ��ְ��',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'position',
				fieldLabel: 'ְ��'   			
    		}]
	});
	
	is.window.Employee.superclass.constructor.call(this, {
		id: 'employee-window',
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
		items: [this.employeeForm]
	});
};

Ext.extend(is.window.Employee, Ext.Window, {	
	open: function(id) {
		this.mode = 'update',
		this.store.baseParams = { 'id': id };
		this.store.load({
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('employee_id').setValue(record.get('id'));
					Ext.getCmp('employee_code').setValue(record.get('code'));
					Ext.getCmp('employee_name').setValue(record.get('name'));
					Ext.getCmp('employee_tel').setValue(record.get('tel'));
					Ext.getCmp('employee_birthday').setValue(record.get('birthday'));
					Ext.getCmp('employee_sex').setValue(record.get('sex'));
					clsys.form.Util.updateCombo('employee_position', record.json.position.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
		this.employeeForm.getForm().submit({
			url: this.mode == 'add' ? 'addEmployee.action' : 'updateEmployee.action',
			params: {
				birthday: Ext.getCmp('employee_birthday').getValue()
			},
			success:function(form, action) {
				this.destroy();
				var grid = Ext.getCmp('employeeGrid');
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
		this.employeeForm.getForm().reset();
	}
});

Ext.reg('is-employee-window', is.window.Employee);
