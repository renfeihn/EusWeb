<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>计划查询</title>
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
		fieldLabel:'产品名称及型号',
		width:220,
		name:'txtProductCombinationForScheduleSearch'
	};
	
	//2
	var txtVoltageForScheduleSearch = {
		xtype:'textfield',
		id:'txtVoltageForScheduleSearch',
		fieldLabel:'产品电压',
		width:220,
		name:'txtVoltageForScheduleSearch'
	};
	//3
	var txtCapacityForScheduleSearch = {
		xtype:'textfield',
		id:'txtCapacityForScheduleSearch',
		fieldLabel:'产品容量',
		width:220,
		name:'txtCapacityForScheduleSearch'
	};

	//8
	var txtMemoForScheduleSearch = {
		xtype:'textfield',
		id:'txtMemoForScheduleSearch',
		fieldLabel:'合同号',
		width:220,
		name:'txtMemoForScheduleSearch'	
	};

	var txtCompanyForScheduleSearch = {
		xtype:'textfield',
		id:'txtCompanyForScheduleSearch',
		fieldLabel:'合同厂商',
		width:220,
		name:'txtCompanyForScheduleSearch'	
	};
	
	//9 产品代号下拉列表	
	var cbProductCodeForScheduleSearch = {
		xtype:'combo',
		store:productCodeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCodeForScheduleSearch',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id',
		editable: true
	};
	
	//10 湿度系数指标	
	var cbHumidityForScheduleSearch = {
		xtype:'combo',
		store:humidityStoreForScheduleSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidityForScheduleSearch',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id',
		editable: true
	};
	
	//11 误差等级
	var cbErrorLevelForScheduleSearch = {
		xtype:'combo',
		store:errorLevelStoreForScheduleSearch,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevelForScheduleSearch',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id',
		editable: true
	};
	
	//13  产品品种
	var cbUsageTypeForScheduleSearch = {
		xtype:'combo',
		store:usageTypeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageTypeForScheduleSearch',
		width:220,
		blankText:'请选择产品品种',
		valueField:'id',
		editable: true
	};
	
	//14  产品类别
	var cbProductTypeForScheduleSearch = {
		xtype:'combo',
		store:productTypeStoreForScheduleSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbProductTypeForScheduleSearch',
		width:220,
		blankText:'请选择产品类别',
		valueField:'id',
		editable: true
	};
	
	var txtScheduleNoForScheduleSearch = {
		xtype:'textfield',
		id:'txtScheduleNoForScheduleSearch',
		fieldLabel:'计划编号',
		width:220,
		name:'txtScheduleNoForScheduleSearch'	
	};

	var txtScheduleDateStart = {
		xtype:'datefield',
		id:'txtScheduleDateStart',
		fieldLabel:'交货日期(开始)',
		width:220,
		name:'txtScheduleDateStart'	
	};
	
	var txtScheduleDateEnd = {
		xtype:'datefield',
		id:'txtScheduleDateEnd',
		fieldLabel:'交货日期(结束)',
		width:220,
		name:'txtScheduleDateEnd'	
	};
	
	var txtScheduleSavedDateStart = {
		xtype:'datefield',
		id:'txtScheduleSavedDateStart',
		fieldLabel:'保存日期(开始)',
		width:220,
		name:'txtScheduleSavedDateStart'	
	};
	
	var txtScheduleSavedDateEnd = {
		xtype:'datefield',
		id:'txtScheduleSavedDateEnd',
		fieldLabel:'保存日期(结束)',
		width:220,
		name:'txtScheduleSavedDateEnd'	
	};	
	
	var cbScheduleState = {
		xtype: 'combo',
		id: 'cbScheduleState',
		emptyText: '请选择计划状态',
		fieldLabel:'计划状态',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', '全部状态' ],
					['Saved','已保存'],
					['WaitForAduilt','待审核'],
					['AduitFailed','审核失败'],
					['None','未完成'],
					['Part','部分完成'],
					[['None','Part'],'欠交计划'],
					['Complete','全部完成'],
					['Terminated','终止']
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
		emptyText: '请选择计划是否作废',
		fieldLabel:'是否作废',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', '全部' ],
					['Using','有效'],
					['Deleted','作废']
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
		emptyText: '请选择计划类型',
		fieldLabel:'计划类型',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', '全部' ],
					['SchduleType','预投计划'],
					['ContractType','合同计划']
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
		text:'导出',
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
			    {header:'计划编号',width:120,dataIndex:'scheduleNo'},
				{header:'产品名称及型号',width:250,dataIndex:'productCombination'},
				{header:'计划数量',width:80,dataIndex:'amount'},
				{header:'完成数量',width:80,dataIndex:'finishedAmount'},				
				{header:'交货日期',width:150,dataIndex:'scheduleDate'},
				{header:'合同厂商',width:400,dataIndex:'companyName'},
				{header:'合同号',width:180,dataIndex:'contractNo'},
			    {header:'状态',width:80,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'},												
			    {header:'类型',width:80,renderer:clsys.grid.columnrender.ScheduleTypeRender,dataIndex:'scheduleType'},															    
				{header:'保存时间',width:80,dataIndex:'createTime',hidden:true}
			]
		}),
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

 	 var scheduleQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'查询条件',
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
			text: '查询',
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
			text: '清除',
			iconCls: 'icon-remove',
			handler: function() {scheduleQueryConditionPanel.getForm().reset();}
		},{
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				scheduleSearchStore.reload();
			},
			scope:this
		},{
			text:'打印',
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