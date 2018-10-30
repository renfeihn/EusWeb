<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�����ϸ</title>
<script type="text/javascript" src="js/schedulesearch/storageItemSearch.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	var warehouseItem_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],start:0,limit:25}},
		baseParams:{status:['Using']},
	  	url:'queryStorageItem.action',
	  	totalProperty:'results',
	  	root:'StorageItemList',
	  	idProperty:'id',
	  	fields:['id',
	  		  	{name:'amount',type:'int'},
	  		  	'productionDate',
	  	      	{name:'productCombination',mapping:'product.productCombination'},
	  		  	{name:'productName',mapping:'product.productName'},
	  		  	{name:'voltage',mapping:'product.voltage'},
	  			{name:'capacity',mapping:'product.capacity'},	        		   
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'product.unit.name'},
	  	       	{name:'productCode',mapping:'product.productCode.name'},
	  		   	{name:'usageType',mapping:'product.usageType.name'}]
  	});
  	
	productCodeStoreForWarehouseItem = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	humidityStoreForWarehouseItem = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findHumidity.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	errorLevelStoreForWarehouseItem = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	usageTypeStoreForWarehouseItem = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	productTypeStoreForWarehouseItem = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombinationForWarehouseItem = {
		xtype:'textfield',
		id:'txtProductCombinationForWarehouseItem',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForWarehouseItem'
	};
	
	//2
	var txtVoltageForWarehouseItem = {
		xtype:'textfield',
		id:'txtVoltageForWarehouseItem',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForWarehouseItem'
	};
	//3
	var txtCapacityForWarehouseItem = {
		xtype:'textfield',
		id:'txtCapacityForWarehouseItem',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'capacity'
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCodeForWarehouseItem = {
		xtype:'combo',
		store:productCodeStoreForWarehouseItem,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForWarehouseItem',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForWarehouseItem = {
		xtype:'combo',
		store:humidityStoreForWarehouseItem,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForWarehouseItem',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbErrorLevelForWarehouseItem = {
		xtype:'combo',
		store:errorLevelStoreForWarehouseItem,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForWarehouseItem',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForWarehouseItem = {
		xtype:'combo',
		store:usageTypeStoreForWarehouseItem,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForWarehouseItem',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbProductTypeForWarehouseItem = {
		xtype:'combo',
		store:productTypeStoreForWarehouseItem,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForWarehouseItem',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id'
	};

	var txtStorageItemDateStart = {
		xtype:'datefield',
		id:'txtStorageItemDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtStorageItemDateStart'	
	};
	
	var txtStorageItemDateEnd = {
		xtype:'datefield',
		id:'txtStorageItemDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtStorageItemDateEnd'	
	};
		
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtProductCombinationForWarehouseItem,cbProductCodeForWarehouseItem,cbUsageTypeForWarehouseItem,txtVoltageForWarehouseItem,txtStorageItemDateStart]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForWarehouseItem,cbHumidityForWarehouseItem,cbErrorLevelForWarehouseItem,txtCapacityForWarehouseItem,txtStorageItemDateEnd]		
	};

	 var warehouseItemStoreQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'warehouseItemStoregQueryConditionPanel',
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
 		 			warehouseItemSearch:1,
					productCombination:Ext.getCmp('txtProductCombinationForWarehouseItem').getValue(),
					productCode:Ext.getCmp('cbProductCodeForWarehouseItem').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForWarehouseItem').getValue(),
					voltage:Ext.getCmp('txtVoltageForWarehouseItem').getValue(),
					capacity:Ext.getCmp('txtCapacityForWarehouseItem').getValue(),
					productType:Ext.getCmp('cbProductTypeForWarehouseItem').getValue(),
					humidity:Ext.getCmp('cbHumidityForWarehouseItem').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForWarehouseItem').getValue(),
					storageItemDateStart:Ext.getCmp('txtStorageItemDateStart').getValue(),
					storageItemDateEnd:Ext.getCmp('txtStorageItemDateEnd').getValue()
 		 	 	};
 				attributes.start = 0;
 				warehouseItem_Store.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {warehouseItemStoreQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				warehouseItem_Store.reload();
			},
			scope:this
		}]
     });
	
	
	var warehouseItemGrid = {
		xtype:'grid',
		id:'warehouseItem-grid',
		anchor:'100% 65%',
		store:warehouseItem_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'warehouseItemGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��Ʒ���Ƽ��ͺ�',width:220,dataIndex:'productCombination'},
				{header:'��Ʒ����',width:60,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:60,dataIndex:'usageType'},
			    {header:'��ѹ',width:40,dataIndex:'voltage'},
			    {header:'����',width:40,dataIndex:'capacity'},
			    {header:'ʪ��',width:40,dataIndex:'humidity'},
			    {header:'���',width:40,dataIndex:'errorLevel'}, 
				{header:'��λ',width:40,dataIndex:'unit'},
				{header:'�������',width:50,dataIndex:'amount'},
				{header:'��������',width:80,dataIndex:'productionDate'}
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
	
	var warehouseItemPanel = Ext.getCmp('WarehouseItem-mainpanel');
	warehouseItemPanel.add(warehouseItemStoreQueryConditionPanel,warehouseItemGrid);
	clsys.form.Util.PagingToolbar(warehouseItem_Store, warehouseItemPanel.tbar, 'warehouseItem-paging');
	warehouseItemPanel.doLayout();
	  	
  });
</script>
</head>
<body>
<div id="warehouseItemGridPanel"></div>
<div id="warehouseItemStoregQueryConditionPanel"></div>
</body>
</html>