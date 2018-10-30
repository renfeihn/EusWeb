
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
				vtypeText: '编码只能是数字或字母！',
				allowBlank:false,
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'department_name',
				name: 'name',
				regex : /[\u4e00-\u9fa5]/,
                regexText:"部门名称只能输入中文！", 
				allowBlank:false,
    			blankText:"名称不能为空",
				fieldLabel: '名称'
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
				emptyText: '选择机构',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'corporation',
				fieldLabel: '机构'   			
    		}, {
				xtype: 'datefield',
				width: 140,
				id: 'department_startdate',
				fieldLabel: '创建日期'
			}, {
				xtype: 'datefield',
				width: 140,
				id: 'department_enddate',
				fieldLabel: '撤销日期'
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
				emptyText: '选择上级部门',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'parent',
				fieldLabel: '上级部门'   			
    		}]
	});
	
	is.window.Department.superclass.constructor.call(this, {
		id: 'department-window',
		title: '新增部门',
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
		items: [this.departmentForm]
	});
	
	this.addEvents({'departmentSaved':true});
};

Ext.extend(is.window.Department, Ext.Window, {
	open: function(id) {
		this.mode = 'update';
		this.title = '修改部门';
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
		this.departmentForm.getForm().reset();
	}
});

Ext.reg('is-department-window', is.window.Department);
