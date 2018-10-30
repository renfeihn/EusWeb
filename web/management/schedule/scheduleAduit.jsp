<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�ƻ�����</title>
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
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				scheduleAduitStore.reload();
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

	var aduit = function(success){
		var sm = Ext.getCmp('scheduleAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		var scheduleID = sm.getSelected().get('id');
		var scheduleNo = sm.getSelected().get('scheduleNo');
		
		var strSuccess = '��ͨ��';
		if (success) {
			strSuccess = 'ͨ��';
		}	
		var strMessage = '���' + strSuccess +'�ƻ���Ϊ [' + scheduleNo + "] �ļƻ�";

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
			    {header:'�ƻ���',width:80,dataIndex:'scheduleNo'},
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
		id:'scheduleAduit-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){scheduleAduitStore.reload();},
		scope:this
	};
		
	var scheduleAduitPanel = Ext.getCmp('ScheduleAduit-mainpanel');
	scheduleAduitPanel.add(scheduleGrid);
	scheduleAduitPanel.getTopToolbar().add(btnAduitSuccess,btnAduitFailed,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '��������',
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