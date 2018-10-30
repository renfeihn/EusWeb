<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>����嵥</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	var warehouseList_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{start:0,limit:25}},
		baseParams:{start:0,limit:25},
	  	url:'queryStorageView.action',
	  	totalProperty:'results',
	  	root:'StorageViewList',
	  	idProperty:'id',
	  	fields:['id','totalAmount','advancedAmount','restAmount',
	  	      	{name:'productCombination',mapping:'product.productCombination'},
	  		  	{name:'productName',mapping:'product.productName'},
	  		  	{name:'voltage',mapping:'product.voltage'},
	  			{name:'capacity',mapping:'product.capacity'},
		        {name:'productCode',mapping:'product.productCode.name'},	        		   
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'product.unit.name'},
	  		   	{name:'usageType',mapping:'product.usageType.name'}  		   	
	  	       	]
  	});

	productCodeStoreForWarehouseList = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	humidityStoreForWarehouseList = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{status:'Using'},
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	errorLevelStoreForWarehouseList = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	usageTypeStoreForWarehouseList = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	productTypeStoreForWarehouseList = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombinationForWarehouseList = {
		xtype:'textfield',
		id:'txtProductCombinationForWarehouseList',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForWarehouseList'
	};
	
	//2
	var txtVoltageForWarehouseList = {
		xtype:'textfield',
		id:'txtVoltageForWarehouseList',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForWarehouseList'
	};
	//3
	var txtCapacityForWarehouseList = {
		xtype:'textfield',
		id:'txtCapacityForWarehouseList',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForWarehouseList'
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCodeForWarehouseList = {
		xtype:'combo',
		store:productCodeStoreForWarehouseList,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForWarehouseList',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForWarehouseList = {
		xtype:'combo',
		store:humidityStoreForWarehouseList,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForWarehouseList',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbErrorLevelForWarehouseList = {
		xtype:'combo',
		store:errorLevelStoreForWarehouseList,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForWarehouseList',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForWarehouseList = {
		xtype:'combo',
		store:usageTypeStoreForWarehouseList,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForWarehouseList',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbProductTypeForWarehouseList = {
		xtype:'combo',
		store:productTypeStoreForWarehouseList,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForWarehouseList',
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
		items:[txtProductCombinationForWarehouseList,cbProductCodeForWarehouseList,cbUsageTypeForWarehouseList,txtVoltageForWarehouseList]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForWarehouseList,cbHumidityForWarehouseList,cbErrorLevelForWarehouseList,txtCapacityForWarehouseList]		
	};

	 var warehouseListStoreQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'warehouseListStoregQueryConditionPanel',
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
 		 			warehouseListSearch:1,
					productCombination:Ext.getCmp('txtProductCombinationForWarehouseList').getValue(),
					productCode:Ext.getCmp('cbProductCodeForWarehouseList').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForWarehouseList').getValue(),
					voltage:Ext.getCmp('txtVoltageForWarehouseList').getValue(),
					capacity:Ext.getCmp('txtCapacityForWarehouseList').getValue(),
					productType:Ext.getCmp('cbProductTypeForWarehouseList').getValue(),
					humidity:Ext.getCmp('cbHumidityForWarehouseList').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForWarehouseList').getValue()
 		 	 	};
 				attributes.start = 0;
 				warehouseList_Store.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {warehouseListStoreQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				warehouseList_Store.reload();
			},
			scope:this
		},{
			text:'��ӡ',
			iconCls:'icon-printer',
			handler:function(){
	   			var url = 'printQueryStorageView.action';
 				var params = {
					productCombination:Ext.getCmp('txtProductCombinationForWarehouseList').getValue(),
					productCode:Ext.getCmp('cbProductCodeForWarehouseList').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForWarehouseList').getValue(),
					voltage:Ext.getCmp('txtVoltageForWarehouseList').getValue(),
					capacity:Ext.getCmp('txtCapacityForWarehouseList').getValue(),
					productType:Ext.getCmp('cbProductTypeForWarehouseList').getValue(),
					humidity:Ext.getCmp('cbHumidityForWarehouseList').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForWarehouseList').getValue()
 		 	 	};

 				var strUrl = Ext.urlEncode(params);
 				window.open(url + '?' + strUrl);
	   			params.start = 0;
	   			warehouseList_Store.reload({params:params});
			},
			scope:this	
	    }]
     });
     
	var warehouseListGrid = {
		xtype:'grid',
		id:'warehouseList-grid',
		anchor:'100% 65%',
		store:warehouseList_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'warehouseListGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��Ʒ���Ƽ��ͺ�',width:150,dataIndex:'productCombination'},
				{header:'��Ʒ����',width:80,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:40,dataIndex:'usageType'},
			    {header:'��ѹ',width:40,dataIndex:'voltage'},
			    {header:'����',width:40,dataIndex:'capacity'},
			    {header:'ʪ��',width:40,dataIndex:'humidity'},
			    {header:'���',width:40,dataIndex:'errorLevel'}, 
				{header:'��λ',width:40,dataIndex:'unit'},
				{header:'�������',width:50,dataIndex:'totalAmount'},
				{header:'��������',width:50,dataIndex:'advancedAmount'},
				{header:'��������',width:50,dataIndex:'restAmount'}
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
	
	var warehouseListPanel = Ext.getCmp('WarehouseList-mainpanel');
	warehouseListPanel.add(warehouseListStoreQueryConditionPanel,warehouseListGrid);
	clsys.form.Util.PagingToolbar(warehouseList_Store, warehouseListPanel.tbar, 'warehouseList-paging');
	warehouseListPanel.doLayout();
	  	
  });
</script>
</head>
<body>
<div id="warehouseListGridPanel"></div>
<div id="warehouseListStoregQueryConditionPanel"></div>
</body>
</html>