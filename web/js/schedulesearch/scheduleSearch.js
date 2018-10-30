Ext.ns('eus.window.ScheduleSearch');

eus.window.ScheduleSearch = function() {
	
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

	//8
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'��ע',
		width:220,
		name:'memo'	
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
	
	var txtScheduleNo = {
		xtype:'textfield',
		id:'txtScheduleNo',
		fieldLabel:'�ƻ����',
		width:220,
		name:'txtScheduleNo'	
	};

	var txtScheduleDateStart = {
		xtype:'datefield',
		id:'txtScheduleDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtScheduleDateStart'	
	};
	
	var txtScheduleDateEnd = {
		xtype:'datefield',
		id:'txtScheduleDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtScheduleDateEnd'	
	};
	
	var txtScheduleSavedDateStart = {
		xtype:'datefield',
		id:'txtScheduleSavedDateStart',
		fieldLabel:'��������(��ʼ)',
		width:220,
		name:'txtScheduleSavedDateStart'	
	};
	
	var txtScheduleSavedDateEnd = {
		xtype:'datefield',
		id:'txtScheduleSavedDateEnd',
		fieldLabel:'��������(����)',
		width:220,
		name:'txtScheduleSavedDateEnd'	
	};	
	
	var cbScheduleState = {
		xtype: 'combo',
		id: 'cbScheduleState',
		emptyText: '��ѡ��ƻ�״̬',
		fieldLabel:'�ƻ�״̬',
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
		editable: false
	};
	
	var cbScheduleStatus = {
		xtype: 'combo',
		id: 'cbScheduleStatus',
		emptyText: '��ѡ��ƻ��Ƿ�����',
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
		editable: false
	};	
	
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtScheduleNo,txtProductCombination,txtScheduleDateStart,txtScheduleDateEnd,cbProductCode,cbErrorLevel,txtVoltage,txtCapacity]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbScheduleStatus,cbScheduleState,txtScheduleSavedDateStart,txtScheduleSavedDateEnd,cbProductType,cbHumidity,cbUsageType,txtMemo]		
	};
	
	this.scheduleSearchForm = new Ext.form.FormPanel({
		id:'schedule-search-window-form',
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
		id:'schedule-search-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'schedule-search-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'schedule-search-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.ScheduleSearch.superclass.constructor.call(this, {
		id:'schedule-search-window',
		title:'�ƻ���ѯ����',
		buttonAlign:'center',
		autoHeight:true,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.scheduleSearchForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'scheduleSearchSaved':true});
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

Ext.extend(eus.window.ScheduleSearch,Ext.Window,config);

Ext.reg('eus-schedule-search-window',eus.window.ScheduleSearch);
