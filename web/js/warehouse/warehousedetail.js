Ext.ns('eus.window.WarehouseDetail');

eus.window.WarehouseDetail = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
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
	
	/* 只有增加的时候自动加载，避免在修改的时候重复加载,
	 * 该函数clsys.form.Util.updateCombo会导致重复加载
	 */
	
	//1
	var txtProductName = {
		xtype:'textfield',
		id:'txtProductName',
		fieldLabel:'产品名称',
		name:'productName'
	};
	//2
	var txtVoltage = {
		xtype:'textfield',
		id:'txtVoltage',
		fieldLabel:'产品电压',
		name:'voltage'
	};
	//3
	var txtCapacity = {
		xtype:'textfield',
		id:'txtCapacity',
		fieldLabel:'产品容量',
		name:'capacity'
	};
	//4
	var txtPrice = {
		xtype:'textfield',
		id:'txtPrice',
		fieldLabel:'单价',
		name:'price'		
	};
	//5
	var txtStandard = {
		xtype:'textfield',
		id:'txtStandard',
		fieldLabel:'执行标准',
		name:'standard'	
	};
	//6
	var txtProtocol = {
		xtype:'textfield',
		id:'txtProtocol',
		fieldLabel:'技术协议',
		name:'protocol'	
	};
	//7
	var txtProject = {
		xtype:'textfield',
		id:'txtProject',
		fieldLabel:'于何工程',
		name:'project'	
	};

	//8
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'备注',
		name:'memo'	
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
		emptyText:'请选择',
		fieldLabel:'产品代号',
		selectOnFocus:true,
		id:'cbProductCode',
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
		emptyText:'请选择',
		fieldLabel:'湿度系数指标',
		selectOnFocus:true,
		id:'cbHumidity',
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
		emptyText:'请选择',
		fieldLabel:'误差等级',
		selectOnFocus:true,
		id:'cbErrorLevel',
		valueField:'id'
	};
	
	//12 单位
	var cbUnit = {
		xtype:'combo',
		store:this.unitStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择',
		fieldLabel:'单位',
		selectOnFocus:true,
		id:'cbUnit',
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
		emptyText:'请选择',
		fieldLabel:'产品品种',
		selectOnFocus:true,
		id:'cbUsageType',
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
		emptyText:'请选择',
		fieldLabel:'产品类别',
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
		text:'关闭',
		id:'warehousedetail-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.WarehouseDetail.superclass.constructor.call(this, {
		id:'warehousedetail-window',
		title:'新增产品',
		buttonAlign:'center',
		autoHeight:true,
		width:650,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.capacitorForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'capacitorSaved':true});
};

var config = {
	/*打开窗口*/
	open:function(capacitorID){
		
		this.capacitorID = capacitorID;
		this.mode = 'update';
		this.title = '修改产品';
		
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
