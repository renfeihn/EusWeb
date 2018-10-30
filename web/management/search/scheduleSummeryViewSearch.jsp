<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�ƻ�Ƿ�����ܲ�ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleSummeryViewSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryScheduleSummeryView.action',
	  	totalProperty:'results',
	  	root:'ScheduleSummeryViewList',
	  	baseParams:{start:0,limit:25},
	  	idProperty:'id',
	  	fields:['id','amount','finishedAmount','restAmount',
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
  	
	var productCodeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});

	var productTypeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var txtProductCombinationForScheduleSummeryViewSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForScheduleSummeryViewSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForScheduleSummeryViewSearch'
	};
	
	//2
	var txtVoltageForScheduleSummeryViewSearch = {
		xtype:'textfield',
		id:'txtVoltageForScheduleSummeryViewSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForScheduleSummeryViewSearch'
	};
	//3
	var txtCapacityForScheduleSummeryViewSearch = {
		xtype:'textfield',
		id:'txtCapacityForScheduleSummeryViewSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForScheduleSummeryViewSearch'
	};

	//9 ��Ʒ���������б�	
	var cbProductCodeForScheduleSummeryViewSearch = {
		xtype:'combo',
		store:productCodeStoreForScheduleSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForScheduleSummeryViewSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForScheduleSummeryViewSearch = {
		xtype:'combo',
		store:humidityStoreForScheduleSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForScheduleSummeryViewSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	//11 ���ȼ�
	var cbErrorLevelForScheduleSummeryViewSearch = {
		xtype:'combo',
		store:errorLevelStoreForScheduleSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForScheduleSummeryViewSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForScheduleSummeryViewSearch = {
		xtype:'combo',
		store:usageTypeStoreForScheduleSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForScheduleSummeryViewSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	//14  ��Ʒ���
	var cbProductTypeForScheduleSummeryViewSearch = {
		xtype:'combo',
		store:productTypeStoreForScheduleSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForScheduleSummeryViewSearch',
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
		items:[cbProductCodeForScheduleSummeryViewSearch,cbErrorLevelForScheduleSummeryViewSearch,txtVoltageForScheduleSummeryViewSearch,txtProductCombinationForScheduleSummeryViewSearch]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForScheduleSummeryViewSearch,cbHumidityForScheduleSummeryViewSearch,cbUsageTypeForScheduleSummeryViewSearch,txtCapacityForScheduleSummeryViewSearch]		
	};
	
	var scheduleSummeryViewSearchGrid = {
		xtype:'grid',
		id:'scheduleSummeryViewSearch-grid',
		anchor:'100% 90%',
		store:scheduleSummeryViewSearchStore,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'scheduleSummeryViewSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��Ʒ���Ƽ��ͺ�',dataIndex:'productCombination'},
				{header:'��Ʒ����',width:40,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:40,dataIndex:'usageType'},
			    {header:'��ѹ',width:40,dataIndex:'voltage'},
			    {header:'����',width:40,dataIndex:'capacity'},
			    {header:'ʪ��',width:40,dataIndex:'humidity'},
			    {header:'���',width:40,dataIndex:'errorLevel'}, 
				{header:'��λ',width:40,dataIndex:'unit'},
				{header:'�ƻ������ϼ�',width:50,dataIndex:'amount'},
				{header:'��������ϼ�',width:50,dataIndex:'finishedAmount'},	
				{header:'Ƿ�������ϼ�',width:50,dataIndex:'restAmount'}
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

 	 var scheduleSummeryViewQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'scheduleSummeryViewQueryConditionPanel',
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
 						productCombination:Ext.getCmp('txtProductCombinationForScheduleSummeryViewSearch').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForScheduleSummeryViewSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForScheduleSummeryViewSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForScheduleSummeryViewSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForScheduleSummeryViewSearch').getValue(),
 						productType:Ext.getCmp('cbProductTypeForScheduleSummeryViewSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForScheduleSummeryViewSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForScheduleSummeryViewSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				scheduleSummeryViewSearchStore.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {scheduleSummeryViewQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				scheduleSummeryViewSearchStore.reload();
			},
			scope:this
		},{
			text:'��ӡ',
			iconCls:'icon-printer',
			handler:function(){
	   			var url = 'printQueryScheduleSummeryView.action';
 				var params = {
 						productCombination:Ext.getCmp('txtProductCombinationForScheduleSummeryViewSearch').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForScheduleSummeryViewSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForScheduleSummeryViewSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForScheduleSummeryViewSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForScheduleSummeryViewSearch').getValue(),
 						productType:Ext.getCmp('cbProductTypeForScheduleSummeryViewSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForScheduleSummeryViewSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForScheduleSummeryViewSearch').getValue()
 		 	 	};

 				var strUrl = Ext.urlEncode(params);
 				window.open(url + '?' + strUrl);
	   			params.start = 0;
 				scheduleSummeryViewSearchStore.reload({params:params});
			},
			scope:this	
		}]
     });

	var scheduleSummeryViewSearchPanel = Ext.getCmp('ScheduleSummeryViewSearch-mainpanel');
	scheduleSummeryViewSearchPanel.add(scheduleSummeryViewQueryConditionPanel,scheduleSummeryViewSearchGrid);
	clsys.form.Util.PagingToolbar(scheduleSummeryViewSearchStore, scheduleSummeryViewSearchPanel.tbar, 'scheduleSummeryViewSearch-paging');
	scheduleSummeryViewSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="scheduleSummeryViewSearchPanel"></div>
<div id="scheduleSummeryViewSearchGridPanel"></div>
<div id="scheduleSummeryViewSearchItemsPanel"></div>
<div id="scheduleSummeryViewQueryConditionPanel"></div>
</body>
</html>