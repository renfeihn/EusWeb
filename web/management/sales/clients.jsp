<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<script type="text/javascript" src="js/ContactSelector.js"></script>
<script type="text/javascript" src="js/Client-Detail.js"></script>
<script type="text/javascript">
/*
 * �򿪿ͻ�����.
 */
function openClientWindow(id) {
	if (!id || id == '') {
		var window = Ext.getCmp('clients-form-window');
		var selector = new is.window.ClientSelector(window.fillClient);
		selector.show();
	} else {	
		var window = Ext.getCmp('client-information-window');
		if (!window) {
			window = new is.window.Client();
		}
		window.open(id);
		window.show();
	}
};

/*
 * ����ϵ�˴���.
 */
function openContactWindow(id) {
	if (!id || id == '') {
		var window = Ext.getCmp('clients-form-window');
		var selector = new is.window.ContactSelector(window.fillContact);
		selector.show();
	} else {	
		var window = Ext.getCmp('contact-information-window');
		if (!window) {
			window = new is.window.Contact();
		}
		window.open(id);
		window.show();
	}
};

Ext.onReady(function() {
	/*
	 * clients store.
	 */
	var clientsStore = new Ext.data.JsonStore({
        autoDestroy:true,
        autoLoad:true,
		url: "findClients.action",
		params: { 'findType':null, 'findValue':null },
		root: "ClientsList",
		idProperty: "id",
		fields: 
			['id', 'code', 'model', 'color', 'decoration', 'frame', 'audit', 'auditorname', 
				'ownername', 'receivername', 'salesmanname', 'typename']			 
	});

	/*
	 * clients resources store.
	 */
	var clientsResourcesStore = new Ext.data.JsonStore({
		autoDestroy: true,
		autoLoad: true,
		url: 'findCarsForClient.action',
		baseParams: {
			start: 0,
			limit: 1024
		},
		root: 'CarList',
		idProperty: 'id',
		fields: ['id', 'modelname', 'colorname', 'decorationname', 'frame', 'engine', 'certificate', 'productDate']
	});

	var clientsPanel = Ext.getCmp('Clients-mainpanel');

	var pageToolbar = new Ext.PagingToolbar({
    	store: clientsStore,
    	pageSize: 25,
    	displayInfo:true,
    	renderTo: clientsPanel.bbar,
    	items: [ '-', {
			text: 'ÿҳ25��',
			id: 'clientsPagingSize',
			menu: {
				items: [{
					text: 'ÿҳ25��',
					checked: true,
					handler: function() {
	    			},
	    			group: 'clientsPagingGroup',
	    			scope: this
				}, {
					text: 'ÿҳ50��',
					handler: function() {
	    			},
	    			group: 'clientsPagingGroup',
	    			scope: this
				}, {
					text: 'ÿҳ100��',
					handler: function() {
	    			},
	    			group: 'clientsPagingGroup',
	    			scope: this
				}]
    		}
    	}, '-', {
			text: '������:��',
			iconCls: 'icon-remove',
			id: 'clientsDataFilter'	
    	}]
	});

	var auditRender = function(value) {
		if (value == '1') {
			return '<img height="9" src="images/drop-yes.gif"></img><span>�����</span>';
		} else if (value == '0') {
			return '<img height="9" src="images/drop-no.gif"></img><span>δ���</span>';
		} else {
			return '<span>δ֪</span>';
		}
	};
	
	var clientsGrid = new Ext.grid.GridPanel({
		id: 'clientsGrid',
		//title: '���',
		store: clientsStore,
 	    autoHeight:true,
		border: false,
		frame: false,
 	    renderTo: 'clientsGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            //width: 120,
 	            sortable: true
 	        },
 	        columns: [
     	        {header: '���۵����', dataIndex: 'code'},
      	        {header: '����', dataIndex: 'model'},
      	        {header: '��ɫ', dataIndex: 'color'},
      	        {header: '����', dataIndex: 'decoration'},     	        
      	        {header: '���ܺ�', dataIndex: 'frame'},
      	        {header: '����Ա', dataIndex: 'salesmanname'},
      	        {header: '���״̬', renderer: auditRender, dataIndex: 'status'}
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		}, 
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	var clientsResourcesGrid = new Ext.grid.GridPanel({
		id: 'clients-resources-grid',
		store: clientsResourcesStore,
		hidden: true,
		border: false,
		frame: false,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
	        	{header: '����', dataIndex: 'modelname'},
	        	{header: '��ɫ', dataIndex: 'colorname'},
	        	{header: '����', dataIndex: 'decorationname'},
	        	{header: '���ܺ�', dataIndex: 'frame'},
	        	{header: '��������', dataIndex: 'engine'},
	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
	        	{header: '��������', dataIndex: 'productDate'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	clientsPanel.getTopToolbar().add({
			text: '����',
			iconCls: 'icon-add',
			handler: function(button) {
				var window = Ext.getCmp('clients-form-window');
				if (!window) {
					window = new is.window.Clients();
				}
				/* clear all data remained in the window. */
				window.clear();
				/* 
				 * if we open clients window with selected car in resource view,
				 * fill car's id in clients window.
				 */
				var rv = Ext.getCmp('clients-resource-view');
				if (rv.pressed) {
					var record = clientsResourcesGrid.getSelectionModel().getSelected();
					if (record) {
						var id = record.get('id');
						window.fillCar(id);
					}
				}
				window.show();
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-remove',
			id: 'removeClients',
			disabled: true,
			handler: function() {
				Ext.Msg.show({
					title:'ȷ��ɾ��', 
					msg:'��ȷ��Ҫɾ�������¼?',
					buttons: Ext.Msg.YESNOCANCEL,
					icon: Ext.MessageBox.QUESTION,
					fn: function(buttonId) {
						if (buttonId == 'yes') {
							var selected = clientsGrid.getSelectionModel().getSelected();
							if (!selected) return;
							var id = selected.get('clientsId');
							Ext.Ajax.request({
								url: 'removeClient.action',
								params: { 'clientsId': id },
								success: function(response, opt) {
									//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
									clientsStore.reload();
								},
								failure: function(response, opt) {
									Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
								}
							});
						}
					}
				});
			}
		}, '-', {
			text: 'Excel����',
			iconCls: 'icon-leading-out',
			handler: importClientsFromExcel
		}, {
			text: 'Excel����',
			iconCls: 'icon-leading-out',
			handler: function() {
				var type = Ext.getCmp('clients-find-type').getValue();
				var value = Ext.getCmp('clients-search').getValue();
				window.open('exportClientsExcel.action?findType=' + type + '&findValue=' + value);
			}
		}, {
			text: 'Excel��������',
			iconCls: 'icon-out',
			handler: function() {
				window.open('exportAllClientsExcel.action');
			}
		},{
			text: '��ӡ',
			iconCls: 'icon-printer',
			handler: function(){
			}
			},
			 '-', {
			text: '����',
			iconCls: 'icon-pkg',
			id: 'traceClients',
			disabled: true,
			handler: function() {
			},
			scope: this
		}, {
			text: '��ϸ',
			id: 'clients-detail',
			iconCls: 'icon-prop',
			handler: function() {
				var rv = Ext.getCmp('clients-resource-view');
				if (rv.pressed) {
					var win = Ext.getCmp('car-information-window');
					if (!win) {
						win = new is.window.Car();
					}
					win.open(clientsResourcesGrid.getSelectionModel().getSelected().get('id'));
					win.show();
				} else {
					var win = Ext.getCmp('clients-form-window');
					if (!win) {
						win = new is.window.Clients();
					}
					win.open(clientsGrid.getSelectionModel().getSelected().get('id'));
					win.show();
				}
			},
			scope: this
		}, {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				clientsStore.reload();
			},
			scope:this
		}, '-', {
			text: '��',
			enableToggle: true,
			id: 'clients-sheet-view',
			iconCls: 'icon-prop',
			pressed: true,
			toggleGroup: 'clients-view-group',
			scope: this,
			toggleHandler: function(btn, pressed) {
				if (pressed) {
					clientsResourcesGrid.hide();
					clientsGrid.show();
				}
			}
		}, {
			text: '������Դ',
			id: 'clients-resource-view',
			enableToggle: true,
			iconCls: 'icon-prop',
			pressed: false,
			toggleGroup: 'clients-view-group',
			toggleHandler: function(btn, pressed) {
				if (pressed) {
					clientsGrid.hide();
					clientsResourcesGrid.show();
					Ext.getCmp('removeClients').setDisabled(true);
				}
			}
		}, '->', '����:', {
			xtype: 'combo',
			id: 'clients-find-type',
			store: new Ext.data.ArrayStore({
				fields: [ 'findType', 'findTypeName' ],
				data: [
					[ 'id', '���ⵥ��' ],
					[ 'vcode', '����' ],
					[ 'owner', '����' ],
					[ 'model', '����' ],
					[ 'hardware', '���ܺ�' ],
					[ 'tel', '�绰' ],
					[ 'cellphone', '�ֻ�' ],
					[ 'clients', '�ջ���' ],
					[ 'salesman', '����' ],
					[ 'salesmanager', '���۾���' ],
					[ 'purchaseDate', '��������' ]
				]
			}),
			mode: 'local',
			triggerAction: 'all',
			displayField: 'findTypeName',
			valueField: 'findType',
			//emptyText: '',
			width: 75,
			selectOnFocus: true,
			forceSelection: true,
			editable: false,
			listeners: {
				'select': function(combo) {
					var sf = Ext.getCmp('clients-search');
					if (sf) {
						sf.setSearchType(combo.getValue());
					}
				}, 
				scope: this
			}
		}, ' ', {
			xtype: 'is-search-field',
			id: 'clients-search',
			store: clientsStore,
			paramName: 'findValue',
			paramTypeName: 'findType'
		}, ' '
	);
       
	clientsPanel.add(clientsGrid);
	clientsPanel.add(clientsResourcesGrid);
	clientsPanel.getBottomToolbar().hide();
	clientsPanel.doLayout();	
	
	clientsGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('removeClients').setDisabled(sm.getCount() > 1);
		Ext.getCmp('traceClients').setDisabled(sm.getCount() > 1);
		Ext.getCmp('clients-detail').setDisabled(sm.getCount() > 1);
	});
	
	clientsResourcesGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('traceClients').setDisabled(sm.getCount() > 1);
		Ext.getCmp('clients-detail').setDisabled(sm.getCount() > 1);
	});

});
</script>
</head>
<body>
<div id="clientsPanel"></div>
<div id="clientsWindow"></div>
<div id="clientsGridPanel"></div>
<div id="clientsExcelUploadForm"></div>
<div id="clientsExcelUpload"></div>
<div id="clientsExelUploadPreviewForm"></div>
<div id="clientsExportExcelForm"></div>
</body>
</html>