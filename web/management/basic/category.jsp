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
		category.setTitle('����');
		category.reset();
//		Ext.getCmp('category_type').setValue(Ext.getCmp('category-find-type').getValue());
		category.show();
	};
	
	var delCategory = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ����Ʒ����?',
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
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							categoryStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingcategory = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
								is.messsage.error('���ô�����Ϣ:' + result.msg);
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
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
							is.messsage.error('���ô�����Ϣ:' + result.msg);
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
		window.setTitle('����');
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
 	        columns: [{header: '���', dataIndex: 'id'},
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: '��Ӧ��', dataIndex: 'supplier'},
	 	 	          {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	categoryPanel.getTopToolbar().add({
		text: '����',
		id: 'addCategory',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddCategory
	},{
		text: 'ɾ��',
		id: 'delCategory',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delCategory
	},{
		text: '����',
		id: 'updCategory',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdCategory
	},{
		text: '����',
		id: 'usingcategory',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcategory
	},{
		text: '����',
		id: 'suspendedcategory',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcategory
	},'-', '��ѯ:', {
		xtype: 'is-search-field',
		id: 'category-search',
		store: categoryStore
	}, '->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
	}, '-', {
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
			categoryStore.reload();
		},
		scope: this
	},{
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
//			var type = Ext.getCmp('category-find-type').getValue();
			var value = Ext.getCmp('category-search').getValue();
			window.open('exportCategoryExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel��������',		
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