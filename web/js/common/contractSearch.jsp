<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>��ͬ��ѯ</title>
<script language="javascript">
  Ext.onReady(function(){

  	Ext.QuickTips.init();
	  
	var contractSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'queryContract.action',
	  	totalProperty:'results',
	  	root:'ContractList',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	idProperty:'id',
		fields:['id','contractNo','contractDate','items','status','state','createTime',
	  		  	'totalFinishedAmount','totalCheckingAmount','totalAmount','totalSum',
	  	        {name:'company',mapping:'company.name'},
	  	        {name:'empName',mapping:'creator.name'},
	  	        {name:'empCode',mapping:'creator.code'}],
	  	sortInfo: {field: 'createTime',direction: 'ASC'}	
  	});

	var contractGetItemsStore = new Ext.data.JsonStore({
  		url:'getContract.action',
  		root:'Contract',
		fields: ['id','items']
  	});

  	var contractSearchItemsStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
  		fields:['id','amount','price','originalPrice','subTotal','finishedAmount',
  		      	{name:'contractItemNo', type:'int'},
	  	        {name:'productCombination',mapping:'product.productCombination'}],
 		sortInfo: {field:'contractItemNo',direction:'ASC'} 
  	});
  		
	var provinceStoreForContractSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProvince.action',
		autoLoad:{status:['Using']},
		baseParams:{status:['Using']},
		root:'ProvinceList',
		fields:['id','name']
	});
	
	var provinceItemStoreForContractSearch = new Ext.data.JsonStore({
		url:'getProvince.action',
		root:'Province',
		fields:['id','cities']
	});
	
	var cityStoreForContractSearch = new Ext.data.JsonStore({
		root:'cities',
		fields:['id','name']
	});
	
	var companyStoreForContractSearch = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCompany.action',
		baseParams:{status:'Using'},
		root:'Company',
		fields:['id','code','name','address','commAddress',
		        'bank','contract','account','tax',
		        'zipCode','tele','delegatee','email','fax','memo']
	});
	
	var txtCodeForContractSearch = {
		xtype:'textfield',
		id:'txtCodeForContractSearch',
		fieldLabel:'���̱��',
		width:220,
		name:'txtCodeForContractSearch'
	};

	var txtNameForContractSearch = {
		xtype:'textfield',
		id:'txtNameForContractSearch',
		fieldLabel:'��������',
		width:220,
		name:'txtNameForContractSearch'
	};	
	
	var txtAddressForContractSearch = {
		xtype:'textfield',
		id:'txtAddressForContractSearch',
		fieldLabel:'���̵�ַ',
		width:220,
		name:'txtAddressForContractSearch'
	};
	
	var txtCommAddressForContractSearch = {
		xtype:'textfield',
		id:'txtCommAddressForContractSearch',
		fieldLabel:'ͨѶ��ַ',
		width:220,
		name:'txtCommAddressForContractSearch'
	};
	
	var txtBankForContractSearch = {
		xtype:'textfield',
		id:'txtBankForContractSearch',
		fieldLabel:'��������',
		width:220,
		name:'txtBankForContractSearch'
	};
	
	var txtContractForContractSearch = {
		xtype:'textfield',
		id:'txtContractForContractSearch',
		fieldLabel:'��ͬ��',
		width:220,
		name:'txtContractForContractSearch'
	};
	
	var txtAccountForContractSearch = {
		xtype:'textfield',
		id:'txtAccountForContractSearch',
		fieldLabel:'�ʺ�',
		width:220,
		name:'txtAccountForContractSearch'
	};
	
	var txtTaxForContractSearch = {
		xtype:'textfield',
		id:'txtTaxForContractSearch',
		fieldLabel:'˰��',
		width:220,
		name:'txtTaxForContractSearch'
	};
	
	var txtZipCodeForContractSearch = {
		xtype:'textfield',
		id:'txtZipCodeForContractSearch',
		fieldLabel:'�ʱ�',
		width:220,
		name:'txtZipCodeForContractSearch'
	};
	
	var txtTeleForContractSearch = {
		xtype:'textfield',
		id:'txtTeleForContractSearch',
		fieldLabel:'�绰����',
		width:220,
		name:'txtTeleForContractSearch'
	};
	
	var txtDelegateeForContractSearch = {
		xtype:'textfield',
		id:'txtDelegateeForContractSearch',
		fieldLabel:'������',
		width:220,
		name:'txtDelegateeForContractSearch'
	};
	
	var txtEmailForContractSearch = {
		xtype:'textfield',
		id:'txtEmailForContractSearch',
		fieldLabel:'�����ʼ�',
		width:220,
		name:'txtEmailForContractSearch'
	};
	
	var txtFaxForContractSearch = {
		xtype:'textfield',
		id:'txtFaxForContractSearch',
		fieldLabel:'�������',
		width:220,
		name:'txtFaxForContractSearch'
	};
	
	var txtMemoForContractSearch = {
		xtype:'textfield',
		id:'txtMemoForContractSearch',
		fieldLabel:'��ע',
		width:220,
		name:'txtMemoForContractSearch'
	};
	
	var loadCityHandler = function(combo,record,index){
		provinceItemStoreForContractSearch.removeAll();
		cityStoreForContractSearch.removeAll();
		Ext.getCmp('cbCity').setValue(null);	
		var id = Ext.getCmp('cbProvinceForContractSearch').getValue();

		if (id){
			provinceItemStoreForContractSearch.load({					
				params:{'id':id},
				callback:function(r,o,s){
					var rc = provinceItemStoreForContractSearch.getAt(0);
					if (rc){
						cityStoreForContractSearch.loadData(rc.json);
					}
				},
				scope:this
			});
		}
	};
	
	/*���ͨ������ı�ʡ������û��ѡ�е�����£���Ҫ���е���Ϣȫ�����*/
	var blurHandle = function(field){
		var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvinceForContractSearch').getValue());
		if (isEmptyProvince) {
			provinceItemStoreForContractSearch.removeAll();
			cityStoreForContractSearch.removeAll();
		}
	};
	
	var cbProvinceForContractSearch = {
		xtype:'combo',
		store:provinceStoreForContractSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��',
		fieldLabel:'����ʡ',
		selectOnFocus:true,
		id:'cbProvinceForContractSearch',
		valueField:'id',
		listeners:{'select':loadCityHandler,'blur':blurHandle,scope:this},
		width:220
	};	
	
	var focusHandler= function(field) {
		var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvinceForContractSearch').getValue());
		if (cityStoreForContractSearch.getCount()<1){
			if (isEmptyProvince){
				clsys.message.info('����ѡ������ʡ');
			}			
		}
	};
	
	var cbCityForContractSearch = {
		xtype:'combo',
		store:cityStoreForContractSearch,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��',
		fieldLabel:'������',
		selectOnFocus:true,
		id:'cbCityForContractSearch',
		valueField:'id',
		listeners:{'focus':focusHandler,scope:this},
		width:220
	};	

	var txtContractForContractSearchDateStart = {
		xtype:'datefield',
		id:'txtContractForContractSearchDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtContractForContractSearchDateStart'	
	};
	
	var txtContractForContractSearchDateEnd = {
		xtype:'datefield',
		id:'txtContractForContractSearchDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtContractForContractSearchDateEnd'	
	};
	
	var txtContractForContractSearchSavedDateStart = {
		xtype:'datefield',
		id:'txtContractForContractSearchSavedDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtContractForContractSearchSavedDateStart'	
	};
	
	var txtContractForContractSearchSavedDateEnd = {
		xtype:'datefield',
		id:'txtContractForContractSearchSavedDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtContractForContractSearchSavedDateEnd'	
	};	
	
	var cbContractState = {
		xtype: 'combo',
		id: 'cbContractState',
		emptyText: '��ѡ���ͬ״̬',
		fieldLabel:'��ͬ״̬',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', 'ȫ��״̬' ],
					['Saved','�ѱ���'],
					['WaitForAduilt','�����'],
					['AduitFailed','���ʧ��'],
					['None','δ���'],
					['Part','�������'],
					['Complete','ȫ�����']
				]
		}),
		mode: 'local',
		triggerAction: 'all',
		displayField: 'name',
		valueField: 'id',
		width: 220,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	};
	
	var cbContractStatus = {
		xtype: 'combo',
		id: 'cbContractStatus',
		emptyText: '��ѡ���ͬ�Ƿ�����',
		fieldLabel:'�Ƿ�����',
		store: new Ext.data.ArrayStore({
			fields: [ 'id', 'name' ],
			data: [
					[ '', 'ȫ��' ],
					['Using','��Ч'],
					['Deleted','����']
				]
		}),
		mode: 'local',
		triggerAction: 'all',
		displayField: 'name',
		valueField: 'id',
		width: 220,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	};	
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtNameForContractSearch,cbProvinceForContractSearch,txtAddressForContractSearch,txtCommAddressForContractSearch,txtBankForContractSearch,txtContractForContractSearch,txtContractForContractSearchDateStart,txtContractForContractSearchDateEnd,cbContractStatus]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtCodeForContractSearch,cbCityForContractSearch,txtTaxForContractSearch,txtZipCodeForContractSearch,txtTeleForContractSearch,txtDelegateeForContractSearch,txtContractForContractSearchSavedDateStart,txtContractForContractSearchSavedDateEnd,cbContractState]		
	};

	var showItems = function(sm){
		Ext.getCmp('contract-search-showitems-button').setDisabled(sm.getCount() < 1);
		contractGetItemsStore.removeAll();
		contractSearchItemsStore.removeAll();

		/*�����ϸ���ݵ�GridPanel�����صģ��򲻽���ϸ����Ϣ��ѯ*/
		if (Ext.getCmp('contractSearchItems-grid').hidden) return;

		if (sm.getCount() > 0) {
			var record = sm.getSelected();
			if (record) {
				var id = record.get('id');
				contractGetItemsStore.reload({
					params:{'id':id},
					callback:function(r,o,s){
						var rc = contractGetItemsStore.getAt(0);
						if (rc) {
							contractSearchItemsStore.loadData(rc.json);
						}
					},
					scope:this
				});

			}
		}		
	};

	var btnShowItems = {
		text: '��ϸ��Ϣ',
		id: 'contract-search-showitems-button',
		iconCls: 'icon-preview',
		enableToggle: true,
		disabled: true,
		scope: this,
		toggleHandler: function(btn, pressed) {
			var preview = Ext.getCmp('contractSearchItems-grid');
			if (pressed) {
				preview.show();
				showItems(Ext.getCmp('contractSearch-grid').getSelectionModel());
			} else {
				preview.hide();
			}
			contractSearchPanel.doLayout();			
		}
	};
	
	var contractSearchItemsGrid = {
		xtype:'grid',
		id:'contractSearchItems-grid',
		anchor:'100% 35%',
		store:contractSearchItemsStore,
		stripeRows:true,
		autoScroll:true,
		hidden:true,
		loadMask:true,
		border:false,
		frame:true,
		renderTo:'contractSearchItemsPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'���',width:30,dataIndex:'contractItemNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:250,dataIndex:'productCombination'},
				{header:'��ͬ����',width:70,dataIndex:'amount'},
				{header:'�������',width:40,dataIndex:'finishedAmount'},	
				{header:'�������',width:40,dataIndex:'checkingAmount'},
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
				Ext.getCmp('contract-search-showitems-button').toggle();
			}
		}]
	};
	
	var contractSearchGrid = {
		xtype:'grid',
		id:'contractSearch-grid',
		anchor:'100% 65%',
		store:contractSearchStore,
		stripeRows:true,
		autoScroll:true,
		border:false,
		frame:true,
		renderTo:'contractSearchGridPanel',
		colModel:new Ext.grid.ColumnModel({
			defaults:{sortable:true},
			columns:[
				{header:'��ͬ��',width:120,dataIndex:'contractNo'},
				{header:'����ʱ��',width:120,dataIndex:'createTime'},
				{header:'��ͬ����',width:150,dataIndex:'company'},
				{header:'�����ܼ�',width:50,dataIndex:'totalAmount'},
				{header:'����ܼ�',width:50,dataIndex:'totalFinishedAmount'},	
				{header:'����ܼ�',width:50,dataIndex:'totalCheckingAmount'},
				{header:'����ܼ�',width:50,dataIndex:'totalSum'},
				{header:'������',width:80,dataIndex:'contractDate'},
				{header:'��Ա���',width:70,dataIndex:'empCode'},
				{header:'����',width:50,dataIndex:'empName'},
				{header:'��Ч',width:50,dataIndex:'status',renderer:clsys.grid.columnrender.ContractDeletedRender},
			    {header:'״̬',width:50,renderer:clsys.grid.columnrender.ScheduleStatusRender,dataIndex:'state'}													
			]
		}),
		viewConfig:{forceFit:true},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};

	 var contractQueryConditionPanel = new Ext.FormPanel({
         frame:true,
         bodyStyle:'padding:5px 5px 0',
         collapsible:true,
         collapsed:false,
         title:'��ѯ����',
         labelWidth:150,
         renderTo:'contractQueryConditionPanel',
         items: [{		
			layout:'column',
			frame:false,
			border:false,
			items:[col1,col2]
		}],
		 buttonAlign:'left',
         buttons: [{
			text: '��ѯ',
			iconCls: 'icon-examine',
			handler: function(){
 				var attributes = {
						companyName:Ext.getCmp('txtNameForContractSearch').getValue(),
						companyCode:Ext.getCmp('txtCodeForContractSearch').getValue(),
						companyAddress:Ext.getCmp('txtAddressForContractSearch').getValue(),
						companyCommAddress:Ext.getCmp('txtCommAddressForContractSearch').getValue(),
						companyBank:Ext.getCmp('txtBankForContractSearch').getValue(),
						companyTax:Ext.getCmp('txtTaxForContractSearch').getValue(),
						companyZipCode:Ext.getCmp('txtZipCodeForContractSearch').getValue(),
						companyTele:Ext.getCmp('txtTeleForContractSearch').getValue(),
						companyDelegatee:Ext.getCmp('txtDelegateeForContractSearch').getValue(),
						companyProvince:Ext.getCmp('cbProvinceForContractSearch').getValue(),
						companyCity:Ext.getCmp('cbCityForContractSearch').getValue(),
						contractNo:Ext.getCmp('txtContractForContractSearch').getValue(), 		 				
 						contractDateStart:Ext.getCmp('txtContractForContractSearchDateStart').getValue(),
 						contractDateEnd:Ext.getCmp('txtContractForContractSearchDateEnd').getValue(),
 						status:Ext.getCmp('cbContractStatus').getValue(),
 						states:Ext.getCmp('cbContractState').getValue(),
 						contractSavedDateStart:Ext.getCmp('txtContractForContractSearchSavedDateStart').getValue(),
 						contractSavedDateEnd:Ext.getCmp('txtContractForContractSearchSavedDateEnd').getValue()
 		 	 	};
 				attributes.start = 0;
 				contractSearchStore.reload({params:attributes});
  			}
		},{
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				contractSearchStore.reload();
			},
			scope:this
		},btnShowItems]
     });
     		   
	var contractSearchPanel = Ext.getCmp('ContractSearch-mainpanel');
	contractSearchPanel.add(contractQueryConditionPanel,contractSearchGrid,contractSearchItemsGrid);
	clsys.form.Util.PagingToolbar(contractSearchStore, contractSearchPanel.tbar, 'contractSearch-paging');
	contractSearchPanel.doLayout();

	Ext.getCmp('contractSearch-grid').getSelectionModel().on('selectionchange', function(sm) {
		showItems(sm);
	});	
  	
  });
</script>
</head>
<body>
<div id="contractSearchPanel"></div>
<div id="contractSearchGridPanel"></div>
<div id="contractSearchItemsPanel"></div>
<div id="contractQueryConditionPanel"></div>
</body>
</html>