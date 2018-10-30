Ext.ns('eus.window.StorageIncomingProduct');

eus.window.StorageIncomingProduct = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	this.sicItemNo = '';
	this.originalResult = {};
	
	/*��Ʒ��� Store*/
	this.storageIncomingItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
	this.storageIncomingItem_ProductCombination = new Ext.data.JsonStore({
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
	this.storageIncomingItem_storageLocationStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findStorageLocation.action',
		baseParams:{status:'Using'},
		root:'StorageLocationList',
		fields:['id','name']
	});
	
	var loadHandler = function(combo,record,index){
		this.storageIncomingItem_ProductCombination.removeAll();
		Ext.getCmp('cbStorageIncomingItem_ProductCombination').setValue(null);
		
		var strProductType = record.get('id');
		var isEmptyProductType = Ext.isEmpty(strProductType);
		
		if (!isEmptyProductType){
			this.storageIncomingItem_ProductCombination.baseParams = {status:'Using',productType:strProductType};
			this.storageIncomingItem_ProductCombination.reload();
		}
		this.clearDataview();
	};
	
	var blurHandle = function(field){
		var isEmptyProductType = Ext.isEmpty(Ext.getCmp('cbStorageIncomingItem_ProductType').getValue());
		if (isEmptyProductType) {
			this.storageIncomingItem_ProductCombination.removeAll();
			Ext.getCmp('cbStorageIncomingItem_ProductCombination').setValue(null);
			Ext.getCmp('txtStorageIncomingItemVoltage').setValue(null);
			Ext.getCmp('txtStorageIncomingItemCapacity').setValue(null);
			Ext.getCmp('txtStorageIncomingItemHumidity').setValue(null);
			Ext.getCmp('txtStorageIncomingItemProductCode').setValue(null);
		}
	};
	
	var loadHandler_ProductCombination = function(combo,record,index){
		Ext.getCmp('txtStorageIncomingItemVoltage').setValue(record.get('voltage'));
		Ext.getCmp('txtStorageIncomingItemCapacity').setValue(record.get('capacity'));
		Ext.getCmp('txtStorageIncomingItemHumidity').setValue(record.get('humidity'));
		Ext.getCmp('txtStorageIncomingItemProductCode').setValue(record.get('productCode'));
		this.clearDataview();
	};
	
	var blurHandle_ProductCombination = function(field){
		var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbStorageIncomingItem_ProductCombination').getValue());
		if (isEmptyProductCombination) {
			Ext.getCmp('txtStorageIncomingItemVoltage').setValue(null);
			Ext.getCmp('txtStorageIncomingItemCapacity').setValue(null);
			Ext.getCmp('txtStorageIncomingItemHumidity').setValue(null);
			Ext.getCmp('txtStorageIncomingItemProductCode').setValue(null);
		}
	};
	
	/*��Ʒ���*/
	var cbStorageIncomingItem_ProductType = {
		xtype:'combo',
		store:this.storageIncomingItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbStorageIncomingItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'��ѡ���Ʒ���',
		allowBlank:false,
		width:317
	};

	/*��Ʒ���Ƽ��ͺ�*/	
	var cbStorageIncomingItem_ProductCombination = {
		xtype:'combo',
		store:this.storageIncomingItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		selectOnFocus:true,
		id:'cbStorageIncomingItem_ProductCombination',
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
		   					clsys.form.Util.updateCombo('cbStorageIncomingItem_ProductType',temp2);
		   					var combo = Ext.getCmp('cbStorageIncomingItem_ProductCombination');
		   					combo.getStore().load({
		   							params:{id:temp1},
		   							callback : function(records, opt, success) {
		   								if (success) {
		   									combo.setValue(temp1);
		   									Ext.getCmp('txtStorageIncomingItemVoltage').setValue(records[0].get('voltage'));
		   									Ext.getCmp('txtStorageIncomingItemCapacity').setValue(records[0].get('capacity'));
		   									Ext.getCmp('txtStorageIncomingItemHumidity').setValue(records[0].get('humidity'));
		   									Ext.getCmp('txtStorageIncomingItemProductCode').setValue(records[0].get('productCode'));
		   								}
		   							}
		   					});
		   				}
		   				else {
		   					Ext.getCmp('cbStorageIncomingItem_ProductType').clearValue();
		   					Ext.getCmp('cbStorageIncomingItem_ProductCombination').clearValue();
		   					Ext.getCmp('txtStorageIncomingItemVoltage').setValue(null);
		   					Ext.getCmp('txtStorageIncomingItemCapacity').setValue(null);
		   					Ext.getCmp('txtStorageIncomingItemHumidity').setValue(null);
		   					Ext.getCmp('txtStorageIncomingItemProductCode').setValue(null);
		   					var ScheduleStore = Ext.getCmp('txtStorageIncomingItemMemo').getStore();
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
	var cbStorageIncomingItem_storageLocation = {
		xtype:'combo',
		store:this.storageIncomingItem_storageLocationStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���λ',
		fieldLabel:'��λ',
		selectOnFocus:true,
		id:'cbStorageIncomingItem_storageLocation',
		width:300,
		blankText:'��ѡ���λ',
		valueField:'id'
	};	
	/*��Ʒ����*/
	var txtStorageIncomingItemAmount = {
		xtype:'numberfield',
		id:'txtStorageIncomingItemAmount',
		fieldLabel:'����',
		width:300,
		allowBlank:false,
		blankText:'����������',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,
		name:'txtStorageIncomingItemAmount'
	};
	
	/*�������*/
	var txtStorageIncomingItemJobCmdNo = {
		xtype:'textfield',
		id:'txtStorageIncomingItemJobCmdNo',
		fieldLabel:'�������',
		width:300,
		allowBlank:false,
		blankText:'�����빤�����',
		name:'txtStorageIncomingItemJobCmdNo'
	};
	
	/*������ѹ*/
	var txtStorageIncomingItemVoltage = {
		xtype:'textfield',
		id:'txtStorageIncomingItemVoltage',
		fieldLabel:'������ѹ(V)',
		readOnly:true,
		width:300,
		name:'txtStorageIncomingItemVoltage'
	};	
	
	/*����*/
	var txtStorageIncomingItemCapacity = {
		xtype:'textfield',
		id:'txtStorageIncomingItemCapacity',
		fieldLabel:'����(PF)',
		readOnly:true,
		width:300,
		name:'txtStorageIncomingItemCapacity'
	};

	/*���-ʪ��ϵ��*/
	var txtStorageIncomingItemHumidity = {
		xtype:'textfield',
		id:'txtStorageIncomingItemHumidity',
		fieldLabel:'���',
		readOnly:true,
		width:300,
		name:'txtStorageIncomingItemHumidity'
	};	

	/*�ȼ�-��Ʒ����*/
	var txtStorageIncomingItemProductCode = {
		xtype:'textfield',
		id:'txtStorageIncomingItemProductCode',
		fieldLabel:'�ȼ�',
		readOnly:true,
		width:300,
		name:'txtStorageIncomingItemProductCode'
	};
	
	/*��ע-�ƻ���*/
	var txtStorageIncomingItemMemo = {
		xtype:'clsys-schedule-dataview',
		id:'txtStorageIncomingItemMemo',
		fieldLabel:'��ע',
		name:'txtStorageIncomingItemMemo',
		width:300,
		readOnly: false
	};
	
	/*��������*/
	var cbStorageIncomingItemProductionDate = {		
		xtype:'datefield',
		id:'cbStorageIncomingItemProductionDate',
		fieldLabel:'��������',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'��ѡ����������',		
		name:'cbStorageIncomingItemProductionDate'
	}
			
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'storageIncomingProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'storageIncomingProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'storageIncomingProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbStorageIncomingItem_ProductType,
		       cbStorageIncomingItem_ProductCombination,
		       txtStorageIncomingItemJobCmdNo,
		       txtStorageIncomingItemAmount,
		       cbStorageIncomingItem_storageLocation,
		       txtStorageIncomingItemMemo]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtStorageIncomingItemCapacity,
		       txtStorageIncomingItemProductCode,
		       txtStorageIncomingItemVoltage,
		       txtStorageIncomingItemHumidity,
		       cbStorageIncomingItemProductionDate]		
	};
	
	this.storageIncomingItemForm = new Ext.form.FormPanel({
		id:'storageIncomingProduct-window-form',
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
							var combo = Ext.getCmp('cbStorageIncomingItem_ProductCombination');
							combo.getStore().load({
									params:{id:attr.id},
									callback : function(records, opt, success) {
										if (success) {
											combo.setValue(attr.id);
											Ext.getCmp('txtStorageIncomingItemVoltage').setValue(records[0].get('voltage'));
											Ext.getCmp('txtStorageIncomingItemCapacity').setValue(records[0].get('capacity'));
											Ext.getCmp('txtStorageIncomingItemHumidity').setValue(records[0].get('humidity'));
											Ext.getCmp('txtStorageIncomingItemProductCode').setValue(records[0].get('productCode'));
											clsys.form.Util.updateCombo('cbStorageIncomingItem_ProductType',attr.productTypeID);
											wnd.close();
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
	
	eus.window.StorageIncomingProduct.superclass.constructor.call(this, {
		id:'storageIncomingProduct-window',
		title:'������ⵥ��Ŀ',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.storageIncomingItemForm]
	});
};

var config = {
	/*������ϸ*/
	upsert:function(){
	    if (!this.storageIncomingItemForm.getForm().isValid()) return;
		var ScheduleStoreRecord = Ext.getCmp('txtStorageIncomingItemMemo').getStore().getAt(0);
		var scheduleID = ScheduleStoreRecord.get('id');
		var scheduleNo = ScheduleStoreRecord.get('scheduleNo');
		var amount = parseInt(ScheduleStoreRecord.get('amount'));
		var finishedAmount = parseInt(ScheduleStoreRecord.get('finishedAmount'));	
		var inputAmount = 0;
		var restAmount = amount - finishedAmount;
		
		if (Ext.isEmpty(ScheduleStoreRecord.get('amount'))){
			clsys.message.info('��ѡ��ƻ�');
			return;			
		}

		if (!Ext.isEmpty(Ext.getCmp('txtStorageIncomingItemAmount').getValue())) {
			inputAmount = parseInt(Ext.getCmp('txtStorageIncomingItemAmount').getValue());
		} else {
			clsys.message.info('����������');
			return;
		}
		
		if (restAmount < inputAmount){
			var strMessage = '�������������  [��������]:'+ inputAmount + '  [���������]:' + restAmount; 
			clsys.message.info(strMessage);
			return;
		}
		
		
		var combo = clsys.form.Util.getComboValues('cbStorageIncomingItem_ProductCombination');
		var combo2 = clsys.form.Util.getComboValues('cbStorageIncomingItem_storageLocation');
		var temp = new Date(Ext.getCmp('cbStorageIncomingItemProductionDate').getValue());
		var temp2 = temp.format('Y-m-d');

		var attributes = {
			sicItemNo:this.sicItemNo,
			productType:clsys.form.Util.getComboValues('cbStorageIncomingItem_ProductType'),
			productCombination:{'id':combo.id,'productName':combo.name},
			voltage:Ext.getCmp('txtStorageIncomingItemVoltage').getValue(),
			amount:Ext.getCmp('txtStorageIncomingItemAmount').getValue(),
			capacity:Ext.getCmp('txtStorageIncomingItemCapacity').getValue(),
			productCode:Ext.getCmp('txtStorageIncomingItemProductCode').getValue(),
			humidity:Ext.getCmp('txtStorageIncomingItemHumidity').getValue(),
			jobCmdNo:Ext.getCmp('txtStorageIncomingItemJobCmdNo').getValue(),
			schedule:scheduleID,
			storageLocation:{'id':combo2.id,'name':combo2.name},
			memo:scheduleNo,
			productionDate:temp2
		};
		this.fireEvent(this.mode,attributes);
		this.destroy();
	},
	/*�޸���ϸ*/
	open:function(OldResult){
		this.mode = 'update';
		this.originalResult = OldResult;
		this.sicItemNo = this.originalResult.sicItemNo;
		Ext.getCmp('txtStorageIncomingItemAmount').setValue(this.originalResult.amount);
		Ext.getCmp('txtStorageIncomingItemVoltage').setValue(this.originalResult.voltage);
		Ext.getCmp('txtStorageIncomingItemCapacity').setValue(this.originalResult.capacity);
		Ext.getCmp('txtStorageIncomingItemProductCode').setValue(this.originalResult.productCode);
		Ext.getCmp('txtStorageIncomingItemHumidity').setValue(this.originalResult.humidity);
		Ext.getCmp('txtStorageIncomingItemJobCmdNo').setValue(this.originalResult.jobCmdNo);
		Ext.getCmp('cbStorageIncomingItemProductionDate').setValue(this.originalResult.productionDate);
		Ext.getCmp('txtStorageIncomingItemMemo').open(this.originalResult.schedule);
		clsys.form.Util.updateCombo('cbStorageIncomingItem_storageLocation',this.originalResult.storageLocation);
		clsys.form.Util.updateCombo('cbStorageIncomingItem_ProductType',this.originalResult.productType);
		var combo = Ext.getCmp('cbStorageIncomingItem_ProductCombination');
		
		var productID = this.originalResult.productCombination;	
		combo.getStore().load({
				params:{id:productID},
				callback : function(records, opt, success) {
					if (success) {
						combo.setValue(productID);
					}
				}
			});
		
	},
	reset:function(){
		var resetFunc = function(btn){
			
			this.clearDataview();
			
			if (btn == 'yes' && this.mode == 'add'){
				this.storageIncomingItemForm.getForm().reset();
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
		this.storageIncomingItem_ProductType.baseParams = {status:'Using'};
		this.storageIncomingItem_ProductType.reload();
		this.storageIncomingItem_storageLocationStore.baseParams = {status:'Using'};
		this.storageIncomingItem_storageLocationStore.reload();
	},
	clearDataview:function(){
		var ScheduleStore = Ext.getCmp('txtStorageIncomingItemMemo').getStore();
		var data = {Schedule:[{id:'', scheduleNo:'ѡ��ƻ�',finishedAmount:'',amount:''}]};
		ScheduleStore.loadData(data);
	}
};

Ext.extend(eus.window.StorageIncomingProduct,Ext.Window,config);

Ext.reg('eus-storageIncoming-product-window',eus.window.StorageIncomingProduct);