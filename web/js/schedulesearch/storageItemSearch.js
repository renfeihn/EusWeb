Ext.ns('eus.window.StorageItemSearch');

eus.window.StorageItemSearch = function() {
	
	this.productCodeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	this.humidityStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	this.errorLevelStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	this.usageTypeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	this.productTypeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	var txtProductCombination = {
		xtype:'textfield',
		id:'txtProductCombination',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		width:220,
		name:'txtProductCombination'
	};
	
	//2
	var txtVoltage = {
		xtype:'textfield',
		id:'txtVoltage',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'voltage'
	};
	//3
	var txtCapacity = {
		xtype:'textfield',
		id:'txtCapacity',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'capacity'
	};
	
	//9 ��Ʒ���������б�	
	var cbProductCode = {
		xtype:'combo',
		store:this.productCodeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCode',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbHumidity = {
		xtype:'combo',
		store:this.humidityStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidity',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbErrorLevel = {
		xtype:'combo',
		store:this.errorLevelStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevel',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbUsageType = {
		xtype:'combo',
		store:this.usageTypeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageType',
		width:220,
		blankText:'��ѡ���ƷƷ��',
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbProductType = {
		xtype:'combo',
		store:this.productTypeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductType',
		width:220,
		blankText:'��ѡ���Ʒ���',
		valueField:'id'
	};

	var txtStorageItemDateStart = {
		xtype:'datefield',
		id:'txtStorageItemDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtStorageItemDateStart'	
	};
	
	var txtStorageItemDateEnd = {
		xtype:'datefield',
		id:'txtStorageItemDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtStorageItemDateEnd'	
	};
		
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtProductCombination,txtStorageItemDateStart,txtStorageItemDateEnd,cbProductCode,txtVoltage]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductType,cbHumidity,cbUsageType,cbErrorLevel,txtCapacity]		
	};
	
	this.storageItemSearchForm = new Ext.form.FormPanel({
		id:'storageitem-search-window-form',
		autoWidth:true,
		frame:false,
		border:false,
		labelWidth:150,
		labelAlign:'right',
		items:[{		
			layout:'column',
			frame:false,
			border:false,
			items:[col1,col2]
		}]
	});
	
	/* �����еİ�ť */
	var btnSubmit = {
		text:'��ѯ',
		id:'storageitem-search-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'storageitem-search-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'storageitem-search-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.StorageItemSearch.superclass.constructor.call(this, {
		id:'storageitem-search-window',
		title:'�����ϸ��ѯ����',
		buttonAlign:'center',
		autoHeight:true,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.storageItemSearchForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'StorageItemSearchSaved':true});
};

var config = {
	upsert:function(){},
	reset:function(){
		this.scheduleSearchForm.getForm().reset()
	},
	doAutoReload:function(){
		this.productCodeStore.baseParams = {status:'Using'};
		this.humidityStore.baseParams = {status:'Using'};
		this.errorLevelStore.baseParams = {status:'Using'};
		this.usageTypeStore.baseParams = {status:'Using'};
		this.productTypeStore.baseParams = {status:'Using'};
		
		this.productCodeStore.reload();
		this.humidityStore.reload();
		this.errorLevelStore.reload();
		this.usageTypeStore.reload();
		this.productTypeStore.reload();
	}
};

Ext.extend(eus.window.StorageItemSearch,Ext.Window,config);

Ext.reg('eus-storageitem-search-window',eus.window.StorageItemSearch);
