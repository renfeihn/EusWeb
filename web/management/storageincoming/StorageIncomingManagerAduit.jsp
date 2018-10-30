<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>成品库审核</title> 
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var storageIncomingManagerAduit_JSP_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{states:['ManagerAduit'],
						  status:['Using','Deleted'],start:0,limit:25}},
	    baseParams:{states:['ManagerAduit'],status:['Using','Deleted']},				  
	  	url:'findStorageIncoming.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingList',
	  	idProperty:'id',
	  	fields:['id','sicNo','sicDate','totalAmount',
	  	      	{name:'state',type:'int'},
	  	 		{name:'empCode',mapping:'creator.name'},
	  	        {name:'empName',mapping:'creator.code'}]
  	});

	var storageIncomingManagerAduitGetItems_JSP_Store = new Ext.data.JsonStore({
  		url:'getStorageIncoming.action',
  		root:'StorageIncoming',
		fields: ['id','items']
  	});

  	var storageIncomingManagerAduitItems_JSP_Store = new Ext.data.JsonStore({
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

	var showManagerAduitItems = function(sm){
		Ext.getCmp('storageIncomingManagerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		storageIncomingManagerAduitGetItems_JSP_Store.removeAll();
		storageIncomingManagerAduitItems_JSP_Store.removeAll();
		
		/*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
		if (Ext.getCmp('storageIncomingManagerAduitItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageIncomingManagerAduitGetItems_JSP_Store.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageIncomingManagerAduitGetItems_JSP_Store.getAt(0);
						if (rc) {
							storageIncomingManagerAduitItems_JSP_Store.loadData(rc.json);
						}
					}
				});

			}
		}		
	};

	var ManagerAduitHandler = function(storageIncomingID,isSuccess){
		var url = 'aduitByManagerStorageIncoming.action';
		var aduit;
		if (isSuccess) {aduit=4} else {aduit=3}
		var params = {id:storageIncomingID,aduit:aduit};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageIncomingManagerAduit_JSP_Store.reload();
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

	var ManagerAduit = function(isSuccess){
		var sm = Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('sicNo');
		var strSuccess = '';
		if (!isSuccess){strSuccess = '不';}
		var strMessage = '确定是否审核' + strSuccess + '通过,入库编号为 ['+ strName +'] 的入库单';

		clsys.message.confirmInfo(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				ManagerAduitHandler(storageIncomingID,isSuccess);
			}
		});	
	};
	
	var btnManagerAduitSuccess = {
		text:'审核通过',
		iconCls:'icon-add',
		handler:function(){ManagerAduit(true);},
		scope:this
	};
	
	var btnManagerAduitFailure = {
		text:'审核失败',
		iconCls:'icon-remove',
		handler:function(){ManagerAduit(false);},
		scope:this
	};	
	
	var btnRefresh = {
		text:'刷新',
		iconCls:'icon-refresh',
		handler:function(){storageIncomingManagerAduit_JSP_Store.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '详细信息',
		id: 'storageIncomingManagerAduit-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageIncomingManagerAduitItems-grid');
			if (pressed) {
				preview.show();
				showManagerAduitItems(Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageIncomingManagerAduitPanel.doLayout();			
		}
	};
	
	this.storageIncomingManagerAduitGrid = {
		xtype:'grid',
		id:'storageIncomingManagerAduit-grid',
		anchor:'100% 65%',
		store:storageIncomingManagerAduit_JSP_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		renderTo:'storageIncomingManagerAduitGridPanel',
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

		        
	this.storageIncomingManagerAduitItemsGrid = {
			xtype:'grid',
			id:'storageIncomingManagerAduitItems-grid',
			anchor:'100% 35%',
			store:storageIncomingManagerAduitItems_JSP_Store,
			stripeRows:true,
			autoScroll:true,
			hidden:true,
			border:false,
			renderTo:'storageIncomingManagerAduitItemsPanel',
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
					Ext.getCmp('storageIncomingManagerAduit-showitems-button').toggle();
				}
			}]
		};	

	var storageIncomingManagerAduitPanel = Ext.getCmp('StorageIncomingManagerAudit-mainpanel');
	storageIncomingManagerAduitPanel.add(this.storageIncomingManagerAduitGrid,this.storageIncomingManagerAduitItemsGrid);
	storageIncomingManagerAduitPanel.getTopToolbar().add(btnManagerAduitSuccess,btnManagerAduitFailure,btnShowItems,btnRefresh);
	clsys.form.Util.PagingToolbar(storageIncomingManagerAduit_JSP_Store, storageIncomingManagerAduitPanel.bbar, 'storageIncomingManagerAduit-paging');
	storageIncomingManagerAduitPanel.doLayout();

	Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('storageIncomingManagerAduit-showitems-button').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				storageIncomingManagerAduitItems_JSP_Store.removeAll();
				storageIncomingManagerAduitItems_JSP_Store.loadData(record.json);			
			}
		}
	});

	Ext.getCmp('storageIncomingManagerAduit-grid').getSelectionModel().on('selectionchange', function(sm) {
		showManagerAduitItems(sm)
	});		
  	
  });
</script>
</head>
<body>
<div id="storageIncomingManagerAduitPanel"></div>
<div id="storageIncomingManagerAduitGridPanel"></div>
<div id="storageIncomingManagerAduitItemsPanel"></div>
</body>
</html>