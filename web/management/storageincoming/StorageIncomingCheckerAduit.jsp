<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�������</title> 
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	//'CheckerAduit','CheckerFailed','ManagerAduit','ManagerFaild','AduitSuccess'
	//'Using','Deleted'   
	var storageIncomingCheckerAduit_JSP_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{states:['CheckerAduit','ManagerAduit'],
			 	  		  status:['Using','Deleted'],start:0,limit:25}},
		baseParams:{states:['CheckerAduit','ManagerAduit'],status:['Using','Deleted']},
		url:'findStorageIncoming.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingList',
	  	idProperty:'id',
	  	fields:['id','sicNo','sicDate','totalAmount',
	  	      	{name:'state',type:'int'},
	  	 		{name:'empCode',mapping:'creator.name'},
	  	        {name:'empName',mapping:'creator.code'}]
  	});

	var storageIncomingCheckerAduitGetItems_JSP_Store = new Ext.data.JsonStore({
  		url:'getStorageIncoming.action',
  		root:'StorageIncoming',
		fields: ['id','items']
  	});

  	var storageIncomingCheckerAduitItems_JSP_Store = new Ext.data.JsonStore({
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

	var showCheckerAduitItems = function(sm){
		Ext.getCmp('storageIncomingCheckerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageIncomingCheckerAduitGetItems_JSP_Store.removeAll();
		storageIncomingCheckerAduitItems_JSP_Store.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('storageIncomingCheckerAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageIncomingCheckerAduitGetItems_JSP_Store.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageIncomingCheckerAduitGetItems_JSP_Store.getAt(0);
						if (rc) {
							storageIncomingCheckerAduitItems_JSP_Store.loadData(rc.json);
						}
					}
				});

			}
		}		
	};
  	
	var CheckerAduitHandler = function(storageIncomingID,isSuccess){
		var url = 'aduitByCheckerStorageIncoming.action';
		var aduit;
		if (isSuccess) {aduit=2} else {aduit=1}
		var params = {id:storageIncomingID,aduit:aduit};
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageIncomingCheckerAduit_JSP_Store.reload();
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

	var CheckerAduit = function(isSuccess){
		var sm = Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('sicNo');
		var strSuccess = '';
		if (!isSuccess){strSuccess = '��';}
		var strMessage = 'ȷ���Ƿ����' + strSuccess + 'ͨ��,�����Ϊ ['+ strName +'] ����ⵥ';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				CheckerAduitHandler(storageIncomingID,isSuccess);
			}
		});	
	};
	  	
	var btnCheckerAduitSuccess = {
		text:'����ͨ��',
		iconCls:'icon-add',
		handler:function(){CheckerAduit(true);},
		scope:this
	};
	
	var btnCheckerAduitFailure = {
		text:'����ʧ��',
		iconCls:'icon-remove',
		handler:function(){CheckerAduit(false);},
		scope:this
	};	
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){storageIncomingCheckerAduit_JSP_Store.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '��ϸ��Ϣ',
		id: 'storageIncomingCheckerAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageIncomingCheckerAduitItems-grid');
			if (pressed) {
				preview.show();
				showCheckerAduitItems(Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageIncomingCheckerAduitPanel.doLayout();			
		}
	};
	
	this.storageIncomingCheckerAduitGrid = {
		xtype:'grid',
		id:'storageIncomingCheckerAduit-grid',
		anchor:'100% 65%',
		store:storageIncomingCheckerAduit_JSP_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		renderTo:'storageIncomingCheckerAduitGridPanel',
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

		        
	this.storageIncomingCheckerAduitItemsGrid = {
			xtype:'grid',
			id:'storageIncomingCheckerAduitItems-grid',
			anchor:'100% 35%',
			store:storageIncomingCheckerAduitItems_JSP_Store,
			stripeRows:true,
			autoScroll:true,
			hidden:true,
			border:false,
			renderTo:'storageIncomingCheckerAduitItemsPanel',
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
					Ext.getCmp('storageIncomingCheckerAduit-showitems-button').toggle();
				}
			}]
		};	

		
	var storageIncomingCheckerAduitPanel = Ext.getCmp('StorageIncomingCheckerAudit-mainpanel');
	storageIncomingCheckerAduitPanel.add(this.storageIncomingCheckerAduitGrid,this.storageIncomingCheckerAduitItemsGrid);
	storageIncomingCheckerAduitPanel.getTopToolbar().add(btnCheckerAduitSuccess,btnCheckerAduitFailure,btnShowItems,btnRefresh);
	clsys.form.Util.PagingToolbar(storageIncomingCheckerAduit_JSP_Store, storageIncomingCheckerAduitPanel.bbar, 'storageIncomingCheckerAduit-paging');
	storageIncomingCheckerAduitPanel.doLayout();

	Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('storageIncomingCheckerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				storageIncomingCheckerAduitItems_JSP_Store.removeAll();
				storageIncomingCheckerAduitItems_JSP_Store.loadData(record.json);			
			}
		}
	});	

	Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showCheckerAduitItems(sm)
	});	
  	
  });
</script>
</head>
<body>
<div id="storageIncomingCheckerAduitPanel"></div>
<div id="storageIncomingCheckerAduitGridPanel"></div>
<div id="storageIncomingCheckerAduitItemsPanel"></div>
</body>
</html>