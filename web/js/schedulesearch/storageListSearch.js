Ext.ns('eus.window.StorageListSearch');

eus.window.StorageListSearch = function() {
	
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
		fieldLabel:'产品名称及型号',
		width:220,
		name:'txtProductCombination'
	};
	
	//2
	var txtVoltage = {
		xtype:'textfield',
		id:'txtVoltage',
		fieldLabel:'产品电压',
		width:220,
		name:'voltage'
	};
	//3
	var txtCapacity = {
		xtype:'textfield',
		id:'txtCapacity',
		fieldLabel:'产品容量',
		width:220,
		name:'capacity'
	};
	
	//9 产品代号下拉列表	
	var cbProductCode = {
		xtype:'combo',
		store:this.productCodeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCode',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id'
	};
	
	//10 湿度系数指标	
	var cbHumidity = {
		xtype:'combo',
		store:this.humidityStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidity',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id'
	};
	
	//11 误差等级
	var cbErrorLevel = {
		xtype:'combo',
		store:this.errorLevelStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevel',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id'
	};
	
	//13  产品品种
	var cbUsageType = {
		xtype:'combo',
		store:this.usageTypeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageType',
		width:220,
		blankText:'请选择产品品种',
		valueField:'id'
	};
	
	//14  产品类别
	var cbProductType = {
		xtype:'combo',
		store:this.productTypeStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbProductType',
		width:220,
		blankText:'请选择产品类别',
		valueField:'id'
	};

	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtProductCombination,cbProductCode,cbUsageType,txtVoltage]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductType,cbHumidity,cbErrorLevel,txtCapacity]		
	};
	
	this.scheduleSearchForm = new Ext.form.FormPanel({
		id:'storagelist-search-window-form',
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
	
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'查询',
		id:'storagelist-search-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'storagelist-search-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'storagelist-search-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.StorageListSearch.superclass.constructor.call(this, {
		id:'storagelist-search-window',
		title:'库存明细查询条件',
		buttonAlign:'center',
		autoHeight:true,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.scheduleSearchForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'StorageListSearchSaved':true});
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

Ext.extend(eus.window.StorageListSearch,Ext.Window,config);

Ext.reg('eus-storagelist-search-window',eus.window.StorageListSearch);
