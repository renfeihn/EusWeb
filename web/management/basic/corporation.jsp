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
		corporation.setTitle('����');
		corporation.reset();
//		Ext.getCmp('corporation_type').setValue(Ext.getCmp('corporation-find-type').getValue());
		corporation.show();
	};
	
	var delCorporation = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ���û�����',
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
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							corporationStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};

	var usingcorporation = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
	
	var suspendedcorporation = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
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
	
	var openUpdCorporation = function() {

		var corporationId = corporationGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newCorporationWindow');
		if (!window) {
			window = new is.window.Corporation();
		}
		window.open(corporationId);
		window.setTitle('����');
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
 	        columns: [{header: '���', dataIndex: 'id'},
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: '����', dataIndex: 'factory'},
	 	 	          {header: '���', dataIndex: 'shortname'},
	 	 	          {header: '��ַ', dataIndex: 'address'},
	 	 	          {header: '�绰', dataIndex: 'tel'},
	 	 	          {header: '����', dataIndex: 'manager'},
	 	 	     	  {header: '�ƶ��绰', dataIndex: 'mobil'},
	 	 	     	  {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});
	
	corporationPanel.getTopToolbar().add({
		text: '����',
		id: 'addCorporation',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddCorporation
	},{
		text: 'ɾ��',
		id: 'delCorporation',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delCorporation
	},{
		text: '����',
		id: 'updCorporation',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdCorporation
	},{
		text: '����',
		id: 'usingcorporation',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcorporation
	},{
		text: '����',
		id: 'suspendedcorporation',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcorporation
	}, '-','��ѯ:', {
		xtype: 'is-search-field',
		id: 'corporation-search',
		store: corporationStore
	}, '->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
		}, '-', {
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
			corporationStore.reload();
		},
		scope:this
	},{
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('corporation-find-type').getValue();
			var value = Ext.getCmp('corporation-search').getValue();
			window.open('exportCorporationExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel��������',
		
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