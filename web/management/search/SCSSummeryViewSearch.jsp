<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��Դ���ܲ�ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();

	var cbVarAmount = {
		xtype: 'combo',
		id: 'cbVarAmount',
		emptyText: '',
		fieldLabel:'���״̬',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					['0','ȫ��'],
					['1','����0'],
					['2','����0'],
					['3','С��0']
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

    var srAmount1 = {
          xtype: 'combo',
          id: 'srAmount1',
          emptyText: '',
          fieldLabel:'��Դ��',
          store: new Ext.data.ArrayStore({
              fields: [ 'id', 'name' ],
              data: [
                  ['0','ȫ��'],
                  ['1','����0'],
                  ['2','����0'],
                  ['3','С��0']
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

	
	var SCSSummerySearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'querySummerySCSSummeryView.action',
	  	root:'SCSSumeryList',
	  	totalProperty:'results',
	  	fields:['srTotalAmount','srAmount','coCheckingAmount','coUnfinishedAmount','coOwnedAmount','ssRestAmount','varAmount']  	
  	});
	
	var SCSSummeryViewSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'querySCSSummeryView.action',
	  	totalProperty:'results',
	  	root:'SCSSummeryViewList',
	  	baseParams:{start:0,limit:25},
	  	idProperty:'id',
	  	fields:['id',
	  	      	'coAmount','coFinishedAmount','coCheckingAmount','coUnfinishedAmount','coRestAmount','coOwnedAmount',
	  	    	'srAmount','srAdvancedAmount','srTotalAmount','srRestAmount','srVarAmount',
	  	    	'ssAmount','ssFinishedAmount','ssRestAmount','varAmount',
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
  	
	var productCodeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});

	var productTypeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var txtMinForSCSSummeryViewSearch = {
		xtype:'textfield',
		id:'txtMinForSCSSummeryViewSearch',
		fieldLabel:'���(��С)',
		width:220,
		name:'txtMinForSCSSummeryViewSearch'
	};
	
	var txtMaxForSCSSummeryViewSearch = {
		xtype:'textfield',
		id:'txtMaxForSCSSummeryViewSearch',
		fieldLabel:'���(���)',
		width:220,
		name:'txtMaxForSCSSummeryViewSearch'
	};
	
	var txtProductCombinationForSCSSummeryViewSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForSCSSummeryViewSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForSCSSummeryViewSearch'
	};
	
	//2
	var txtVoltageForSCSSummeryViewSearch = {
		xtype:'textfield',
		id:'txtVoltageForSCSSummeryViewSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForSCSSummeryViewSearch'
	};
	//3
	var txtCapacityForSCSSummeryViewSearch = {
		xtype:'textfield',
		id:'txtCapacityForSCSSummeryViewSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForSCSSummeryViewSearch'
	};

	//9 ��Ʒ���������б�	
	var cbProductCodeForSCSSummeryViewSearch = {
		xtype:'combo',
		store:productCodeStoreForSCSSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForSCSSummeryViewSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForSCSSummeryViewSearch = {
		xtype:'combo',
		store:humidityStoreForSCSSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForSCSSummeryViewSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	//11 ���ȼ�
	var cbErrorLevelForSCSSummeryViewSearch = {
		xtype:'combo',
		store:errorLevelStoreForSCSSummeryViewSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForSCSSummeryViewSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForSCSSummeryViewSearch = {
		xtype:'combo',
		store:usageTypeStoreForSCSSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForSCSSummeryViewSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	//14  ��Ʒ���
	var cbProductTypeForSCSSummeryViewSearch = {
		xtype:'combo',
		store:productTypeStoreForSCSSummeryViewSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForSCSSummeryViewSearch',
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
		items:[cbProductCodeForSCSSummeryViewSearch,cbErrorLevelForSCSSummeryViewSearch,txtVoltageForSCSSummeryViewSearch,txtProductCombinationForSCSSummeryViewSearch,txtMinForSCSSummeryViewSearch,cbVarAmount,srAmount1]
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductTypeForSCSSummeryViewSearch,cbHumidityForSCSSummeryViewSearch,cbUsageTypeForSCSSummeryViewSearch,txtCapacityForSCSSummeryViewSearch,txtMaxForSCSSummeryViewSearch]		
	};
	
	var SCSSummeryViewSearchGrid = new Ext.grid.EditorGridPanel ({
		xtype:'grid',
		id:'SCSSummeryViewSearch-grid',
		anchor:'100% 75%',
		store:SCSSummeryViewSearchStore,
		stripeRows:true,
		autoScroll:true,
		clicksToEdit:1,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'SCSSummeryViewSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��Ʒ���Ƽ��ͺ�',width:150,dataIndex:'productCombination',editor:{xtype:'textfield'}},
				{header:'�����',width:50,dataIndex:'srTotalAmount'},
				{header:'��Դ��',width:50,dataIndex:'srAmount'},
				{header:'��ͬ�����',width:60,dataIndex:'coCheckingAmount'},				
				{header:'��ͬǷ����',width:60,dataIndex:'coUnfinishedAmount'},
				{header:'��ͬ�Կ�Ƿ����',width:80,dataIndex:'coOwnedAmount',renderer:clsys.grid.columnrender.coOwnedAmount},
				{header:'�ƻ�Ƿ����',width:60,dataIndex:'ssRestAmount'},
				{header:'���',width:50,dataIndex:'varAmount',renderer:clsys.grid.columnrender.varStyle},
				{header:'��Ʒ����',width:50,dataIndex:'productCode'},
			    {header:'��ƷƷ��',width:50,dataIndex:'usageType'},
			    {header:'��ѹ',width:40,dataIndex:'voltage'},
			    {header:'����',width:40,dataIndex:'capacity'},
			    {header:'ʪ��',width:40,dataIndex:'humidity'},
			    {header:'���',width:40,dataIndex:'errorLevel'}, 
				{header:'��λ',width:40,dataIndex:'unit'}
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	var SCSSummerySearchGrid = new Ext.grid.EditorGridPanel ({
		xtype:'grid',
		id:'SCSSummerySearch-grid',
		anchor:'100% 15%',
		store:SCSSummerySearchStore,
		stripeRows:true,
		autoScroll:true,
		clicksToEdit:1,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'SCSSummerySearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'������ϼ�',width:50,dataIndex:'srTotalAmount'},
				{header:'��Դ���ϼ�',width:50,dataIndex:'srAmount'},
				{header:'��ͬ������ϼ�',width:60,dataIndex:'coCheckingAmount'},				
				{header:'��ͬǷ�����ϼ�',width:60,dataIndex:'coUnfinishedAmount'},
				{header:'��ͬ�Կ�Ƿ�����ϼ�',width:80,dataIndex:'coOwnedAmount',renderer:clsys.grid.columnrender.coOwnedAmount},
				{header:'�ƻ�Ƿ�����ϼ�',width:60,dataIndex:'ssRestAmount'},
				{header:'���ϼ�',width:50,dataIndex:'varAmount',renderer:clsys.grid.columnrender.varStyle}
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	});

 	 var SCSSummeryViewQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'SCSSummeryViewQueryConditionPanel',
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
 						varAmount:Ext.getCmp('cbVarAmount').getValue(),
 						minAmount:Ext.getCmp('txtMinForSCSSummeryViewSearch').getValue(),
 						maxAmount:Ext.getCmp('txtMaxForSCSSummeryViewSearch').getValue(), 						
 						productCombination:Ext.getCmp('txtProductCombinationForSCSSummeryViewSearch').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForSCSSummeryViewSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForSCSSummeryViewSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForSCSSummeryViewSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForSCSSummeryViewSearch').getValue(),
 						productType:Ext.getCmp('cbProductTypeForSCSSummeryViewSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForSCSSummeryViewSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForSCSSummeryViewSearch').getValue(),
 						srAmount:Ext.getCmp('srAmount1').getValue()
 		 	 	};
 				attributes.start = 0;
 				SCSSummeryViewSearchStore.reload({params:attributes});
 				SCSSummerySearchStore.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {SCSSummeryViewQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				SCSSummeryViewSearchStore.reload();
			},
			scope:this
		}]
     });

	var SCSSummeryViewSearchPanel = Ext.getCmp('SCSSummeryViewSearch-mainpanel');
	SCSSummeryViewSearchPanel.add(SCSSummeryViewQueryConditionPanel,SCSSummerySearchGrid,SCSSummeryViewSearchGrid);
	clsys.form.Util.PagingToolbar(SCSSummeryViewSearchStore, SCSSummeryViewSearchPanel.tbar, 'SCSSummeryViewSearch-paging');
	SCSSummeryViewSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="SCSSummeryViewSearchPanel"></div>
<div id="SCSSummerySearchGridPanel"></div>
<div id="SCSSummeryViewSearchGridPanel"></div>
<div id="SCSSummeryViewSearchItemsPanel"></div>
<div id="SCSSummeryViewQueryConditionPanel"></div>
</body>
</html>