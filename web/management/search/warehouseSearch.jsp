<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>ֱ�ӳ�����ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	var warehouseSearch_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		baseParams:{status:['Using'],start:0,limit:25},
	  	url:'queryInWarehouse.action',
	  	totalProperty:'results',
	  	root:'InWarehouseList',
	  	idProperty:'id',
	  	fields:['id','totalAmount','flag','createTime',
	  	      	{name:'productCombination',mapping:'product.productCombination'},
	  		  	{name:'productName',mapping:'product.productName'},
	  		  	{name:'voltage',mapping:'product.voltage'},
	  			{name:'capacity',mapping:'product.capacity'},
		        {name:'productCode',mapping:'product.productCode.name'},	        		   
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'product.unit.name'},
	  		   	{name:'usageType',mapping:'product.usageType.name'}  		   	
	  	       	],
		sortInfo: {field: 'createTime',direction: 'DESC'}	
	  	       	
  	});

	productCodeStoreForWarehouseSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	humidityStoreForWarehouseSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{status:'Using'},
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	errorLevelStoreForWarehouseSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	usageTypeStoreForWarehouseSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	productTypeStoreForWarehouseSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		autoLoad:{status:'Using'},
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombinationForWarehouseSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForWarehouseSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForWarehouseSearch'
	};
	
	//2
	var txtVoltageForWarehouseSearch = {
		xtype:'textfield',
		id:'txtVoltageForWarehouseSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForWarehouseSearch'
	};
	//3
	var txtCapacityForWarehouseSearch = {
		xtype:'textfield',
		id:'txtCapacityForWarehouseSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForWarehouseSearch'
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCodeForWarehouseSearch = {
		xtype:'combo',
		store:productCodeStoreForWarehouseSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForWarehouseSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForWarehouseSearch = {
		xtype:'combo',
		store:humidityStoreForWarehouseSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForWarehouseSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbErrorLevelForWarehouseSearch = {
		xtype:'combo',
		store:errorLevelStoreForWarehouseSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForWarehouseSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForWarehouseSearch = {
		xtype:'combo',
		store:usageTypeStoreForWarehouseSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForWarehouseSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbProductTypeForWarehouseSearch = {
		xtype:'combo',
		store:productTypeStoreForWarehouseSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForWarehouseSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id'
	};

	var cbDirectionState = {
			xtype: 'combo',
			id: 'cbDirectionState',
			fieldLabel:'�����״̬',
			store: new Ext.data.ArrayStore({
				fields: [ 'id', 'name' ],
				data: [
						[ '', 'ȫ��' ],
						['0','ֱ�����'],
						['2','���ƻ����'],
						['1','ֱ�ӳ���']
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

	var txtIWSearchSavedDateStart = {
		xtype:'datefield',
		id:'txtIWSearchSavedDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtIWSearchSavedDateStart'	
	};
	
	var txtIWSearchSavedDateEnd = {
		xtype:'datefield',
		id:'txtIWSearchSavedDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtIWSearchSavedDateEnd'	
	};	
	
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtProductCombinationForWarehouseSearch,cbProductCodeForWarehouseSearch,cbUsageTypeForWarehouseSearch,txtVoltageForWarehouseSearch,txtIWSearchSavedDateStart,cbDirectionState]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForWarehouseSearch,cbHumidityForWarehouseSearch,cbErrorLevelForWarehouseSearch,txtCapacityForWarehouseSearch,txtIWSearchSavedDateEnd]		
	};

	 var warehouseSearchStoreQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'warehouseSearchStoregQueryConditionPanel',
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
 		 			warehouseSearchSearch:1,
					productCombination:Ext.getCmp('txtProductCombinationForWarehouseSearch').getValue(),
					productCode:Ext.getCmp('cbProductCodeForWarehouseSearch').getValue(),
					errorLevel:Ext.getCmp('cbErrorLevelForWarehouseSearch').getValue(),
					voltage:Ext.getCmp('txtVoltageForWarehouseSearch').getValue(),
					capacity:Ext.getCmp('txtCapacityForWarehouseSearch').getValue(),
					productType:Ext.getCmp('cbProductTypeForWarehouseSearch').getValue(),
					humidity:Ext.getCmp('cbHumidityForWarehouseSearch').getValue(),
					usageType:Ext.getCmp('cbUsageTypeForWarehouseSearch').getValue(),
					flag:Ext.getCmp('cbDirectionState').getValue(),
					SavedDateStart:Ext.getCmp('txtIWSearchSavedDateStart').getValue(),
 					SavedDateEnd:Ext.getCmp('txtIWSearchSavedDateEnd').getValue()
					
 		 	 	};
 				attributes.start = 0;
 				warehouseSearch_Store.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {warehouseSearchStoreQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				warehouseSearch_Store.reload();
			},
			scope:this
		}]
     });
     
	var warehouseSearchGrid = {
		xtype:'grid',
		id:'warehouseSearch-grid',
		anchor:'100% 65%',
		store:warehouseSearch_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'warehouseSearchGridPanel',
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
				{header:'����',width:50,dataIndex:'totalAmount'},
				{header:'״̬',width:50,dataIndex:'flag',renderer:clsys.grid.columnrender.InWarehouseFlagRender},
				{header:'ʱ��',width:80,dataIndex:'createTime'}
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
	
	var warehouseSearchPanel = Ext.getCmp('WarehouseSearch-mainpanel');
	warehouseSearchPanel.add(warehouseSearchStoreQueryConditionPanel,warehouseSearchGrid);
	clsys.form.Util.PagingToolbar(warehouseSearch_Store, warehouseSearchPanel.tbar, 'warehouseSearch-paging');
	warehouseSearchPanel.doLayout();
	  	
  });
</script>
</head>
<body>
<div id="warehouseSearchGridPanel"></div>
<div id="warehouseSearchStoregQueryConditionPanel"></div>
</body>
</html>