Ext.ns('eus.window.WarehouseDetail');

eus.window.WarehouseDetail = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	
	this.capacitorID = '';
	
	this.productCodeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductCode.action',
		baseParams:{status:'Using'},
		root:'ProductCodeList',
		fields:['id','code','name']
	});
	
	this.humidityStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findHumidity.action',
		baseParams:{status:'Using'},
		root:'HumidityList',
		fields:['id','code']
	});
	
	this.errorLevelStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findErrorLevel.action',
		baseParams:{status:'Using'},
		root:'ErrorLevelList',
		fields:['id','code']
	});

	this.unitStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUnit.action',
		baseParams:{status:'Using'},
		root:'UnitList',
		fields:['id','name']
	});
	
	this.usageTypeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUsageType.action',
		baseParams:{status:'Using'},
		root:'UsageTypeList',
		fields:['id','name']
	});

	this.productTypeStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});	
	
	this.capacitorStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCapacitor.action',
		baseParams:{status:'Using'},
		root:'Capacitor',
		fields:['id','productName','voltage','capacity',{name:'price',type:'float'},
		        'standard','protocol','project','memo','productCode',
		        'humidity','errorLevel','unit','usageType','productType']
	});
	
	/* ֻ�����ӵ�ʱ���Զ����أ��������޸ĵ�ʱ���ظ�����,
	 * �ú���clsys.form.Util.updateCombo�ᵼ���ظ�����
	 */
	
	//1
	var txtProductName = {
		xtype:'textfield',
		id:'txtProductName',
		fieldLabel:'��Ʒ����',
		name:'productName'
	};
	//2
	var txtVoltage = {
		xtype:'textfield',
		id:'txtVoltage',
		fieldLabel:'��Ʒ��ѹ',
		name:'voltage'
	};
	//3
	var txtCapacity = {
		xtype:'textfield',
		id:'txtCapacity',
		fieldLabel:'��Ʒ����',
		name:'capacity'
	};
	//4
	var txtPrice = {
		xtype:'textfield',
		id:'txtPrice',
		fieldLabel:'����',
		name:'price'		
	};
	//5
	var txtStandard = {
		xtype:'textfield',
		id:'txtStandard',
		fieldLabel:'ִ�б�׼',
		name:'standard'	
	};
	//6
	var txtProtocol = {
		xtype:'textfield',
		id:'txtProtocol',
		fieldLabel:'����Э��',
		name:'protocol'	
	};
	//7
	var txtProject = {
		xtype:'textfield',
		id:'txtProject',
		fieldLabel:'�ںι���',
		name:'project'	
	};

	//8
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'��ע',
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
		emptyText:'��ѡ��',
		fieldLabel:'��Ʒ����',
		selectOnFocus:true,
		id:'cbProductCode',
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
		emptyText:'��ѡ��',
		fieldLabel:'ʪ��ϵ��ָ��',
		selectOnFocus:true,
		id:'cbHumidity',
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
		emptyText:'��ѡ��',
		fieldLabel:'���ȼ�',
		selectOnFocus:true,
		id:'cbErrorLevel',
		valueField:'id'
	};
	
	//12 ��λ
	var cbUnit = {
		xtype:'combo',
		store:this.unitStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ��',
		fieldLabel:'��λ',
		selectOnFocus:true,
		id:'cbUnit',
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
		emptyText:'��ѡ��',
		fieldLabel:'��ƷƷ��',
		selectOnFocus:true,
		id:'cbUsageType',
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
		emptyText:'��ѡ��',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbProductType',
		valueField:'id'
	};
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductCode,cbUnit,cbErrorLevel,txtProductName,txtVoltage,txtCapacity,txtMemo]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductType,cbHumidity,cbUsageType,txtPrice,txtStandard,txtProtocol,txtProject]		
	};
	
	this.capacitorForm = new Ext.form.FormPanel({
		id:'warehousedetail-window-form',
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
	
	var btnCancel = {
		text:'�ر�',
		id:'warehousedetail-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.WarehouseDetail.superclass.constructor.call(this, {
		id:'warehousedetail-window',
		title:'������Ʒ',
		buttonAlign:'center',
		autoHeight:true,
		width:650,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.capacitorForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'capacitorSaved':true});
};

var config = {
	/*�򿪴���*/
	open:function(capacitorID){
		
		this.capacitorID = capacitorID;
		this.mode = 'update';
		this.title = '�޸Ĳ�Ʒ';
		
		var callbackFunc = function(){
			if (this.capacitorStore.getCount()<1) return;
			var record = this.capacitorStore.getAt(0);
			Ext.getCmp('txtProductName').setValue(record.get('productName'));
			Ext.getCmp('txtVoltage').setValue(record.get('voltage'));
			Ext.getCmp('txtCapacity').setValue(record.get('capacity'));
			Ext.getCmp('txtPrice').setValue(record.get('price'));
			Ext.getCmp('txtStandard').setValue(record.get('standard'));
			Ext.getCmp('txtProtocol').setValue(record.get('protocol'));
			Ext.getCmp('txtProject').setValue(record.get('project'));
			Ext.getCmp('txtMemo').setValue(record.get('memo'));
			clsys.form.Util.updateCombo('cbProductCode',record.json.productCode.id);
			clsys.form.Util.updateCombo('cbHumidity',record.json.humidity.id);
			clsys.form.Util.updateCombo('cbErrorLevel',record.json.errorLevel.id);
			clsys.form.Util.updateCombo('cbUnit',record.json.unit.id);
			clsys.form.Util.updateCombo('cbUsageType',record.json.usageType.id);
			clsys.form.Util.updateCombo('cbProductType',record.json.productType.id); 
		};

		this.capacitorStore.load({
			params:{id:capacitorID},
			callback:callbackFunc,
			scope:this
		});
	}
};

Ext.extend(eus.window.WarehouseDetail,Ext.Window,config);

Ext.reg('eus-warehousedetail-window',eus.window.WarehouseDetail);
