<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�������</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageOutcomingAduit = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['Checking'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['Checking']},
	  	url:'findStorageOutcoming.action',
	  	totalProperty:'results',
	  	root:'StorageOutcomingList',
	  	idProperty:'id',
	  	fields:['id','socNo','socDate','socItems','printDate',
	  		  	'totalAmount','totalSum','totalSumWithoutTax','totalTaxAmount',
	  		  	{name:'state',type:'int'},
	  	        {name:'company',mapping:'contract.company.name'},
	  	      	{name:'contractNo',mapping:'contract.contractNo'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}]
  	});

	var storageOutcomingAduitGetItemsStore = new Ext.data.JsonStore({
  		url:'getStorageOutcoming.action',
  		root:'StorageOutcoming',
		fields: ['id','socItems']
  	});

  	var storageOutcomingAduitItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'socItems',
  		fields:['id',
  		  		 {name:'socItemNo',type:'int'},
  		      	 {name:'productID',mapping:'id'},
		  	     {name:'productName',mapping:'product.productName'},
			     {name:'productCode',mapping:'product.productCode.code'},
			     {name:'unit',mapping:'product.unit.name'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'},
		         {name:'storageLocation_id',mapping:'storageLocation.id'},
		         {name:'storageLocation',mapping:'storageLocation.name'},		         
		         'amount','price','subTotal','subTotalWithoutTax','priceWithoutTax','taxAmount','tax','memo' 
		        ],
		sortInfo: {field: 'socItemNo',direction: 'ASC'}
  	});

	var showItems = function(sm){
		Ext.getCmp('storageOutcomingAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageOutcomingAduitGetItemsStore.removeAll();
		storageOutcomingAduitItemsStore.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('storageOutcomingAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageOutcomingAduitGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageOutcomingAduitGetItemsStore.getAt(0);
						if (rc) {
							storageOutcomingAduitItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var CheckerStorageOutcomingAduitHandler = function(storageOutomingID,isSuccess){
		var url = 'aduitByCheckerStorageOutcoming.action';
		var aduit;
		if (isSuccess) {aduit=2} else {aduit=1}
		var params = {id:storageOutomingID,aduit:aduit};
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageOutcomingAduit.reload();
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
	
	var CheckerStorageOutcomingAduit = function(isSuccess){
		var sm = Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageOutomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('socNo');
		if (Ext.isEmpty(strName) && isSuccess) {
			clsys.message.info("���ȴ�ӡ���ⵥ���ٽ������"); 
			return;
		}
		var strSuccess = '';
		if (!isSuccess){strSuccess = '��';}
		var strMessage = 'ȷ���Ƿ����' + strSuccess + 'ͨ��,���ⵥ���Ϊ ['+ strName +'] �ĳ��ⵥ';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				CheckerStorageOutcomingAduitHandler(storageOutomingID,isSuccess);
			}
		});	
	};

	var btnStorageOutcomingCheckerAduitSuccess = {
			text:'���ͨ��',
			iconCls:'icon-add',
			handler:function(){CheckerStorageOutcomingAduit(true);},
			scope:this
		};
		
	var btnStorageOutcomingCheckerAduitFailure = {
			text:'���ʧ��',
			iconCls:'icon-remove',
			handler:function(){CheckerStorageOutcomingAduit(false);},
			scope:this
	};
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){storageOutcomingAduit.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '��ϸ������Ϣ',
		id: 'storageOutcomingAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageOutcomingAduitItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageOutcomingAduitPanel.doLayout();			
		}
	};
	
	var storageOutcomingAduitGrid = {
		xtype:'grid',
		id:'storageOutcomingAduit-grid',
		anchor:'100% 65%',
		store:storageOutcomingAduit,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		renderTo:'storageOutcomingAduitGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[      
				{header:'���ⵥ���',width:100,dataIndex:'socNo'},
				{header:'��ͬ��',width:100,dataIndex:'contractNo'},
				{header:'������λ����',width:100,dataIndex:'company'},
				{header:'��Ʊ����',width:50,dataIndex:'printDate'},
				{header:'�����ܼ�',width:50,dataIndex:'totalAmount'},
				{header:'����ܼ�',width:50,dataIndex:'totalSum'},	
				{header:'����˰����ܼ�',width:60,dataIndex:'totalSumWithoutTax'},
				{header:'˰���ܼ�',width:50,dataIndex:'totalTaxAmount'},
				{header:'��Ա���',width:40,dataIndex:'empCode',hidden:true},
				{header:'����',width:40,dataIndex:'empName',hidden:true},
				{header:'���״̬',width:40,renderer:clsys.grid.columnrender.StorageOutcomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var storageOutcomingAduitItemsGrid = {
		xtype:'grid',
		id:'storageOutcomingAduitItems-grid',
		anchor:'100% 35%',
		store:storageOutcomingAduitItemsStore,
		stripeRows:true,
		autoScroll:true,
		hidden:true,
		loadMask:true,
		border:false,
		renderTo:'storageOutcomingAduitItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
	 		    {header: '���', width:25,dataIndex: 'socItemNo'},
	 		    {header: '��Ʒ���Ƽ��ͺ�',width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'productID'},
	 			{header: '��λ', width:25,dataIndex: 'unit'},
	 			{header: '����', width:25,dataIndex: 'amount'},
	 			{header: '����', width:30,dataIndex: 'price'},
	 			{header: '����˰����', width:50,dataIndex: 'priceWithoutTax'},
	 			{header: '���', width:50,dataIndex: 'subTotal'},
	 			{header: '����˰���',width:50, dataIndex: 'subTotalWithoutTax'},
	 			{header: '˰��', width:25,dataIndex: 'tax'},
	 			{header: '˰��', width:50,dataIndex: 'taxAmount'},
	 			{header: '��λ', width:80,dataIndex: 'storageLocation'},
	 			{header: '��ע', width:80,dataIndex: 'memo'}		
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar: ['<b>Ԥ��</b>', {
			iconCls: 'icon-remove',
			text: '�ر�Ԥ��',
			handler: function() {
				Ext.getCmp('storageOutcomingAduit-showitems-button').toggle();
			}
		}]
	};	

		
	var storageOutcomingAduitPanel = Ext.getCmp('StorageOutcomingAudit-mainpanel');
	storageOutcomingAduitPanel.add(storageOutcomingAduitGrid,storageOutcomingAduitItemsGrid);
	storageOutcomingAduitPanel.getTopToolbar().add(btnStorageOutcomingCheckerAduitSuccess,btnStorageOutcomingCheckerAduitFailure,btnShowItems,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '��������',
		width:300,
		store: storageOutcomingAduit
	});
	clsys.form.Util.PagingToolbar(storageOutcomingAduit, storageOutcomingAduitPanel.bbar, 'storageOutcomingAduit-paging');
	
	storageOutcomingAduitPanel.doLayout();

	Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="storageOutcomingAduitPanel"></div>
<div id="storageOutcomingAduitGridPanel"></div>
<div id="storageOutcomingAduitItemsPanel"></div>
</body>
</html>