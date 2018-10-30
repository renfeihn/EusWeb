<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>计划终止</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleTerminateStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['None','Part'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['None','Part'],start:0,limit:25},
	  	url:'findSchedule.action',
	  	totalProperty:'results',
	  	root:'ScheduleList',
	  	idProperty:'id',
	  	fields:['id','scheduleNo','scheduleDate','state','createTime','contractNo',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productCombination',mapping:'product.productCombination'}],	      	
		sortInfo:{field: 'createTime',direction: 'ASC'}  	
  	});

	var DeleteHandler = function(scheduleID,submit){
		var url = 'terminateSchedule.action';
		var params = {id:scheduleID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				scheduleTerminateStore.reload();
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
		var sm = Ext.getCmp('scheduleTerminate-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		var scheduleID = sm.getSelected().get('id');
		var scheduleNo = sm.getSelected().get('scheduleNo');		
		var strMessage = '确定终止,计划号为 [' + scheduleNo + "] 的计划";
		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(scheduleID,submit);
			}
		});	
	};
	var btnDelete = {
		text:'计划终止',
		iconCls:'icon-remove',
		handler:function(){Delete(false);},
		id:'scheduleTerminate-remove',
		scope:this
	};
	
	var scheduleGrid = {
		xtype:'grid',
		id:'scheduleTerminate-grid',
		anchor:'100% 65%',
		store:scheduleTerminateStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		border:false,
		renderTo:'scheduleTerminateGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
			    {header:'计划号',width:80,dataIndex:'scheduleNo'},
			    {header:'合同号',width:120,dataIndex:'contractNo'},
				{header:'产品名称及型号',width:150,dataIndex:'productCombination'},
				{header:'计划数量',width:40,dataIndex:'amount'},
				{header:'完成数量',width:40,dataIndex:'finishedAmount'},	
				{header:'一季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q1'},
				{header:'二季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q2'},
				{header:'三季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q3'},
				{header:'四季',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q4'},				
				{header:'交货日期',width:60,dataIndex:'scheduleDate'},
				{header:'备注',width:50,dataIndex:'memo'}			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAduitSuccess = {
		text:'通过',
		iconCls:'icon-add',
		handler:function() {aduit(true);},
		scope:this
	};

	var btnAduitFailed = {
		text:'不通过',
		iconCls:'icon-remove',
		handler:function() {aduit(false);},
		id:'scheduleTerminate-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){scheduleTerminateStore.reload();},
		scope:this
	};
		
	var scheduleTerminatePanel = Ext.getCmp('ScheduleTerminate-mainpanel');
	scheduleTerminatePanel.add(scheduleGrid);
	scheduleTerminatePanel.getTopToolbar().add(btnDelete,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: scheduleTerminateStore
	});
	clsys.form.Util.PagingToolbar(scheduleTerminateStore, scheduleTerminatePanel.bbar, 'scheduleTerminate-paging');
	scheduleTerminatePanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="scheduleTerminatePanel"></div>
<div id="scheduleTerminateGridPanel"></div>
<div id="scheduleTerminateItemsPanel"></div>
</body>
</html>