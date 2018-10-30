<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/basic/Department.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var openAddDepartment = function() {
		var win = Ext.getCmp('department-window');
		if (!win) {
			win = new is.window.Department();
			win.on('departmentSaved', function(attr) {
				departmentStore.reload();
			});
		}
		win.show();
	};
	
	var delDepartment = function() {
		clsys.message.confirm('确定要删除该部门?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = departmentGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'removeDepartment.action',
					params: { 'id': id },
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							departmentStore.reload();
						} else {
							clsys.message.error(result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.systemerror();
					}
				});
			}
		});
	};

	var usingdepartment = function() {
		clsys.message.confirm('确定启用该部门?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = departmentGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeDepartment.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								departmentStore.reload();
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
	
	var suspendeddepartment = function() {
		clsys.message.confirm('确定禁用该部门?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = departmentGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeDepartment.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							departmentStore.reload();
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
	
	var openUpdDepartment = function() {
		var departmentId = departmentGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('department-window');
		if (!window) {
			window = new is.window.Department();
			window.on('departmentSaved', function(attr) {
				departmentStore.reload();
			});
		}
		window.open(departmentId);
		window.show();
	};
	
	var importDepartmentFromExcel = function() {
		var departmentFromExcel = Ext.getCmp('department-uplaod-excel-window');
		if (!departmentFromExcel) {
			departmentFromExcel = new is.window.DepartmentExcel();
		}
		departmentFromExcel.reset();
		departmentFromExcel.show();
	};
	
	var departmentStore = new Ext.data.JsonStore({
		id: 'departmentStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findDepartment.action",
		root: "DepartmentList",
		idProperty: "id",
		fields: ['id', 'code','name',
		 		 {name:'startdate', type:'date', dateFormat:'Y-m-d'},'status',
		 		 {name:'enddate', type:'date', dateFormat:'Y-m-d'},{name:'state',type:'int'},
				 {name:'parent', mapping:'parent.name'},
		 		 {name:'corporation', mapping:'corporation.name'}]
	});
	
	var departmentPanel = Ext.getCmp('department-mainpanel');

	clsys.form.Util.PagingToolbar(departmentStore, departmentPanel.bbar, 'department-paging');
	
	var departmentGrid = new Ext.grid.GridPanel({
		store: departmentStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'departmentGrid',
 	    renderTo: 'departmentGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	     	  {header: '创建日期', renderer:clsys.grid.columnrender.DateRender, dataIndex: 'startdate'},
	 	 	     	  {header: '撤销日期', renderer:clsys.grid.columnrender.DateRender, dataIndex: 'enddate'},
	 	 	     	  {header: '机构', dataIndex: 'corporation'},
	 	 	    	  {header: '上级部门', dataIndex: 'parent'},
	 	 	          {header: '状态', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	departmentPanel.getTopToolbar().add({
		text: '新增',
		id: 'addDepartment',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddDepartment
	},{
		text: '删除',
		id: 'delDepartment',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delDepartment
	},{
		text: '更新',
		id: 'updDepartment',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdDepartment
	},{
		text: '启用',
		id: 'usingdepartment',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingdepartment
	},{
		text: '禁用',
		id: 'suspendeddepartment',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendeddepartment
	}, '-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
			departmentStore.reload();
		},
		scope:this
	}, /*{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
		}*/
	{
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('department-find-type').getValue();
			var value = Ext.getCmp('department-search').getValue();
			window.open('exportDepartmentExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllDepartmentExcel.action');
		}
	}, '->', {
		xtype: 'is-search-field',
		id: 'department-search',
		store: departmentStore
	}, ' '
);

	departmentPanel.getBottomToolbar().hide();
	departmentPanel.doLayout();

	departmentGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updDepartment').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delDepartment').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendeddepartment').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingdepartment').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="departmentPanel"></div>
<div id="departmentWindow"></div>
<div id="departmentGridPanel"></div>
</body>
</html>