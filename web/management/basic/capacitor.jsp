<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��Ʒ����</title>
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
		/*ֻ��ѡ������ʱ�ſ��Խ����޸Ĳ���*/
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
		/*�ɹ�ʱ�Ĵ�����*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				//capacitorStore.reload();
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
		var sm = Ext.getCmp('capacitor-grid').getSelectionModel();
		if (sm.getCount()<1) return;
		
		var capacitorID = sm.getSelected().get('id');		
		var strProductName = sm.getSelected().get('productName');
		var strMessage = 'ȷ���Ƿ�ɾ����Ʒ����Ϊ ['+ strProductName +'] �Ĳ�Ʒ';

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
			    {header:'��Ʒ���', width:50,dataIndex:'productType'},
				{header:'��Ʒ���Ƽ��ͺ�',width:300,dataIndex:'productCombination'},
				{header:'ע��',width:60,dataIndex:'standard'},
				{header:'��Ϳ������',width:80,dataIndex:'memo'},
			    {header:'�۸�',width:80,dataIndex:'price'},
			    {header:'��ѹ',width:40,dataIndex:'voltage'},
			    {header:'����',width:40,dataIndex:'capacity'},
			    {header:'ʪ��',width:40,dataIndex:'humidity'},
			    {header:'���',width:40,dataIndex:'errorLevel'}, 
				{header:'��λ',width:40,dataIndex:'unit'}

			    		
			]
		}),
		viewConfig:{ forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	var btnAddNew = {
		text:'������Ʒ',
		iconCls:'icon-add',
		handler:addNew,
		scope:this
	};

	var btnUpdate = {
		text:'�޸Ĳ�Ʒ',
		iconCls:'icon-prop',
		handler:Update,
		id:'capacitor-update',
		scope:this
	};

	var btnDelete = {
		text:'ɾ����Ʒ',
		iconCls:'icon-remove',
		handler:Delete,
		id:'capacitor-remove',
		scope:this
	};
	
	var btnRefresh = {
		text:'ȫ����Ʒ',
		iconCls:'icon-refresh',
		handler:function(){capacitorStore.load();},
		scope:this
	};

		
	var capacitorPanel = Ext.getCmp('CapacitorInfoMan-mainpanel');
	capacitorPanel.add(capacitorGrid);
	capacitorPanel.getTopToolbar().add(btnAddNew,btnUpdate,btnDelete,
	{
		text:'�ۺϲ�ѯ',
		iconCls: 'icon-examine',
		handler:function(){
			var wnd = Ext.getCmp('capacitor-search-window');
			if (!wnd) {
				var wnd = new eus.window.CapacitorSearch();
				wnd.on('capacitorSearching', function(attr){
					/*������ѯ������ʱ����Ҫָ���һҳ*/
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
		emptyText: '��������',
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