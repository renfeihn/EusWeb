<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��ͬ��ֹ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractTerminateStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['None','Part'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['None','Part']},
	  	url:'findContract.action',
	  	totalProperty:'results',
	  	root:'ContractList',
	  	idProperty:'id',
	  	fields:['id','contractNo','contractDate','items','state','createTime',
	  		  	'totalFinishedAmount','totalCheckingAmount','totalAmount','totalSum',
	  	        {name:'company',mapping:'company.name'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}],
	  	sortInfo: {field: 'createTime',direction: 'ASC'}
  	});

	var contractTerminateGetItemsStore = new Ext.data.JsonStore({
  		url:'getContract.action',
  		root:'Contract',
		fields: ['id','items']
  	});

  	var contractTerminateItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
  		fields:['id','amount','price','originalPrice','subTotal','finishedAmount',
  		      	{name:'contractItemNo', type:'int'},
	  	        {name:'productCombination',mapping:'product.productCombination'}],
	    sortInfo: {field:'contractItemNo',direction:'ASC'}        	
  	});

	var showItems = function(sm){
		Ext.getCmp('contractTerminate-showitems-button').setDisabled(sm.getCount() < 1);
		contractTerminateGetItemsStore.removeAll();
		contractTerminateItemsStore.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('contractTerminateItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				contractTerminateGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = contractTerminateGetItemsStore.getAt(0);
						if (rc) {
							contractTerminateItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var DeleteHandler = function(contractTerminateID,submit){
		var url = (submit == true ? '' : 'terminateContract.action');
		var params = {id:contractTerminateID};
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				contractTerminateStore.reload();
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
		var sm = Ext.getCmp('contractTerminate-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var contractTerminateID = sm.getSelected().get('id');		
		var contractNo = sm.getSelected().get('contractNo');
		var state = parseInt(sm.getSelected().get('state'));
		
		/*����˵ļƻ����ܽ����ύ��ɾ��*/
		if (state == 1) return;
		
		var strMessage = 'ȷ����ֹ,��ͬ��Ϊ [' + contractNo + "] �ĺ�ͬ";

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(contractTerminateID,submit);
			}
		});	
	};

	var btnDelete = {
		text:'��ͬ��ֹ',
		iconCls:'icon-remove',
		handler:function(){Delete(false);},
		id:'contractTerminate-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){contractTerminateStore.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '��ϸ��Ϣ',
		id: 'contractTerminate-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('contractTerminateItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('contractTerminate-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			contractTerminatePanel.doLayout();			
		}
	};
	
	var contractTerminateGrid = {
		xtype:'grid',
		id:'contractTerminate-grid',
		anchor:'100% 65%',
		store:contractTerminateStore,
		stripeRows:true,
		loadMask:true,
		autoScroll:true,
		border:false,
		renderTo:'contractTerminateGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��ͬ��',width:150,dataIndex:'contractNo'},
				{header:'��ͬ����',width:150,dataIndex:'company'},
				{header:'�����ܼ�',width:50,dataIndex:'totalAmount'},
				{header:'����ܼ�',width:50,dataIndex:'totalFinishedAmount'},	
				{header:'����ܼ�',width:50,dataIndex:'totalCheckingAmount'},
				{header:'����ܼ�',width:50,dataIndex:'totalSum'},
				{header:'��ͬ����',width:80,dataIndex:'contractDate'},
				{header:'��Ա���',width:70,dataIndex:'empCode'},
				{header:'����',width:50,dataIndex:'empName'},	
			    {header:'״̬',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}													
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var contractTerminateItemsGrid = {
		xtype:'grid',
		id:'contractTerminateItems-grid',
		anchor:'100% 35%',
		store:contractTerminateItemsStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		hidden:true,
		border:false,
		renderTo:'contractTerminateItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
	            {header:'���',width:30,dataIndex:'contractItemNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:250,dataIndex:'productCombination'},
				{header:'����С��',width:70,dataIndex:'amount'},
				{header:'��ͬ�۸�',width:70,dataIndex:'price'},
				{header:'ԭʼ�۸�',width:70,dataIndex:'originalPrice'},
				{header:'���С��',width:70,dataIndex:'subTotal'}				
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar: ['<b>Ԥ��</b>', {
			iconCls: 'icon-remove',
			text: '�ر�Ԥ��',
			handler: function() {
				Ext.getCmp('contractTerminate-showitems-button').toggle();
			}
		}]
	};	
		
	var contractTerminatePanel = Ext.getCmp('ContractTerminate-mainpanel');
	contractTerminatePanel.add(contractTerminateGrid,contractTerminateItemsGrid);
	contractTerminatePanel.getTopToolbar().add(btnDelete,btnShowItems,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '��������',
		width:300,
		store: contractTerminateStore
	});
	clsys.form.Util.PagingToolbar(contractTerminateStore, contractTerminatePanel.bbar, 'contractTerminate-paging');
	contractTerminatePanel.doLayout();

	Ext.getCmp('contractTerminate-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="contractTerminatePanel"></div>
<div id="contractTerminateGridPanel"></div>
<div id="contractTerminateItemsPanel"></div>
<div id="contractTerminateSelectorPanel"></div>
</body>
</html>