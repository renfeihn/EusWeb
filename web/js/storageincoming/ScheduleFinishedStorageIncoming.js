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
	
	/*��Ʒ��� Store*/
	this.scheduleFinishedSICItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getProductType.action',
		baseParams:{status:'Using'},
		root:'ProductType',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
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

	/*��Ʒ���*/
	var cbScheduleFinishedSICItem_ProductType = {
		xtype:'combo',
		store:this.scheduleFinishedSICItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbScheduleFinishedSICItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'��ѡ���Ʒ���',
		allowBlank:false,
		width:317
	};

	/*��Ʒ���Ƽ��ͺ�*/	
	var cbScheduleFinishedSICItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleFinishedSICItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		selectOnFocus:true,
		id:'cbScheduleFinishedSICItem_ProductCombination',
		width:317,
		readOnly:true,
		allowBlank:false,
		blankText:'��ѡ���Ʒ���Ƽ��ͺ�',
		valueField:'id'
	};

	/*��Ʒ����*/
	var txtScheduleFinishedSICItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleFinishedSICItemAmount',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�������������',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,
		name:'txtScheduleFinishedSICItemAmount'
	};
	
	/*�������*/
	var txtScheduleFinishedSICItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemJobCmdNo',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�����빤�����',
		name:'txtScheduleFinishedSICItemJobCmdNo'
	};
	
	/*������ѹ*/
	var txtScheduleFinishedSICItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemVoltage',
		fieldLabel:'������ѹ(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemVoltage'
	};	

	/*����*/
	var txtScheduleFinishedSICItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemCapacity',
		fieldLabel:'����(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemCapacity'
	};

	/*���-ʪ��ϵ��*/
	var txtScheduleFinishedSICItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemHumidity',
		fieldLabel:'���',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemHumidity'
	};	

	/*�ȼ�-��Ʒ����*/
	var txtScheduleFinishedSICItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemProductCode',
		fieldLabel:'�ȼ�',
		readOnly:true,
		width:300,
		name:'txtScheduleFinishedSICItemProductCode'
	};
	
	/*�ƻ���*/
	var txtScheduleFinishedSICItemScheduleNo = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleNo',
		fieldLabel:'�ƻ����',
		name:'txtScheduleFinishedSICItemScheduleNo',
		width:300,
		readOnly:true
	};

	var txtScheduleFinishedSICItemScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleAmount',
		fieldLabel:'�ƻ�����',
		name:'txtScheduleFinishedSICItemScheduleAmount',
		width:300,
		readOnly:true
	};
	
	var txtScheduleFinishedSICItemScheduleFinishedAmount = {
		xtype:'textfield',
		id:'txtScheduleFinishedSICItemScheduleFinishedAmount',
		fieldLabel:'�������',
		name:'txtScheduleFinishedSICItemScheduleFinishedAmount',
		width:300,
		readOnly:true
	};
	
	/*��������*/
	var cbScheduleFinishedSICItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleFinishedSICItemProductionDate',
		fieldLabel:'��������',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'��ѡ����������',		
		name:'cbScheduleFinishedSICItemProductionDate'
	}
			
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'scheduleFinishedSICProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'�ر�',
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
		title:'������ⵥ',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.scheduleFinishedSICItemForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'scheduleFinishedSICSaved':true});
};

var config = {
	upsert:function(){
		if (!this.scheduleFinishedSICItemForm.getForm().isValid()) return;
		
		if (Ext.isEmpty(Ext.getCmp('txtScheduleFinishedSICItemJobCmdNo').getValue().trim())){
			clsys.message.info('�����빤�����');
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
			waitMsg: '�����ύ���ݣ����Ժ�...',
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