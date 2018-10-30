Ext.ns('eus.window.ScheduleFinishedSICProduct');

eus.window.ScheduleFinishedSICProduct = function() {

	this.mode = 'add';
	this.sicItemNo = '';
	this.originalResult = {};
	this.scheduleID = '';
	this.productType = '';
	this.productTypeID = '';
	this.scheduleNo = '';
	this.scheduleAmount = 0;
	this.scheduleFinishedAmount = 0;
	
	/*产品类别 Store*/
	this.scheduleFinishedSICItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getProductType.action',
		baseParams:{status:'Using'},
		root:'ProductType',
		fields:['id','name']
	});
	
	/*产品名称及型号 Store*/
	this.scheduleFinishedSICItem_ProductCombination = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCapacitor.action',
		root:'Capacitor',
		fields:['id','productName','price','voltage','capacity','productCombination','productionDate',
		        {name:'productCode',mapping:'productCode.code'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'}, 
		        {name:'unit',mapping:'unit.name'}]
	});	

	/*产品类别*/
	var cbScheduleFinishedSICItem_ProductType = {
		xtype:'combo',
		store:this.scheduleFinishedSICItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbScheduleFinishedSICItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'请选择产品类别',
		allowBlank:false,
		width:317
	};

	/*产品名称及型号*/	
	var cbScheduleFinishedSICItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleFinishedSICItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品名称及型号',
		fieldLabel:'产品名称及型号',
		selectOnFocus:true,
		id:'cbScheduleFinishedSICItem_ProductCombination',
		width:317,
		readOnly:true,
		allowBlank:false,
		blankText:'请选择产品名称及型号',
		valueField:'id'
	};

	/*产品数量*/
	var txtScheduleFinishedSICItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleFinishedSICItemAmount',
		fieldLabel:'入库数量',
		width:300,
		allowBlank:false,
		blankText:'请输入入库数量',
		allowDecimals: false, // 允许小数点 
		allowNegative: false, // 允许负数 
		minValue:1,
		name:'txtScheduleFinishedSICItemAmount'
	};
	
	/*工作令号*/
	var txtScheduleFinishedSICItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemJobCmdNo',
		fieldLabel:'工作令号',
		width:300,
		allowBlank:false,
		blankText:'请输入工作令号',
		name:'txtScheduleFinishedSICItemJobCmdNo'
	};
	
	/*工作电压*/
	var txtScheduleFinishedSICItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemVoltage',
		fieldLabel:'工作电压(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemVoltage'
	};	

	/*容量*/
	var txtScheduleFinishedSICItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemCapacity',
		fieldLabel:'容量(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemCapacity'
	};

	/*组别-湿度系数*/
	var txtScheduleFinishedSICItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemHumidity',
		fieldLabel:'组别',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemHumidity'
	};	

	/*等级-产品代号*/
	var txtScheduleFinishedSICItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemProductCode',
		fieldLabel:'等级',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemProductCode'
	};
	
	/*计划号*/
	var txtScheduleFinishedSICItemScheduleNo = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleNo',
		fieldLabel:'计划编号',
		name:'txtScheduleFinishedSICItemScheduleNo',
		width:300,
		readOnly:true
	};

	var txtScheduleFinishedSICItemScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleAmount',
		fieldLabel:'计划数量',
		name:'txtScheduleFinishedSICItemScheduleAmount',
		width:300,
		readOnly:true
	};
	
	var txtScheduleFinishedSICItemScheduleFinishedAmount = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleFinishedAmount',
		fieldLabel:'完成数量',
		name:'txtScheduleFinishedSICItemScheduleFinishedAmount',
		width:300,
		readOnly:true
	};
	
	/*生产日期*/
	var cbScheduleFinishedSICItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleFinishedSICItemProductionDate',
		fieldLabel:'生产日期',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'请选择生产日期',		
		name:'cbScheduleFinishedSICItemProductionDate'
	}
			
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'scheduleFinishedSICProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'关闭',
		id:'scheduleFinishedSICProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtScheduleFinishedSICItemScheduleNo,
		       txtScheduleFinishedSICItemScheduleAmount,
		       txtScheduleFinishedSICItemScheduleFinishedAmount,
		       txtScheduleFinishedSICItemAmount,
		       txtScheduleFinishedSICItemJobCmdNo,
		       txtScheduleFinishedSICItemAmount,    
		       cbScheduleFinishedSICItemProductionDate]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[
		       cbScheduleFinishedSICItem_ProductType,
		       cbScheduleFinishedSICItem_ProductCombination,
		       txtScheduleFinishedSICItemCapacity,
		       txtScheduleFinishedSICItemProductCode,
		       txtScheduleFinishedSICItemVoltage,
		       txtScheduleFinishedSICItemHumidity]		
	};
	
	this.scheduleFinishedSICItemForm = new Ext.form.FormPanel({
		id:'scheduleFinishedSICProduct-window-form',
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
	
	eus.window.ScheduleFinishedSICProduct.superclass.constructor.call(this, {
		id:'scheduleFinishedSICProduct-window',
		title:'新增入库单',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.scheduleFinishedSICItemForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'scheduleFinishedSICSaved':true});
};

var config = {
	upsert:function(){
		if (!this.scheduleFinishedSICItemForm.getForm().isValid()) return;
		
		if (Ext.isEmpty(Ext.getCmp('txtScheduleFinishedSICItemJobCmdNo').getValue().trim())){
			clsys.message.info('请输入工作令号');
			return;			
		}
		
		var scheduleAmount = parseInt(Ext.getCmp('txtScheduleFinishedSICItemScheduleAmount').getValue());
		var scheduleFinishedAmount =parseInt(Ext.getCmp('txtScheduleFinishedSICItemScheduleFinishedAmount').getValue());	
		var inputAmount = parseInt(Ext.getCmp('txtScheduleFinishedSICItemAmount').getValue());
		var restAmount = scheduleAmount - scheduleFinishedAmount;
				
		var aSicItemNo=[],aProductID=[],aAmount=[],aJobCmdNo=[],aSchedule=[],aStorageLocation=[],aProductionDate=[];
		aSicItemNo.push(1);
		aProductID.push(this.productID);
		aJobCmdNo.push(Ext.getCmp('txtScheduleFinishedSICItemJobCmdNo').getValue());
		aAmount.push(inputAmount);
		aSchedule.push(this.scheduleID);
		aStorageLocation.push('');
		aProductionDate.push(Ext.getCmp('cbScheduleFinishedSICItemProductionDate').getValue());

		var url = 'byScheduleStorageIncoming.action';
		var params = {
			id:this.storageIncomingID,
			itemNos:aSicItemNo,
			productIDs:aProductID,
			amounts:aAmount,
			jobCmdNos:aJobCmdNo,
			storageLocationIDs:aStorageLocation,
			scheduleIDs:aSchedule,
			ProductionDates:aProductionDate
		};
		
		this.scheduleFinishedSICItemForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('scheduleFinishedSICSaved',{});
				this.destroy();
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	open:function(scheduleID,scheduleNo,scheduleAmount,scheduleFinishedAmount,productID,productTypeID){
		this.scheduleID = scheduleID;
		this.productID = productID;
		this.productTypeID = productTypeID;
		this.scheduleNo = scheduleNo;
		this.scheduleAmount = scheduleAmount;
		this.scheduleFinishedAmount = scheduleFinishedAmount;
		
		clsys.form.Util.updateComboWithGet('cbScheduleFinishedSICItem_ProductCombination',this.productID);
		clsys.form.Util.updateComboWithGet('cbScheduleFinishedSICItem_ProductType',this.productTypeID);
		
		this.scheduleFinishedSICItem_ProductCombination.on('load',function(store,records,opts){
			Ext.getCmp('txtScheduleFinishedSICItemVoltage').setValue(records[0].get('voltage'));
			Ext.getCmp('txtScheduleFinishedSICItemCapacity').setValue(records[0].get('capacity'));
			Ext.getCmp('txtScheduleFinishedSICItemHumidity').setValue(records[0].get('humidity'));
			Ext.getCmp('txtScheduleFinishedSICItemProductCode').setValue(records[0].get('productCode'));
			Ext.getCmp('txtScheduleFinishedSICItemScheduleNo').setValue(scheduleNo);
			Ext.getCmp('txtScheduleFinishedSICItemScheduleAmount').setValue(this.scheduleAmount );
			Ext.getCmp('txtScheduleFinishedSICItemScheduleFinishedAmount').setValue(this.scheduleFinishedAmount);
		},this);		
	}
};

Ext.extend(eus.window.ScheduleFinishedSICProduct,Ext.Window,config);

Ext.reg('eus-scheduleFinishedSIC-product-window',eus.window.ScheduleFinishedSICProduct);