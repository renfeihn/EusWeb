Ext.ns('eus.window.ScheduleStorageIncomingProduct');

eus.window.ScheduleStorageIncomingProduct = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	this.sicItemNo = '';
	this.originalResult = {};
	
	/*��Ʒ��� Store*/
	this.scheduleStorageIncomingItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
	this.scheduleStorageIncomingItem_ProductCombination = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCapacitor.action',
		root:'Capacitor',
		fields:['id','productName','price','voltage','capacity','productCombination','productionDate',
		        {name:'productCode',mapping:'productCode.code'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'}, 
		        {name:'unit',mapping:'unit.name'}]
	});	
	
	/*��λ��Ϣ*/
	this.scheduleStorageIncomingItem_storageLocationStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findStorageLocation.action',
		baseParams:{status:'Using'},
		root:'StorageLocationList',
		fields:['id','name']
	});
	
	var loadHandler = function(combo,record,index){
		this.scheduleStorageIncomingItem_ProductCombination.removeAll();
		Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination').setValue(null);
		
		var strProductType = record.get('id');
		var isEmptyProductType = Ext.isEmpty(strProductType);
		
		if (!isEmptyProductType){
			this.scheduleStorageIncomingItem_ProductCombination.baseParams = {status:'Using',productType:strProductType};
			this.scheduleStorageIncomingItem_ProductCombination.reload();
		}
		this.clearDataview();
	};
	
	var blurHandle = function(field){
		var isEmptyProductType = Ext.isEmpty(Ext.getCmp('cbScheduleStorageIncomingItem_ProductType').getValue());
		if (isEmptyProductType) {
			this.scheduleStorageIncomingItem_ProductCombination.removeAll();
			Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(null);
		}
	};
	
	var loadHandler_ProductCombination = function(combo,record,index){
		Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(record.get('voltage'));
		Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(record.get('capacity'));
		Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(record.get('humidity'));
		Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(record.get('productCode'));
		this.clearDataview();
	};
	
	var blurHandle_ProductCombination = function(field){
		var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination').getValue());
		if (isEmptyProductCombination) {
			Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(null);
			Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(null);
		}
	};
	
	/*��Ʒ���*/
	var cbScheduleStorageIncomingItem_ProductType = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'��ѡ���Ʒ���',
		allowBlank:false,
		width:317
	};

	/*��Ʒ���Ƽ��ͺ�*/	
	var cbScheduleStorageIncomingItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_ProductCombination',
		width:317,
		readOnly:false,
		allowBlank:false,
		blankText:'��ѡ���Ʒ���Ƽ��ͺ�',
		loadingText:'��ѯ��...',
		valueField:'id',
		listeners:{
		   'specialkey':function(field,event){
		   		if (event.getKey() == event.ENTER){
		   			var inputValue = field.getRawValue().trim();
		   			if (Ext.isEmpty(inputValue)) return;
		   			
		   			/*ͨ��ProductCombination(PC)����Product��ID*/
		   			var url = 'getProductIDCapacitor.action';
		   			var params = {productCombination:inputValue};
		   			/*�ɹ�ʱ�Ĵ�����*/
		   			var successFunc = function(response,opts){
		   				var result = Ext.decode(response.responseText);
		   				if (result.success) {
		   					var temp1 = result.msg.productID;
		   					var temp2 = result.msg.productType;
		   					clsys.form.Util.updateCombo('cbScheduleStorageIncomingItem_ProductType',temp2);
		   					var combo = Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination');
		   					combo.getStore().load({
		   							params:{id:temp1},
		   							callback : function(records, opt, success) {
		   								if (success) {
		   									combo.setValue(temp1);
		   									Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(records[0].get('voltage'));
		   									Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(records[0].get('capacity'));
		   									Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(records[0].get('humidity'));
		   									Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(records[0].get('productCode'));
		   								}
		   							}
		   					});
		   				}
		   				else {
		   					Ext.getCmp('cbScheduleStorageIncomingItem_ProductType').clearValue();
		   					Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination').clearValue();
		   					Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(null);
		   					Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(null);
		   					Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(null);
		   					Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(null);
		   					var ScheduleStore = Ext.getCmp('txtScheduleStorageIncomingItemMemo').getStore();
		   					var data = {Schedule:[{id:'', scheduleNo:'ѡ��ƻ�',finishedAmount:'',amount:''}]};
		   					ScheduleStore.loadData(data);
		   				}
		   			};
		   			/*ʧ��ʱ�Ĵ�����*/
		   			var failureFunc = function(response,opts){
		   				clsys.message.systemerror(response.responseText.msg);
		   			};
		   			/*ʹ��AJAX�������*/
		   			Ext.Ajax.request({
		   				url:url,
		   				success:successFunc,
		   				failure:failureFunc,
		   				params:params,
		   				scope:this
		   			});	
		   			
		   		}
		  },
		  scope:this}		
	};

	/*��λ*/
	var cbScheduleStorageIncomingItem_storageLocation = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_storageLocationStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���λ',
		fieldLabel:'��λ',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_storageLocation',
		width:300,
		allowBlank:false,
		blankText:'��ѡ���λ',
		valueField:'id'
	};	
	/*��Ʒ����*/
	var txtScheduleStorageIncomingItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleStorageIncomingItemAmount',
		fieldLabel:'����',
		width:300,
		allowBlank:false,
		blankText:'����������',
		name:'txtScheduleStorageIncomingItemAmount'
	};
	
	/*�������*/
	var txtScheduleStorageIncomingItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemJobCmdNo',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�����빤�����',
		name:'txtScheduleStorageIncomingItemJobCmdNo'
	};
	
	/*������ѹ*/
	var txtScheduleStorageIncomingItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemVoltage',
		fieldLabel:'������ѹ(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemVoltage'
	};	
	
	/*����*/
	var txtScheduleStorageIncomingItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemCapacity',
		fieldLabel:'����(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemCapacity'
	};

	/*���-ʪ��ϵ��*/
	var txtScheduleStorageIncomingItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemHumidity',
		fieldLabel:'���',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemHumidity'
	};	

	/*�ȼ�-��Ʒ����*/
	var txtScheduleStorageIncomingItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemProductCode',
		fieldLabel:'�ȼ�',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemProductCode'
	};
	
	/*��ע-�ƻ���*/
	var txtScheduleStorageIncomingItemMemo = {
		xtype:'clsys-schedule-dataview',
		id:'txtScheduleStorageIncomingItemMemo',
		fieldLabel:'��ע',
		name:'txtScheduleStorageIncomingItemMemo',
		width:300,
		readOnly: false
	};
	
	/*��������*/
	var cbScheduleStorageIncomingItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleStorageIncomingItemProductionDate',
		fieldLabel:'��������',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'��ѡ����������',		
		name:'cbScheduleStorageIncomingItemProductionDate'
	}
			
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'scheduleStorageIncomingProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'scheduleStorageIncomingProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'scheduleStorageIncomingProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbScheduleStorageIncomingItem_ProductType,
		       cbScheduleStorageIncomingItem_ProductCombination,
		       txtScheduleStorageIncomingItemJobCmdNo,
		       txtScheduleStorageIncomingItemAmount,
		       cbScheduleStorageIncomingItem_storageLocation,
		       txtScheduleStorageIncomingItemMemo]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtScheduleStorageIncomingItemCapacity,
		       txtScheduleStorageIncomingItemProductCode,
		       txtScheduleStorageIncomingItemVoltage,
		       txtScheduleStorageIncomingItemHumidity,
		       cbScheduleStorageIncomingItemProductionDate]		
	};
	
	this.scheduleStorageIncomingItemForm = new Ext.form.FormPanel({
		id:'scheduleStorageIncomingProduct-window-form',
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
		}],
		tbar:[
		      	{
		    	  text:'��Ʒ�ۺϲ�ѯ',
		    	  iconCls: 'icon-examine',
		    	  handler:function(){
					var wnd = Ext.getCmp('capacitor-selector-window');
					if (!wnd) {
						var wnd = new eus.window.CapacitorSelector();
						wnd.on('capacitorSelected', function(attr){
							var combo = Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination');
							combo.getStore().load({
									params:{id:attr.id},
									callback : function(records, opt, success) {
										if (success) {
											combo.setValue(attr.id);
											Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(records[0].get('voltage'));
											Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(records[0].get('capacity'));
											Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(records[0].get('humidity'));
											Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(records[0].get('productCode'));
											clsys.form.Util.updateCombo('cbScheduleStorageIncomingItem_ProductType',attr.productTypeID);
										}
									}
								});
							});
					}
					wnd.doAutoReload();
					wnd.show();
		      	  },
		    	  scope:this	    	  
		      	}
		      ]
	});
	
	eus.window.ScheduleStorageIncomingProduct.superclass.constructor.call(this, {
		id:'scheduleStorageIncomingProduct-window',
		title:'������ⵥ��Ŀ',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.scheduleStorageIncomingItemForm]
	});
};

