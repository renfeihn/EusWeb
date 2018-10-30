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
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtSelectorProductName'
	};
	//2
	var txtSelectorVoltage = {
		xtype:'textfield',
		id:'txtSelectorVoltage',
		fieldLabel:'��Ʒ��ѹ',
		width:220,
		name:'txtSelectorVoltage'
	};
	//3
	var txtSelectorCapacity = {
		xtype:'textfield',
		id:'txtSelectorCapacity',
		fieldLabel:'��Ʒ����',
		width:220,
		name:'txtSelectorCapacity'
	};
	//4
	var txtSelectorPrice = {
		xtype:'textfield',
		id:'txtSelectorPrice',
		fieldLabel:'����',
		width:220,
		name:'txtSelectorPrice'		
	};
	//5
	var txtSelectorStandard = {
		xtype:'textfield',
		id:'txtSelectorStandard',
		fieldLabel:'ִ�б�׼',
		width:220,
		name:'txtSelectorStandard'	
	};
	//6
	var txtSelectorProtocol = {
		xtype:'textfield',
		id:'txtSelectorProtocol',
		fieldLabel:'����Э��',
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
		fieldLabel:'��ע',
		width:220,
		name:'txtSelectorMemo'	
	};
	
	//9 ��Ʒ���������б�	
	var cbSelectorProductCode = {
		xtype:'combo',
		store:this.productCodeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ����',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbSelectorProductCode',
		width:220,
		blankText:'��ѡ���Ʒ����',
		valueField:'id'
	};
	
	//10 ʪ��ϵ��ָ��	
	var cbSelectorHumidity = {
		xtype:'combo',
		store:this.humiditySelectorStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��ʪ��ϵ��ָ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbSelectorHumidity',
		width:220,
		blankText:'��ѡ��ʪ��ϵ��ָ��',
		valueField:'id'
	};
	
	//11 ���ȼ�
	var cbSelectorErrorLevel = {
		xtype:'combo',
		store:this.errorLevelSelectorStore,
		displayField:'code',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ�����ȼ�',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbSelectorErrorLevel',
		width:220,
		blankText:'��ѡ�����ȼ�',
		valueField:'id'
	};
	
	//12 ��λ
	var cbSelectorUnit = {
		xtype:'combo',
		store:this.unitSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��λ',
		fieldLabel:'��λ',
		selectOnFocus:true,
		id:'cbSelectorUnit',
		
		blankText:'��ѡ��λ',
		width:220,
		valueField:'id'
	};
	
	//13  ��ƷƷ��
	var cbSelectorUsageType = {
		xtype:'combo',
		store:this.usageTypeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���ƷƷ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbSelectorUsageType',
		width:220,
		valueField:'id'
	};
	
	//14  ��Ʒ���
	var cbSelectorProductType = {
		xtype:'combo',
		store:this.productTypeSelectorStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
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
	
	/* �����еİ�ť */
	var btnSubmit = {
		text:'��ѯ',
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
			/*������ѯ������ʱ����Ҫָ���һҳ*/
			attributes.start = 0;
			this.capacitorSelectorStore.reload({params:attributes});	
	},
		scope:this
	};
	
	var btnReset = {
		text:'����',
		iconCls: 'icon-prop',
		id:'capacitor-selector-window-reset',
		handler:function(){this.capacitorSelectorForm.getForm().reset();},
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
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
					/*ֻ��ѡ������ʱ�ſ��Բ���*/
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
				    {header:'��Ʒ���', width:50,dataIndex:'productType'},
					{header:'��Ʒ���Ƽ��ͺ�',width:200,dataIndex:'productCombination'},
				    {header:'�۸�',width:50,dataIndex:'price'},
				    {header:'��ѹ',width:40,dataIndex:'voltage'},
				    {header:'����',width:40,dataIndex:'capacity'},
				    {header:'ʪ��',width:40,dataIndex:'humidity'},
				    {header:'���',width:40,dataIndex:'errorLevel'}, 
					{header:'��λ',width:40,dataIndex:'unit'}
				]
			}),
			viewConfig:{forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.CapacitorSelector.superclass.constructor.call(this, {
		id:'capacitor-selector-window',
		title:'��Ʒ�ۺϲ�ѯ',
		buttonAlign:'center',
		height:530,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		bbar:[],
		items:[this.capacitorSelectorForm,this.capacitorSelectorGrid]
	});
	/*��Ӵ�����Ӧ���¼�*/
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
