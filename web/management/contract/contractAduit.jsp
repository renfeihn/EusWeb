<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>合同管理</title>

<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractAduitStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['WaitForAduilt'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['WaitForAduilt']},
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

	var contractAduitGetItemsStore = new Ext.data.JsonStore({
  		url:'getContract.action',
  		root:'Contract',
		fields: ['id','items']
  	});

  	var contractAduitItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
  		fields:['id','amount','price','originalPrice','subTotal','finishedAmount',
  		      	{name:'contractItemNo', type:'int'},
	  	        {name:'productCombination',mapping:'product.productCombination'}],
 		sortInfo: {field:'contractItemNo',direction:'ASC'}        		
  	});

	var showItems = function(sm){
		Ext.getCmp('contractAduit-showitems-button').setDisabled(sm.getCount() < 1);
		contractAduitGetItemsStore.removeAll();
		contractAduitItemsStore.removeAll();
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
		if (Ext.getCmp('contractAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				contractAduitGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = contractAduitGetItemsStore.getAt(0);
						if (rc) {
							contractAduitItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};
	var aduitHandler = function(contractID,success){
		var url = (success == true ? 'aduitSuccessContract.action' : 'aduitFailedContract.action');
		var params = {id:contractID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				contractAduitStore.reload();
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
		var sm = Ext.getCmp('contractAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		var contractID = sm.getSelected().get('id');
		var createTime = sm.getSelected().get('createTime');
		
		var strSuccess = '不通过';
		if (success) {
			strSuccess = '通过';
		}	
		var strMessage = '审核' + strSuccess +',保存时间为 [' + createTime + "] 的合同";

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				aduitHandler(contractID,success);
			}
		});	
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
		id:'contractAduit-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){contractAduitStore.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细信息',
		id: 'contractAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('contractAduitItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('contractAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			contractAduitPanel.doLayout();			
		}
	};
	
	var contractAduitGrid = {
		xtype:'grid',
		id:'contractAduit-grid',
		anchor:'100% 65%',
		store:contractAduitStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		border:false,
		renderTo:'contractAduitGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'合同号',width:120,dataIndex:'contractNo'},
				{header:'合同厂商',width:150,dataIndex:'company'},
				{header:'数量总计',width:50,dataIndex:'totalAmount'},
				{header:'金额总计',width:50,dataIndex:'totalSum'},
				{header:'交货期',width:80,dataIndex:'contractDate'},
				{header:'保存时间',width:120,dataIndex:'createTime'},
			    {header:'状态',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}													
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var contractAduitItemsGrid = {
		xtype:'grid',
		id:'contractAduitItems-grid',
		anchor:'100% 35%',
		store:contractAduitItemsStore,
		stripeRows:true,
		autoScroll:true,
		hidden:true,
		loadMask:true,
		border:false,
		renderTo:'contractAduitItemsPanel',
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
				Ext.getCmp('contractAduit-showitems-button').toggle();
			}
		}]
	};	

		
	var contractAduitPanel = Ext.getCmp('ContractAduit-mainpanel');
	contractAduitPanel.add(contractAduitGrid,contractAduitItemsGrid);
	contractAduitPanel.getTopToolbar().add(btnAduitSuccess,btnAduitFailed,btnShowItems,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: contractAduitStore
	});
	clsys.form.Util.PagingToolbar(contractAduitStore, contractAduitPanel.bbar, 'contractAduit-paging');
	contractAduitPanel.doLayout();

	Ext.getCmp('contractAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="contractAduitPanel"></div>
<div id="contractAduitGridPanel"></div>
<div id="contractAduitItemsPanel"></div>
<div id="contractAduitSelectorPanel"></div>
</body>
</html>