<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>

<script type="text/javascript" src="js/basic/warehouse.js"></script>
<script type="text/javascript">

Ext.onReady(function(){

	var openAddWarehouse = function() {
		var warehouse = Ext.getCmp('newWarehouseWindow');
		if (!warehouse) {
			warehouse = new is.window.Warehouse();
		}
		warehouse.setTitle('����');
		warehouse.reset();
//		Ext.getCmp('warehouse_type').setValue(Ext.getCmp('warehouse-find-type').getValue());
		warehouse.show();
	};
	
	var delWarehouse = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ���ÿ�λ��',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = warehouseGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeWarehouse.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							warehouseStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingwarehouse = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = warehouseGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeWarehouse.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								warehouseStore.reload();
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
	
	var suspendedwarehouse = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = warehouseGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeWarehouse.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							warehouseStore.reload();
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
	
	var openUpdWarehouse = function() {

		var warehouseId = warehouseGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newWarehouseWindow');
		if (!window) {
			window = new is.window.Warehouse();
		}
		window.open(warehouseId);
		window.setTitle('����');
		window.show();
	};
	
	var importWarehouseFromExcel = function() {
		var warehouseFromExcel = Ext.getCmp('warehouse-uplaod-excel-window');
		if (!warehouseFromExcel) {
			warehouseFromExcel = new is.window.WarehouseExcel();
		}
		warehouseFromExcel.reset();
		warehouseFromExcel.show();
	};
	
	var warehouseStore = new Ext.data.JsonStore({
		id: 'warehouseStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findWarehouse.action",
		root: "WarehouseList",
		idProperty: "id",
		fields: ['id', 'code','name','capcity',{name:'state',type:'int'}]	
	});
	
	var warehousePanel = Ext.getCmp('warehouse-mainpanel');
	
	clsys.form.Util.PagingToolbar(warehouseStore, warehousePanel.bbar, 'warehouse-info-paging');
	
	var warehouseGrid = new Ext.grid.GridPanel({
		store: warehouseStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'warehouseGrid',
 	    renderTo: 'warehouseGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [{header: '���', dataIndex: 'id'},
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: '����', dataIndex: 'capcity'},
	 	 	          {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	warehousePanel.getTopToolbar().add({
		text: '����',
		id: 'addWarehouse',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddWarehouse
	},{
		text: 'ɾ��',
		id: 'delWarehouse',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delWarehouse
	},{
		text: '����',
		id: 'updWarehouse',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdWarehouse
	},{
		text: '����',
		id: 'usingwarehouse',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingwarehouse
	},{
		text: '����',
		id: 'suspendedwarehouse',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedwarehouse
	},'-', '��ѯ:', {
		xtype: 'is-search-field',
		id: 'warehouse-search',
		store: warehouseStore
	}, '->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
	}, '-', {
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
		warehouseStore.reload();
		}
	},{
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('warehouse-find-type').getValue();
			var value = Ext.getCmp('warehouse-search').getValue();
			window.open('exportWarehouseExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel��������',
		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllWarehouseExcel.action');
		}
	}, ' '
);

	warehousePanel.getBottomToolbar().hide();
	warehousePanel.doLayout();

	warehouseGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updWarehouse').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delWarehouse').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedwarehouse').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingwarehouse').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="warehousePanel"></div>
<div id="warehouseWindow"></div>
<div id="warehouseGridPanel"></div>
</body>
</html>