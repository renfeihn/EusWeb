<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>

<script type="text/javascript" src="js/basic/model.js"></script>
<script type="text/javascript">

Ext.onReady(function(){

	var openAddModel = function() {
		var model = Ext.getCmp('newModelWindow');
		if (!model) {
			model = new is.window.Model();
		}
		model.setTitle('新增');
		model.reset();
//		Ext.getCmp('model_type').setValue(Ext.getCmp('model-find-type').getValue());
		model.show();
	};
	
	var delModel = function() {
		Ext.Msg.show({
			title:'确认删除', 
			msg:'你确定要删除该车型吗？',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = modelGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeModel.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('消息', '删除成功!');
							modelStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('错误', '删除错误，消息:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingmodel = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = modelGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeModel.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								modelStore.reload();
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
	
	var suspendedmodel = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = modelGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeModel.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							modelStore.reload();
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
	
	var openUpdModel = function() {

		var modelId = modelGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newModelWindow');
		if (!window) {
			window = new is.window.Model();
		}
		window.open(modelId);
		window.setTitle('更改');
		window.show();
	};
	
	var importModelFromExcel = function() {
		var modelFromExcel = Ext.getCmp('model-uplaod-excel-window');
		if (!modelFromExcel) {
			modelFromExcel = new is.window.ModelExcel();
		}
		modelFromExcel.reset();
		modelFromExcel.show();
	};
	
	var modelStore = new Ext.data.JsonStore({
		id: 'modelStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ 
        	params:{
    			start: 0, 
    			limit: 25,
    			status: ['Using', 'Suspended']
    		}
		},
		url: "findModel.action",
		root: "ModelList",
		idProperty: "id",
		fields: 
			['id', 'code','name','manufacturer',{name:'state',type:'int'},
			{name:'category', mapping:'category.name'},
			{name:'type', mapping:'type.name'}]
	});
	
	var modelPanel = Ext.getCmp('model-mainpanel');
	
	clsys.form.Util.PagingToolbar(modelStore, modelPanel.bbar, 'model-info-paging');
	
	var modelGrid = new Ext.grid.GridPanel({
		store: modelStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'modelGrid',
 	    renderTo: 'modelGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [{header: '编号', dataIndex: 'id'},
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	          {header: '品牌', dataIndex: 'category'},
	 	 	          {header: '类别', dataIndex: 'type'},
	 	 	          {header: '制造商', dataIndex: 'manufacturer'},
	 	 	          {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	modelPanel.getTopToolbar().add({
		text: '新增',
		id: 'addModel',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddModel
	},{
		text: '删除',
		id: 'delModel',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delModel
	},{
		text: '更新',
		id: 'updModel',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdModel
	},{
		text: '启用',
		id: 'usingmodel',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingmodel
	},{
		text: '禁用',
		id: 'suspendedmodel',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedmodel
	},'-', '查询:', {
		xtype: 'is-search-field',
		id: 'model-search',
		store: modelStore
	},'->',{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
	},'-',{
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
		modelStore.reload();
		}
	},  {
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('model-find-type').getValue();
			var value = Ext.getCmp('model-search').getValue();
			window.open('exportModelExcel.action?type=' + type + '&search=' + value);
		}
	}, {
		text: 'Excel导出所有',
		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllModelExcel.action');
		}
	}
);

	modelPanel.getBottomToolbar().hide();
	modelPanel.doLayout();

	modelGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updModel').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delModel').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedmodel').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingmodel').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="modelPanel"></div>
<div id="modelWindow"></div>
<div id="modelGridPanel"></div>
</body>
</html>