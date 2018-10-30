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
				vtypeText: '编码只能是数字或字母！',
				allowBlank:false,
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'employee_name',
				name: 'name',
				allowBlank:false,
    			blankText:"姓名不能为空",
				fieldLabel: '姓名'
			}, {
				id: 'employee_tel',
				name: 'tel',
				fieldLabel: '电话'
			}, {
    			xtype: 'combo',
    			id: 'employee_sex',
				width: 140,
				allowBlank:false,
    			blankText:"性别不能为空",
                store: ['男','女'],
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: '选择性别',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'sex',
				fieldLabel: '性别'   			
    		}, {
				xtype: 'datefield',
				width: 140,
				id: 'employee_birthday',
				name: 'birthday',
				fieldLabel: '出生日期'
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
				emptyText: '选择职务',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'position',
				fieldLabel: '职务'   			
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
		this.employeeForm.getForm().reset();
	}
});

Ext.reg('is-employee-window', is.window.Employee);
