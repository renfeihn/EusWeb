<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
 
<script type="text/javascript" src="js/basic/corporation.js"></script>
<script type="text/javascript">

Ext.onReady(function(){

	var openAddCorporation = function() {
		var corporation = Ext.getCmp('newCorporationWindow');
		if (!corporation) {
			corporation = new is.window.Corporation();
		}
		corporation.setTitle('新增');
		corporation.reset();
//		Ext.getCmp('corporation_type').setValue(Ext.getCmp('corporation-find-type').getValue());
		corporation.show();
	};
	
	var delCorporation = function() {
		Ext.Msg.show({
			title:'确认删除', 
			msg:'你确定要删除该机构吗？',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = corporationGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeCorporation.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('消息', '删除成功!');
							corporationStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('错误', '删除错误，消息:' + response.responseText);
						}
					});
				}
			}
		});
	};

	var usingcorporation = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = corporationGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeCorporation.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								corporationStore.reload();
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
	
	var suspendedcorporation = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = corporationGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeCorporation.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							corporationStore.reload();
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
	
	var openUpdCorporation = function() {

		var corporationId = corporationGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newCorporationWindow');
		if (!window) {
			window = new is.window.Corporation();
		}
		window.open(corporationId);
		window.setTitle('更改');
		window.show();
	};
	
	var importCorporationFromExcel = function() {
		var corporationFromExcel = Ext.getCmp('corporation-uplaod-excel-window');
		if (!corporationFromExcel) {
			corporationFromExcel = new is.window.CorporationExcel();
		}
		corporationFromExcel.reset();
		corporationFromExcel.show();
	};
	
	var corporationStore = new Ext.data.JsonStore({
		id: 'corporationStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25,status: ['Using', 'Suspended']} },
		url: "findCorporation.action",
		root: "CorporationList",
		idProperty: "id",
		fields: ['id', 'code','name','factory','tel','shortname','address','manager','mobil',{name:'state',type:'int'}]
	});
	
	var corporationPanel = Ext.getCmp('corporation-mainpanel');
	
	clsys.form.Util.PagingToolbar(corporationStore, corporationPanel.bbar, 'corporation-info-paging');
	
	var corporationGrid = new Ext.grid.GridPanel({
		store: corporationStore,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id:'corporationGrid',
 	    renderTo: 'corporationGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [{header: '编号', dataIndex: 'id'},
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	          {header: '厂商', dataIndex: 'factory'},
	 	 	          {header: '简称', dataIndex: 'shortname'},
	 	 	          {header: '地址', dataIndex: 'address'},
	 	 	          {header: '电话', dataIndex: 'tel'},
	 	 	          {header: '主管', dataIndex: 'manager'},
	 	 	     	  {header: '移动电话', dataIndex: 'mobil'},
	 	 	     	  {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	corporationPanel.getTopToolbar().add({
		text: '新增',
		id: 'addCorporation',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddCorporation
	},{
		text: '删除',
		id: 'delCorporation',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delCorporation
	},{
		text: '更新',
		id: 'updCorporation',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdCorporation
	},{
		text: '启用',
		id: 'usingcorporation',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcorporation
	},{
		text: '禁用',
		id: 'suspendedcorporation',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcorporation
	}, '-','查询:', {
		xtype: 'is-search-field',
		id: 'corporation-search',
		store: corporationStore
	}, '->',{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
		}, '-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
			corporationStore.reload();
		},
		scope:this
	},{
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('corporation-find-type').getValue();
			var value = Ext.getCmp('corporation-search').getValue();
			window.open('exportCorporationExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',
		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllCorporationExcel.action');
		}
	}, ' '
);

	corporationPanel.getBottomToolbar().hide();
	corporationPanel.doLayout();

	corporationGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updCorporation').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delCorporation').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedcorporation').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingcorporation').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="corporationPanel"></div>
<div id="corporationWindow"></div>
<div id="corporationGridPanel"></div>
</body>
</html>