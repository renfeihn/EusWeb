
Ext.ns('is.window.RoleDataAccess');

is.window.RoleDataAccess = function() {
	this.datastore = new Ext.data.JsonStore({
		url: 'getRoleDataAccess.action',
		root: 'RoleDataAccessList',
		fields : ['id', 'code', 'name', {name:'state', type: 'int'}, {name: 'value', type: 'int'}]
	});	
	
	this.formPanel = new Ext.form.FormPanel({
		labelAlign: 'right'
	});
	
	is.window.RoleDataAccess.superclass.constructor.call(this, {
		id: 'role-data-access-window',
		title: '数据权限',
		buttonAlign: 'center',
		width: 400,
		height: 300,
		modal: true,
		items: this.formPanel,
		buttons: [{
			text: '应用',
			iconCls: 'icon-commit',
			handler: this.submit,
			scope: this
		}, {
			text: '取消',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
};

Ext.extend(is.window.RoleDataAccess, Ext.Window, {
	/*
	 * create radio box group.
	 */
	createRadioGroup: function(record) {
		if (record.get('state') != 0) {
			/* data access has been disabled. */
			return;
		}
		var category = record.get('code');

		var radioGroup = new Ext.form.RadioGroup({
			xtype: 'radiogroup',
			id: category + '-radio-group',
			fieldLabel: record.get('name'),
			columns: 3,
			items: [{
				boxLabel: '个人',
				id: category + '-private',
				name: 'unused_' + category,
				inputValue: 0
			}, {
				boxLabel: '部门',
				id: category + '-group',
				name: 'unused_' + category,
				inputValue: 1
			}, {
				boxLabel: '所有',
				id: category + '-all',
				name: 'unused_' + category,
				inputValue: 2
			}]
		});
		var selected = record.get('value');
		switch (selected) {
		case 0:
			radioGroup.setValue(category + '-private', true);
			break;
		case 1:
			radioGroup.setValue(category + '-group', true);
			break;
		case 2:
			default:
				radioGroup.setValue(category + '-all', true);
			break;
		}
		this.formPanel.add(radioGroup);
	},
	/*
	 * create all data access radio box group.
	 */
	createAll: function(role) {
		this.role = role;
		var id = role ? role : '';
		this.datastore.load({
			params: {
				id: id
			},
			callback: function() {
				var records = this.datastore.getRange();
				for (var i = 0; i < records.length; i++) {
					var chkgrp = this.createRadioGroup(records[i]);
				}
				this.formPanel.doLayout();
			},
			scope: this
		});
	},
	
	/*
	 * submit form.
	 */
	submit: function() {
		var access = [], states = [];
		for (var i = 0; i < this.datastore.getCount(); i++) {
			access.push(this.datastore.getAt(i).get('id'));
			var selected = Ext.getCmp(this.datastore.getAt(i).get('code') + '-radio-group').getValue();
			if (selected) {
				var id = selected.getId();
				if (id.indexOf('private') != -1) {
					states.push(0);
				} else if (id.indexOf('group') != -1) {
					states.push(1);
				} else {
					states.push(2);
				}
			} else {
				states.push(0);
			}
		}
		
		var role = this.role ? this.role : '';
		this.formPanel.getForm().submit({
			url: 'updateRoleDataAccess.action',
			params: {
				role: role,
				access: access,
				states: states
			},
			success: function(form, action) {
				this.destroy();
			}, failure: function(form, action) {
				clsys.message.error(action.result.msg);
			},
			scope: this
		});
	}
});

Ext.reg('is-role-data-access', is.window.RoleDataAccess);