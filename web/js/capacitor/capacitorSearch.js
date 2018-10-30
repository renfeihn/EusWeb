Ext.ns('eus.window.CapacitorSearch');

eus.window.CapacitorSearch = function() {
	
	this.productCodeSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name']
	});
	
	this.humiditySearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code']
	});
	
	this.errorLevelSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code']
	});

	this.unitSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUnit.action',
		baseParams:{status:'Using'},
		root:'UnitList',
		fields:['id','name']
	});
	
	this.usageTypeSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name']
	});

	this.productTypeSearchStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});	


	//1
	var txtSearchProductName = {
		xtype:'textfield',
		id:'txtSearchProductName',
		fieldLabel:'产品名称',
		width:220,
		name:'txtSearchProductName'
	};
	//2
	var txtSearchVoltage = {
		xtype:'textfield',
		id:'txtSearchVoltage',
		fieldLabel:'产品电压',
		width:220,
		name:'txtSearchVoltage'
	};
	//3
	var txtSearchCapacity = {
		xtype:'textfield',
		id:'txtSearchCapacity',
		fieldLabel:'产品容量',
		width:220,
		name:'txtSearchCapacity'
	};
	//4
	var txtSearchPrice = {
		xtype:'textfield',
		id:'txtSearchPrice',
		fieldLabel:'单价',
		width:220,
		name:'txtSearchPrice'		
	};
	//5
	var txtSearchStandard = {
		xtype:'textfield',
		id:'txtSearchStandard',
		fieldLabel:'执行标准',
		width:220,
		name:'txtSearchStandard'	
	};
	//6
	var txtSearchProtocol = {
		xtype:'textfield',
		id:'txtSearchProtocol',
		fieldLabel:'技术协议',
		width:220,
		name:'txtSearchProtocol'	
	};
	//7
	var txtSearchProject = {
		hidden:true,
		xtype:'textfield',
		id:'txtSearchProject',
		fieldLabel:'',
		width:220,
		name:'txtSearchProject'	
	};

	//8
	var txtSearchMemo = {
		xtype:'txtSearchMemo',
		id:'txtSearchMemo',
		fieldLabel:'备注',
		width:220,
		name:'txtSearchMemo'	
	};
	
	//9 产品代号下拉列表	
	var cbSearchProductCode = {
		xtype:'combo',
		store:this.productCodeSearchStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbSearchProductCode',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id'
	};
	
	//10 湿度系数指标	
	var cbSearchHumidity = {
		xtype:'combo',
		store:this.humiditySearchStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbSearchHumidity',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id'
	};
	
	//11 误差等级
	var cbSearchErrorLevel = {
		xtype:'combo',
		store:this.errorLevelSearchStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbSearchErrorLevel',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id'
	};
	
	//12 单位
	var cbSearchUnit = {
		xtype:'combo',
		store:this.unitSearchStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择单位',
		fieldLabel:'单位',
		selectOnFocus:true,
		id:'cbSearchUnit',
		
		blankText:'请选择单位',
		width:220,
		valueField:'id'
	};
	
	//13  产品品种
	var cbSearchUsageType = {
		xtype:'combo',
		store:this.usageTypeSearchStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbSearchUsageType',
		width:220,
		valueField:'id'
	};
	
	//14  产品类别
	var cbSearchProductType = {
		xtype:'combo',
		store:this.productTypeSearchStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbSearchProductType',
		width:220,
		valueField:'id'
	};
	
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSearchProductCode,cbSearchUnit,cbSearchErrorLevel,txtSearchProductName,txtSearchVoltage,txtSearchCapacity]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSearchProductType,cbSearchHumidity,cbSearchUsageType,txtSearchPrice,txtSearchStandard,txtSearchProtocol,txtSearchProject]		
	};
	
	this.capacitorSearchForm = new Ext.form.FormPanel({
		id:'capacitor-search-window-form',
		autoWidth:true,
		frame:false,
		border:false,
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
		id:'capacitor-search-window-submit',
		handler:function(){
			var attributes = {
				productCode:Ext.getCmp('cbSearchProductCode').getValue(),
				humidity:Ext.getCmp('cbSearchHumidity').getValue(),
				errorLevel:Ext.getCmp('cbSearchErrorLevel').getValue(),
				unit:Ext.getCmp('cbSearchUnit').getValue(),
				usageType:Ext.getCmp('cbSearchUsageType').getValue(),
				productType:Ext.getCmp('cbSearchProductType').getValue(),
				productName:Ext.getCmp('txtSearchProductName').getValue(),
				voltage:Ext.getCmp('txtSearchVoltage').getValue(),
				capacity:Ext.getCmp('txtSearchCapacity').getValue(),
				price:Ext.getCmp('txtSearchPrice').getValue(),
				standard:Ext.getCmp('txtSearchStandard').getValue(),
				protocol:Ext.getCmp('txtSearchProtocol').getValue(),
				project:Ext.getCmp('txtSearchProject').getValue()
			};
			this.fireEvent('capacitorSearching',attributes);	
	},
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'capacitor-search-window-reset',
		handler:function(){this.capacitorSearchForm.getForm().reset();},
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'capacitor-search-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.CapacitorSearch.superclass.constructor.call(this, {
		id:'capacitor-search-window',
		title:'产品综合查询',
		buttonAlign:'center',
		autoHeight:true,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.capacitorSearchForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'capacitorSearching':true});
};

Ext.extend(eus.window.CapacitorSearch,Ext.Window,{
	doAutoReload:function(){
		this.productCodeSearchStore.baseParams = {status:'Using'};
		this.humiditySearchStore.baseParams = {status:'Using'};
		this.errorLevelSearchStore.baseParams = {status:'Using'};
		this.unitSearchStore.baseParams = {status:'Using'};
		this.usageTypeSearchStore.baseParams = {status:'Using'};
		this.productTypeSearchStore.baseParams = {status:'Using'};
		
		this.productCodeSearchStore.reload();
		this.humiditySearchStore.reload();
		this.errorLevelSearchStore.reload();
		this.unitSearchStore.reload();
		this.usageTypeSearchStore.reload();
		this.productTypeSearchStore.reload();
	}
});

Ext.reg('eus-capacitor-search-window',eus.window.CapacitorSearch);
