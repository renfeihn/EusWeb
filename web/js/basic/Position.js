
Ext.ns('is.window.Position');

is.window.Position = function() {
	this.mode = 'add';
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getPosition.action',
		root: 'Position',
		fields:['id', 'code','name',
				{name:'department', mapping:'department.name'},
				{name:'level', mapping:'level.name'}]			 
	});
	
	this.positionForm = new Ext.form.FormPanel({
		border:false,
		frame: false,
		labelAlign: 'right',
		defaultType: 'textfield',
		items:[{
				xtype: 'hidden',
				id: 'position_id',
				name: 'id'
			}, {
				id: 'position_code',
				name: 'code',
				allowBlank:false,
				vtype: 'alphanum',
				vtypeText: '编码只能是数字或字母！',
    			blankText:"编码不能为空",
				fieldLabel: '编码'
			}, {
				id: 'position_name',
				name: 'name',
				allowBlank:false,
    			blankText:"名称不能为空",
				fieldLabel: '名称'
			},{
    			xtype: 'combo',
    			id: 'model_department',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'departmentId',
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
				emptyText: '选择部门',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'department',
				fieldLabel: '部门'
    			
    		}, {
    			xtype: 'combo',
    			id: 'model_level',
				width: 140,
                store:  new Ext.data.JsonStore({
                    idProperty: 'levelId',
                    url: 'findBasic.action',
                    root: 'LevelList',
                    baseParams: {
						type: 'Level', states : ['Using']
                    },
            		fields:['id', 'code', 'name']
                }),
				triggerAction: 'all',
				editable:false,
				forceSelection: true,
				emptyText: '选择级别',
				valueField: 'id',
				displayField: 'name',
				hiddenName: 'level',
				fieldLabel: '级别'
    		}]
	});
	
	is.window.Position.superclass.constructor.call(this, {
		id: 'position-window',
		title: '新增职位',
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
		items: [this.positionForm]
	});
	
	this.addEvents({'positionSaved':true});
};

Ext.extend(is.window.Position, Ext.Window, {	
	open: function(id) {
		this.mode = 'update';
		this.title = '更新职位';
		this.store.load({
			params: {id: id},
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('position_id').setValue(record.get('id'));
					Ext.getCmp('position_code').setValue(record.get('code'));
					Ext.getCmp('position_name').setValue(record.get('name'));
					clsys.form.Util.updateCombo('model_department', record.json.department.id);
					clsys.form.Util.updateCombo('model_level', record.json.level.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
		this.positionForm.getForm().submit({
			url: this.mode == 'add' ? 'addPosition.action' : 'updatePosition.action',
			success:function(form, action) {
				this.fireEvent('positionSaved', {});
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
		this.positionForm.getForm().reset();
	}
});

Ext.reg('is-position-window', is.window.Position);
