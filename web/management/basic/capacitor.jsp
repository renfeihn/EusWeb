<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>产品管理</title>
<script type="text/javascript" src="js/capacitor/capacitor.js"></script>
<script type="text/javascript" src="js/capacitor/capacitorSearch.js"></script>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var capacitorStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'findCapacitor.action',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	totalProperty:'results',
	  	root:'CapacitorList',
	  	idProperty:'id',
	  	fields:['id','productName','voltage','capacity','standard','productCombination','price','memo',
		        {name:'productType',mapping:'productType.name'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'unit.name'},
	  	       	{name:'productCode',mapping:'productCode.code'}],
	  	sortInfo: {field: 'productCombination',direction: 'ASC'}
  	});



	var addNew = function(){
		var wnd = Ext.getCmp('capacitor-window');
		if (!wnd) {
			var wnd = new eus.window.Capacitor();
			wnd.on('capacitorSaved', function(attr){
				//capacitorStore.reload();
			});
		}
		wnd.doAutoReload();
		wnd.show();
	};
	
	var Update = function(){
		/*只有选中资料时才可以进行修改操作*/
		var sm = Ext.getCmp('capacitor-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var capacitorID = sm.getSelected().get('id');	
		var wnd = Ext.getCmp('capacitor-window');
		if (!wnd) {
			var wnd = new eus.window.Capacitor();
			wnd.on('capacitorSaved', function(attr){
				//capacitorStore.reload();
			});
		}
		wnd.open(capacitorID);
		wnd.show();
	};

	var DeleteHandler = function(capacitorID){
		var url = 'removeCapacitor.action';
		var params = {id:capacitorID};
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				//capacitorStore.reload();
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

	var Delete = function(){
		var sm = Ext.getCmp('capacitor-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var capacitorID = sm.getSelected().get('id');		
		var strProductName = sm.getSelected().get('productName');
		var strMessage = '确定是否删除产品名称为 ['+ strProductName +'] 的产品';

		clsys.message.confirmDelete(strMessage,function(buttonId){
			if (buttonId == 'yes'){
				DeleteHandler(capacitorID);
			}
		});	
	};

	var capacitorGrid = {
		xtype:'grid',
		id:'capacitor-grid',
		anchor:'100% 80%',
		store:capacitorStore,
		stripeRows:true,
		autoScroll:true,
		listeners:{'dblclick':Update,scope:this},
		border:false,
		loadMask:true,
		renderTo:'capacitorGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
			    {header:'产品类别', width:50,dataIndex:'productType'},
				{header:'产品名称及型号',width:300,dataIndex:'productCombination'},
				{header:'注解',width:60,dataIndex:'standard'},
				{header:'最低库存数量',width:80,dataIndex:'memo'},
			    {header:'价格',width:80,dataIndex:'price'},
			    {header:'电压',width:40,dataIndex:'voltage'},
			    {header:'容量',width:40,dataIndex:'capacity'},
			    {header:'湿度',width:40,dataIndex:'humidity'},
			    {header:'误差',width:40,dataIndex:'errorLevel'}, 
				{header:'单位',width:40,dataIndex:'unit'}

			    		
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAddNew = {
		text:'新增产品',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnUpdate = {
		text:'修改产品',
		iconCls:'icon-prop',
		handler:Update,
		id:'capacitor-update',
		scope:this
	};

	var btnDelete = {
		text:'删除产品',
		iconCls:'icon-remove',
		handler:Delete,
		id:'capacitor-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'全部产品',
		iconCls:'icon-refresh',
		handler:function(){capacitorStore.load();},
		scope:this
	};

		
	var capacitorPanel = Ext.getCmp('CapacitorInfoMan-mainpanel');
	capacitorPanel.add(capacitorGrid);
	capacitorPanel.getTopToolbar().add(btnAddNew,btnUpdate,btnDelete,
	{
		text:'综合查询',
		iconCls: 'icon-examine',
		handler:function(){
			var wnd = Ext.getCmp('capacitor-search-window');
			if (!wnd) {
				var wnd = new eus.window.CapacitorSearch();
				wnd.on('capacitorSearching', function(attr){
					/*更换查询条件的时候，需要指向第一页*/
					attr.start = 0;
					capacitorStore.reload({params:attr});
				});
			}
			wnd.doAutoReload();
			wnd.show();
		},
		scope:this
	},'->',
	{
		xtype: 'is-search-field',
		emptyText: '输入条件',
		width:300,
		store: capacitorStore
	});
	clsys.form.Util.PagingToolbar(capacitorStore, capacitorPanel.bbar, 'capacitor-paging');
	capacitorPanel.doLayout();
  	
  });
</script>
</head>
<body>
<div id="capacitorPanel"></div>
<div id="capacitorGridPanel"></div>
</body>
</html>