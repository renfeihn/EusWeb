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
		model.setTitle('����');
		model.reset();
//		Ext.getCmp('model_type').setValue(Ext.getCmp('model-find-type').getValue());
		model.show();
	};
	
	var delModel = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ���ó�����',
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
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							modelStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingmodel = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
	
	var suspendedmodel = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
	
	var openUpdModel = function() {

		var modelId = modelGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newModelWindow');
		if (!window) {
			window = new is.window.Model();
		}
		window.open(modelId);
		window.setTitle('����');
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
 	        columns: [{header: '���', dataIndex: 'id'},
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: 'Ʒ��', dataIndex: 'category'},
	 	 	          {header: '���', dataIndex: 'type'},
	 	 	          {header: '������', dataIndex: 'manufacturer'},
	 	 	          {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	modelPanel.getTopToolbar().add({
		text: '����',
		id: 'addModel',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddModel
	},{
		text: 'ɾ��',
		id: 'delModel',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delModel
	},{
		text: '����',
		id: 'updModel',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdModel
	},{
		text: '����',
		id: 'usingmodel',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingmodel
	},{
		text: '����',
		id: 'suspendedmodel',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedmodel
	},'-', '��ѯ:', {
		xtype: 'is-search-field',
		id: 'model-search',
		store: modelStore
	},'->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
	},'-',{
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
		modelStore.reload();
		}
	},  {
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('model-find-type').getValue();
			var value = Ext.getCmp('model-search').getValue();
			window.open('exportModelExcel.action?type=' + type + '&search=' + value);
		}
	}, {
		text: 'Excel��������',
		
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