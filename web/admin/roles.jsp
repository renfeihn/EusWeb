<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/admin/RoleTree.js"></script>
<script type="text/javascript" src="js/admin/Role.js"></script>
<script type="text/javascript" src="js/admin/RoleInfo.js"></script>
<script type="text/javascript" src="js/admin/RoleSelector.js"></script>
<script type="text/javascript" src="js/admin/RoleDataAccess.js"></script>
<script type="text/javascript">
Ext.onReady(function() {
	var roleStore = new Ext.data.JsonStore({
		autoDestroy: true,
        autoLoad:true,
		url: 'findRole.action',
		root: 'RoleList',
		fields: 
			['id', 'name', 'code', 'description']
	});

	var rolePanel = Ext.getCmp('Role-mainpanel');
	
	rolePanel.getTopToolbar().add({
		text: '新增',
		iconCls: 'icon-add',
		handler: function(button) {
			var win = Ext.getCmp('role-window');
			if (!win) {
				win = new is.window.Role();
				win.on('roleSaved', function(attr) {
					roleStore.reload();
				});
				win.show();
			}
		}
	}, {
		text: '更新',
		id: 'role-update',
		iconCls: 'icon-update',
		disabled: true,
		handler: function(button) {
			var win = Ext.getCmp('role-window');
			if (!win) {
				win = new is.window.Role();
				win.on('roleSaved', function(attr) {
					roleStore.reload();
				});
			}
			win.show();
			win.open(Ext.getCmp('admin-role-grid').getSelectionModel().getSelected().get('id'));
		}
	}, {
		text: '数据控制',
		id: 'role-data-access-button',
		disabled: true,
		iconCls: 'icon-prop',
		handler: function(button) {
			var win = Ext.getCmp('role-data-access-window');
			if (!win) {
				win = new is.window.RoleDataAccess();
				win.createAll(Ext.getCmp('admin-role-grid').getSelectionModel().getSelected().get('id'));
			}
			win.show();
		}
	});

	var roleRender = function(id) {
		var record = roleStore.getById(id);
		if (record) {
			var name = record.get('name');
			return '<span><a href="#" onclick="openRoleInfo(\'' + record.get('id') + '\')">' + name + '</a></span>';
		}
		return '<span></span>';
	};
	
	rolePanel.add({
		xtype: 'grid',
		id: 'admin-role-grid',
		//title:'角色列表',
		store: roleStore,
 	    //width: 400,
 	    autoHeight: true,
 	    border: false,
 	    stripeRows: true,
 	    frame: false,
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
				{header:'编号', width: 120, dataIndex:'code'},
				{header:'名称', renderer: roleRender, width: 120, dataIndex: 'id'},
				{header:'描述', dataIndex: 'description'}
 	 	  	]
 		}),
 		viewConfig: {
 			forceFit: true
		},
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	clsys.form.Util.PagingToolbar(roleStore, rolePanel.bbar, 'role-paging');
	rolePanel.getBottomToolbar().hide();
	rolePanel.doLayout();

	Ext.getCmp('admin-role-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('role-update').setDisabled(sm.getCount() < 1);
		Ext.getCmp('role-data-access-button').setDisabled(sm.getCount() < 1);
	});
});
</script>
</head>
<body>
</body>
</html>