<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�����Դ��ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	var storageResourceSearch_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		baseParams:{status:['Using'],start:0,limit:25},
	  	url:'queryStorageResourceView.action',
	  	totalProperty:'results',
	  	root:'StorageResourceViewList',
	  	idProperty:'id',
	  	fields:['id','amount','totalAmount','advancedAmount','restAmount','varAmount',
	  	      	{name:'productCombination',mapping:'product.productCombination'},
	  	      	{name:'memo',mapping:'product.memo'},
	  		  	{name:'productName',mapping:'product.productName'},
	  		  	{name:'voltage',mapping:'product.voltage'},
	  			{name:'capacity',mapping:'product.capacity'},
		        {name:'productCode',mapping:'product.productCode.name'},	        		   
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'product.unit.name'},
	  		   	{name:'usageType',mapping:'product.usageType.name'}  		   	
	  	       	],
       	sortInfo: {field: 'productCombination',direction: 'ASC'}
  	});

	productCodeStoreForStorageResourceSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	humidityStoreForStorageResourceSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{status:'Using'},
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	errorLevelStoreForStorageResourceSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	usageTypeStoreForStorageResourceSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	productTypeStoreForStorageResourceSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombinationForStorageResourceSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForStorageResourceSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForStorageResourceSearch'
	};
	
	//2
	var txtVoltageForStorageResourceSearch = {
		xtype:'textfield',
		id:'txtVoltageForStorageResourceSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForStorageResourceSearch'
	};
	//3
	var txtCapacityForStorageResourceSearch = {
		xtype:'textfield',
		id:'txtCapacityForStorageResourceSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForStorageResourceSearch'
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCodeForStorageResourceSearch = {
		xtype:'combo',
		store:productCodeStoreForStorageResourceSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForStorageResourceSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForStorageResourceSearch = {
		xtype:'combo',
		store:humidityStoreForStorageResourceSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForStorageResourceSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbErrorLevelForStorageResourceSearch = {
		xtype:'combo',
		store:errorLevelStoreForStorageResourceSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForStorageResourceSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForStorageResourceSearch = {
		xtype:'combo',
		store:usageTypeStoreForStorageResourceSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForStorageResourceSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbProductTypeForStorageResourceSearch = {
		xtype:'combo',
		store:productTypeStoreForStorageResourceSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForStorageResourceSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id'
	};

	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtProductCombinationForStorageResourceSearch,cbProductCodeForStorageResourceSearch,cbUsageTypeForStorageResourceSearch,txtVoltageForStorageResourceSearch]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForStorageResourceSearch,cbHumidityForStorageResourceSearch,cbErrorLevelForStorageResourceSearch,txtCapacityForStorageResourceSearch]		
	};

	 var storageResourceSearchStoreQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'storageResourceSearchStoregQueryConditionPanel',
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
 		 			storageResourceSearchSearch:1,
					productCombination:Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForStorageResourceSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForStorageResourceSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForStorageResourceSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				storageResourceSearch_Store.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {storageResourceSearchStoreQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				storageResourceSearch_Store.reload();
			},
			scope:this
		},{
			text:'��ӡ',
			hidden:true,
			iconCls:'icon-printer',
			handler:function(){
	   			var url = 'printQueryStorageResource.action';
 				var params = {
					productCombination:Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForStorageResourceSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForStorageResourceSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForStorageResourceSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue()
 		 	 	};

 		 	 	var strUrl = "";
 		 	 	strUrl += 'productCombination='+Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'productCode='+Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'errorLevel='+Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'voltage='+Ext.getCmp('txtVoltageForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'capacity='+Ext.getCmp('txtCapacityForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'productType='+Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'humidity='+Ext.getCmp('cbHumidityForStorageResourceSearch').getValue() + "&";
 		 	 	strUrl += 'usageType='+Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue();
 		 	 	
 				//window.open(url + '?' + strUrl);
	   			params.start = 0;
	   			storageResourceSearch_Store.reload({params:params});
			},
			scope:this	
	    }]
     });
     
	var storageResourceSearchGrid = {
		xtype:'grid',
		id:'storageResourceSearch-grid',
		anchor:'100% 65%',
		store:storageResourceSearch_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'storageResourceSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��Ʒ���Ƽ��ͺ�',width:150,dataIndex:'productCombination'},
				{header:'�������',width:50,dataIndex:'totalAmount'},
				{header:'��������',width:50,dataIndex:'advancedAmount'},
				{header:'��������',width:50,dataIndex:'restAmount'},
				{header:'��Դ����',width:50,dataIndex:'amount'},
				{header:'�����Դ����',width:60,dataIndex:'memo'},
				{header:'��Ʒ����',width:80,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:40,dataIndex:'usageType'},
			    {header:'���',width:40,dataIndex:'errorLevel'}
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
	
	var storageResourceSearchPanel = Ext.getCmp('StorageResourceSearch-mainpanel');
	storageResourceSearchPanel.add(storageResourceSearchStoreQueryConditionPanel,storageResourceSearchGrid);
	clsys.form.Util.PagingToolbar(storageResourceSearch_Store, storageResourceSearchPanel.tbar, 'storageResourceSearch-paging');
	storageResourceSearchPanel.doLayout();
	  	
  });
</script>
</head>
<body>
<div id="storageResourceSearchGridPanel"></div>
<div id="storageResourceSearchStoregQueryConditionPanel"></div>
</body>
</html>