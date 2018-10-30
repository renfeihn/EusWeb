<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>

<script type="text/javascript" src="js/clients/client.js"></script>
<script type="text/javascript" src="js/clients/clientInfo.js"></script>
<script type="text/javascript" src="js/clients/clientContact.js"></script>
<script type="text/javascript" src="js/clients/contactSelectors.js"></script>
<script type="text/javascript">

Ext.onReady(function(){

	var openAddClient = function() {
		var client = Ext.getCmp('newClientWindow');
		if (!client) {
			client = new is.window.Client();
		}
		client.setTitle('����');
		client.reset();
//		Ext.getCmp('client_type').setValue(Ext.getCmp('client-find-type').getValue());
		client.show();
	};
	
	var delClient = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ�����ݿ��м�¼?',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = Ext.getCmp('client-clients-grid').getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeClient.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							clientStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};

	var usingClient = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = Ext.getCmp('client-clients-grid').getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeClient.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								clientStore.reload();
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
	
	var suspendedClient = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = Ext.getCmp('client-clients-grid').getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeClient.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							clientStore.reload();
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
	var openUpdClient = function() {

		var clientId = Ext.getCmp('client-clients-grid').getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newClientWindow');
		if (!window) {
			window = new is.window.Client();
		}
		window.open(clientId);
		window.setTitle('����');
		window.show();
	};
	
	var importClientFromExcel = function() {
		var clientFromExcel = Ext.getCmp('client-uplaod-excel-window');
		if (!clientFromExcel) {
			clientFromExcel = new is.window.ClientExcel();
		}
		clientFromExcel.reset();
		clientFromExcel.show();
	};
	
	var clientStore = new Ext.data.JsonStore({
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25, status: ['Using', 'Suspended']} },
		url: "findClient.action",
		root: "ClientList",
		idProperty: "id",
		fields: ['id', 'code','name','address','tel','zipcode',{name:'individual',type:'int'},'ContactList',{name:'state',type:'int'}]	
	});

	var contactStore = new Ext.data.JsonStore({
        autoDestroy:true,
		root: "ContactList",
		idProperty: "id",
		fields: ['id', 'code','name','sex','tel','mobile','idnum','client',{name:'state',type:'int'}]	
	});
	
	var clientPanel = Ext.getCmp('client-mainpanel');
	
	clsys.form.Util.PagingToolbar(clientStore, clientPanel.bbar, 'client-info-paging');
	
	clientPanel.getTopToolbar().add({
		text: '����',
		id: 'addClient',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddClient
		/*
		handler: function(button, event) {
			var client = Ext.getCmp('client-form-window');
			if (!client) {
				client = new is.window.Client();
			}
			client.setTitle('�����ͻ�');
			client.reset();
			client.show();
		}*/
	},{
		text: 'ɾ��',
		id: 'delClient',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delClient
	},{
		text: '����',
		id: 'updClient',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdClient
	},{
		text: '����',
		id: 'usingClient',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingClient
	},{
		text: '����',
		id: 'suspendedClient',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedClient
	}, {
		text: '��ϵ��',
		id: 'client-preview-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('client-preview-grid');
			if (pressed) {
				preview.show();
			} else {
				preview.hide();
			}
			clientPanel.doLayout();
		}
	}, '-',
	 '��ѯ:', {
		xtype: 'is-search-field',
		id: 'client-search',
		store: clientStore
	}, '->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
	},'-', {
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
			clientStore.reload();
		},
		scope:this
	},{
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('client-find-type').getValue();
			var value = Ext.getCmp('client-search').getValue();
			window.open('exportClientExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel��������',
		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllClientExcel.action');
		}
	},' '
);
	var clientRender = function(id) {
/*		var record = clientStore.findExact('id', id);
		if (index != -1) {
			var record = clientStore.getAt(index);
			var name = record.get('name');
			return '<span><a href="#" onclick="openClient(\'' + record.get('id') + '\');">' + name + '</a></span>';
		} else {
			return '<span></span>';
		}*/
		var record = clientStore.getById(id);
		if (record) {
			var name = record.get('name');
			return '<span><a href="#" onclick="openClient(\'' + record.get('id') + '\');">' + name + '</a></span>';
		} else {
			return '<span></span>';
		}
	};
	
	clientPanel.add({
		xtype: 'grid',
		id: 'client-clients-grid',
		anchor: '100% 65%',
		store: clientStore,
		stripeRows: true,
		autoScroll:true,
	 	border: false,
	 	renderTo: 'clientGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: { 	 
 	            sortable: true
 	        },	        
 	        columns: [
					  {header: '���', dataIndex: 'id'},
					  {header: '����', dataIndex: 'code'},
					  {header: '����', renderer: clientRender,dataIndex: 'id'},
					  {header: '�绰', dataIndex: 'tel'},
					  {header: '��ַ', dataIndex: 'address'},
					  {header: '��������', dataIndex: 'zipcode'},
					  {header: '�ͻ����', renderer: clsys.grid.columnrender.ContactRender, dataIndex: 'individual'},
					  {header: '״̬', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}, {
		xtype: 'grid',
		id: 'client-preview-grid',
		anchor: '100% 35%',
		store: contactStore,
		stripeRows: true,
		autoScroll: true,
		hidden: true,
		frame: false,
		tbar: ['Ԥ����ϵ��'
		       , '->', {
			iconCls: 'icon-remove',
			text: '�ر�Ԥ��',
			handler: function() {
				Ext.getCmp('client-preview-button').toggle();
			}
		}],
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: { 	 
 	            sortable: true
 	        },	        
 	        columns: [
 	        		  {header: '���', dataIndex: 'id'},
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: '�Ա�', dataIndex: 'sex'},
	 	 	          {header: '�绰', dataIndex: 'tel'},
	 	 	          {header: '�ƶ��绰', dataIndex: 'mobile'},
	 	 	          {header: '֤������', dataIndex: 'idnum'},
	 	 	          {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}	 	        	
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	clientPanel.getBottomToolbar().hide();
	clientPanel.doLayout();

	Ext.getCmp('client-clients-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updClient').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delClient').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedClient').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingClient').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				contactStore.removeAll();
				contactStore.loadData(record.json);
			}
		}
	});
	
});
</script>
</head>
<body>
<div id="clientPanel"></div>
<div id="clientWindow"></div>
<div id="clientGridPanel"></div>
</body>
</html>