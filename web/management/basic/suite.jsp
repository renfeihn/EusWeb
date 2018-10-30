<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/basic/suite.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var openAddSuite = function() {
		var win = Ext.getCmp('suite-window');
		if (!win) {
			win = new is.window.Suite();
			win.on('suiteSaved', function(attr) {
				suiteStore.reload();
			});			
		}
		win.show();
	};
	
	var delSuite = function() {
		clsys.message.confirm('确定要删除该配置信息吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = suiteGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'removeSuite.action',
					params: { 'id': id },
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							suiteStore.reload();
						} else {
							clsys.message.error(action.result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.error(response.responseText);
					}
				});
			}
		});
	};
	
	var usingsuite = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = suiteGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeSuite.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								suiteStore.reload();
							} else {
								clsys.message.error(action.result.msg);
							}
						},
						failure: function(response, opt) {
							clsys.message.systemerror();
						}
					});
				}
		});
	};
	
	var suspendedsuite = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = suiteGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeSuite.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							suiteStore.reload();
						} else {
							clsys.message.error(action.result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.systemerror();
					}
				});
			}
		});
	};
	
	var openUpdSuite = function() {
		var suiteId = suiteGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('suite-window');
		if (!window) {
			window = new is.window.Suite();
			window.on('suiteSaved', function(attr) {
				suiteStore.reload();
			});
		}
		window.open(suiteId);
		window.show();
	};
	
	var importSuiteFrom = function() {
		var suiteFrom = Ext.getCmp('suite-uplaod-excel-window');
		if (!suiteFrom) {
			suiteFrom = new is.window.Suite();
		}
		suiteFrom.reset();
		suiteFrom.show();
	};
	
	var suiteStore = new Ext.data.JsonStore({
        autoDestroy:true,
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findSuite.action",
		root: "SuiteList",
		idProperty: 'id',
		fields: ['id', 'code','name','filepath',{name:'model', mapping:'model.name'},{name:'state',type:'int'}]
	});
	
	downloadSuite = function(id) {
		clsys.message.confirm('确定要下载详细信息吗?', function(buttonId) {
			if (buttonId == 'yes') {
				window.open('downloadSuite.action?id=' + id);
			}
		});
	};
	
	var suitePanel = Ext.getCmp('suite-mainpanel');
	
	var nameRender = function(id) {
		var store = Ext.getCmp('suiteGrid').getStore();
		var name = store.getById(id).get('name');
		var filepath = store.getById(id).get('filepath');
		if (id && filepath && filepath != '') {
			return '<span><a href="#" onclick="downloadSuite(\'' + id + '\');">' + name + '</a></span>';
		} else {
			return '<span>'+name+'</span>';
		}
	};
	
	clsys.form.Util.PagingToolbar(suiteStore, suitePanel.bbar, 'suite-info-paging');
	
	var suiteGrid = new Ext.grid.GridPanel({
		store: suiteStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'suiteGrid',
 	    renderTo: 'suiteGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', renderer: nameRender, dataIndex:'id'},
	 	 	          {header: '车型', dataIndex: 'model'},
	 	 	          {header: '状态', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	suitePanel.getTopToolbar().add({
		text: '新增',
		id: 'addSuite',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddSuite
	},{
		text: '删除',
		id: 'delSuite',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delSuite
	},{
		text: '更新',
		id: 'updSuite',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdSuite
	},{
		text: '启用',
		id: 'usingsuite',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingsuite
	},{
		text: '禁用',
		id: 'suspendedsuite',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedsuite
	},'-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
		suiteStore.reload();
		}
	}, {
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('suite-find-type').getValue();
			var value = Ext.getCmp('suite-search').getValue();
			window.open('exportSuiteExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllSuiteExcel.action');
		}
	}, '->', /*{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
	},*/{
		xtype: 'is-search-field',
		id: 'suite-search',
		store: suiteStore
	}, ' '
);

	suitePanel.getBottomToolbar().hide();
	suitePanel.doLayout();

	suiteGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updSuite').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delSuite').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedsuite').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingsuite').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="codediv"></div>
<div id="suitePanel"></div>
<div id="suiteUploadFile"></div>
<div id="suiteWindow"></div>
<div id="suiteGridPanel"></div>
</body>
</html>