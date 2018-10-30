<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>

<script type="text/javascript" src="js/basic/category.js"></script>

<script type="text/javascript">

Ext.onReady(function(){

	var openAddCategory = function() {
		var category = Ext.getCmp('newCategoryWindow');
		if (!category) {
			category = new is.window.Category();
		}
		category.setTitle('新增');
		category.reset();
//		Ext.getCmp('category_type').setValue(Ext.getCmp('category-find-type').getValue());
		category.show();
	};
	
	var delCategory = function() {
		Ext.Msg.show({
			title:'确认删除', 
			msg:'你确定要删除该品牌吗?',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = categoryGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeCategory.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('消息', '删除成功!');
							categoryStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('错误', '删除错误，消息:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingcategory = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = categoryGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeCategory.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								categoryStore.reload();
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
	
	var suspendedcategory = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = categoryGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeCategory.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							categoryStore.reload();
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
	
	var openUpdCategory = function() {

		var categoryId = categoryGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newCategoryWindow');
		if (!window) {
			window = new is.window.Category();
		}
		window.open(categoryId);
		window.setTitle('更改');
		window.show();
	};
	
	var importCategoryFromExcel = function() {
		var categoryFromExcel = Ext.getCmp('category-uplaod-excel-window');
		if (!categoryFromExcel) {
			categoryFromExcel = new is.window.CategoryExcel();
		}
		categoryFromExcel.reset();
		categoryFromExcel.show();
	};
	var findValues = function(){
		alert(action.result.success);
		if(action.result.success){
			alert(action.result.success);
		}
				
	};
	var categoryStore = new Ext.data.JsonStore({
		id: 'categoryStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findCategory.action",
		totalProperty: 'results',
		root: "CategoryList",
		idProperty: "id",
		fields: ['id', 'code','name',{name:'state',type:'int'},
		 		{name:'supplier', mapping:'supplier.name'}]
	});
	
	var categoryPanel = Ext.getCmp('category-mainpanel');

	clsys.form.Util.PagingToolbar(categoryStore, categoryPanel.bbar, 'category-info-paging');
	
	var categoryGrid = new Ext.grid.GridPanel({
		store: categoryStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'categoryGrid',
 	    renderTo: 'categoryGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	           // width: 120,
 	            sortable: true
 	        },
 	        columns: [{header: '编号', dataIndex: 'id'},
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	          {header: '供应商', dataIndex: 'supplier'},
	 	 	          {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	categoryPanel.getTopToolbar().add({
		text: '新增',
		id: 'addCategory',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddCategory
	},{
		text: '删除',
		id: 'delCategory',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delCategory
	},{
		text: '更新',
		id: 'updCategory',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdCategory
	},{
		text: '启用',
		id: 'usingcategory',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcategory
	},{
		text: '禁用',
		id: 'suspendedcategory',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcategory
	},'-', '查询:', {
		xtype: 'is-search-field',
		id: 'category-search',
		store: categoryStore
	}, '->',{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
	}, '-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
			categoryStore.reload();
		},
		scope: this
	},{
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
//			var type = Ext.getCmp('category-find-type').getValue();
			var value = Ext.getCmp('category-search').getValue();
			window.open('exportCategoryExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllCategoryExcel.action');
		}
	}, ' '
);

	categoryPanel.getBottomToolbar().hide();
	categoryPanel.doLayout();

	categoryGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updCategory').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delCategory').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedcategory').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingcategory').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="categoryPanel"></div>
<div id="categoryWindow"></div>
<div id="categoryGridPanel"></div>
</body>
</html>