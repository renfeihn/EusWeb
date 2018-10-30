<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/common/EmployeeDataview.js"></script>
<script type="text/javascript" src="js/common/EmployeeSelector.js"></script>
<script type="text/javascript" src="js/common/EmployeeInfo.js"></script>
<script type="text/javascript" src="js/admin/Role.js"></script>
<script type="text/javascript" src="js/admin/RoleInfo.js"></script>
<script type="text/javascript" src="js/admin/RoleSelector.js"></script>
<script type="text/javascript" src="js/admin/User.js"></script>
<script type="text/javascript">

Ext.onReady(function() {
	var userStore = new Ext.data.JsonStore({
		autoDestroy: true,
        autoLoad:true,
		url: 'findUser.action',
		root: 'UserList',
		baseParams: {
			start: 0,
			limit: 25,
			states: ['Using', 'Suspended']
		},
		fields: 
			['id', 'name',
			{name:'position', mapping:'employee.position'},
			{name:'department', mapping:'employee.position.department'},
			{name:'level', mapping:'employee.position.level'},
			'employee', {name:'state', type:'int'}]
	});

	var changeUser = function(id, state) {
		Ext.Ajax.request({
			url: 'changeUser.action',
			params: {
				id: id,
				state: state
			},
			success: function(response, opts) {
				var result = Ext.decode(response.responseText);
				if (!result.success) {
					clsys.message.error(result.msg);
				} else {
					userStore.reload();
				}
			},
			failure: function(response, opts) {
				clsys.message.systemerror();
			}
		});
	};
	
	var userPanel = Ext.getCmp('Users-mainpanel');
	
	userPanel.getTopToolbar().add({
		text: '新增',
		iconCls: 'icon-add',
		handler: function(button) {
			var win = Ext.getCmp('user-window');
			if (!win) {
				win = new is.window.User();
				win.on('userAdded', function(attr) {
					userStore.reload();
				});
			}
			win.show();
		},
		scope: this
	}, {
		text: '修改',
		id: 'user-update',
		disabled: true,
		iconCls: 'icon-update',
		handler: function(button) {
			var win = Ext.getCmp('user-window');
			if (!win) {
				win = new is.window.User();
				win.on('userAdded', function(attr) {
					userStore.reload();
				});
			}
			win.open(Ext.getCmp('admin-user-grid').getSelectionModel().getSelected().get('id'));
			win.show();
		},
		scope: this
	}, {
		text: '启用',
		id: 'user-enable',
		disabled: true,
		iconCls: 'icon-commit',
		handler: function(button) {
			clsys.message.confirm('确启用该用户?', function(buttonId) {
				if (buttonId == 'yes') {
					changeUser(Ext.getCmp('admin-user-grid').getSelectionModel().getSelected().get('id'), 'Using');
				}
			});
		},
		scope: this
	}, {
		text: '停用',
		id: 'user-disable',
		disabled: true,
		iconCls: 'icon-event',
		handler: function(button) {
			clsys.message.confirm('确定禁用该用户?', function(buttonId) {
				if (buttonId == 'yes') {
					changeUser(Ext.getCmp('admin-user-grid').getSelectionModel().getSelected().get('id'), 'Suspended');
				}
			});
		}
	}, {
		text: '删除',
		iconCls: 'icon-remove',
		handler: function(button) {
		}
	}, '-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function(button) {
			userStore.reload();
		},
		scope: this
	}, '->', {
		xtype: 'is-search-field',
		id: 'user-search',
		store: userStore,
		paramName: 'search'
	}, ' ');

	var employeeRender = function(employee) {
		if (employee) {
			return '<span><a href="#" onclick="openEmployee(\'' + employee.id + '\');">' + employee.name + '</a></span>';
		} else {
			return '<span></span>';
		}
	};

	userPanel.add({
		xtype: 'grid',
		id: 'admin-user-grid',
		store: userStore,
		border: false,
		frame: false,
 	    //width: 400,
 	    autoHeight:true,
 	    stripeRows: true,
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
				{header:'名称', dataIndex: 'name'},
				{header:'员工', renderer:employeeRender, dataIndex:'employee'},
				{header:'部门', renderer:clsys.grid.columnrender.DepartmentRender, dataIndex: 'department'},
				{header:'级别', renderer:clsys.grid.columnrender.LevelRender, dataIndex: 'level'},
				{header:'岗位', renderer:clsys.grid.columnrender.PositionRender, dataIndex: 'position'},
				{header:'状态', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}
 	 	  	]
 		}),
 		viewConfig: {
 			forceFit: true
		},
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	clsys.form.Util.PagingToolbar(userStore, userPanel.bbar, 'user-paging');
	userPanel.getBottomToolbar().hide();
	userPanel.doLayout();

	Ext.getCmp('admin-user-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('user-update').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var state = sm.getSelected().get('state');
			Ext.getCmp('user-enable').setDisabled(state==0);
			Ext.getCmp('user-disable').setDisabled(state==1);
		}
	});
});
</script>
</head>
<body>
</body>
</html>