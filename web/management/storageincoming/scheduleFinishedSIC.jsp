<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>超计划入库</title>
<script type="text/javascript" src="js/storageincoming/ScheduleFinishedStorageIncoming.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleFinishedSICStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['Complete'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['Complete'],start:0,limit:25},
	  	url:'findSchedule.action',
	  	totalProperty:'results',
	  	root:'ScheduleList',
	  	idProperty:'id',
	  	fields:['id','scheduleNo','scheduleDate','createTime',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productID',mapping:'product.id'},
	  	        {name:'productCombination',mapping:'product.productCombination'},
		        {name:'productTypeID',mapping:'product.productType.id'}],  	
		sortInfo:{field: 'createTime',direction: 'ASC'}  	
  	});

	var addNew = function(){
		var sm = Ext.getCmp('scheduleFinishedSIC-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var scheduleFinishedSICID = sm.getSelected().get('id');
		var productID = sm.getSelected().get('productID');
		var productTypeID = sm.getSelected().get('productTypeID');
		var scheduleNo = sm.getSelected().get('scheduleNo'); 
		var amount = sm.getSelected().get('amount');
		var finishedAmount = sm.getSelected().get('finishedAmount');
		
		var wnd = Ext.getCmp('eus-scheduleFinishedSIC-product-window');
		if (!wnd) {
			var wnd = new eus.window.ScheduleFinishedSICProduct();
			wnd.on('scheduleFinishedSICSaved', function(attr){
				scheduleFinishedSICStore.reload();
			});
		}
		wnd.open(scheduleFinishedSICID,scheduleNo,amount,finishedAmount,productID,productTypeID);
		wnd.show();
	};

	var scheduleFinishedSICGrid = {
		xtype:'grid',
		id:'scheduleFinishedSIC-grid',
		anchor:'100% 65%',
		store:scheduleFinishedSICStore,
		stripeRows:true,
		autoScroll:true,
		listeners:{'dblclick':addNew,scope:this},
		border:false,
		renderTo:'scheduleFinishedSICGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
			    {header:'计划编号',width:60,dataIndex:'scheduleNo'},
				{header:'产品名称及型号',width:150,dataIndex:'productCombination'},
				{header:'计划数量',width:40,dataIndex:'amount'},
				{header:'完成数量',width:40,dataIndex:'finishedAmount'},	
				{header:'一季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q1'},
				{header:'二季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q2'},
				{header:'三季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q3'},
				{header:'四季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q4'},				
				{header:'交货日期',width:60,dataIndex:'scheduleDate'},
				{header:'合同号',width:100,dataIndex:'contractNo',hidden:true},
			    {header:'生成时间',width:100,dataIndex:'createTime'},
				{header:'备注',width:50,dataIndex:'memo'}						
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAddNew = {
		text:'新增入库单',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){scheduleFinishedSICStore.reload();},
		scope:this
	};
		
	var scheduleFinishedSICPanel = Ext.getCmp('ScheduleFinishedStorageIncomingApplication-mainpanel');
	scheduleFinishedSICPanel.add(scheduleFinishedSICGrid);
	scheduleFinishedSICPanel.getTopToolbar().add(btnAddNew,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: scheduleFinishedSICStore
	});
	clsys.form.Util.PagingToolbar(scheduleFinishedSICStore, scheduleFinishedSICPanel.bbar, 'scheduleFinishedSIC-paging');
	scheduleFinishedSICPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="scheduleFinishedSICPanel"></div>
<div id="scheduleFinishedSICGridPanel"></div>
<div id="scheduleFinishedSICItemsPanel"></div>
</body>
</html>