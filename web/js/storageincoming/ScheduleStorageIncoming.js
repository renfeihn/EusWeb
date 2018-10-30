Ext.ns('eus.window.ScheduleSICProduct');

eus.window.ScheduleSICProduct = function() {

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
	this.scheduleSICItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getProductType.action',
		baseParams:{status:'Using'},
		root:'ProductType',
		fields:['id','name']
	});
	
	/*产品名称及型号 Store*/
	this.scheduleSICItem_ProductCombination = new Ext.data.JsonStore({
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
	var cbScheduleSICItem_ProductType = {
		xtype:'combo',
		store:this.scheduleSICItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbScheduleSICItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'请选择产品类别',
		allowBlank:false,
		width:317
	};

	/*产品名称及型号*/	
	var cbScheduleSICItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleSICItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品名称及型号',
		fieldLabel:'产品名称及型号',
		selectOnFocus:true,
		id:'cbScheduleSICItem_ProductCombination',
		width:317,
		readOnly:true,
		allowBlank:false,
		blankText:'请选择产品名称及型号',
		valueField:'id'
	};

	/*产品数量*/
	var txtScheduleSICItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleSICItemAmount',
		fieldLabel:'入库数量',
		width:300,
		allowBlank:false,
		blankText:'请输入入库数量',
		allowDecimals: false, // 允许小数点 
		allowNegative: false, // 允许负数 
		minValue:1,
		name:'txtScheduleSICItemAmount'
	};
	
	/*工作令号*/
	var txtScheduleSICItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleSICItemJobCmdNo',
		fieldLabel:'工作令号',
		width:300,
		allowBlank:false,
		blankText:'请输入工作令号',
		name:'txtScheduleSICItemJobCmdNo'
	};
	
	/*工作电压*/
	var txtScheduleSICItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleSICItemVoltage',
		fieldLabel:'工作电压(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemVoltage'
	};	

	/*容量*/
	var txtScheduleSICItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleSICItemCapacity',
		fieldLabel:'容量(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemCapacity'
	};

	/*组别-湿度系数*/
	var txtScheduleSICItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleSICItemHumidity',
		fieldLabel:'组别',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemHumidity'
	};	

	/*等级-产品代号*/
	var txtScheduleSICItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleSICItemProductCode',
		fieldLabel:'等级',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemProductCode'
	};
	
	/*计划号*/
	var txtScheduleSICItemScheduleNo = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleNo',
		fieldLabel:'计划编号',
		name:'txtScheduleSICItemScheduleNo',
		width:300,
		readOnly:true
	};

	var txtScheduleSICItemScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleAmount',
		fieldLabel:'计划数量',
		name:'txtScheduleSICItemScheduleAmount',
		width:300,
		readOnly:true
	};
	
	var txtScheduleSICItemScheduleFinishedAmount = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleFinishedAmount',
		fieldLabel:'完成数量',
		name:'txtScheduleSICItemScheduleFinishedAmount',
		width:300,
		readOnly:true
	};
	
	/*生产日期*/
	var cbScheduleSICItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleSICItemProductionDate',
		fieldLabel:'生产日期',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'请选择生产日期',		
		name:'cbScheduleSICItemProductionDate'
	}
			
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'scheduleSICProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'关闭',
		id:'scheduleSICProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtScheduleSICItemScheduleNo,
		       txtScheduleSICItemScheduleAmount,
		       txtScheduleSICItemScheduleFinishedAmount,
		       txtScheduleSICItemAmount,
		       txtScheduleSICItemJobCmdNo,
		       txtScheduleSICItemAmount,    
		       cbScheduleSICItemProductionDate]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[
		       cbScheduleSICItem_ProductType,
		       cbScheduleSICItem_ProductCombination,
		       txtScheduleSICItemCapacity,
		       txtScheduleSICItemProductCode,
		       txtScheduleSICItemVoltage,
		       txtScheduleSICItemHumidity]		
	};
	
	this.scheduleSICItemForm = new Ext.form.FormPanel({
		id:'scheduleSICProduct-window-form',
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
	
	eus.window.ScheduleSICProduct.superclass.constructor.call(this, {
		id:'scheduleSICProduct-window',
		title:'新增入库单',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.scheduleSICItemForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'scheduleSICSaved':true});
};

var config = {
	upsert:function(){
		if (!this.scheduleSICItemForm.getForm().isValid()) return;
		
		if (Ext.isEmpty(Ext.getCmp('txtScheduleSICItemJobCmdNo').getValue().trim())){
			clsys.message.info('请输入工作令号');
			return;			
		}
		
		var scheduleAmount = parseInt(Ext.getCmp('txtScheduleSICItemScheduleAmount').getValue());
		var scheduleFinishedAmount =parseInt(Ext.getCmp('txtScheduleSICItemScheduleFinishedAmount').getValue());	
		var inputAmount = parseInt(Ext.getCmp('txtScheduleSICItemAmount').getValue());
		var restAmount = scheduleAmount - scheduleFinishedAmount;
		
		/*允许超入库
		if (restAmount < inputAmount){
			var strMessage = '输入的入库数量错误,  [入库数量]:'+ inputAmount + '  [最大可入库数量]:' + restAmount; 
			clsys.message.info(strMessage);
			return;
		}
		*/
		var aSicItemNo=[],aProductID=[],aAmount=[],aJobCmdNo=[],aSchedule=[],aStorageLocation=[],aProductionDate=[];
		aSicItemNo.push(1);
		aProductID.push(this.productID);
		aJobCmdNo.push(Ext.getCmp('txtScheduleSICItemJobCmdNo').getValue());
		aAmount.push(inputAmount);
		aSchedule.push(this.scheduleID);
		aStorageLocation.push('');
		aProductionDate.push(Ext.getCmp('cbScheduleSICItemProductionDate').getValue());

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
		
		this.scheduleSICItemForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('scheduleSICSaved',{});
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
		
		clsys.form.Util.updateComboWithGet('cbScheduleSICItem_ProductCombination',this.productID);
		clsys.form.Util.updateComboWithGet('cbScheduleSICItem_ProductType',this.productTypeID);
		
		this.scheduleSICItem_ProductCombination.on('load',function(store,records,opts){
			Ext.getCmp('txtScheduleSICItemVoltage').setValue(records[0].get('voltage'));
			Ext.getCmp('txtScheduleSICItemCapacity').setValue(records[0].get('capacity'));
			Ext.getCmp('txtScheduleSICItemHumidity').setValue(records[0].get('humidity'));
			Ext.getCmp('txtScheduleSICItemProductCode').setValue(records[0].get('productCode'));
			Ext.getCmp('txtScheduleSICItemScheduleNo').setValue(scheduleNo);
			Ext.getCmp('txtScheduleSICItemScheduleAmount').setValue(this.scheduleAmount );
			Ext.getCmp('txtScheduleSICItemScheduleFinishedAmount').setValue(this.scheduleFinishedAmount);
		},this);		
	}
};

Ext.extend(eus.window.ScheduleSICProduct,Ext.Window,config);

Ext.reg('eus-scheduleSIC-product-window',eus.window.ScheduleSICProduct);