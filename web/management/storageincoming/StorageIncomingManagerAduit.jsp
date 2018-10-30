<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��Ʒ�����</title> 
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageIncomingManagerAduit_JSP_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{states:['ManagerAduit'],
						  status:['Using','Deleted'],start:0,limit:25}},
	    baseParams:{states:['ManagerAduit'],status:['Using','Deleted']},				  
	  	url:'findStorageIncoming.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingList',
	  	idProperty:'id',
	  	fields:['id','sicNo','sicDate','totalAmount',
	  	      	{name:'state',type:'int'},
	  	 		{name:'empCode',mapping:'creator.name'},
	  	        {name:'empName',mapping:'creator.code'}]
  	});

	var storageIncomingManagerAduitGetItems_JSP_Store = new Ext.data.JsonStore({
  		url:'getStorageIncoming.action',
  		root:'StorageIncoming',
		fields: ['id','items']
  	});

  	var storageIncomingManagerAduitItems_JSP_Store = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
		fields: ['id','sicItemNo','amount','jobCmdNo','productionDate',
		         {name:'storageLocation_id',mapping:'storageLocation.id'},
		         {name:'storageLocation',mapping:'storageLocation.name'},		         
		  	     {name:'productID',mapping:'id'},
		  	     {name:'schedule',mapping:'schedule.scheduleNo'},		         
		  	     {name:'productName',mapping:'product.productName'},
			     {name:'productCode',mapping:'product.productCode.code'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'}
			    ]
  	});

	var showManagerAduitItems = function(sm){
		Ext.getCmp('storageIncomingManagerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageIncomingManagerAduitGetItems_JSP_Store.removeAll();
		storageIncomingManagerAduitItems_JSP_Store.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('storageIncomingManagerAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageIncomingManagerAduitGetItems_JSP_Store.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageIncomingManagerAduitGetItems_JSP_Store.getAt(0);
						if (rc) {
							storageIncomingManagerAduitItems_JSP_Store.loadData(rc.json);
						}
					}
				});

			}
		}		
	};

	var ManagerAduitHandler = function(storageIncomingID,isSuccess){
		var url = 'aduitByManagerStorageIncoming.action';
		var aduit;
		if (isSuccess) {aduit=4} else {aduit=3}
		var params = {id:storageIncomingID,aduit:aduit};
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageIncomingManagerAduit_JSP_Store.reload();
			}
			else {
				clsys.message.error(result.msg);
			}
		};
		/*ʧ��ʱ�Ĵ�����*/
		var failureFunc = function(response,opts){
			clsys.message.systemerror(response.responseText.msg);
		};
		/*ʹ��AJAX�������*/
		Ext.Ajax.request({
			url:url,
			success:successFunc,
			failure:failureFunc,
			params:params,
			scope:this
		});	
	};

	var ManagerAduit = function(isSuccess){
		var sm = Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('sicNo');
		var strSuccess = '';
		if (!isSuccess){strSuccess = '��';}
		var strMessage = 'ȷ���Ƿ����' + strSuccess + 'ͨ��,�����Ϊ ['+ strName +'] ����ⵥ';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				ManagerAduitHandler(storageIncomingID,isSuccess);
			}
		});	
	};
	
	var btnManagerAduitSuccess = {
		text:'���ͨ��',
		iconCls:'icon-add',
		handler:function(){ManagerAduit(true);},
		scope:this
	};
	
	var btnManagerAduitFailure = {
		text:'���ʧ��',
		iconCls:'icon-remove',
		handler:function(){ManagerAduit(false);},
		scope:this
	};	
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){storageIncomingManagerAduit_JSP_Store.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '��ϸ��Ϣ',
		id: 'storageIncomingManagerAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageIncomingManagerAduitItems-grid');
			if (pressed) {
				preview.show();
				showManagerAduitItems(Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageIncomingManagerAduitPanel.doLayout();			
		}
	};
	
	this.storageIncomingManagerAduitGrid = {
		xtype:'grid',
		id:'storageIncomingManagerAduit-grid',
		anchor:'100% 65%',
		store:storageIncomingManagerAduit_JSP_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		renderTo:'storageIncomingManagerAduitGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��ⵥ��',dataIndex:'sicNo'},
				{header:'�����ܼ�',dataIndex:'totalAmount'},
				{header:'��ⵥ����',dataIndex:'sicDate'},
				{header:'��Ա���',dataIndex:'empCode'},
				{header:'����',dataIndex:'empName'},
				{header:'���״̬',renderer:clsys.grid.columnrender.StorageIncomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

		        
	this.storageIncomingManagerAduitItemsGrid = {
			xtype:'grid',
			id:'storageIncomingManagerAduitItems-grid',
			anchor:'100% 35%',
			store:storageIncomingManagerAduitItems_JSP_Store,
			stripeRows:true,
			autoScroll:true,
			hidden:true,
			border:false,
			renderTo:'storageIncomingManagerAduitItemsPanel',
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
		 			{header: '���',width:30,dataIndex: 'sicItemNo'},
		 			{header: '��Ʒ���Ƽ��ͺ�', width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'productID'},
		 			{header: '�������', width:50, dataIndex: 'jobCmdNo'},
		 			{header: '��ѹ(V)',width:50, dataIndex: 'voltage'},
		 			{header: '����(PF)',width:50, dataIndex: 'capacity'},
		 			{header: '���', width:30,dataIndex: 'humidity'},
		 			{header: '�ȼ�', width:30,dataIndex: 'productCode'},
		 			{header: '����', width:50,dataIndex: 'amount'},
		 			{header: '��λ', width:80,dataIndex: 'storageLocation'},
		 			{header: '��������', width:60,dataIndex: 'productionDate'},
		 			{header: '��ע', width:110,dataIndex: 'schedule'}			
				]
			}),
			viewConfig:{ forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
			tbar: ['<b>��ϸ��Ϣ</b>', {
				iconCls: 'icon-remove',
				text: '�ر���ϸ��Ϣ',
				handler: function() {
					Ext.getCmp('storageIncomingManagerAduit-showitems-button').toggle();
				}
			}]
		};	

	var storageIncomingManagerAduitPanel = Ext.getCmp('StorageIncomingManagerAudit-mainpanel');
	storageIncomingManagerAduitPanel.add(this.storageIncomingManagerAduitGrid,this.storageIncomingManagerAduitItemsGrid);
	storageIncomingManagerAduitPanel.getTopToolbar().add(btnManagerAduitSuccess,btnManagerAduitFailure,btnShowItems,btnRefresh);
	clsys.form.Util.PagingToolbar(storageIncomingManagerAduit_JSP_Store, storageIncomingManagerAduitPanel.bbar, 'storageIncomingManagerAduit-paging');
	storageIncomingManagerAduitPanel.doLayout();

	Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('storageIncomingManagerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				storageIncomingManagerAduitItems_JSP_Store.removeAll();
				storageIncomingManagerAduitItems_JSP_Store.loadData(record.json);			
			}
		}
	});

	Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showManagerAduitItems(sm)
	});		
  	
  });
</script>
</head>
<body>
<div id="storageIncomingManagerAduitPanel"></div>
<div id="storageIncomingManagerAduitGridPanel"></div>
<div id="storageIncomingManagerAduitItemsPanel"></div>
</body>
</html>