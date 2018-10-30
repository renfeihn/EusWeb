<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>检验审核</title> 
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	//'CheckerAduit','CheckerFailed','ManagerAduit','ManagerFaild','AduitSuccess'
	//'Using','Deleted'   
	var storageIncomingCheckerAduit_JSP_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{states:['CheckerAduit','ManagerAduit'],
			 	  		  status:['Using','Deleted'],start:0,limit:25}},
		baseParams:{states:['CheckerAduit','ManagerAduit'],status:['Using','Deleted']},
		url:'findStorageIncoming.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingList',
	  	idProperty:'id',
	  	fields:['id','sicNo','sicDate','totalAmount',
	  	      	{name:'state',type:'int'},
	  	 		{name:'empCode',mapping:'creator.name'},
	  	        {name:'empName',mapping:'creator.code'}]
  	});

	var storageIncomingCheckerAduitGetItems_JSP_Store = new Ext.data.JsonStore({
  		url:'getStorageIncoming.action',
  		root:'StorageIncoming',
		fields: ['id','items']
  	});

  	var storageIncomingCheckerAduitItems_JSP_Store = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
		fields: ['id','sicItemNo','amount','jobCmdNo','productionDate',
		         {name:'storageLocation_id',mapping:'storageLocation.id'},
		         {name:'storageLocation',mapping:'storageLocation.name'},		         
		  	     {name:'productID',mapping:'id'},
		  	     {name:'schedule',mapping:'schedule.scheduleNo'},		         
		  	     {name:'productName',mapping:'product.productName'},
			     {name:'productCode',mapping:'product.productCode.code'},
			     {name:'voltage',mapping:'product.voltage'},
			     {name:'capacity',mapping:'product.capacity'},
			     {name:'humidity',mapping:'product.humidity.code'},
			     {name:'errorLevel',mapping:'product.errorLevel.code'}
			    ]
  	});

	var showCheckerAduitItems = function(sm){
		Ext.getCmp('storageIncomingCheckerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageIncomingCheckerAduitGetItems_JSP_Store.removeAll();
		storageIncomingCheckerAduitItems_JSP_Store.removeAll();
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
		if (Ext.getCmp('storageIncomingCheckerAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageIncomingCheckerAduitGetItems_JSP_Store.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageIncomingCheckerAduitGetItems_JSP_Store.getAt(0);
						if (rc) {
							storageIncomingCheckerAduitItems_JSP_Store.loadData(rc.json);
						}
					}
				});

			}
		}		
	};
  	
	var CheckerAduitHandler = function(storageIncomingID,isSuccess){
		var url = 'aduitByCheckerStorageIncoming.action';
		var aduit;
		if (isSuccess) {aduit=2} else {aduit=1}
		var params = {id:storageIncomingID,aduit:aduit};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageIncomingCheckerAduit_JSP_Store.reload();
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

	var CheckerAduit = function(isSuccess){
		var sm = Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('sicNo');
		var strSuccess = '';
		if (!isSuccess){strSuccess = '不';}
		var strMessage = '确定是否检验' + strSuccess + '通过,入库编号为 ['+ strName +'] 的入库单';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				CheckerAduitHandler(storageIncomingID,isSuccess);
			}
		});	
	};
	  	
	var btnCheckerAduitSuccess = {
		text:'检验通过',
		iconCls:'icon-add',
		handler:function(){CheckerAduit(true);},
		scope:this
	};
	
	var btnCheckerAduitFailure = {
		text:'检验失败',
		iconCls:'icon-remove',
		handler:function(){CheckerAduit(false);},
		scope:this
	};	
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){storageIncomingCheckerAduit_JSP_Store.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细信息',
		id: 'storageIncomingCheckerAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageIncomingCheckerAduitItems-grid');
			if (pressed) {
				preview.show();
				showCheckerAduitItems(Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageIncomingCheckerAduitPanel.doLayout();			
		}
	};
	
	this.storageIncomingCheckerAduitGrid = {
		xtype:'grid',
		id:'storageIncomingCheckerAduit-grid',
		anchor:'100% 65%',
		store:storageIncomingCheckerAduit_JSP_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		renderTo:'storageIncomingCheckerAduitGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'入库单号',dataIndex:'sicNo'},
				{header:'数量总计',dataIndex:'totalAmount'},
				{header:'入库单日期',dataIndex:'sicDate'},
				{header:'人员编号',dataIndex:'empCode'},
				{header:'姓名',dataIndex:'empName'},
				{header:'审核状态',renderer:clsys.grid.columnrender.StorageIncomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

		        
	this.storageIncomingCheckerAduitItemsGrid = {
			xtype:'grid',
			id:'storageIncomingCheckerAduitItems-grid',
			anchor:'100% 35%',
			store:storageIncomingCheckerAduitItems_JSP_Store,
			stripeRows:true,
			autoScroll:true,
			hidden:true,
			border:false,
			renderTo:'storageIncomingCheckerAduitItemsPanel',
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
		 			{header: '序号',width:30,dataIndex: 'sicItemNo'},
		 			{header: '产品名称及型号', width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'productID'},
		 			{header: '工作令号', width:50, dataIndex: 'jobCmdNo'},
		 			{header: '电压(V)',width:50, dataIndex: 'voltage'},
		 			{header: '容量(PF)',width:50, dataIndex: 'capacity'},
		 			{header: '组别', width:30,dataIndex: 'humidity'},
		 			{header: '等级', width:30,dataIndex: 'productCode'},
		 			{header: '数量', width:50,dataIndex: 'amount'},
		 			{header: '库位', width:80,dataIndex: 'storageLocation'},
		 			{header: '生产日期', width:60,dataIndex: 'productionDate'},
		 			{header: '备注', width:110,dataIndex: 'schedule'}			
				]
			}),
			viewConfig:{ forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
			tbar: ['<b>详细信息</b>', {
				iconCls: 'icon-remove',
				text: '关闭详细信息',
				handler: function() {
					Ext.getCmp('storageIncomingCheckerAduit-showitems-button').toggle();
				}
			}]
		};	

		
	var storageIncomingCheckerAduitPanel = Ext.getCmp('StorageIncomingCheckerAudit-mainpanel');
	storageIncomingCheckerAduitPanel.add(this.storageIncomingCheckerAduitGrid,this.storageIncomingCheckerAduitItemsGrid);
	storageIncomingCheckerAduitPanel.getTopToolbar().add(btnCheckerAduitSuccess,btnCheckerAduitFailure,btnShowItems,btnRefresh);
	clsys.form.Util.PagingToolbar(storageIncomingCheckerAduit_JSP_Store, storageIncomingCheckerAduitPanel.bbar, 'storageIncomingCheckerAduit-paging');
	storageIncomingCheckerAduitPanel.doLayout();

	Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('storageIncomingCheckerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				storageIncomingCheckerAduitItems_JSP_Store.removeAll();
				storageIncomingCheckerAduitItems_JSP_Store.loadData(record.json);			
			}
		}
	});	

	Ext.getCmp('storageIncomingCheckerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showCheckerAduitItems(sm)
	});	
  	
  });
</script>
</head>
<body>
<div id="storageIncomingCheckerAduitPanel"></div>
<div id="storageIncomingCheckerAduitGridPanel"></div>
<div id="storageIncomingCheckerAduitItemsPanel"></div>
</body>
</html>