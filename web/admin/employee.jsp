<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/admin/Employee.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var openAddEmployee = function() {
		var employee = Ext.getCmp('employee-window');
		if (!employee) {
			employee = new is.window.Employee();
		}
		employee.setTitle('新增');
		employee.reset();
		employee.show();
	};
	
	var delEmployee = function() {
		clsys.message.confirm('你确定要删除数据库中记录?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = employeeGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'removeEmployee.action',
					params: { 'id': id },
					success: function(response, opt) {
						employeeStore.reload();
					},
					failure: function(response, opt) {
						Ext.Msg.alert('错误', '删除错误，消息:' + response.responseText);
					}
				});
			}
		});
	};
	
	var enableEmployee = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = employeeGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeEmployee.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								employeeStore.reload();
							} else {
								is.messsage.error('启用错误，消息:' + result.msg);
							}
						},
						failure: function(response, opt) {
							clsys.message.systemerror();
						}
					});
				}
		});
	};
	
	var disableEmployee = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = employeeGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeEmployee.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							employeeStore.reload();
						} else {
							is.messsage.error('禁用错误，消息:' + result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.systemerror();
					}
				});
			}
		});
	};
	
	var openEmployee = function() {
		var employeeId = employeeGrid.getSelectionModel().getSelected().get('id');
		if (Ext.isEmpty(employeeId)) return;
		
		var window = Ext.getCmp('employee-window');
		if (!window) {
			window = new is.window.Employee();
		}
		window.open(employeeId);
		window.setTitle('更改');
		window.show();
	};
	/*
	var importEmployeeFromExcel = function() {
		var employeeFromExcel = Ext.getCmp('employee-uplaod-excel-window');
		if (!employeeFromExcel) {
			employeeFromExcel = new is.window.EmployeeExcel();
		}
		employeeFromExcel.reset();
		employeeFromExcel.show();
	};
	*/
	
	var employeeStore = new Ext.data.JsonStore({
		id: 'employeeStore',
        autoDestroy:true,
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findEmployee.action",
		root: "EmployeeList",
		idProperty: "id",
		fields: ['id', 'code','name','sex','tel','birthday',{name:'state',type:'int'},
		 		 {name:'position', mapping:'position.name'}]
	});
	
	var employeePanel = Ext.getCmp('employee-mainpanel');
	
	clsys.form.Util.PagingToolbar(employeeStore, employeePanel.bbar, 'employee-info-paging');
	
	var employeeGrid = new Ext.grid.GridPanel({
		store: employeeStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'employeeGrid',
 	    renderTo: 'employeeGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '姓名', dataIndex: 'name'},
	 	 	          {header: '性别', dataIndex: 'sex'},
	 	 	          {header: '电话', dataIndex: 'tel'},
	 	 	          {header: '出生日期', dataIndex: 'birthday'},
	 	 	          {header: '职务', dataIndex: 'position'},
	 	 	          {header: '状态', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	employeePanel.getTopToolbar().add({
			text: '新增',
			id: 'addEmployee',
			iconCls: 'icon-add',
			handler: openAddEmployee
		},{
			text: '删除',
			id: 'delEmployee',
			disabled: true,
			iconCls: 'icon-remove',
			handler: delEmployee
		}, {
			text: '更新',
			id: 'updEmployee',
			disabled: true,
			iconCls: 'icon-update',
			handler: openEmployee
		},{
			text: '启用',
			id: 'employee-enable',
			disabled: true,
			iconCls: 'icon-using',
			handler: enableEmployee
		},{
			text: '禁用',
			id: 'employee-disable',
			disabled: true,
			iconCls: 'icon-suspended',
			handler: disableEmployee
		},'-', '查询:',  {
			xtype: 'is-search-field',
			id: 'employee-search',
			store: employeeStore
		}, '->',{
			text: '打印',
			iconCls: 'icon-printer',
			handler: function(){
			}
		}, '-', {
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				employeeStore.reload();
			}
		}, {
			text: 'Excel导出',
			iconCls: 'icon-leading-out',
			handler: function() {
				var type = Ext.getCmp('employee-find-type').getValue();
				var value = Ext.getCmp('employee-search').getValue();
				window.open('exportEmployeeExcel.action?type=' + type + '&findValue=' + value);
			}
		}, {
			text: 'Excel导出所有',
			iconCls: 'icon-out',
			handler: function() {
				window.open('exportAllEmployeeExcel.action');
			}
		},' '
	);

	employeePanel.getBottomToolbar().hide();
	employeePanel.doLayout();

	employeeGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updEmployee').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delEmployee').setDisabled(sm.getCount() < 1);
		Ext.getCmp('employee-disable').setDisabled(sm.getCount() < 1);
		Ext.getCmp('employee-enable').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="employeePanel"></div>
<div id="employeeWindow"></div>
<div id="employeeGridPanel"></div>
</body>
</html>