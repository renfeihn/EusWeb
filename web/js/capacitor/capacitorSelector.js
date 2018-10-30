Ext.ns('eus.window.CapacitorSelector');

eus.window.CapacitorSelector = function() {
	
	this.capacitorSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'findCapacitor.action',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	totalProperty:'results',
	  	root:'CapacitorList',
	  	idProperty:'id',
	  	fields:['id','productName','voltage','capacity','productCombination','price',
		        {name:'productType',mapping:'productType.name'},
		        {name:'productTypeID',mapping:'productType.id'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'},   		  	
	  		   	{name:'unit',mapping:'unit.name'},
	  	       	{name:'productCode',mapping:'productCode.code'}]
  	});
	
	this.productCodeSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	this.humiditySelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	this.errorLevelSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code'],
		sortInfo: {field: 'code',direction: 'ASC'}
	});

	this.unitSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUnit.action',
		baseParams:{status:'Using'},
		root:'UnitList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});
	
	this.usageTypeSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});

	this.productTypeSelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
	});	


	//1
	var txtSelectorProductName = {
		xtype:'textfield',
		id:'txtSelectorProductName',
		fieldLabel:'产品名称',
		width:220,
		name:'txtSelectorProductName'
	};
	//2
	var txtSelectorVoltage = {
		xtype:'textfield',
		id:'txtSelectorVoltage',
		fieldLabel:'产品电压',
		width:220,
		name:'txtSelectorVoltage'
	};
	//3
	var txtSelectorCapacity = {
		xtype:'textfield',
		id:'txtSelectorCapacity',
		fieldLabel:'产品容量',
		width:220,
		name:'txtSelectorCapacity'
	};
	//4
	var txtSelectorPrice = {
		xtype:'textfield',
		id:'txtSelectorPrice',
		fieldLabel:'单价',
		width:220,
		name:'txtSelectorPrice'		
	};
	//5
	var txtSelectorStandard = {
		xtype:'textfield',
		id:'txtSelectorStandard',
		fieldLabel:'执行标准',
		width:220,
		name:'txtSelectorStandard'	
	};
	//6
	var txtSelectorProtocol = {
		xtype:'textfield',
		id:'txtSelectorProtocol',
		fieldLabel:'技术协议',
		width:220,
		name:'txtSelectorProtocol'	
	};
	//7
	var txtSelectorProject = {
		hidden:true,
		xtype:'textfield',
		id:'txtSelectorProject',
		fieldLabel:'',
		width:220,
		name:'txtSelectorProject'	
	};

	//8
	var txtSelectorMemo = {
		xtype:'txtSelectorMemo',
		id:'txtSelectorMemo',
		fieldLabel:'备注',
		width:220,
		name:'txtSelectorMemo'	
	};
	
	//9 产品代号下拉列表	
	var cbSelectorProductCode = {
		xtype:'combo',
		store:this.productCodeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品代号',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbSelectorProductCode',
		width:220,
		blankText:'请选择产品代号',
		valueField:'id'
	};
	
	//10 湿度系数指标	
	var cbSelectorHumidity = {
		xtype:'combo',
		store:this.humiditySelectorStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择湿度系数指标',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbSelectorHumidity',
		width:220,
		blankText:'请选择湿度系数指标',
		valueField:'id'
	};
	
	//11 误差等级
	var cbSelectorErrorLevel = {
		xtype:'combo',
		store:this.errorLevelSelectorStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择误差等级',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbSelectorErrorLevel',
		width:220,
		blankText:'请选择误差等级',
		valueField:'id'
	};
	
	//12 单位
	var cbSelectorUnit = {
		xtype:'combo',
		store:this.unitSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择单位',
		fieldLabel:'单位',
		selectOnFocus:true,
		id:'cbSelectorUnit',
		
		blankText:'请选择单位',
		width:220,
		valueField:'id'
	};
	
	//13  产品品种
	var cbSelectorUsageType = {
		xtype:'combo',
		store:this.usageTypeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品品种',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbSelectorUsageType',
		width:220,
		valueField:'id'
	};
	
	//14  产品类别
	var cbSelectorProductType = {
		xtype:'combo',
		store:this.productTypeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbSelectorProductType',
		width:220,
		valueField:'id'
	};
	
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSelectorProductCode,cbSelectorUnit,cbSelectorErrorLevel,txtSelectorProductName,txtSelectorVoltage,txtSelectorCapacity]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSelectorProductType,cbSelectorHumidity,cbSelectorUsageType,txtSelectorPrice,txtSelectorStandard,txtSelectorProtocol,txtSelectorProject]		
	};
	
	this.capacitorSelectorForm = new Ext.form.FormPanel({
		id:'capacitor-selector-window-form',
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
		iconCls: 'icon-examine',
		id:'capacitor-selector-window-submit',
		handler:function(){
			var attributes = {
				productCode:Ext.getCmp('cbSelectorProductCode').getValue(),
				humidity:Ext.getCmp('cbSelectorHumidity').getValue(),
				errorLevel:Ext.getCmp('cbSelectorErrorLevel').getValue(),
				unit:Ext.getCmp('cbSelectorUnit').getValue(),
				usageType:Ext.getCmp('cbSelectorUsageType').getValue(),
				productType:Ext.getCmp('cbSelectorProductType').getValue(),
				productName:Ext.getCmp('txtSelectorProductName').getValue(),
				voltage:Ext.getCmp('txtSelectorVoltage').getValue(),
				capacity:Ext.getCmp('txtSelectorCapacity').getValue(),
				price:Ext.getCmp('txtSelectorPrice').getValue(),
				standard:Ext.getCmp('txtSelectorStandard').getValue(),
				protocol:Ext.getCmp('txtSelectorProtocol').getValue(),
				project:Ext.getCmp('txtSelectorProject').getValue()
			};
			/*更换查询条件的时候，需要指向第一页*/
			attributes.start = 0;
			this.capacitorSelectorStore.reload({params:attributes});	
	},
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		iconCls: 'icon-prop',
		id:'capacitor-selector-window-reset',
		handler:function(){this.capacitorSelectorForm.getForm().reset();},
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		iconCls: 'icon-remove',
		id:'capacitor-selector-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
	
	this.capacitorSelectorGrid = {
			xtype:'grid',
			id:'capacitor-selector-grid',
			store:this.capacitorSelectorStore,
			stripeRows:true,
			autoScroll:true,
			height:230,
			width:880,
			loadMask:true,
			border:false,
			listeners:{
				dblclick:function(){
					/*只有选中资料时才可以操作*/
		  			var sm = Ext.getCmp('capacitor-selector-grid').getSelectionModel();
		  			if (sm.getCount()<1) return;
		  			var attributes = {id:sm.getSelected().get('id'),productTypeID:sm.getSelected().get('productTypeID')};
		  			this.fireEvent("capacitorSelected",attributes);
				},
				scope:this},
			tbar:[btnSubmit,btnReset,btnCancel],
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
				    {header:'产品类别', width:50,dataIndex:'productType'},
					{header:'产品名称及型号',width:200,dataIndex:'productCombination'},
				    {header:'价格',width:50,dataIndex:'price'},
				    {header:'电压',width:40,dataIndex:'voltage'},
				    {header:'容量',width:40,dataIndex:'capacity'},
				    {header:'湿度',width:40,dataIndex:'humidity'},
				    {header:'误差',width:40,dataIndex:'errorLevel'}, 
					{header:'单位',width:40,dataIndex:'unit'}
				]
			}),
			viewConfig:{forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.CapacitorSelector.superclass.constructor.call(this, {
		id:'capacitor-selector-window',
		title:'产品综合查询',
		buttonAlign:'center',
		height:530,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		bbar:[],
		items:[this.capacitorSelectorForm,this.capacitorSelectorGrid]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'capacitorSelected':true});
};

Ext.extend(eus.window.CapacitorSelector,Ext.Window,{
	doAutoReload:function(){
		this.initComponet();
		this.productCodeSelectorStore.baseParams = {status:'Using'};
		this.humiditySelectorStore.baseParams = {status:'Using'};
		this.errorLevelSelectorStore.baseParams = {status:'Using'};
		this.unitSelectorStore.baseParams = {status:'Using'};
		this.usageTypeSelectorStore.baseParams = {status:'Using'};
		this.productTypeSelectorStore.baseParams = {status:'Using'};
		
		this.productCodeSelectorStore.reload();
		this.humiditySelectorStore.reload();
		this.errorLevelSelectorStore.reload();
		this.unitSelectorStore.reload();
		this.usageTypeSelectorStore.reload();
		this.productTypeSelectorStore.reload();
	},
	initComponet:function(){
		Ext.Container.superclass.initComponent.call(this);
		this.add(clsys.form.Util.PagingToolbar(this.capacitorSelectorStore, this.capacitorSelectorForm.bbar, 'capacitorSelector-paging'))
	}
});

Ext.reg('eus-capacitor-selector-window',eus.window.CapacitorSelector);
