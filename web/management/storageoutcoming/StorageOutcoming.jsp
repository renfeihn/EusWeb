<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>出库申请</title>
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
		fieldLabel:'合同号',
		width:220,
		name:'txtContractForSocContract'
	};
	
	var txtCompanyForSocContract = {
			xtype:'textfield',
			id:'txtCompanyForSocContract',
			fieldLabel:'合同厂商',
			width:220,
			name:'txtCompanyForSocContract'
	};
		
	var txtProductCombinationForSocContract = {
		xtype:'textfield',
		id:'txtProductCombinationForSocContract',
		fieldLabel:'产品名称及型号',
		width:220,
		name:'txtProductCombinationForSocContract'
	};
	
	var txtVoltageForSocContract = {
		xtype:'textfield',
		id:'txtVoltageForSocContract',
		fieldLabel:'产品电压',
		width:220,
		name:'txtVoltageForSocContract'
	};
	var txtCapacityForSocContract = {
		xtype:'textfield',
		id:'txtCapacityForSocContract',
		fieldLabel:'产品容量',
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
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCodeForSocContract',
		width:220,
		blankText:'请选择产品代号',
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
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidityForSocContract',
		width:220,
		blankText:'请选择湿度系数指标',
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
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevelForSocContract',
		width:220,
		blankText:'请选择误差等级',
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
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageTypeForSocContract',
		width:220,
		blankText:'请选择产品品种',
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
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbProductTypeForSocContract',
		width:220,
		blankText:'请选择产品类别',
		valueField:'id',
		editable: true
	};

	var txtDateStartForSocContract = {
		xtype:'datefield',
		id:'txtDateStartForSocContract',
		fieldLabel:'合同日期(开始)',
		width:220,
		name:'txtDateStartForSocContract'	
	};
	
	var txtDateEndForSocContract = {
		xtype:'datefield',
		id:'txtDateEndForSocContract',
		fieldLabel:'合同日期(结束)',
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
         title:'查询条件',
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
			text: '查询',
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
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
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
		text:'新增出库单',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){contractForSOCStore.reload();},
		scope:this
	};

	var btnPrint = {
		text:'打印',
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
		text:'打印预览',
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
		text: '详细出库信息',
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
					{header:'合同号',width:150,dataIndex:'contractNo'},
					{header:'合同厂商',width:150,dataIndex:'company'},
					{header:'数量总计',width:50,dataIndex:'totalAmount'},
					{header:'完成总计',width:50,dataIndex:'totalFinishedAmount'},	
					{header:'审核总计',width:50,dataIndex:'totalCheckingAmount'},
					{header:'金额总计',width:50,dataIndex:'totalSum'},
					{header:'合同日期',width:80,dataIndex:'contractDate'},
					{header:'人员编号',width:70,dataIndex:'empCode',hidden:true},
					{header:'姓名',width:50,dataIndex:'empName',hidden:true}									
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
				{header:'出库单编号',width:150,dataIndex:'socNo'},
				{header:'开票日期',dataIndex:'printDate'},
				{header:'数量总计',dataIndex:'totalAmount'},
				{header:'金额总计',dataIndex:'totalSum'},	
				{header:'不含税金额总计',dataIndex:'totalSumWithoutTax'},
				{header:'税额总计',dataIndex:'totalTaxAmount'},
				{header:'人员编号',dataIndex:'empCode'},
				{header:'姓名',dataIndex:'empName'},
				{header:'审核状态',renderer:clsys.grid.columnrender.StorageOutcomingStatusRender,dataIndex:'state'}							
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
	 		    {header: '序号', width:25,dataIndex: 'socItemNo'},
	 		    {header: '产品名称及型号',width:150,dataIndex:'productCombination'},
	 			{header: '单位', width:25,dataIndex: 'unit'},
	 			{header: '数量', width:25,dataIndex: 'amount'},
	 			{header: '单价', width:30,dataIndex: 'price'},
	 			{header: '不含税单价', width:50,dataIndex: 'priceWithoutTax'},
	 			{header: '金额', width:50,dataIndex: 'subTotal'},
	 			{header: '不含税金额',width:50, dataIndex: 'subTotalWithoutTax'},
	 			{header: '税率', width:25,dataIndex: 'tax'},
	 			{header: '税额', width:50,dataIndex: 'taxAmount'},
	 			{header: '库位', width:80,dataIndex: 'storageLocation'},
	 			{header: '备注', width:80,dataIndex: 'memo'}		
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar: ['<b>预览</b>', {
			iconCls: 'icon-remove',
			text: '关闭预览',
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