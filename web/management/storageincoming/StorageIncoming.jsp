<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�������</title> 
<script type="text/javascript" src="js/common/ScheduleSelector.js"></script>
<script type="text/javascript" src="js/common/ScheduleDataview.js"></script>
<script type="text/javascript" src="js/storageincoming/StorageIncoming.js"></script>
<script type="text/javascript" src="js/storageincoming/StorageIncomingItem.js"></script>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	//'CheckerAduit','CheckerFailed','ManagerAduit','ManagerFaild','AduitSuccess'
	//'Using','Deleted'  
	var storageIncoming_JSP_Store = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{states:['CheckerAduit','CheckerFailed','ManagerAduit','ManagerFaild','AduitSuccess'],
						  status:['Using','Deleted'],start:0,limit:25}},
		baseParams:{states:['CheckerAduit','CheckerFailed','ManagerAduit','ManagerFaild','AduitSuccess'],
				    status:['Using','Deleted']},
	  	url:'findStorageIncoming.action',
	  	totalProperty:'results',
	  	root:'StorageIncomingList',
	  	idProperty:'id',
	  	fields:['id','sicNo','sicDate','totalAmount',
	  			{name:'state',type:'int'},
	  	 		{name:'empCode',mapping:'creator.name'},
	  	        {name:'empName',mapping:'creator.code'}]
  	});

	var storageIncomingGetItems_JSP_Store = new Ext.data.JsonStore({
  		url:'getStorageIncoming.action',
  		root:'StorageIncoming',
		fields: ['id','items']
  	});
  	
  	var storageIncomingItems_JSP_Store = new Ext.data.JsonStore({
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

	var showItems = function(sm){
		Ext.getCmp('storageIncoming-showitems-button').setDisabled(sm.getCount() < 1);
		storageIncomingGetItems_JSP_Store.removeAll();
		storageIncomingItems_JSP_Store.removeAll();
		
		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('storageIncomingItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				storageIncomingGetItems_JSP_Store.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = storageIncomingGetItems_JSP_Store.getAt(0);
						if (rc) {
							storageIncomingItems_JSP_Store.loadData(rc.json);
						}
					}
				});

			}
		}		
	};
	  	
	var addNew = function(){
		var wnd = Ext.getCmp('storageIncoming-window');
		if (!wnd) {
			var wnd = new eus.window.StorageIncoming();
			wnd.on('storageIncomingSaved', function(attr){
				storageIncoming_JSP_Store.reload();
			});
		}
		wnd.doAutoReload();
		wnd.show();
	};
	
	var Update = function(){
		/*ֻ��ѡ������ʱ�ſ��Խ����޸Ĳ���*/
		var sm = Ext.getCmp('storageIncoming-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');	
		var wnd = Ext.getCmp('storageIncoming-window');
		if (!wnd) {
			var wnd = new eus.window.StorageIncoming();
			wnd.on('storageIncomingSaved', function(attr){
				storageIncoming_JSP_Store.reload();
			});
		}
		wnd.open(storageIncomingID);
		wnd.show();
	};

	var DeleteHandler = function(storageIncomingID){
		var url = 'removeStorageIncoming.action';
		var params = {id:storageIncomingID};
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				storageIncoming_JSP_Store.reload();
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

	var Delete = function(){
		var sm = Ext.getCmp('storageIncoming-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var storageIncomingID = sm.getSelected().get('id');		
		var strName = sm.getSelected().get('storageIncomingNo');
		var strMessage = 'ȷ���Ƿ�ɾ�������Ϊ ['+ strName +'] ����ⵥ';

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(storageIncomingID);
			}
		});	
	};

	var btnAddNew = {
		text:'������ⵥ',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnUpdate = {
		text:'�޸���ⵥ',
		iconCls:'icon-prop',
		handler:Update,
		id:'storageIncoming-update',
		scope:this
	};

	var btnDelete = {
		text:'ɾ����ⵥ',
		iconCls:'icon-remove',
		handler:Delete,
		id:'storageIncoming-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'ˢ��',
		iconCls:'icon-refresh',
		handler:function(){storageIncoming_JSP_Store.reload();},
		scope:this
	};

	var btnShowItems = {
		text: '��ϸ��Ϣ',
		id: 'storageIncoming-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('storageIncomingItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('storageIncoming-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			storageIncomingPanel.doLayout();			
		}
	};
	
	var storageIncomingGrid = {
		xtype:'grid',
		id:'storageIncoming-grid',
		anchor:'100% 65%',
		store:storageIncoming_JSP_Store,
		stripeRows:true,
		autoScroll:true,
		border:false,
		renderTo:'storageIncomingGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��ⵥ��',dataIndex:'sicNo'},
				{header:'�����ܼ�',dataIndex:'totalAmount'},
				{header:'��ⵥ����',dataIndex:'sicDate'},
				{header:'��Ա���',dataIndex:'empCode'},
				{header:'����',dataIndex:'empName'},
				{header:'���״̬',renderer:clsys.grid.columnrender.StorageIncomingStatusRender,dataIndex:'state'}							
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

		        
	var storageIncomingItemsGrid = {
			xtype:'grid',
			id:'storageIncomingItems-grid',
			anchor:'100% 35%',
			store:storageIncomingItems_JSP_Store,
			stripeRows:true,
			autoScroll:true,
			hidden:true,
			border:false,
			renderTo:'storageIncomingItemsPanel',
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
		 			{header: '���',width:25,dataIndex: 'sicItemNo'},
		 			{header: '��Ʒ���Ƽ��ͺ�', width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'productID'},
		 			{header: '�������', width:50, dataIndex: 'jobCmdNo'},
		 			{header: '��ѹ(V)',width:50, dataIndex: 'voltage'},
		 			{header: '����(PF)',width:50, dataIndex: 'capacity'},
		 			{header: '���', width:30,dataIndex: 'humidity'},
		 			{header: '�ȼ�', width:30,dataIndex: 'productCode'},
		 			{header: '����', width:50,dataIndex: 'amount'},
		 			{header: '��λ', width:80,dataIndex: 'storageLocation'},
		 			{header: '��������', width:80,dataIndex: 'productionDate'},
		 			{header: '��ע', width:80,dataIndex: 'schedule'}			
				]
			}),
			viewConfig:{ forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
			tbar: ['<b>��ϸ��Ϣ</b>', {
				iconCls: 'icon-remove',
				text: '�ر���ϸ��Ϣ',
				handler: function() {
					Ext.getCmp('storageIncoming-showitems-button').toggle();
				}
			}]
		};	

		
	var storageIncomingPanel = Ext.getCmp('StorageIncomingApplication-mainpanel');
	storageIncomingPanel.add(storageIncomingGrid,storageIncomingItemsGrid);
	storageIncomingPanel.getTopToolbar().add(btnAddNew,btnShowItems,btnRefresh);
	clsys.form.Util.PagingToolbar(storageIncoming_JSP_Store, storageIncomingPanel.bbar, 'storageIncoming-paging');
	storageIncomingPanel.doLayout();
	
	Ext.getCmp('storageIncoming-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm)
	});	
  	
  });
</script>
</head>
<body>
<div id="storageIncomingPanel"></div>
<div id="storageIncomingGridPanel"></div>
<div id="storageIncomingItemsPanel"></div>
</body>
</html>