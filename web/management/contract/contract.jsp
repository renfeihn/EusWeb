<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>合同管理</title>
<script type="text/javascript" src="js/contract/Contract.js"></script>
<script type="text/javascript" src="js/contract/ContractProduct.js"></script>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script type="text/javascript" src="js/company/companySelector.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['Saved','WaitForAduilt','AduitFailed'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['Saved','WaitForAduilt','AduitFailed']},
	  	url:'findContract.action',
	  	totalProperty:'results',
	  	root:'ContractList',
	  	idProperty:'id',
	  	fields:['id','contractNo','contractDate','items','state','createTime',
	  		  	'totalFinishedAmount','totalCheckingAmount','totalAmount','totalSum',
	  	        {name:'company',mapping:'company.name'}],
	  	sortInfo: {field: 'createTime',direction: 'ASC'}
  	});

	var contractGetItemsStore = new Ext.data.JsonStore({
  		url:'getContract.action',
  		root:'Contract',
		fields: ['id','items']
  	});

  	var contractItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
  		fields:['id','contractItemNo','amount','price','originalPrice','subTotal','finishedAmount',
  		      	{name:'contractItemNo', type:'int'},
	  	        {name:'productCombination',mapping:'product.productCombination'}],
	    sortInfo: {field:'contractItemNo',direction:'ASC'}        	
  	});

	var showItems = function(sm){
		Ext.getCmp('contract-showitems-button').setDisabled(sm.getCount() < 1);
		contractGetItemsStore.removeAll();
		contractItemsStore.removeAll();
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
		if (Ext.getCmp('contractItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				contractGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = contractGetItemsStore.getAt(0);
						if (rc) {
							contractItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var addNew = function(){
		var wnd = Ext.getCmp('contract-window');
		if (!wnd) {
			var wnd = new eus.window.Contract();
			wnd.on('contractSaved', function(attr){
				contractStore.reload();
			});
		}
		wnd.doAutoReload();
		wnd.show();
	};
	
	var Update = function(){
		/*只有选中资料时才可以进行修改操作*/
		var sm = Ext.getCmp('contract-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var contractID = sm.getSelected().get('id');	
		var state = parseInt(sm.getSelected().get('state'));

		/*待审核的计划不能进行修改*/
		if (state == 1) return;
		
		var wnd = Ext.getCmp('contract-window');
		if (!wnd) {
			var wnd = new eus.window.Contract();
			wnd.on('contractSaved', function(attr){
				contractStore.reload();
			});
		}
		wnd.open(contractID);
		wnd.show();
	};

	var DeleteHandler = function(contractID,submit){
		var url = (submit == true ? 'submitContract.action' : 'removeContract.action');
		var params = {id:contractID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				contractStore.reload();
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
		var sm = Ext.getCmp('contract-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var contractID = sm.getSelected().get('id');		
		var createTime = sm.getSelected().get('createTime');
		var state = parseInt(sm.getSelected().get('state'));
		
		/*待审核的计划不能进行提交和删除*/
		if (state == 1) return;
		
		var strMessage = '确定作废,保存时间为 [' + createTime + "] 的合同";
		if (submit){
			strMessage = '提交审核,保存时间为 [' + createTime + "] 的合同";
		}
		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(contractID,submit);
			}
		});	
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
		id:'contract-update',
		scope:this
	};

	var btnDelete = {
		text:'删除',
		iconCls:'icon-remove',
		handler:function(){Delete(false);},
		id:'contract-remove',
		scope:this
	};
	var btnSubmit = {
		text:'提交审核',
		iconCls:'icon-commit',
		handler:function(){Delete(true);},
		id:'contract-submit',
		scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){contractStore.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细信息',
		id: 'contract-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('contractItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('contract-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			contractPanel.doLayout();			
		}
	};
	
	var contractGrid = {
		xtype:'grid',
		id:'contract-grid',
		anchor:'100% 65%',
		store:contractStore,
		stripeRows:true,
		loadMask:true,
		autoScroll:true,
		border:false,
		renderTo:'contractGridPanel',
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

	var contractItemsGrid = {
		xtype:'grid',
		id:'contractItems-grid',
		anchor:'100% 35%',
		store:contractItemsStore,
		stripeRows:true,
		autoScroll:true,
		loadMask:true,
		hidden:true,
		border:false,
		renderTo:'contractItemsPanel',
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
				Ext.getCmp('contract-showitems-button').toggle();
			}
		}]
	};	
		
	var contractPanel = Ext.getCmp('ContractApplication-mainpanel');
	contractPanel.add(contractGrid,contractItemsGrid);
	contractPanel.getTopToolbar().add(btnAddNew,btnUpdate,btnSubmit,btnDelete,btnShowItems,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: contractStore
	});
	clsys.form.Util.PagingToolbar(contractStore, contractPanel.bbar, 'contract-paging');
	contractPanel.doLayout();

	Ext.getCmp('contract-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="contractPanel"></div>
<div id="contractGridPanel"></div>
<div id="contractItemsPanel"></div>
<div id="contractSelectorPanel"></div>
</body>
</html>