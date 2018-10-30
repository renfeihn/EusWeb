<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>出库审核</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageOutcomingAduit = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using'],states:['Checking'],start:0,limit:25}},
		baseParams:{status:['Using'],states:['Checking']},
	  	url:'findStorageOutcoming.action',
	  	totalProperty:'results',
	  	root:'StorageOutcomingList',
	  	idProperty:'id',
	  	fields:['id','socNo','socDate','socItems','printDate',
	  		  	'totalAmount','totalSum','totalSumWithoutTax','totalTaxAmount',
	  		  	{name:'state',type:'int'},
	  	        {name:'company',mapping:'contract.company.name'},
	  	      	{name:'contractNo',mapping:'contract.contractNo'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}]
  	});

	var storageOutcomingAduitGetItemsStore = new Ext.data.JsonStore({
  		url:'getStorageOutcoming.action',
  		root:'StorageOutcoming',
		fields: ['id','socItems']
  	});

  	var storageOutcomingAduitItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'socItems',
  		fields:['id',
  		  		 {name:'socItemNo',type:'int'},
  		      	 {name:'productID',mapping:'id'},
		  	     {name:'productName',mapping:'product.productName'},
			     {name:'productCode',mapping:'product.productCode.code'},
			     {name:'unit',mapping:'product.unit.name'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'},
		         {name:'storageLocation_id',mapping:'storageLocation.id'},
		         {name:'storageLocation',mapping:'storageLocation.name'},		         
		         'amount','price','subTotal','subTotalWithoutTax','priceWithoutTax','taxAmount','tax','memo' 
		        ],
		sortInfo: {field: 'socItemNo',direction: 'ASC'}
  	});

	var showItems = function(sm){
		Ext.getCmp('storageOutcomingAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageOutcomingAduitGetItemsStore.removeAll();
		storageOutcomingAduitItemsStore.removeAll();
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
		if (Ext.getCmp('storageOutcomingAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageOutcomingAduitGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageOutcomingAduitGetItemsStore.getAt(0);
						if (rc) {
							storageOutcomingAduitItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var CheckerStorageOutcomingAduitHandler = function(storageOutomingID,isSuccess){
		var url = 'aduitByCheckerStorageOutcoming.action';
		var aduit;
		if (isSuccess) {aduit=2} else {aduit=1}
		var params = {id:storageOutomingID,aduit:aduit};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageOutcomingAduit.reload();
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
	
	var CheckerStorageOutcomingAduit = function(isSuccess){
		var sm = Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageOutomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('socNo');
		if (Ext.isEmpty(strName) && isSuccess) {
			clsys.message.info("请先打印出库单后，再进行审核"); 
			return;
		}
		var strSuccess = '';
		if (!isSuccess){strSuccess = '不';}
		var strMessage = '确定是否审核' + strSuccess + '通过,出库单编号为 ['+ strName +'] 的出库单';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				CheckerStorageOutcomingAduitHandler(storageOutomingID,isSuccess);
			}
		});	
	};

	var btnStorageOutcomingCheckerAduitSuccess = {
			text:'审核通过',
			iconCls:'icon-add',
			handler:function(){CheckerStorageOutcomingAduit(true);},
			scope:this
		};
		
	var btnStorageOutcomingCheckerAduitFailure = {
			text:'审核失败',
			iconCls:'icon-remove',
			handler:function(){CheckerStorageOutcomingAduit(false);},
			scope:this
	};
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){storageOutcomingAduit.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细出库信息',
		id: 'storageOutcomingAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageOutcomingAduitItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageOutcomingAduitPanel.doLayout();			
		}
	};
	
	var storageOutcomingAduitGrid = {
		xtype:'grid',
		id:'storageOutcomingAduit-grid',
		anchor:'100% 65%',
		store:storageOutcomingAduit,
		stripeRows:true,
		autoScroll:true,
		border:false,
		loadMask:true,
		renderTo:'storageOutcomingAduitGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[      
				{header:'出库单编号',width:100,dataIndex:'socNo'},
				{header:'合同号',width:100,dataIndex:'contractNo'},
				{header:'购货单位名称',width:100,dataIndex:'company'},
				{header:'开票日期',width:50,dataIndex:'printDate'},
				{header:'数量总计',width:50,dataIndex:'totalAmount'},
				{header:'金额总计',width:50,dataIndex:'totalSum'},	
				{header:'不含税金额总计',width:60,dataIndex:'totalSumWithoutTax'},
				{header:'税额总计',width:50,dataIndex:'totalTaxAmount'},
				{header:'人员编号',width:40,dataIndex:'empCode',hidden:true},
				{header:'姓名',width:40,dataIndex:'empName',hidden:true},
				{header:'审核状态',width:40,renderer:clsys.grid.columnrender.StorageOutcomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var storageOutcomingAduitItemsGrid = {
		xtype:'grid',
		id:'storageOutcomingAduitItems-grid',
		anchor:'100% 35%',
		store:storageOutcomingAduitItemsStore,
		stripeRows:true,
		autoScroll:true,
		hidden:true,
		loadMask:true,
		border:false,
		renderTo:'storageOutcomingAduitItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
	 		    {header: '序号', width:25,dataIndex: 'socItemNo'},
	 		    {header: '产品名称及型号',width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'productID'},
	 			{header: '单位', width:25,dataIndex: 'unit'},
	 			{header: '数量', width:25,dataIndex: 'amount'},
	 			{header: '单价', width:30,dataIndex: 'price'},
	 			{header: '不含税单价', width:50,dataIndex: 'priceWithoutTax'},
	 			{header: '金额', width:50,dataIndex: 'subTotal'},
	 			{header: '不含税金额',width:50, dataIndex: 'subTotalWithoutTax'},
	 			{header: '税率', width:25,dataIndex: 'tax'},
	 			{header: '税额', width:50,dataIndex: 'taxAmount'},
	 			{header: '库位', width:80,dataIndex: 'storageLocation'},
	 			{header: '备注', width:80,dataIndex: 'memo'}		
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar: ['<b>预览</b>', {
			iconCls: 'icon-remove',
			text: '关闭预览',
			handler: function() {
				Ext.getCmp('storageOutcomingAduit-showitems-button').toggle();
			}
		}]
	};	

		
	var storageOutcomingAduitPanel = Ext.getCmp('StorageOutcomingAudit-mainpanel');
	storageOutcomingAduitPanel.add(storageOutcomingAduitGrid,storageOutcomingAduitItemsGrid);
	storageOutcomingAduitPanel.getTopToolbar().add(btnStorageOutcomingCheckerAduitSuccess,btnStorageOutcomingCheckerAduitFailure,btnShowItems,btnRefresh,'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: storageOutcomingAduit
	});
	clsys.form.Util.PagingToolbar(storageOutcomingAduit, storageOutcomingAduitPanel.bbar, 'storageOutcomingAduit-paging');
	
	storageOutcomingAduitPanel.doLayout();

	Ext.getCmp('storageOutcomingAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="storageOutcomingAduitPanel"></div>
<div id="storageOutcomingAduitGridPanel"></div>
<div id="storageOutcomingAduitItemsPanel"></div>
</body>
</html>