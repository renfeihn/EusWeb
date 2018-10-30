<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��������</title>
<script type="text/javascript" src="js/storageoutcoming/StorageOutcoming.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();

	var contractForSOCStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['None','Part'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['None','Part']},
	  	url:'queryForSocContract.action',
	  	totalProperty:'results',
	  	root:'ContractList',
	  	idProperty:'id',
	  	fields:['id','contractNo','contractDate','items',
	  		  	'totalFinishedAmount','totalCheckingAmount','totalAmount','totalSum',
	  		    {name:'companyID',mapping:'company.id'},
	  	        {name:'company',mapping:'company.name'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}]
  	});
  	
	var storageOutcoming = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'findByContractStorageOutcoming.action',
	  	totalProperty:'results',
	  	root:'StorageOutcomingList',
	  	idProperty:'id',
	  	fields:['id','socNo','printDate','socItems',
	  		  	'totalAmount','totalSum','totalSumWithoutTax','totalTaxAmount',
	  		  	{name:'state',type:'int'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}],
	    sortInfo: {field: 'socNo',direction: 'DESC'}
  	});

	var storageOutcomingGetItemsStore = new Ext.data.JsonStore({
  		url:'getStorageOutcoming.action',
  		root:'StorageOutcoming',
		fields: ['id','socItems']
  	});

  	var storageOutcomingItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'socItems',
  		fields:['id',
  		  		 {name:'socItemNo',type:'int'},
  		      	 {name:'productID',mapping:'id'},
		  	     {name:'productName',mapping:'product.productName'},
		  	  	 {name:'productCombination',mapping:'product.productCombination'},
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

	var productCodeStoreForSocContract = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForSocContract = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForSocContract = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForSocContract = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var productTypeStoreForSocContract = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var txtContractForSocContract = {
		xtype:'textfield',
		id:'txtContractForSocContract',
		fieldLabel:'��ͬ��',
		width:220,
		name:'txtContractForSocContract'
	};
	
	var txtCompanyForSocContract = {
			xtype:'textfield',
			id:'txtCompanyForSocContract',
			fieldLabel:'��ͬ����',
			width:220,
			name:'txtCompanyForSocContract'
	};
		
	var txtProductCombinationForSocContract = {
		xtype:'textfield',
		id:'txtProductCombinationForSocContract',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForSocContract'
	};
	
	var txtVoltageForSocContract = {
		xtype:'textfield',
		id:'txtVoltageForSocContract',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForSocContract'
	};
	var txtCapacityForSocContract = {
		xtype:'textfield',
		id:'txtCapacityForSocContract',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForSocContract'
	};

	var cbProductCodeForSocContract = {
		xtype:'combo',
		store:productCodeStoreForSocContract,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForSocContract',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	var cbHumidityForSocContract = {
		xtype:'combo',
		store:humidityStoreForSocContract,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForSocContract',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	var cbErrorLevelForSocContract = {
		xtype:'combo',
		store:errorLevelStoreForSocContract,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForSocContract',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	var cbUsageTypeForSocContract = {
		xtype:'combo',
		store:usageTypeStoreForSocContract,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForSocContract',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	var cbProductTypeForSocContract = {
		xtype:'combo',
		store:productTypeStoreForSocContract,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForSocContract',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id',
		editable: true
	};

	var txtDateStartForSocContract = {
		xtype:'datefield',
		id:'txtDateStartForSocContract',
		fieldLabel:'��ͬ����(��ʼ)',
		width:220,
		name:'txtDateStartForSocContract'	
	};
	
	var txtDateEndForSocContract = {
		xtype:'datefield',
		id:'txtDateEndForSocContract',
		fieldLabel:'��ͬ����(����)',
		width:220,
		name:'txtDateEndForSocContract'	
	};
	
	var col1 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[txtProductCombinationForSocContract,cbProductCodeForSocContract,cbErrorLevelForSocContract,txtVoltageForSocContract,txtDateStartForSocContract,txtContractForSocContract]		
		};
		
		var col2 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[cbProductTypeForSocContract,cbHumidityForSocContract,cbUsageTypeForSocContract,txtCapacityForSocContract,txtDateEndForSocContract,txtCompanyForSocContract]		
		};
	
	
	 var contractQueryConditionPanelForSocContract = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'contractQueryConditionPanelForSocContract',
         items: [{		
			layout:'column',
			frame:false,
			border:false,
			items:[col1,col2]
		}],
		 buttonAlign:'left',
         buttons: [{
			text: '��ѯ',
			iconCls: 'icon-examine',
			handler: function(){
 				var attributes = {
 		 			contractNo:Ext.getCmp('txtContractForSocContract').getValue(),
 		 			companyName:Ext.getCmp('txtCompanyForSocContract').getValue(),
					productCombination:Ext.getCmp('txtProductCombinationForSocContract').getValue(),
					productCode:Ext.getCmp('cbProductCodeForSocContract').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForSocContract').getValue(),
					voltage:Ext.getCmp('txtVoltageForSocContract').getValue(),
					capacity:Ext.getCmp('txtCapacityForSocContract').getValue(),
					productType:Ext.getCmp('cbProductTypeForSocContract').getValue(),
					humidity:Ext.getCmp('cbHumidityForSocContract').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForSocContract').getValue(),
					contractSavedDateStart:Ext.getCmp('txtDateStartForSocContract').getValue(),
					contractSavedDateEnd:Ext.getCmp('txtDateEndForSocContract').getValue()
 		 	 	};
 				attributes.start = 0;
 				contractForSOCStore.reload({params:attributes});
  			}
		}]
     });
     
  	var showStorageOutcomingItems = function (sm){
		Ext.getCmp('storageOutcoming-showitems-button').setDisabled(sm.getCount() < 1);
		storageOutcoming.removeAll();
		storageOutcomingGetItemsStore.removeAll();
		storageOutcomingItemsStore.removeAll();
	
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageOutcoming.reload({
					params:{'contractID':id},
					scope:this
				});

			}
		}		
  	};
  	
	var showItems = function(sm){
		Ext.getCmp('storageOutcoming-showitems-button').setDisabled(sm.getCount() < 1);
		storageOutcomingGetItemsStore.removeAll();
		storageOutcomingItemsStore.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('storageOutcomingItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageOutcomingGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageOutcomingGetItemsStore.getAt(0);
						if (rc) {
							storageOutcomingItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var addNew = function() {

		var sm = Ext.getCmp('contractForSOC-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var contractID = sm.getSelected().get('id');
		var contractNo = sm.getSelected().get('contractNo');
		var companyID = sm.getSelected().get('companyID'); 
		
		var wnd = Ext.getCmp('storageOutcoming-window');
		if (!wnd) {
			var wnd = new eus.window.StorageOutcoming();
			wnd.on('storageOutcomingSaved', function(attr){
				contractForSOCStore.reload();
			});
		}
		wnd.open(contractID,contractNo,companyID);
		wnd.show();
	};
	
	var btnAddNew = {
		text:'�������ⵥ',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){contractForSOCStore.reload();},
		scope:this
	};

	var btnPrint = {
		text:'��ӡ',
		iconCls:'icon-printer',
		handler:function(){
			var record = Ext.getCmp('storageOutcoming-grid').getSelectionModel().getSelected();
			if (!record) return;
			var id = record.get('id');
			window.open('printStorageOutcoming.action?id=' + id);
			storageOutcoming.reload();
		},
		scope:this
	};

	var btnPrintPriview = {
		text:'��ӡԤ��',
		iconCls:'icon-printer',
		handler:function(){
			var record = Ext.getCmp('storageOutcoming-grid').getSelectionModel().getSelected();
			if (!record) return;
			var id = record.get('id');
			window.open('printPreviewStorageOutcoming.action?id=' + id);
			storageOutcoming.reload();
		},
		scope:this
	};
		
	var btnShowItems = {
		text: '��ϸ������Ϣ',
		id: 'storageOutcoming-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageOutcomingItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('storageOutcoming-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageOutcomingPanel.doLayout();			
		}
	};

	var contractForSOCGrid = {
			xtype:'grid',
			id:'contractForSOC-grid',
			anchor:'100% 40%',
			store:contractForSOCStore,
			stripeRows:true,
			autoScroll:true,
			border:false,
			loadMask:true,
			renderTo:'contractForSOCGridPanel',
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
					{header:'��ͬ��',width:150,dataIndex:'contractNo'},
					{header:'��ͬ����',width:150,dataIndex:'company'},
					{header:'�����ܼ�',width:50,dataIndex:'totalAmount'},
					{header:'����ܼ�',width:50,dataIndex:'totalFinishedAmount'},	
					{header:'����ܼ�',width:50,dataIndex:'totalCheckingAmount'},
					{header:'����ܼ�',width:50,dataIndex:'totalSum'},
					{header:'��ͬ����',width:80,dataIndex:'contractDate'},
					{header:'��Ա���',width:70,dataIndex:'empCode',hidden:true},
					{header:'����',width:50,dataIndex:'empName',hidden:true}									
				]
			}),
			viewConfig:{forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true})
		};
		
	
	var storageOutcomingGrid = {
		xtype:'grid',
		id:'storageOutcoming-grid',
		anchor:'100% 30%',
		store:storageOutcoming,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		renderTo:'contractForSOCGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[      
				{header:'���ⵥ���',width:150,dataIndex:'socNo'},
				{header:'��Ʊ����',dataIndex:'printDate'},
				{header:'�����ܼ�',dataIndex:'totalAmount'},
				{header:'����ܼ�',dataIndex:'totalSum'},	
				{header:'����˰����ܼ�',dataIndex:'totalSumWithoutTax'},
				{header:'˰���ܼ�',dataIndex:'totalTaxAmount'},
				{header:'��Ա���',dataIndex:'empCode'},
				{header:'����',dataIndex:'empName'},
				{header:'���״̬',renderer:clsys.grid.columnrender.StorageOutcomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var storageOutcomingItemsGrid = {
		xtype:'grid',
		id:'storageOutcomingItems-grid',
		anchor:'100% 30%',
		store:storageOutcomingItemsStore,
		stripeRows:true,
		autoScroll:true,
		hidden:true,
		border:false,
		renderTo:'storageOutcomingItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
	 		    {header: '���', width:25,dataIndex: 'socItemNo'},
	 		    {header: '��Ʒ���Ƽ��ͺ�',width:150,dataIndex:'productCombination'},
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
				Ext.getCmp('storageOutcoming-showitems-button').toggle();
			}
		}]
	};	

		
	var storageOutcomingPanel = Ext.getCmp('StorageOutcomingApplication-mainpanel');
	storageOutcomingPanel.add(contractQueryConditionPanelForSocContract,contractForSOCGrid,storageOutcomingGrid,storageOutcomingItemsGrid);
	storageOutcomingPanel.getTopToolbar().add(btnAddNew,btnShowItems,btnRefresh,btnPrintPriview,btnPrint);
	clsys.form.Util.PagingToolbar(contractForSOCStore, storageOutcomingPanel.bbar, 'storageOutcoming-paging');
	storageOutcomingPanel.doLayout();
	Ext.getCmp('contractForSOC-grid').getSelectionModel().on('selectionchange', function(sm) {
		showStorageOutcomingItems(sm);
	});	
	Ext.getCmp('storageOutcoming-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="storageOutcomingPanel"></div>
<div id="contractForSOCGridPanel"></div>
<div id="storageOutcomingGridPanel"></div>
<div id="storageOutcomingItemsPanel"></div>
<div id="contractQueryConditionPanelForSocContract"></div>
</body>
</html>