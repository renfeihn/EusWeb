<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>合同明细查询</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractItemSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryContractItem.action',
	  	totalProperty:'results',
	  	root:'ContractItemList',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	idProperty:'id',
  	  	fields:['id','amount','price','originalPrice','subTotal','finishedAmount','checkingAmount','socAmount',
	  	        {name:'productCombination',mapping:'product.productCombination'},
	  	        {name:'contractNo',mapping:'contract.contractNo'},
	  	        {name:'state',mapping:'contract.state'},
	  	        {name:'createTime',mapping:'contract.createTime'},
	  	        {name:'contractDate',mapping:'contract.contractDate'},
		  	    {name:'company',mapping:'contract.company.name'}],		  	        
	  	sortInfo: {field: 'createTime',direction: 'ASC'}	
  	});

	var productCodeStoreForContractItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForContractItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForContractItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForContractItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var productTypeStoreForContractItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var txtContractForContractItemSearch = {
		xtype:'textfield',
		id:'txtContractForContractItemSearch',
		fieldLabel:'合同号',
		width:220,
		name:'txtContractForContractItemSearch'
	};

	var txtCompanyForContractItemSearch = {
		xtype:'textfield',
		id:'txtCompanyForContractItemSearch',
		fieldLabel:'合同厂商',
		width:220,
		name:'txtCompanyForContractItemSearch'
	};
	
	var txtProductCombinationForContractItemSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForContractItemSearch',
		fieldLabel:'产品名称及型号',
		width:220,
		name:'txtProductCombinationForContractItemSearch'
	};
	
	var txtVoltageForContractItemSearch = {
		xtype:'textfield',
		id:'txtVoltageForContractItemSearch',
		fieldLabel:'产品电压',
		width:220,
		name:'txtVoltageForContractItemSearch'
	};
	var txtCapacityForContractItemSearch = {
		xtype:'textfield',
		id:'txtCapacityForContractItemSearch',
		fieldLabel:'产品容量',
		width:220,
		name:'txtCapacityForContractItemSearch'
	};

	var cbProductCodeForContractItemSearch = {
		xtype:'combo',
		store:productCodeStoreForContractItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCodeForContractItemSearch',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id',
		editable: true
	};
	
	var cbHumidityForContractItemSearch = {
		xtype:'combo',
		store:humidityStoreForContractItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidityForContractItemSearch',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id',
		editable: true
	};
	
	var cbErrorLevelForContractItemSearch = {
		xtype:'combo',
		store:errorLevelStoreForContractItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevelForContractItemSearch',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id',
		editable: true
	};
	
	var cbUsageTypeForContractItemSearch = {
		xtype:'combo',
		store:usageTypeStoreForContractItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageTypeForContractItemSearch',
		width:220,
		blankText:'请选择产品品种',
		valueField:'id',
		editable: true
	};
	
	var cbProductTypeForContractItemSearch = {
		xtype:'combo',
		store:productTypeStoreForContractItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbProductTypeForContractItemSearch',
		width:220,
		blankText:'请选择产品类别',
		valueField:'id',
		editable: true
	};

	var txtDateStartForContractItemSearch = {
		xtype:'datefield',
		id:'txtDateStartForContractItemSearch',
		fieldLabel:'保存日期(开始)',
		width:220,
		name:'txtDateStartForContractItemSearch'	
	};
	
	var txtDateEndForContractItemSearch = {
		xtype:'datefield',
		id:'txtDateEndForContractItemSearch',
		fieldLabel:'保存日期(结束)',
		width:220,
		name:'txtDateEndForContractItemSearch'	
	};
	
	var col1 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[txtProductCombinationForContractItemSearch,cbProductCodeForContractItemSearch,cbErrorLevelForContractItemSearch,txtVoltageForContractItemSearch,txtDateStartForContractItemSearch,txtContractForContractItemSearch]		
		};
		
		var col2 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[cbProductTypeForContractItemSearch,cbHumidityForContractItemSearch,cbUsageTypeForContractItemSearch,txtCapacityForContractItemSearch,txtDateEndForContractItemSearch,txtCompanyForContractItemSearch]		
		};
	
	var contractItemSearchGrid = {
		xtype:'grid',
		id:'contractItemSearch-grid',
		anchor:'100% 90%',
		store:contractItemSearchStore,
		stripeRows:true,
		autoScroll:true,
		hidden:false,
		loadMask:true,
		frame:true,
		border:false,
		renderTo:'contractItemSearchItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'合同号',width:120,dataIndex:'contractNo'},
				{header:'保存时间',width:120,dataIndex:'createTime',hidden:true},
				{header:'合同厂商',width:150,dataIndex:'company'},
				{header:'产品名称及型号',width:250,dataIndex:'productCombination'},
				{header:'合同数量',width:70,dataIndex:'amount'},
				{header:'完成数量',width:40,dataIndex:'finishedAmount'},	
				{header:'审核数量',width:40,dataIndex:'checkingAmount'},
				{header:'合同价格',width:70,dataIndex:'price'},
				{header:'原始价格',width:70,dataIndex:'originalPrice'},
				{header:'金额小计',width:70,dataIndex:'subTotal'},
				{header:'交货期',width:80,dataIndex:'contractDate'},
				{header:'合同状态',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}					
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	 var contractItemQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'查询条件',
         labelWidth:150,
         renderTo:'contractItemQueryConditionPanel',
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
					companyName:Ext.getCmp('txtCompanyForContractItemSearch').getValue(),
 		 			contractNo:Ext.getCmp('txtContractForContractItemSearch').getValue(),
					productCombination:Ext.getCmp('txtProductCombinationForContractItemSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForContractItemSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForContractItemSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForContractItemSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForContractItemSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForContractItemSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForContractItemSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForContractItemSearch').getValue(),
					dateStartForContractItemSearch:Ext.getCmp('txtDateStartForContractItemSearch').getValue(),
					dateEndForContractItemSearch:Ext.getCmp('txtDateEndForContractItemSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				contractItemSearchStore.reload({params:attributes});
  			}
		},{
			text: '清除',
			iconCls: 'icon-remove',
			handler: function() {contractItemQueryConditionPanel.getForm().reset();}
		},{
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				contractItemSearchStore.reload();
			},
			scope:this
		}]
     });
     		   
	var contractItemSearchPanel = Ext.getCmp('ContractItemSearch-mainpanel');
	contractItemSearchPanel.add(contractItemQueryConditionPanel,contractItemSearchGrid);
	clsys.form.Util.PagingToolbar(contractItemSearchStore, contractItemSearchPanel.tbar, 'contractItemSearch-paging');
	contractItemSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="contractItemSearchPanel"></div>
<div id="contractItemSearchGridPanel"></div>
<div id="contractItemSearchItemsPanel"></div>
<div id="contractItemQueryConditionPanel"></div>
</body>
</html>