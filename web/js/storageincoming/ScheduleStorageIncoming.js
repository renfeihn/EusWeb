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
	
	/*��Ʒ��� Store*/
	this.scheduleSICItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getProductType.action',
		baseParams:{status:'Using'},
		root:'ProductType',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
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

	/*��Ʒ���*/
	var cbScheduleSICItem_ProductType = {
		xtype:'combo',
		store:this.scheduleSICItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbScheduleSICItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'��ѡ���Ʒ���',
		allowBlank:false,
		width:317
	};

	/*��Ʒ���Ƽ��ͺ�*/	
	var cbScheduleSICItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleSICItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		selectOnFocus:true,
		id:'cbScheduleSICItem_ProductCombination',
		width:317,
		readOnly:true,
		allowBlank:false,
		blankText:'��ѡ���Ʒ���Ƽ��ͺ�',
		valueField:'id'
	};

	/*��Ʒ����*/
	var txtScheduleSICItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleSICItemAmount',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�������������',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,
		name:'txtScheduleSICItemAmount'
	};
	
	/*�������*/
	var txtScheduleSICItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleSICItemJobCmdNo',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�����빤�����',
		name:'txtScheduleSICItemJobCmdNo'
	};
	
	/*������ѹ*/
	var txtScheduleSICItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleSICItemVoltage',
		fieldLabel:'������ѹ(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemVoltage'
	};	

	/*����*/
	var txtScheduleSICItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleSICItemCapacity',
		fieldLabel:'����(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemCapacity'
	};

	/*���-ʪ��ϵ��*/
	var txtScheduleSICItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleSICItemHumidity',
		fieldLabel:'���',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemHumidity'
	};	

	/*�ȼ�-��Ʒ����*/
	var txtScheduleSICItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleSICItemProductCode',
		fieldLabel:'�ȼ�',
		readOnly:true,
		width:300,
		name:'txtScheduleSICItemProductCode'
	};
	
	/*�ƻ���*/
	var txtScheduleSICItemScheduleNo = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleNo',
		fieldLabel:'�ƻ����',
		name:'txtScheduleSICItemScheduleNo',
		width:300,
		readOnly:true
	};

	var txtScheduleSICItemScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleAmount',
		fieldLabel:'�ƻ�����',
		name:'txtScheduleSICItemScheduleAmount',
		width:300,
		readOnly:true
	};
	
	var txtScheduleSICItemScheduleFinishedAmount = {
		xtype:'textfield',
		id:'txtScheduleSICItemScheduleFinishedAmount',
		fieldLabel:'�������',
		name:'txtScheduleSICItemScheduleFinishedAmount',
		width:300,
		readOnly:true
	};
	
	/*��������*/
	var cbScheduleSICItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleSICItemProductionDate',
		fieldLabel:'��������',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'��ѡ����������',		
		name:'cbScheduleSICItemProductionDate'
	}
			
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'scheduleSICProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'�ر�',
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
		title:'������ⵥ',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.scheduleSICItemForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'scheduleSICSaved':true});
};

var config = {
	upsert:function(){
		if (!this.scheduleSICItemForm.getForm().isValid()) return;
		
		if (Ext.isEmpty(Ext.getCmp('txtScheduleSICItemJobCmdNo').getValue().trim())){
			clsys.message.info('�����빤�����');
			return;			
		}
		
		var scheduleAmount = parseInt(Ext.getCmp('txtScheduleSICItemScheduleAmount').getValue());
		var scheduleFinishedAmount =parseInt(Ext.getCmp('txtScheduleSICItemScheduleFinishedAmount').getValue());	
		var inputAmount = parseInt(Ext.getCmp('txtScheduleSICItemAmount').getValue());
		var restAmount = scheduleAmount - scheduleFinishedAmount;
		
		/*�������
		if (restAmount < inputAmount){
			var strMessage = '����������������,  [�������]:'+ inputAmount + '  [�����������]:' + restAmount; 
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