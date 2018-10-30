Ext.ns('eus.window.Capacitor');

eus.window.Capacitor = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	
	this.capacitorID = '';
	
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

	this.unitStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findUnit.action',
		baseParams:{status:'Using'},
		root:'UnitList',
		fields:['id','name'],
		sortInfo: {field: 'name',direction: 'ASC'}
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
		width:220,
		allowBlank:false,
		name:'txtProductName'
	};
	//2
	var txtVoltage = {
		xtype:'textfield',
		id:'txtVoltage',
		fieldLabel:'产品电压',
		width:220,
		name:'txtVoltage'
	};
	//3
	var txtCapacity = {
		xtype:'textfield',
		id:'txtCapacity',
		fieldLabel:'产品容量',
		width:220,
		name:'txtCapacity'
	};
	//4
	var txtPrice = {
		xtype:'numberfield',
		id:'txtPrice',
		fieldLabel:'单价',
		width:220,
		allowDecimals: true, // 允许小数点 
		allowNegative: false, // 允许负数 
		minValue:0.00,
		allowBlank:false,
		name:'txtPrice'		
	};
	//5
	var txtStandard = {
		xtype:'textfield',
		id:'txtStandard',
		fieldLabel:'注解',
		width:220,
		name:'txtStandard'	
	};
	//6
	var txtProtocol = {
		xtype:'textfield',
		id:'txtProtocol',
		fieldLabel:'技术协议',
		width:220,
		name:'txtProtocol'	
	};
	//7
	var txtProject = {
		hidden:true,
		xtype:'textfield',
		id:'txtProject',
		fieldLabel:'',
		width:220,
		name:'txtProject'	
	};

	//8
	var txtMemo = {
		xtype:'numberfield',
		id:'txtMemo',
		width:220,
		allowBlank:false,
		fieldLabel:'最低库存数量',
		blankText:'请输入最低库存数量',
		allowDecimals: false, // 允许小数点 
		allowNegative: false, // 允许负数 
		minValue:0,
		name:'txtMemo'	
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
	
	//12 单位
	var cbUnit = {
		xtype:'combo',
		store:this.unitStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择单位',
		fieldLabel:'单位',
		selectOnFocus:true,
		id:'cbUnit',
		allowBlank:false,
		blankText:'请选择单位',
		width:220,
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
		allowBlank:false,
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
		allowBlank:false,
		blankText:'请选择产品类别',
		valueField:'id'
	};
	
	var col1 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductCode,cbUnit,cbErrorLevel,txtProductName,txtVoltage,txtCapacity,txtMemo]		
	};
	
	var col2 = {
		columnWidth: .50,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbProductType,cbHumidity,cbUsageType,txtPrice,txtStandard,txtProtocol,txtProject]		
	};
	
	this.capacitorForm = new Ext.form.FormPanel({
		id:'capacitor-window-form',
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
		text:'保存',
		id:'capacitor-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'capacitor-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'capacitor-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.Capacitor.superclass.constructor.call(this, {
		id:'capacitor-window',
		title:'新增产品',
		buttonAlign:'center',
		autoHeight:true,
		width:900,
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
	/*新增和修改*/
	upsert:function(){
	
		if (!this.capacitorForm.getForm().isValid()) return;
	
		var url = this.mode == 'add' ? 'addCapacitor.action' : 'updateCapacitor.action';
		var params = {
			id:this.capacitorID,
			productCode:Ext.getCmp('cbProductCode').getValue(),
			humidity:Ext.getCmp('cbHumidity').getValue(),
			errorLevel:Ext.getCmp('cbErrorLevel').getValue(),
			unit:Ext.getCmp('cbUnit').getValue(),
			usageType:Ext.getCmp('cbUsageType').getValue(),
			productType:Ext.getCmp('cbProductType').getValue(),
			productName:Ext.getCmp('txtProductName').getValue(),
			voltage:Ext.getCmp('txtVoltage').getValue(),
			capacity:Ext.getCmp('txtCapacity').getValue(),
			price:Ext.getCmp('txtPrice').getValue(),
			standard:Ext.getCmp('txtStandard').getValue(),
			protocol:Ext.getCmp('txtProtocol').getValue(),
			project:Ext.getCmp('txtProject').getValue(),
			memo:Ext.getCmp('txtMemo').getValue()
		};
		
		var url = this.mode == 'add' ? 'addCapacitor.action' : 'updateCapacitor.action';
		var msg = this.mode == 'add' ? '新增' : '修改'; 
		this.capacitorForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
			    
				clsys.message.info('产品' + msg + '成功');
				this.fireEvent('companySaved',{});
				//this.destroy();
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});

	},
	/*修改时打开窗口*/
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
	},
	/*重置*/
	reset:function(){
		var resetFunc = function(btn){
			var ID = this.capacitorID;
			if (btn == 'yes' && this.mode == 'add'){
				this.capacitorForm.getForm().reset();
			}
			if (this.mode == 'update'){
				this.open(ID);
			}
		};
		Ext.MessageBox.show({
			titile: '确认重置', 
			buttons: Ext.MessageBox.YESNO,
			msg: '是否重置产品信息', 
			fn: resetFunc,
			icon: Ext.MessageBox.QUESTION,
			scope: this
		});
	},
	/*只有新增的时需要autoload*/
	doAutoReload:function(){
		this.productCodeStore.baseParams = {status:'Using'};
		this.humidityStore.baseParams = {status:'Using'};
		this.errorLevelStore.baseParams = {status:'Using'};
		this.unitStore.baseParams = {status:'Using'};
		this.usageTypeStore.baseParams = {status:'Using'};
		this.productTypeStore.baseParams = {status:'Using'};
		
		this.productCodeStore.reload();
		this.humidityStore.reload();
		this.errorLevelStore.reload();
		this.unitStore.reload();
		this.usageTypeStore.reload();
		this.productTypeStore.reload();
	}
};

Ext.extend(eus.window.Capacitor,Ext.Window,config);

Ext.reg('eus-capacitor-window',eus.window.Capacitor);