var config = {
	/*������ϸ*/
	upsert:function(){
	    if (!this.scheduleStorageIncomingItemForm.getForm().isValid()) return;
		var ScheduleStoreRecord = Ext.getCmp('txtScheduleStorageIncomingItemMemo').getStore().getAt(0);
		var scheduleID = ScheduleStoreRecord.get('id');
		var scheduleNo = ScheduleStoreRecord.get('scheduleNo');
		var amount = parseInt(ScheduleStoreRecord.get('amount'));
		var finishedAmount = parseInt(ScheduleStoreRecord.get('finishedAmount'));	
		var inputAmount = 0;
		var restAmount = amount - finishedAmount;
		
		if (Ext.isEmpty(Ext.getCmp('txtScheduleStorageIncomingItemJobCmdNo').getValue())){
			clsys.message.info('�����빤�����');
			return;			
		}	
		
		if (Ext.isEmpty(ScheduleStoreRecord.get('amount'))){
			clsys.message.info('��ѡ��ƻ�');
			return;			
		}

		if (!Ext.isEmpty(Ext.getCmp('txtScheduleStorageIncomingItemAmount').getValue())) {
			inputAmount = parseInt(Ext.getCmp('txtScheduleStorageIncomingItemAmount').getValue());
		} else {
			clsys.message.info('����������');
			return;
		}
		
		if (restAmount < inputAmount){
			var strMessage = '�������������  [��������]:'+ inputAmount + '  [���������]:' + restAmount; 
			clsys.message.info(strMessage);
			return;
		}
		
		if (Ext.isEmpty(Ext.getCmp('cbScheduleStorageIncomingItem_storageLocation').getValue())){
			clsys.message.info('��ѡ���λ');
			return;			
		}	
		
		var combo = clsys.form.Util.getComboValues('cbScheduleStorageIncomingItem_ProductCombination');
		var combo2 = clsys.form.Util.getComboValues('cbScheduleStorageIncomingItem_storageLocation');
		var temp = new Date(Ext.getCmp('cbScheduleStorageIncomingItemProductionDate').getValue());
		var temp2 = temp.format('Y-m-d');

		var attributes = {
			sicItemNo:this.sicItemNo,
			productType:clsys.form.Util.getComboValues('cbScheduleStorageIncomingItem_ProductType'),
			productCombination:{'id':combo.id,'productName':combo.name},
			voltage:Ext.getCmp('txtScheduleStorageIncomingItemVoltage').getValue(),
			amount:Ext.getCmp('txtScheduleStorageIncomingItemAmount').getValue(),
			capacity:Ext.getCmp('txtScheduleStorageIncomingItemCapacity').getValue(),
			productCode:Ext.getCmp('txtScheduleStorageIncomingItemProductCode').getValue(),
			humidity:Ext.getCmp('txtScheduleStorageIncomingItemHumidity').getValue(),
			jobCmdNo:Ext.getCmp('txtScheduleStorageIncomingItemJobCmdNo').getValue(),
			schedule:scheduleID,
			storageLocation:{'id':combo2.id,'name':combo2.name},
			memo:scheduleNo,
			productionDate:temp2
		};
		this.fireEvent(this.mode,attributes);
		this.destroy();
	},
	/*�޸���ϸ*/
	open:function(id){
		alert (id);
//		this.mode = 'update';
//		this.originalResult = OldResult;
//		this.sicItemNo = this.originalResult.sicItemNo;
//		Ext.getCmp('txtScheduleStorageIncomingItemAmount').setValue(this.originalResult.amount);
//		Ext.getCmp('txtScheduleStorageIncomingItemVoltage').setValue(this.originalResult.voltage);
//		Ext.getCmp('txtScheduleStorageIncomingItemCapacity').setValue(this.originalResult.capacity);
//		Ext.getCmp('txtScheduleStorageIncomingItemProductCode').setValue(this.originalResult.productCode);
//		Ext.getCmp('txtScheduleStorageIncomingItemHumidity').setValue(this.originalResult.humidity);
//		Ext.getCmp('txtScheduleStorageIncomingItemJobCmdNo').setValue(this.originalResult.jobCmdNo);
//		Ext.getCmp('cbScheduleStorageIncomingItemProductionDate').setValue(this.originalResult.productionDate);
//		Ext.getCmp('txtScheduleStorageIncomingItemMemo').open(this.originalResult.schedule);
//		clsys.form.Util.updateCombo('cbScheduleStorageIncomingItem_storageLocation',this.originalResult.storageLocation);
//		clsys.form.Util.updateCombo('cbScheduleStorageIncomingItem_ProductType',this.originalResult.productType);
//		var combo = Ext.getCmp('cbScheduleStorageIncomingItem_ProductCombination');
//		
//		var productID = this.originalResult.productCombination;	
//		combo.getStore().load({
//				params:{id:productID},
//				callback : function(records, opt, success) {
//					if (success) {
//						combo.setValue(productID);
//					}
//				}
//			});
//		
	},
	reset:function(){
		var resetFunc = function(btn){
			
			this.clearDataview();
			
			if (btn == 'yes' && this.mode == 'add'){
				this.scheduleStorageIncomingItemForm.getForm().reset();
			}
			if (this.mode == 'update'){
				this.open(this.originalResult);
			}

		};
		Ext.MessageBox.show({
			titile:'ȷ������', 
			buttons:Ext.MessageBox.YESNO,
			msg:'�Ƿ�������ⵥ��Ŀ��Ϣ', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	doAutoReload:function(){
		this.scheduleStorageIncomingItem_ProductType.baseParams = {status:'Using'};
		this.scheduleStorageIncomingItem_ProductType.reload();
		this.scheduleStorageIncomingItem_storageLocationStore.baseParams = {status:'Using'};
		this.scheduleStorageIncomingItem_storageLocationStore.reload();
	},
	clearDataview:function(){
		var ScheduleStore = Ext.getCmp('txtScheduleStorageIncomingItemMemo').getStore();
		var data = {Schedule:[{id:'', scheduleNo:'ѡ��ƻ�',finishedAmount:'',amount:''}]};
		ScheduleStore.loadData(data);
	}
};

Ext.extend(eus.window.ScheduleStorageIncomingProduct,Ext.Window,config);

Ext.reg('eus-scheduleStorageIncoming-product-window',eus.window.ScheduleStorageIncomingProduct);