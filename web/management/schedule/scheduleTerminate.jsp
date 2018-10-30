<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�ƻ���ֹ</title>
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
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				scheduleTerminateStore.reload();
			}
			else {
				clsys.message.error(result.msg);
			}
		};
		/*ʧ��ʱ�Ĵ�����*/
		var failureFunc = function(response,opts){
			clsys.message.systemerror(response.responseText.msg);
		};
		/*ʹ��AJAX�������*/
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
		var strMessage = 'ȷ����ֹ,�ƻ���Ϊ [' + scheduleNo + "] �ļƻ�";
		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(scheduleID,submit);
			}
		});	
	};
	var btnDelete = {
		text:'�ƻ���ֹ',
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
			    {header:'�ƻ���',width:80,dataIndex:'scheduleNo'},
			    {header:'��ͬ��',width:120,dataIndex:'contractNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:150,dataIndex:'productCombination'},
				{header:'�ƻ�����',width:40,dataIndex:'amount'},
				{header:'�������',width:40,dataIndex:'finishedAmount'},	
				{header:'һ��',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q1'},
				{header:'����',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q2'},
				{header:'����',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q3'},
				{header:'�ļ�',width:25,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q4'},				
				{header:'��������',width:60,dataIndex:'scheduleDate'},
				{header:'��ע',width:50,dataIndex:'memo'}			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAduitSuccess = {
		text:'ͨ��',
		iconCls:'icon-add',
		handler:function() {aduit(true);},
		scope:this
	};

	var btnAduitFailed = {
		text:'��ͨ��',
		iconCls:'icon-remove',
		handler:function() {aduit(false);},
		id:'scheduleTerminate-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){scheduleTerminateStore.reload();},
		scope:this
	};
		
	var scheduleTerminatePanel = Ext.getCmp('ScheduleTerminate-mainpanel');
	scheduleTerminatePanel.add(scheduleGrid);
	scheduleTerminatePanel.getTopToolbar().add(btnDelete,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '��������',
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