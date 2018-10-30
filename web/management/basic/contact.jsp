<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/contact/contact.js"></script>
<script type="text/javascript" src="js/contact/contactClient.js"></script>
<script type="text/javascript" src="js/contact/clientSelector.js"></script>
<script type="text/javascript">

Ext.onReady(function(){

	var openAddContact = function() {
		var contact = Ext.getCmp('newContactWindow');
		if (!contact) {
			contact = new is.window.Contact();
		}
		contact.setTitle('����');
		contact.reset();
//		Ext.getCmp('contact_type').setValue(Ext.getCmp('contact-find-type').getValue());
		contact.show();
	};
	
	var delContact = function() {
		Ext.Msg.show({
			title:'ȷ��ɾ��', 
			msg:'��ȷ��Ҫɾ������ϵ����?',
			buttons: Ext.Msg.YESNOCANCEL,
			icon: Ext.MessageBox.QUESTION,
			fn: function(buttonId) {
				if (buttonId == 'yes') {
					var selected = Ext.getCmp('contact-contacts-grid').getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'removeContact.action',
						params: { 'id': id },
						success: function(response, opt) {
							//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
							contactStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingcontact = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = Ext.getCmp('contact-contacts-grid').getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeContact.action',
						params: { 'id': id ,'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								contactStore.reload();
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
	
	var suspendedcontact = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = Ext.getCmp('contact-contacts-grid').getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeContact.action',
					params: { 'id': id ,'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							contactStore.reload();
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
	
	var openUpdContact = function() {

		var contactId = Ext.getCmp('contact-contacts-grid').getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newContactWindow');
		if (!window) {
			window = new is.window.Contact();
		}
		window.open(contactId);
		window.setTitle('����');
		window.show();
	};
	
	var importContactFromExcel = function() {
		var contactFromExcel = Ext.getCmp('contact-uplaod-excel-window');
		if (!contactFromExcel) {
			contactFromExcel = new is.window.ContactExcel();
		}
		contactFromExcel.reset();
		contactFromExcel.show();
	};
	
	var contactStore = new Ext.data.JsonStore({
		id: 'contactStore',
        autoDestroy:true,
        baseParams: {status: ['Using', 'Suspended']},
        autoLoad:{ params: {start: 0, limit: 25,states: ['Using', 'Suspended']} },
		url: "findContact.action",
		root: "ContactList",
		idProperty: "id",
		fields: ['id', 'code','name','sex','tel','mobile','idnum','ClientList',{name:'state',type:'int'}]	
	});
	
	var clientStore = new Ext.data.JsonStore({
		id: 'clientStore',
        autoDestroy:true,
        baseParams: {states: ['Using']},
		root: "ClientList",
		idProperty: "id",
		fields: ['id', 'code','name','address','tel','zipcode',{name:'individual',type:'int'},'ContactList',{name:'state',type:'int'}]	
	});
	
	var contactPanel = Ext.getCmp('contact-mainpanel');
	
	clsys.form.Util.PagingToolbar(contactStore, contactPanel.bbar, 'contact-info-paging');
	
	contactPanel.getTopToolbar().add({
		text: '����',
		id: 'addContact',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddContact
	},{
		text: 'ɾ��',
		id: 'delContact',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delContact
	},{
		text: '����',
		id: 'updContact',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdContact
	},{
		text: '����',
		id: 'usingcontact',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcontact
	},{
		text: '����',
		id: 'suspendedcontact',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcontact
	},{
		text: '�ͻ���Ϣ',
		id: 'contact-preview-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('contact-preview-grid');
			if (pressed) {
				preview.show();
			} else {
				preview.hide();
			}
			contactPanel.doLayout();
		}
	}, '-','��ѯ:',{
		xtype: 'is-search-field',
		id: 'contact-search',
		store: contactStore
	}, '->',{
		text: '��ӡ',
		iconCls: 'icon-printer',
		handler: function(){
		}
		}, '-', {
		text: 'ˢ��',
		iconCls: 'icon-refresh',
		handler: function() {
			contactStore.reload();
		},
		scope:this
	}, {
		text: 'Excel����',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('contact-find-type').getValue();
			var value = Ext.getCmp('contact-search').getValue();
			window.open('exportContactExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel��������',
		
		iconCls: 'icon-out',
		handler: function() {
			window.open('exportAllContactExcel.action');
		}
	},' '
);
	contactPanel.add({
		xtype: 'grid',
		id: 'contact-contacts-grid',
		anchor: '100% 65%',
		store: contactStore,
		stripeRows: true,
		autoScroll:true,
	 	border: false,
	 	renderTo: 'contactGridPanel',
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
	}, {
		xtype: 'grid',
		id: 'contact-preview-grid',
		anchor: '100% 35%',
		store: clientStore,
		stripeRows: true,
		autoScroll: true,
		hidden: true,
		frame: false,
		tbar: ['Ԥ���ͻ�', '->', {
			iconCls: 'icon-remove',
			text: '�ر�Ԥ��',
			handler: function() {
				Ext.getCmp('contact-preview-button').toggle();
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
					  {header: '�绰', dataIndex: 'tel'},
					  {header: '��ַ', dataIndex: 'address'},
					  {header: '��������', dataIndex: 'zipcode'},
					  {header: '�ͻ����', renderer: clsys.grid.columnrender.ContactRender, dataIndex: 'individual'},
					  {header: '״̬',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'} 	        	
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	contactPanel.getBottomToolbar().hide();
	contactPanel.doLayout();

	Ext.getCmp('contact-contacts-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updContact').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delContact').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedcontact').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingcontact').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				clientStore.removeAll();
				if (record.json.ClientList) {
					
					clientStore.loadData(record.json);
				}
			}
		}
	});
	
});
</script>
</head>
<body>
<div id="contactPanel"></div>
<div id="contactWindow"></div>
<div id="contactGridPanel"></div>
</body>
</html>