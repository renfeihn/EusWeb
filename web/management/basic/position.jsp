<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/basic/Position.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var openAddPosition = function() {
		var win = Ext.getCmp('position-window');
		if (!win) {
			win = new is.window.Position();
			win.on('positionSaved', function(attr) {
				positionStore.reload();
			});			
		}
		win.show();
	};
	
	var delPosition = function() {
		clsys.message.confirm('确定要删除该职位?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = positionGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'removePosition.action',
					params: { 'id': id },
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							positionStore.reload();
						} else {
							is.messsage.error('启用错误，消息:' + result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.error(response.responseText);
					}
				});
			}
		});
	};
	
	var usingposition = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = positionGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changePosition.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								positionStore.reload();
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
	
	var suspendedposition = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = positionGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changePosition.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							positionStore.reload();
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
	
	var openUpdPosition = function() {
		var positionId = positionGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('position-window');
		if (!window) {
			window = new is.window.Position();
			window.on('positionSaved', function(attr) {
				positionStore.reload();
			});
		}
		window.open(positionId);
		window.show();
	};
	
	var importPositionFromExcel = function() {
		var positionFromExcel = Ext.getCmp('position-uplaod-excel-window');
		if (!positionFromExcel) {
			positionFromExcel = new is.window.PositionExcel();
		}
		positionFromExcel.reset();
		positionFromExcel.show();
	};
	
	var positionStore = new Ext.data.JsonStore({
		id: 'positionStore',
        autoDestroy:true,
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findPosition.action",
		root: "PositionList",
		idProperty: "id",
		fields: ['id', 'code','name',{name:'state',type:'int'},
		 		{name:'department', mapping:'department.name'},
				{name:'level', mapping:'level.name'}]
	});
	
	var positionPanel = Ext.getCmp('position-mainpanel');

	clsys.form.Util.PagingToolbar(positionStore, positionPanel.bbar, 'position-info-paging');
	
	var positionGrid = new Ext.grid.GridPanel({
		store: positionStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'positionGrid',
 	    renderTo: 'positionGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	          {header: '部门', dataIndex: 'department'},
	 	 	          {header: '级别', dataIndex: 'level'},
	 	 	          {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	positionPanel.getTopToolbar().add({
		text: '新增',
		id: 'addPosition',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddPosition
	},{
		text: '删除',
		id: 'delPosition',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delPosition
	},{
		text: '更新',
		id: 'updPosition',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdPosition
	},{
		text: '启用',
		id: 'usingposition',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingposition
	},{
		text: '禁用',
		id: 'suspendedposition',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedposition
	},'-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
		positionStore.reload();
		}
	}, {
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('position-find-type').getValue();
			var value = Ext.getCmp('position-search').getValue();
			window.open('exportPositionExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllPositionExcel.action');
		}
	}, '->', /*{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
	},*/{
		xtype: 'is-search-field',
		id: 'position-search',
		store: positionStore
	}, ' '
);

	positionPanel.getBottomToolbar().hide();
	positionPanel.doLayout();

	positionGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updPosition').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delPosition').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedposition').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingposition').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="positionPanel"></div>
<div id="positionWindow"></div>
<div id="positionGridPanel"></div>
</body>
</html>