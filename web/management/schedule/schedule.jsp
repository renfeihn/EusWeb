<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>计划管理</title>
<script type="text/javascript" src="js/schedule/Schedule.js"></script>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['Saved','WaitForAduilt','AduitFailed'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['Saved','WaitForAduilt','AduitFailed'],start:0,limit:25},
	  	url:'findSchedule.action',
	  	totalProperty:'results',
	  	root:'ScheduleList',
	  	idProperty:'id',
	  	fields:['id','scheduleNo','scheduleDate','state','createTime',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productCombination',mapping:'product.productCombination'}],	      	
		sortInfo:{field: 'createTime',direction: 'ASC'}  	
  	});

	var addNew = function(){
		var wnd = Ext.getCmp('schedule-window');
		if (!wnd) {
			var wnd = new eus.window.Schedule();
			wnd.on('scheduleSaved', function(attr){
				scheduleStore.reload();
			});
		}
		wnd.doAutoReload();
		wnd.show();
	};
	
	var btnPrint = {
		text:'导出',
		iconCls:'icon-printer',
		handler:function(){
			window.open('getReportSchedule.action');
		},
		scope:this
	};
	
	var Update = function(){
		/*只有选中资料时才可以进行修改操作*/
		var sm = Ext.getCmp('schedule-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var scheduleID = sm.getSelected().get('id');
		var contractNO = sm.getSelected().get('contractNo');
		var state = parseInt(sm.getSelected().get('state'));

		/*合同计划不能进行修改*/
		if (!Ext.isEmpty(contractNO)) return;

		/*待审核的计划不能进行修改*/
		if (state == 1) return;
			
		var wnd = Ext.getCmp('schedule-window');
		if (!wnd) {
			var wnd = new eus.window.Schedule();
			wnd.on('scheduleSaved', function(attr){
				scheduleStore.reload();
			});
		}
		wnd.open(scheduleID);
		wnd.show();
	};

	var DeleteHandler = function(scheduleID,submit){
		var url = (submit == true ? 'submitSchedule.action' : 'removeSchedule.action');
		var params = {id:scheduleID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				scheduleStore.reload();
			}
			else {
				clsys.message.error(result.msg);
			}
		};
		/*失败时的处理函数*/
		var failureFunc = function(response,opts){
			clsys.message.systemerror(response.responseText.msg);
		};
		/*使用AJAX完成请求*/
		Ext.Ajax.request({
			url:url,
			success:successFunc,
			failure:failureFunc,
			params:params,
			scope:this
		});	
	};

	var Delete = function(submit){
		var sm = Ext.getCmp('schedule-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		var scheduleID = sm.getSelected().get('id');
		var scheduleNo = sm.getSelected().get('scheduleNo');		
		var strMessage = '确定作废,计划号为 [' + scheduleNo + "] 的计划";
		if (submit){
			strMessage = '提交审核,计划号为 [' + scheduleNo + "] 的计划";
		}
		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(scheduleID,submit);
			}
		});	
	};
	
	var scheduleGrid = {
		xtype:'grid',
		id:'schedule-grid',
		anchor:'100% 65%',
		store:scheduleStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		border:false,
		renderTo:'scheduleGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
			    {header:'计划号',width:80,dataIndex:'scheduleNo'},
				{header:'产品名称及型号',width:150,dataIndex:'productCombination'},
				{header:'计划数量',width:40,dataIndex:'amount'},
				{header:'完成数量',width:40,dataIndex:'finishedAmount'},	
				{header:'一季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q1'},
				{header:'二季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q2'},
				{header:'三季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q3'},
				{header:'四季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q4'},
				{header:'交货日期',width:60,dataIndex:'scheduleDate'},				
				{header:'备注',width:50,dataIndex:'memo'},
			    {header:'状态',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}						
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAddNew = {
		text:'新增',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnUpdate = {
		text:'修改',
		iconCls:'icon-prop',
		handler:Update,
		id:'schedule-update',
		scope:this
	};

	var btnDelete = {
		text:'作废',
		iconCls:'icon-remove',
		handler:function(){Delete(false);},
		id:'schedule-remove',
		scope:this
	};

	var btnSubmit = {
		text:'提交审核',
		iconCls:'icon-commit',
		handler:function(){Delete(true);},
		id:'schedule-submit',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){scheduleStore.reload();},
		scope:this
	};
		
	var schedulePanel = Ext.getCmp('ScheduleApplication-mainpanel');
	schedulePanel.add(scheduleGrid);
	schedulePanel.getTopToolbar().add(btnAddNew,btnSubmit,btnUpdate,btnDelete,btnRefresh,btnPrint,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: scheduleStore
	});
	clsys.form.Util.PagingToolbar(scheduleStore, schedulePanel.bbar, 'schedule-paging');
	schedulePanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="schedulePanel"></div>
<div id="scheduleGridPanel"></div>
<div id="scheduleItemsPanel"></div>
</body>
</html>