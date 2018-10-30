<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��ͬ�Կ�Ƿ�����ܲ�ѯ</title>
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
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForContractSummeryViewSearch'
	};
	
	//2
	var txtVoltageForContractSummeryViewSearch = {
		xtype:'textfield',
		id:'txtVoltageForContractSummeryViewSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForContractSummeryViewSearch'
	};
	//3
	var txtCapacityForContractSummeryViewSearch = {
		xtype:'textfield',
		id:'txtCapacityForContractSummeryViewSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForContractSummeryViewSearch'
	};

	//9 ��Ʒ���������б�	
	var cbProductCodeForContractSummeryViewSearch = {
		xtype:'combo',
		store:productCodeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForContractSummeryViewSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForContractSummeryViewSearch = {
		xtype:'combo',
		store:humidityStoreForContractSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForContractSummeryViewSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	//11 ���ȼ�
	var cbErrorLevelForContractSummeryViewSearch = {
		xtype:'combo',
		store:errorLevelStoreForContractSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForContractSummeryViewSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForContractSummeryViewSearch = {
		xtype:'combo',
		store:usageTypeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForContractSummeryViewSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	//14  ��Ʒ���
	var cbProductTypeForContractSummeryViewSearch = {
		xtype:'combo',
		store:productTypeStoreForContractSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForContractSummeryViewSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
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
				{header:'��Ʒ���Ƽ��ͺ�',dataIndex:'productCombination'},
				{header:'��Ʒ����',width:40,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:40,dataIndex:'usageType'},
				{header:'�����ϼ�',width:50,dataIndex:'amount'},
				{header:'��ɺϼ�',width:50,dataIndex:'finishedAmount'},
				{header:'��˺ϼ�',width:50,dataIndex:'checkingAmount'},
				{header:'δ��ɺϼ�',width:50,dataIndex:'unfinishedAmount'},	
				{header:'�������',width:50,dataIndex:'restAmount'},
				{header:'Ƿ���ϼ�',width:50,dataIndex:'ownedAmount'}	
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
         title:'��ѯ����',
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
			text: '��ѯ',
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
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				contractSummeryViewSearchStore.reload();
			},
			scope:this
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {
				contractSummeryViewQueryConditionPanel.getForm().reset();
			},
			scope:this
		},{
			text:'��ӡ',
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