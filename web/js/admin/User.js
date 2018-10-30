
Ext.ns('is.window.User');

is.window.User = function() {
	this.mode = 'add';

	this.datastore = new Ext.data.JsonStore({
		url: 'getUser.action',
		baseParams: {
			states: ['Using']
		},
		root: 'User',
		fields: ['id', 'code', 'name', 'password', 'secret', 'employee']
	});
	
	this.userRoleRender = function(id) {
		var store = Ext.getCmp('user-role-grid').getStore();
		var name = store.getById(id).get('name');
		return '<span><a href="#" onclick="openRoleInfo(\'' + id + '\');">' + name + '</a></span>';
	};
	
	this.formPanel = new Ext.form.FormPanel({
		frame: false,
		border: false,
		labelAlign: 'right',
		style: 'padding: 1px 1px 1px 1px;',
		items: [{
	    	xtype: 'textfield',
	    	id: 'user-name',
	    	fieldLabel: '登录名',
	    	allowBlank: false,
	    	name: 'name'
		}, {
			xtype: 'textfield',
			fieldLabel: '登录密码',
			id: 'user-password',
			allowBlank: false,
			inputType: 'password',
			name: 'password'
		}, {
			xtype: 'textfield',
			fieldLabel: '登录密码确认',
			id: 'user-password-confirm',
			name: 'unused_password_confirm',
			allowBlank: false,
			inputType: 'password'
		}, {
			xtype: 'textfield',
			id: 'user-secret',
			fieldLabel: '电子密钥',
			inputType: 'password',
			allowBlank: false,
			name: 'secret'
		}, {
			xtype: 'textfield',
			fieldLabel: '电子密钥确认',
			id: 'user-secret-confirm',
			name: 'unused_secret_confirm',
			allowBlank: false,
			inputType: 'password'
		}, {
			xtyep: 'hidden',
			id: 'user-employee',
			name: 'employee'
		}, {
			xtype: 'is-employee-dataview',
			id: 'user-employee-dataview',
			fieldLabel: '员工'
		}, {
			xtype: 'grid',
			id: 'user-role-grid',
			height: 100,
			store: new Ext.data.JsonStore({
				root: 'roles',
				fields: ['id', 'code', 'name']
			}),
			cm: new Ext.grid.ColumnModel({
				columns: [
			          {header: '编码 ', dataIndex: 'code'},
			          {header: '名称', renderer: this.userRoleRender, dataIndex: 'id'}
				]
			}),
     		viewConfig: {
     			forceFit: true
    		},
			sm: new Ext.grid.RowSelectionModel(),
			stripeRows: true,
			tbar: [{
				text: '增加角色',
				iconCls: 'icon-add',
				handler: function(button) {
					var win = Ext.getCmp('role-selector-window');
					if (!win) {
						win = new is.window.RoleSelector();
						win.on('rolesSelected', this.onRolesSelected, this);
					}
					win.show();
				},
				scope: this
			}, {
				text: '删除',
				iconCls: 'icon-remove',
				disabled: false,
				handler: function(button) {
					var grid = Ext.getCmp('user-role-grid');
					grid.getStore().remove(grid.getSelectionModel().getSelections());
				},
				scope: this
			}]
		}]
	});
		
	is.window.User.superclass.constructor.call(this, {
		id: 'user-window',
		title: '新建用户',
		width: 400,
		//height: 300,
		autoHeight: true,
		buttonAlign: 'center',
		items: this.formPanel,
		buttons: [{
			text: '确定',
			iconCls: 'icon-commit',
			handler: this.submitForm,
			scope: this
		}, {
			text: '取消',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
	
	this.addEvents({'userAdded':true});
};

Ext.extend(is.window.User, Ext.Window, {
	/*
	 * on role selected event handler.
	 */
	onRolesSelected: function(attr) {
		var grid = Ext.getCmp('user-role-grid');
		var store = grid.getStore();
		var roles = [];
		for (var i = 0; i < attr.roles.length; i++) {
			if (store.find('id', attr.roles[i].id) == -1) {
				roles.push(attr.roles[i]);
			}
		}
		store.add(roles);
	},
	/*
	 * open user.
	 */
	open: function(id) {
		this.mode = 'update';
		this.title = '更新用户';
		this.datastore.load({
			params: {id: id},
			callback: function() {
				var record = this.datastore.getAt(0);
				clsys.form.Util.updateField('user-name', record.get('name'));
				clsys.form.Util.updateField('user-password', record.get('password'));
				clsys.form.Util.updateField('user-secret', record.get('secret'));
				clsys.form.Util.updateField('user-password-confirm', record.get('password'));
				clsys.form.Util.updateField('user-secret-confirm', record.get('secret'));
				clsys.form.Util.updateField('user-name', record.get('name'));
				Ext.getCmp('user-employee-dataview').open(record.get('employee').id);
				Ext.getCmp('user-role-grid').getStore().loadData(record.json);
			},
			scope: this
		});
	},

	/*
	 * check employee filled or not.
	 */
	employeeCheck: function() {
		return Ext.getCmp('user-employee-dataview').getEmployeeId() != '';
	},
	
	/*
	 * submit form.
	 */
	submitForm: function() {
		var pwd = Ext.getCmp('user-password').getValue();
		var pwdCfm = Ext.getCmp('user-password-confirm').getValue();
		var secret = Ext.getCmp('user-secret').getValue();
		var secretCfm = Ext.getCmp('user-secret-confirm').getValue();
		if (pwd != pwdCfm) {
			clsys.message.info('密码和确认密码不符.');
			return false;
		}
		
		if (secret != secretCfm) {
			clsys.message.info('电子密钥和电子密钥确认不符.');
			return false;
		}
		
		if (!this.employeeCheck()) {
			clsys.message.info('请选择员工.');
			return false;
		}
		
		var roles = [];
		var store = Ext.getCmp('user-role-grid').getStore();
		
		if (store.getCount() == 0) {
			clsys.message.info('请选择角色.');
			return false;
		}
		for (var i = 0; i < store.getCount(); i++) {
			roles.push(store.getAt(i).get('id'));
		}
		
		this.formPanel.getForm().submit({
			url: this.mode == 'add'? 'addUser.action': 'updateUser.action',
			params: {
				roles: roles,
				employee: Ext.getCmp('user-employee-dataview').getStore().getAt(0).get('id')
			},
			success: function(form, action) {
				this.fireEvent('userAdded', {});
				this.destroy();
			},
			failure: function(form, action) {
				clsys.message.error(action.result.msg);
			},
			scope:this
		});
	}
});

Ext.reg('is-user-window', is.window.User);