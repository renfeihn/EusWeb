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
		contact.setTitle('新增');
		contact.reset();
//		Ext.getCmp('contact_type').setValue(Ext.getCmp('contact-find-type').getValue());
		contact.show();
	};
	
	var delContact = function() {
		Ext.Msg.show({
			title:'确认删除', 
			msg:'你确定要删除该联系人吗?',
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
							//Ext.Msg.alert('消息', '删除成功!');
							contactStore.reload();
						},
						failure: function(response, opt) {
							Ext.Msg.alert('错误', '删除错误，消息:' + response.responseText);
						}
					});
				}
			}
		});
	};
	
	var usingcontact = function() {
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
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
	
	var suspendedcontact = function() {
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
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
	
	var openUpdContact = function() {

		var contactId = Ext.getCmp('contact-contacts-grid').getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('newContactWindow');
		if (!window) {
			window = new is.window.Contact();
		}
		window.open(contactId);
		window.setTitle('更改');
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
		text: '新增',
		id: 'addContact',
//		disabled: true,
		iconCls: 'icon-add',
		handler: openAddContact
	},{
		text: '删除',
		id: 'delContact',
		disabled: true,
		iconCls: 'icon-remove',
		handler: delContact
	},{
		text: '更新',
		id: 'updContact',
		disabled: true,
		iconCls: 'icon-update',
		handler: openUpdContact
	},{
		text: '启用',
		id: 'usingcontact',
		disabled: true,
		iconCls: 'icon-using',
		handler: usingcontact
	},{
		text: '禁用',
		id: 'suspendedcontact',
		disabled: true,
		iconCls: 'icon-suspended',
		handler: suspendedcontact
	},{
		text: '客户信息',
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
	}, '-','查询:',{
		xtype: 'is-search-field',
		id: 'contact-search',
		store: contactStore
	}, '->',{
		text: '打印',
		iconCls: 'icon-printer',
		handler: function(){
		}
		}, '-', {
		text: '刷新',
		iconCls: 'icon-refresh',
		handler: function() {
			contactStore.reload();
		},
		scope:this
	}, {
		text: 'Excel导出',
		iconCls: 'icon-leading-out',
		handler: function() {
			var type = Ext.getCmp('contact-find-type').getValue();
			var value = Ext.getCmp('contact-search').getValue();
			window.open('exportContactExcel.action?type=' + type + '&findValue=' + value);
		}
	}, {
		text: 'Excel导出所有',
		
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
 	        		  {header: '编号', dataIndex: 'id'},
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '姓名', dataIndex: 'name'},
	 	 	          {header: '性别', dataIndex: 'sex'},
	 	 	          {header: '电话', dataIndex: 'tel'},
	 	 	          {header: '移动电话', dataIndex: 'mobile'},
	 	 	          {header: '证件号码', dataIndex: 'idnum'},
	 	 	          {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}	
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
		tbar: ['预览客户', '->', {
			iconCls: 'icon-remove',
			text: '关闭预览',
			handler: function() {
				Ext.getCmp('contact-preview-button').toggle();
			}
		}],
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: { 	 
 	            sortable: true
 	        },	        
 	        columns: [
					  {header: '编号', dataIndex: 'id'},
					  {header: '编码', dataIndex: 'code'},
					  {header: '姓名', dataIndex: 'name'},
					  {header: '电话', dataIndex: 'tel'},
					  {header: '地址', dataIndex: 'address'},
					  {header: '邮政编码', dataIndex: 'zipcode'},
					  {header: '客户类别', renderer: clsys.grid.columnrender.ContactRender, dataIndex: 'individual'},
					  {header: '状态',renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'} 	        	
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