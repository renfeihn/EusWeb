<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>合同对库欠交汇总查询</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractSummeryViewSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryContractItemOwnedSummeryView.action',
	  	totalProperty:'results',
	  	root:'ContractItemOwnedSummeryViewList',
	  	baseParams:{start:0,limit:25},
	  	idProperty:'id',
	  	fields:['id','amount','checkingAmount','finishedAmount','unfinishedAmount','restAmount','ownedAmount',
	  	        {name:'productCombination',mapping:'product.productCombination'},
	  		  	{name:'voltage',mapping:'product.voltage'},
	  			{name:'capacity',mapping:'product.capacity'},
		        {name:'productCode',mapping:'product.productCode.name'},	        		   
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'product.unit.name'},
	  		   	{name:'usageType',mapping:'product.usageType.name'}],  	
		sortInfo:{field: 'productCombination',direction: 'ASC'}  	
  	});
  	
	var productCodeStoreForContractSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForContractSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForContractSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForContractSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});

	var productTypeStoreForContractSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var txtProductCombinationForContractSummeryViewSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForContractSummeryViewSearch',
		fieldLabel:'产品名称及型号',
		width:220,
		name:'txtProductCombinationForContractSummeryViewSearch'
	};
	
	//2
	var txtVoltageForContractSummeryViewSearch = {
		xtype:'textfield',
		id:'txtVoltageForContractSummeryViewSearch',
		fieldLabel:'产品电压',
		width:220,
		name:'txtVoltageForContractSummeryViewSearch'
	};
	//3
	var txtCapacityForContractSummeryViewSearch = {
		xtype:'textfield',
		id:'txtCapacityForContractSummeryViewSearch',
		fieldLabel:'产品容量',
		width:220,
		name:'txtCapacityForContractSummeryViewSearch'
	};

	//9 产品代号下拉列表	
	var cbProductCodeForContractSummeryViewSearch = {
		xtype:'combo',
		store:productCodeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCodeForContractSummeryViewSearch',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id',
		editable: true
	};
	
	//10 湿度系数指标	
	var cbHumidityForContractSummeryViewSearch = {
		xtype:'combo',
		store:humidityStoreForContractSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidityForContractSummeryViewSearch',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id',
		editable: true
	};
	
	//11 误差等级
	var cbErrorLevelForContractSummeryViewSearch = {
		xtype:'combo',
		store:errorLevelStoreForContractSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevelForContractSummeryViewSearch',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id',
		editable: true
	};
	
	//13  产品品种
	var cbUsageTypeForContractSummeryViewSearch = {
		xtype:'combo',
		store:usageTypeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageTypeForContractSummeryViewSearch',
		width:220,
		blankText:'请选择产品品种',
		valueField:'id',
		editable: true
	};
	
	//14  产品类别
	var cbProductTypeForContractSummeryViewSearch = {
		xtype:'combo',
		store:productTypeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbProductTypeForContractSummeryViewSearch',
		width:220,
		blankText:'请选择产品类别',
		valueField:'id',
		editable: true
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductCodeForContractSummeryViewSearch,cbErrorLevelForContractSummeryViewSearch,txtVoltageForContractSummeryViewSearch,txtProductCombinationForContractSummeryViewSearch]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForContractSummeryViewSearch,cbHumidityForContractSummeryViewSearch,cbUsageTypeForContractSummeryViewSearch,txtCapacityForContractSummeryViewSearch]		
	};
	
	var contractSummeryViewSearchGrid = {
		xtype:'grid',
		id:'contractSummeryViewSearch-grid',
		anchor:'100% 90%',
		store:contractSummeryViewSearchStore,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'contractSummeryViewSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'产品名称及型号',dataIndex:'productCombination'},
				{header:'产品代号',width:40,dataIndex:'productCode'},
			    {header:'产品品种',width:40,dataIndex:'usageType'},
				{header:'数量合计',width:50,dataIndex:'amount'},
				{header:'完成合计',width:50,dataIndex:'finishedAmount'},
				{header:'审核合计',width:50,dataIndex:'checkingAmount'},
				{header:'未完成合计',width:50,dataIndex:'unfinishedAmount'},	
				{header:'库存总数',width:50,dataIndex:'restAmount'},
				{header:'欠交合计',width:50,dataIndex:'ownedAmount'}	
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

 	 var contractSummeryViewQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'查询条件',
         labelWidth:150,
         renderTo:'contractSummeryViewQueryConditionPanel',
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
 						productCombination:Ext.getCmp('txtProductCombinationForContractSummeryViewSearch').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForContractSummeryViewSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForContractSummeryViewSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForContractSummeryViewSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForContractSummeryViewSearch').getValue(),
 						productType:Ext.getCmp('cbProductTypeForContractSummeryViewSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForContractSummeryViewSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForContractSummeryViewSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				contractSummeryViewSearchStore.reload({params:attributes});
  			}
		},{
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				contractSummeryViewSearchStore.reload();
			},
			scope:this
		},{
			text: '清除',
			iconCls: 'icon-remove',
			handler: function() {
				contractSummeryViewQueryConditionPanel.getForm().reset();
			},
			scope:this
		},{
			text:'打印',
			iconCls:'icon-printer',
			handler:function(){
	   			var url = 'printQueryContractItemOwnedSummeryView.action';
 				var params = {
 						productCombination:Ext.getCmp('txtProductCombinationForContractSummeryViewSearch').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForContractSummeryViewSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForContractSummeryViewSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForContractSummeryViewSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForContractSummeryViewSearch').getValue(),
 						productType:Ext.getCmp('cbProductTypeForContractSummeryViewSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForContractSummeryViewSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForContractSummeryViewSearch').getValue()
 		 	 	};

 				var strUrl = Ext.urlEncode(params);
 				window.open(url + '?' + strUrl);
	   			params.start = 0;
 				contractSummeryViewSearchStore.reload({params:params});
			},
			scope:this	
		}]
     });

	var contractSummeryViewSearchPanel = Ext.getCmp('ContractSummeryViewSearch-mainpanel');
	contractSummeryViewSearchPanel.add(contractSummeryViewQueryConditionPanel,contractSummeryViewSearchGrid);
	clsys.form.Util.PagingToolbar(contractSummeryViewSearchStore, contractSummeryViewSearchPanel.tbar, 'contractSummeryViewSearch-paging');
	contractSummeryViewSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="contractSummeryViewSearchPanel"></div>
<div id="contractSummeryViewSearchGridPanel"></div>
<div id="contractSummeryViewSearchItemsPanel"></div>
<div id="contractSummeryViewQueryConditionPanel"></div>
</body>
</html>