<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>����ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageIncomingItemSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryStorageIncomingItem.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingItemList',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	idProperty:'id',
		fields: ['id','sicItemNo','amount','jobCmdNo','productionDate','createTime',
		  	     {name:'schedule',mapping:'schedule.scheduleNo'},		         
		  	   	 {name:'productCombination',mapping:'product.productCombination'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'}
			    ],  	        
	  	sortInfo: {field: 'createTime',direction: 'ASC'}	
  	});

	var productCodeStoreForSicItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForSicItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForSicItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForSicItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var productTypeStoreForSicItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombinationForSicItemSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForSicItemSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForSicItemSearch'
	};
	
	var txtVoltageForSicItemSearch = {
		xtype:'textfield',
		id:'txtVoltageForSicItemSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForSicItemSearch'
	};
	var txtCapacityForSicItemSearch = {
		xtype:'textfield',
		id:'txtCapacityForSicItemSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForSicItemSearch'
	};

	var cbProductCodeForSicItemSearch = {
		xtype:'combo',
		store:productCodeStoreForSicItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForSicItemSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	var cbHumidityForSicItemSearch = {
		xtype:'combo',
		store:humidityStoreForSicItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForSicItemSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	var cbErrorLevelForSicItemSearch = {
		xtype:'combo',
		store:errorLevelStoreForSicItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForSicItemSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	var cbUsageTypeForSicItemSearch = {
		xtype:'combo',
		store:usageTypeStoreForSicItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForSicItemSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	var cbProductTypeForSicItemSearch = {
		xtype:'combo',
		store:productTypeStoreForSicItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForSicItemSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id',
		editable: true
	};

	var txtDateStartForSicItemSearch = {
		xtype:'datefield',
		id:'txtDateStartForSicItemSearch',
		fieldLabel:'�������(��ʼ)',
		width:220,
		name:'txtDateStartForSicItemSearch'	
	};
	
	var txtDateEndForSicItemSearch = {
		xtype:'datefield',
		id:'txtDateEndForSicItemSearch',
		fieldLabel:'�������(����)',
		width:220,
		name:'txtDateEndForSicItemSearch'	
	};
	
	var col1 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[txtProductCombinationForSicItemSearch,cbProductCodeForSicItemSearch,cbErrorLevelForSicItemSearch,txtVoltageForSicItemSearch,txtDateStartForSicItemSearch]		
		};
		
		var col2 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[cbProductTypeForSicItemSearch,cbHumidityForSicItemSearch,cbUsageTypeForSicItemSearch,txtCapacityForSicItemSearch,txtDateEndForSicItemSearch]		
		};
	
	var storageIncomingItemSearchGrid = {
		xtype:'grid',
		id:'storageIncomingItemSearch-grid',
		anchor:'100% 90%',
		store:storageIncomingItemSearchStore,
		stripeRows:true,
		autoScroll:true,
		hidden:false,
		loadMask:true,
		border:false,
		frame:true,
		renderTo:'storageIncomingItemSearchItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
	 			{header: '��Ʒ���Ƽ��ͺ�', width:150,dataIndex:'productCombination'},
	 			{header: '�������', width:50, dataIndex: 'jobCmdNo'},
	 			{header: '��ѹ(V)',width:50, dataIndex: 'voltage'},
	 			{header: '����(PF)',width:50, dataIndex: 'capacity'},
	 			{header: '���', width:30,dataIndex: 'humidity'},
	 			{header: '�ȼ�', width:30,dataIndex: 'productCode'},
	 			{header: '����', width:50,dataIndex: 'amount'},
	 			{header: '��������', width:80,dataIndex: 'productionDate'},
	 			{header: '���ʱ��', width:80,dataIndex:'createTime'},
	 			{header: '��ע', width:80,dataIndex: 'schedule'}
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	 var storageIncomingQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'storageIncomingQueryConditionPanel',
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
					productCombination:Ext.getCmp('txtProductCombinationForSicItemSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForSicItemSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForSicItemSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForSicItemSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForSicItemSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForSicItemSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForSicItemSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForSicItemSearch').getValue(),
					dateStartForSicItemSearch:Ext.getCmp('txtDateStartForSicItemSearch').getValue(),
					dateEndForSicItemSearch:Ext.getCmp('txtDateEndForSicItemSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				storageIncomingItemSearchStore.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {storageIncomingQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				storageIncomingItemSearchStore.reload();
			},
			scope:this
		}]
     });
     		   
	var storageIncomingItemSearchPanel = Ext.getCmp('StorageIncomingItemSearch-mainpanel');
	storageIncomingItemSearchPanel.add(storageIncomingQueryConditionPanel,storageIncomingItemSearchGrid);
	clsys.form.Util.PagingToolbar(storageIncomingItemSearchStore, storageIncomingItemSearchPanel.tbar, 'storageIncomingItemSearch-paging');
	storageIncomingItemSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="storageIncomingItemSearchPanel"></div>
<div id="storageIncomingItemSearchGridPanel"></div>
<div id="storageIncomingItemSearchItemsPanel"></div>
<div id="storageIncomingQueryConditionPanel"></div>
</body>
</html>