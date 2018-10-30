<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>计划管理</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var scheduleAduitStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['WaitForAduilt'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['WaitForAduilt'],start:0,limit:25},
	  	url:'findSchedule.action',
	  	totalProperty:'results',
	  	root:'ScheduleList',
	  	idProperty:'id',
	  	fields:['id','scheduleNo','scheduleDate','state','createTime',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productCombination',mapping:'product.productCombination'}],	      	
		sortInfo:{field: 'createTime',direction: 'ASC'}  	
  	});

	var aduitHandler = function(scheduleID,success){
		var url = (success == true ? 'aduitSuccessSchedule.action' : 'aduitFailedSchedule.action');
		var params = {id:scheduleID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				scheduleAduitStore.reload();
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

	var aduit = function(success){
		var sm = Ext.getCmp('scheduleAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		var scheduleID = sm.getSelected().get('id');
		var scheduleNo = sm.getSelected().get('scheduleNo');
		
		var strSuccess = '不通过';
		if (success) {
			strSuccess = '通过';
		}	
		var strMessage = '审核' + strSuccess +'计划号为 [' + scheduleNo + "] 的计划";

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				aduitHandler(scheduleID,success);
			}
		});	
	};
	
	var scheduleGrid = {
		xtype:'grid',
		id:'scheduleAduit-grid',
		anchor:'100% 65%',
		store:scheduleAduitStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		border:false,
		renderTo:'scheduleAduitGridPanel',
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
		id:'scheduleAduit-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){scheduleAduitStore.reload();},
		scope:this
	};
		
	var scheduleAduitPanel = Ext.getCmp('ScheduleAduit-mainpanel');
	scheduleAduitPanel.add(scheduleGrid);
	scheduleAduitPanel.getTopToolbar().add(btnAduitSuccess,btnAduitFailed,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: scheduleAduitStore
	});
	clsys.form.Util.PagingToolbar(scheduleAduitStore, scheduleAduitPanel.bbar, 'scheduleAduit-paging');
	scheduleAduitPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="scheduleAduitPanel"></div>
<div id="scheduleAduitGridPanel"></div>
<div id="scheduleAduitItemsPanel"></div>
</body>
</html>