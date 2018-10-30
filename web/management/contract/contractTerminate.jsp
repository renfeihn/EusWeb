<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>合同终止</title>
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
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
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
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				contractTerminateStore.reload();
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
		var sm = Ext.getCmp('contractTerminate-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var contractTerminateID = sm.getSelected().get('id');		
		var contractNo = sm.getSelected().get('contractNo');
		var state = parseInt(sm.getSelected().get('state'));
		
		/*待审核的计划不能进行提交和删除*/
		if (state == 1) return;
		
		var strMessage = '确定终止,合同号为 [' + contractNo + "] 的合同";

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(contractTerminateID,submit);
			}
		});	
	};

	var btnDelete = {
		text:'合同终止',
		iconCls:'icon-remove',
		handler:function(){Delete(false);},
		id:'contractTerminate-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){contractTerminateStore.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细信息',
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
				{header:'合同号',width:150,dataIndex:'contractNo'},
				{header:'合同厂商',width:150,dataIndex:'company'},
				{header:'数量总计',width:50,dataIndex:'totalAmount'},
				{header:'完成总计',width:50,dataIndex:'totalFinishedAmount'},	
				{header:'审核总计',width:50,dataIndex:'totalCheckingAmount'},
				{header:'金额总计',width:50,dataIndex:'totalSum'},
				{header:'合同日期',width:80,dataIndex:'contractDate'},
				{header:'人员编号',width:70,dataIndex:'empCode'},
				{header:'姓名',width:50,dataIndex:'empName'},	
			    {header:'状态',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}													
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
	            {header:'序号',width:30,dataIndex:'contractItemNo'},
				{header:'产品名称及型号',width:250,dataIndex:'productCombination'},
				{header:'数量小计',width:70,dataIndex:'amount'},
				{header:'合同价格',width:70,dataIndex:'price'},
				{header:'原始价格',width:70,dataIndex:'originalPrice'},
				{header:'金额小计',width:70,dataIndex:'subTotal'}				
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar: ['<b>预览</b>', {
			iconCls: 'icon-remove',
			text: '关闭预览',
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
		emptyText: '输入条件',
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