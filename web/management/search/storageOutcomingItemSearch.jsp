<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>������ϸ��ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageOutcomingItemSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryStorageOutcomingItem.action',
	  	totalProperty:'results',
	  	root:'StorageOutcomingItemList',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	idProperty:'id',
  		fields:['id','createTime',
  		     	 {name:'socItemNo',type:'int'},
 		         {name:'socNo',mapping:'soc.socNo'},
 		         {name:'socState',mapping:'soc.state'},  	
 		         {name:'company',mapping:'contractItem.contract.company.name'},	      
  		         {name:'contractNo',mapping:'contractItem.contract.contractNo'},
		  	  	 {name:'productCombination',mapping:'product.productCombination'},
			     {name:'unit',mapping:'product.unit.name'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'},
		         'amount','price','subTotal','subTotalWithoutTax','priceWithoutTax','taxAmount','tax','memo' 
		        ],		        
	  	sortInfo: {field: 'socItemNo',direction: 'ASC'}	
  	});

	var productCodeStoreForSocItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForSocItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForSocItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForSocItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var productTypeStoreForSocItemSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	var txtSOCNoForSocItemSearch = {
		xtype:'textfield',
		id:'txtSOCNoForSocItemSearch',
		fieldLabel:'���ⵥ��',
		width:220,
		name:'txtSOCNoForSocItemSearch'
	};
	
	var txtContractForSocItemSearch = {
		xtype:'textfield',
		id:'txtContractForSocItemSearch',
		fieldLabel:'��ͬ��',
		width:220,
		name:'txtContractForSocItemSearch'
	};

	var txtCompanyForSocItemSearch = {
		xtype:'textfield',
		id:'txtCompanyForSocItemSearch',
		fieldLabel:'��ͬ����',
		width:220,
		name:'txtCompanyForSocItemSearch'
	};
		
	var txtProductCombinationForSocItemSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForSocItemSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForSocItemSearch'
	};
	
	var txtVoltageForSocItemSearch = {
		xtype:'textfield',
		id:'txtVoltageForSocItemSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForSocItemSearch'
	};
	var txtCapacityForSocItemSearch = {
		xtype:'textfield',
		id:'txtCapacityForSocItemSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacity'
	};

	var cbProductCodeForSocItemSearch = {
		xtype:'combo',
		store:productCodeStoreForSocItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForSocItemSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	var cbHumidityForSocItemSearch = {
		xtype:'combo',
		store:humidityStoreForSocItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForSocItemSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	var cbErrorLevelForSocItemSearch = {
		xtype:'combo',
		store:errorLevelStoreForSocItemSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForSocItemSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	var cbUsageTypeForSocItemSearch = {
		xtype:'combo',
		store:usageTypeStoreForSocItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForSocItemSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	var cbProductTypeForSocItemSearch = {
		xtype:'combo',
		store:productTypeStoreForSocItemSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForSocItemSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id',
		editable: true
	};

	var txtDateStartForSocItemSearch = {
		xtype:'datefield',
		id:'txtDateStartForSocItemSearch',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtDateStartForSocItemSearch'	
	};
	
	var txtDateEndForSocItemSearch = {
		xtype:'datefield',
		id:'txtDateEndForSocItemSearch',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtDateEndForSocItemSearch'	
	};

	var cbSocStateForSocItemSearch  = {
			xtype: 'combo',
			id: 'cbSocStateForSocItemSearch',
			emptyText: '��ѡ����ⵥ״̬',
			fieldLabel:'���ⵥ״̬',
			store: new Ext.data.ArrayStore({
				fields: [ 'id', 'name' ],
				data: [
						[ '', 'ȫ��״̬' ],
						['Checking','�����'],
						['Failed','���ʧ��'],
						['Success','��˳ɹ�']
					]
			}),
			mode: 'local',
			triggerAction: 'all',
			displayField: 'name',
			valueField: 'id',
			width: 220,
			selectOnFocus: true,
			forceSelection: true,
			editable: true
		};
	
	var col1 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[txtProductCombinationForSocItemSearch,cbProductCodeForSocItemSearch,cbErrorLevelForSocItemSearch,txtVoltageForSocItemSearch,txtSOCNoForSocItemSearch,txtDateStartForSocItemSearch,txtContractForSocItemSearch]		
		};
		
		var col2 = {
			columnWidth: .5,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[cbProductTypeForSocItemSearch,cbHumidityForSocItemSearch,cbUsageTypeForSocItemSearch,txtCapacityForSocItemSearch,cbSocStateForSocItemSearch,txtDateEndForSocItemSearch,txtCompanyForSocItemSearch]		
		};
	
	var storageOutcomingItemSearchGrid = {
		xtype:'grid',
		id:'storageOutcomingItemSearch-grid',
		anchor:'100% 90%',
		store:storageOutcomingItemSearchStore,
		stripeRows:true,
		autoScroll:true,
		hidden:false,
		loadMask:true,
		border:false,
		frame:true,
		renderTo:'storageOutcomingItemSearchItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'���ⵥ��',width:120,dataIndex:'socNo'},
				{header:'���',width:40,dataIndex:'socItemNo'},
	 		    {header: '��Ʒ���Ƽ��ͺ�',width:220,dataIndex:'productCombination'},
	 			{header: '��λ', width:40,dataIndex: 'unit'},
	 			{header: '����', width:100,dataIndex: 'amount'},
	 			{header: '����', width:100,dataIndex: 'price'},
	 			{header: '����˰����', width:100,dataIndex: 'priceWithoutTax'},
	 			{header: '���', width:100,dataIndex: 'subTotal'},
	 			{header: '����˰���',width:100, dataIndex: 'subTotalWithoutTax'},
	 			{header: '˰��', width:100,dataIndex: 'tax'},
	 			{header: '˰��', width:100,dataIndex: 'taxAmount'},
				{header:'��ͬ����',width:500,dataIndex:'company'},
				{header:'��ͬ��',width:150,dataIndex:'contractNo'},
	 			{header:'״̬',width:80,dataIndex:'socState',renderer:clsys.grid.columnrender.StorageOutcomingStatusRender},
	 			{header: '��ע', width:80,dataIndex: 'memo'}		
			]
		}),
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	 var storageOutcomingQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'storageOutcomingQueryConditionPanel',
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
 					socNo:Ext.getCmp('txtSOCNoForSocItemSearch').getValue(),
 					companyName:Ext.getCmp('txtCompanyForSocItemSearch').getValue(),
 					contractNo:Ext.getCmp('txtContractForSocItemSearch').getValue(),
					productCombination:Ext.getCmp('txtProductCombinationForSocItemSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForSocItemSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForSocItemSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForSocItemSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForSocItemSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForSocItemSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForSocItemSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForSocItemSearch').getValue(),
					dateStartForSocItemSearch:Ext.getCmp('txtDateStartForSocItemSearch').getValue(),
					dateEndForSocItemSearch:Ext.getCmp('txtDateEndForSocItemSearch').getValue(),
					socState:Ext.getCmp('cbSocStateForSocItemSearch').getValue()
					
 		 	 	};
 				attributes.start = 0;
 				storageOutcomingItemSearchStore.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {storageOutcomingQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				storageOutcomingItemSearchStore.reload();
			},
			scope:this
		}]
     });
     		   
	var storageOutcomingItemSearchPanel = Ext.getCmp('StorageOutcomingItemSearch-mainpanel');
	storageOutcomingItemSearchPanel.add(storageOutcomingQueryConditionPanel,storageOutcomingItemSearchGrid);
	clsys.form.Util.PagingToolbar(storageOutcomingItemSearchStore, storageOutcomingItemSearchPanel.tbar, 'storageOutcomingItemSearch-paging');
	storageOutcomingItemSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="storageOutcomingItemSearchPanel"></div>
<div id="storageOutcomingItemSearchGridPanel"></div>
<div id="storageOutcomingItemSearchItemsPanel"></div>
<div id="storageOutcomingQueryConditionPanel"></div>
</body>
</html>