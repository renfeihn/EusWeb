
Ext.ns('is.window.Role');

is.window.Role = function() {
	this.mode = 'add';
	
	this.datastore = new Ext.data.JsonStore({
		url: 'getRole.action',
		root: 'Role',
		fields: ['id', 'name', 'code', 'description', 'functions']
	});
	
	this.formPanel = new Ext.form.FormPanel({
		id: 'role-form',
		labelAlign: 'right',
		labelWidth: 50,
		autoScroll: true,
		border: false,
		frame: false,
		style: {
			marginTop: 2
		},
		items: [{
			border: false,
			layout: 'column',
			items: [{
				columnWidth: .5,
				border: false,
				frame: false,
				layout: 'form',
				items: [{
					xtype: 'textfield',
					id: 'role-code',
					width: 125,
					allowBlank: false,
					fieldLabel: '编码',
					name: 'code'
				}]
			}, {
				columnWidth: .5,
				border: false,
				frame: false,
				layout: 'form',
				items: [{
					xtype: 'textfield',
					id: 'role-name',
					width: 125,
					allowBlank: false,
					fieldLabel: '名称',
					name: 'name'
				}]
			}]
		}, {
			xtype: 'textarea',
			id: 'role-description',
			name: 'description',
			hideLabel: true,
			style: {
				width: '96%',
				marginBottom: '2px',
				marginRight: '5px',
				marginLeft: '5px'
			},
			emptyText: '填写描述'
		}, {
			xtype: 'treepanel',
			id: 'role-tree-panel',
			animate: false,
			root: {
				nodeType: 'async'
			},
			rootVisible: false,
			autoScroll:true,
			border: true,
			//width: 400,
			height: 335,
			collapseFirst: false,
			tbar: [{
				text: '选择上次设置',
				handler: function() {
					var tree = Ext.getCmp('role-tree-panel');
					var record = this.datastore.getAt(0);
					var list = record.get('functions');
					for (var i = 0; i < list.length; i++) {
						var node = tree.getNodeById(list[i].functionId);
						if (node) {
							node.getUI().toggleCheck(true);
						}
					}
				},
				scope: this
			}],
			loader: new Ext.tree.TreeLoader({
				dataUrl: 'systemFunctions.action'
			})
		}]
	});

	Ext.getCmp('role-tree-panel').getRootNode().expand(true);
	
	is.window.Role.superclass.constructor.call(this, {
		id: 'role-window',
		title: '新增角色',
		buttonAlign: 'center',
		width: 400,
		height: 500,
		items: [this.formPanel],
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
	
	this.addEvents({'roleSaved':true});
};

Ext.extend(is.window.Role, Ext.Window, {	
	open: function(id) {
		this.mode = 'update';
		this.title = '更新角色';
		this.datastore.load({
			params: {id: id },
			callback: function() {
				var record = this.datastore.getAt(0);
				clsys.form.Util.updateField('role-name', record.get('name'));
				clsys.form.Util.updateField('role-code', record.get('code'));
				clsys.form.Util.updateField('role-description', record.get('description'));
				var tree = Ext.getCmp('role-tree-panel');
				var list = record.get('functions');
				for (var i = 0; i < list.length; i++) {
					var node = tree.getNodeById(list[i].functionId);
					if (node) {
						node.getUI().toggleCheck(true);
					}
				}
			},
			scope: this
		});
	},
	/*
	 * submit form.
	 */
	submit: function() {
		var tree = Ext.getCmp('role-tree-panel');
		var functions = [], names = [];
		var nodes = tree.getChecked();
		Ext.each(nodes, function(node) {
			functions.push(node.id);
			names.push(node.text);
		});
		var id = '';
		if (this.mode == 'update') {
			id = this.datastore.getAt(0).get('id');
		}
		
		this.formPanel.getForm().submit({
			url: this.mode == 'add' ? 'addRole.action' : 'updateRole.action',
			params: {
				id: id,
				functions: functions,
				names: names
			},
			success: function(form, action) {
				this.fireEvent('roleSaved', {});
				this.destroy();
			},
			failure: function(form, action) {
				clsys.message.systemerror();
			},
			waitMsg: '正在提交，请稍候...',
			scope: this
		});
	}
});

Ext.reg('is-role-window', is.window.Role);