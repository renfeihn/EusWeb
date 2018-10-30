<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�ƻ���ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryScheduleView.action',
	  	totalProperty:'results',
	  	root:'ScheduleViewList',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	idProperty:'id',
	  	fields:['id','scheduleNo','scheduleType','scheduleDate','createTime','state',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productID',mapping:'product.id'},
	  	        {name:'productCombination',mapping:'product.productCombination'},
	  	        {name:'companyName',mapping:'company.name'},
		        {name:'productTypeID',mapping:'product.productType.id'}],  	
		sortInfo:{field: 'scheduleNo',direction: 'ASC'}  	
  	});
  	
	var productCodeStoreForScheduleSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var humidityStoreForScheduleSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var errorLevelStoreForScheduleSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var usageTypeStoreForScheduleSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});

	var productTypeStoreForScheduleSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var txtProductCombinationForScheduleSearch = {
		xtype:'textfield',
		id:'txtProductCombinationForScheduleSearch',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombinationForScheduleSearch'
	};
	
	//2
	var txtVoltageForScheduleSearch = {
		xtype:'textfield',
		id:'txtVoltageForScheduleSearch',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtVoltageForScheduleSearch'
	};
	//3
	var txtCapacityForScheduleSearch = {
		xtype:'textfield',
		id:'txtCapacityForScheduleSearch',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtCapacityForScheduleSearch'
	};

	//8
	var txtMemoForScheduleSearch = {
		xtype:'textfield',
		id:'txtMemoForScheduleSearch',
		fieldLabel:'��ͬ��',
		width:220,
		name:'txtMemoForScheduleSearch'	
	};

	var txtCompanyForScheduleSearch = {
		xtype:'textfield',
		id:'txtCompanyForScheduleSearch',
		fieldLabel:'��ͬ����',
		width:220,
		name:'txtCompanyForScheduleSearch'	
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCodeForScheduleSearch = {
		xtype:'combo',
		store:productCodeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCodeForScheduleSearch',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id',
		editable: true
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidityForScheduleSearch = {
		xtype:'combo',
		store:humidityStoreForScheduleSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidityForScheduleSearch',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id',
		editable: true
	};
	
	//11 ���ȼ�
	var cbErrorLevelForScheduleSearch = {
		xtype:'combo',
		store:errorLevelStoreForScheduleSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevelForScheduleSearch',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id',
		editable: true
	};
	
	//13  ��ƷƷ��
	var cbUsageTypeForScheduleSearch = {
		xtype:'combo',
		store:usageTypeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageTypeForScheduleSearch',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id',
		editable: true
	};
	
	//14  ��Ʒ���
	var cbProductTypeForScheduleSearch = {
		xtype:'combo',
		store:productTypeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductTypeForScheduleSearch',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id',
		editable: true
	};
	
	var txtScheduleNoForScheduleSearch = {
		xtype:'textfield',
		id:'txtScheduleNoForScheduleSearch',
		fieldLabel:'�ƻ����',
		width:220,
		name:'txtScheduleNoForScheduleSearch'	
	};

	var txtScheduleDateStart = {
		xtype:'datefield',
		id:'txtScheduleDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtScheduleDateStart'	
	};
	
	var txtScheduleDateEnd = {
		xtype:'datefield',
		id:'txtScheduleDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtScheduleDateEnd'	
	};
	
	var txtScheduleSavedDateStart = {
		xtype:'datefield',
		id:'txtScheduleSavedDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtScheduleSavedDateStart'	
	};
	
	var txtScheduleSavedDateEnd = {
		xtype:'datefield',
		id:'txtScheduleSavedDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtScheduleSavedDateEnd'	
	};	
	
	var cbScheduleState = {
		xtype: 'combo',
		id: 'cbScheduleState',
		emptyText: '��ѡ��ƻ�״̬',
		fieldLabel:'�ƻ�״̬',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', 'ȫ��״̬' ],
					['Saved','�ѱ���'],
					['WaitForAduilt','�����'],
					['AduitFailed','���ʧ��'],
					['None','δ���'],
					['Part','�������'],
					[['None','Part'],'Ƿ���ƻ�'],
					['Complete','ȫ�����'],
					['Terminated','��ֹ']
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
	
	
	var cbScheduleStatus = {
		xtype: 'combo',
		id: 'cbScheduleStatus',
		emptyText: '��ѡ��ƻ��Ƿ�����',
		fieldLabel:'�Ƿ�����',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', 'ȫ��' ],
					['Using','��Ч'],
					['Deleted','����']
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


	var cbScheduleType = {
		xtype: 'combo',
		id: 'cbScheduleType',
		emptyText: '��ѡ��ƻ�����',
		fieldLabel:'�ƻ�����',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', 'ȫ��' ],
					['SchduleType','ԤͶ�ƻ�'],
					['ContractType','��ͬ�ƻ�']
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
		items:[txtScheduleNoForScheduleSearch,cbScheduleType,txtScheduleDateStart,txtScheduleDateEnd,cbProductCodeForScheduleSearch,cbErrorLevelForScheduleSearch,txtVoltageForScheduleSearch,txtCapacityForScheduleSearch,txtProductCombinationForScheduleSearch]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbScheduleStatus,cbScheduleState,txtScheduleSavedDateStart,txtScheduleSavedDateEnd,cbProductTypeForScheduleSearch,cbHumidityForScheduleSearch,cbUsageTypeForScheduleSearch,txtMemoForScheduleSearch,txtCompanyForScheduleSearch]		
	};
	
	var btnPrint = {
		text:'����',
		iconCls:'icon-printer',
		handler:function(){
			window.open('getReportSchedule.action');
		},
		scope:this
	};
	
	var scheduleSearchGrid = {
		xtype:'grid',
		id:'scheduleSearch-grid',
		anchor:'100% 90%',
		store:scheduleSearchStore,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		frame:true,
		renderTo:'scheduleSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
			    {header:'�ƻ����',width:120,dataIndex:'scheduleNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:250,dataIndex:'productCombination'},
				{header:'�ƻ�����',width:80,dataIndex:'amount'},
				{header:'�������',width:80,dataIndex:'finishedAmount'},				
				{header:'��������',width:150,dataIndex:'scheduleDate'},
				{header:'��ͬ����',width:400,dataIndex:'companyName'},
				{header:'��ͬ��',width:180,dataIndex:'contractNo'},
			    {header:'״̬',width:80,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'},												
			    {header:'����',width:80,renderer:clsys.grid.columnrender.ScheduleTypeRender,dataIndex:'scheduleType'},															    
				{header:'����ʱ��',width:80,dataIndex:'createTime',hidden:true}
			]
		}),
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

 	 var scheduleQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'scheduleQueryConditionPanel',
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
 						scheduleNo:Ext.getCmp('txtScheduleNoForScheduleSearch').getValue(),
 						productCombination:Ext.getCmp('txtProductCombinationForScheduleSearch').getValue(),
 						scheduleDateStart:Ext.getCmp('txtScheduleDateStart').getValue(),
 						scheduleDateEnd:Ext.getCmp('txtScheduleDateEnd').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForScheduleSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForScheduleSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForScheduleSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForScheduleSearch').getValue(),
 						status:Ext.getCmp('cbScheduleStatus').getValue(),
 						states:Ext.getCmp('cbScheduleState').getValue(),
 						scheduleSavedDateStart:Ext.getCmp('txtScheduleSavedDateStart').getValue(),
 						scheduleSavedDateEnd:Ext.getCmp('txtScheduleSavedDateEnd').getValue(),
 						productType:Ext.getCmp('cbProductTypeForScheduleSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForScheduleSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForScheduleSearch').getValue(),
 						scheduleType:Ext.getCmp('cbScheduleType').getValue(),
 						memo:Ext.getCmp('txtMemoForScheduleSearch').getValue(),
 						companyName:Ext.getCmp('txtCompanyForScheduleSearch').getValue()
 		 	 	};
 				attributes.start = 0;
 				scheduleSearchStore.reload({params:attributes});
  			}
		},{
			text: '���',
			iconCls: 'icon-remove',
			handler: function() {scheduleQueryConditionPanel.getForm().reset();}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				scheduleSearchStore.reload();
			},
			scope:this
		},{
			text:'��ӡ',
			iconCls:'icon-printer',
			handler:function(){
	   			var url = 'printQueryScheduleView.action';
 				var params = {
 						scheduleNo:Ext.getCmp('txtScheduleNoForScheduleSearch').getValue(),
 						productCombination:Ext.getCmp('txtProductCombinationForScheduleSearch').getValue(),
 						scheduleDateStart:Ext.getCmp('txtScheduleDateStart').getValue(),
 						scheduleDateEnd:Ext.getCmp('txtScheduleDateEnd').getValue(),
 						productCode:Ext.getCmp('cbProductCodeForScheduleSearch').getValue(),
 						errorLevel:Ext.getCmp('cbErrorLevelForScheduleSearch').getValue(),
 						voltage:Ext.getCmp('txtVoltageForScheduleSearch').getValue(),
 						capacity:Ext.getCmp('txtCapacityForScheduleSearch').getValue(),
 						status:Ext.getCmp('cbScheduleStatus').getValue(),
 						states:Ext.getCmp('cbScheduleState').getValue(),
 						scheduleSavedDateStart:Ext.getCmp('txtScheduleSavedDateStart').getValue(),
 						scheduleSavedDateEnd:Ext.getCmp('txtScheduleSavedDateEnd').getValue(),
 						productType:Ext.getCmp('cbProductTypeForScheduleSearch').getValue(),
 						humidity:Ext.getCmp('cbHumidityForScheduleSearch').getValue(),
 						usageType:Ext.getCmp('cbUsageTypeForScheduleSearch').getValue(),
 						scheduleType:Ext.getCmp('cbScheduleType').getValue(),
 						memo:Ext.getCmp('txtMemoForScheduleSearch').getValue(),
 						companyName:Ext.getCmp('txtCompanyForScheduleSearch').getValue()
 		 	 	};

 				var strUrl = Ext.urlEncode(params);
 				window.open(url + '?' + strUrl);
	   			params.start = 0;
 				scheduleSearchStore.reload({params:params});
			},
			scope:this	
		}]
     });

	var scheduleSearchPanel = Ext.getCmp('ScheduleSearch-mainpanel');
	scheduleSearchPanel.add(scheduleQueryConditionPanel,scheduleSearchGrid);
	clsys.form.Util.PagingToolbar(scheduleSearchStore, scheduleSearchPanel.tbar, 'scheduleSearch-paging');
	scheduleSearchPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="scheduleSearchPanel"></div>
<div id="scheduleSearchGridPanel"></div>
<div id="scheduleSearchItemsPanel"></div>
<div id="scheduleQueryConditionPanel"></div>
</body>
</html>