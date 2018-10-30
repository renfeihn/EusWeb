Ext.ns('eus.window.ScheduleStorageIncomingProduct');

eus.window.ScheduleStorageIncomingProduct = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.sicItemNo = '';
	this.originalResult = {};
	
	/*产品类别 Store*/
	this.scheduleStorageIncomingItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*产品名称及型号 Store*/
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
	
	/*库位信息*/
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
	
	/*产品类别*/
	var cbScheduleStorageIncomingItem_ProductType = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_ProductType',
		valueField:'id',
		readOnly:true,
		blankText:'请选择产品类别',
		allowBlank:false,
		width:317
	};

	/*产品名称及型号*/	
	var cbScheduleStorageIncomingItem_ProductCombination = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品名称及型号',
		fieldLabel:'产品名称及型号',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_ProductCombination',
		width:317,
		readOnly:false,
		allowBlank:false,
		blankText:'请选择产品名称及型号',
		loadingText:'查询中...',
		valueField:'id',
		listeners:{
		   'specialkey':function(field,event){
		   		if (event.getKey() == event.ENTER){
		   			var inputValue = field.getRawValue().trim();
		   			if (Ext.isEmpty(inputValue)) return;
		   			
		   			/*通过ProductCombination(PC)查找Product的ID*/
		   			var url = 'getProductIDCapacitor.action';
		   			var params = {productCombination:inputValue};
		   			/*成功时的处理函数*/
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
		   					var data = {Schedule:[{id:'', scheduleNo:'选择计划',finishedAmount:'',amount:''}]};
		   					ScheduleStore.loadData(data);
		   				}
		   			};
		   			/*失败时的处理函数*/
		   			var failureFunc = function(response,opts){
		   				clsys.message.systemerror(response.responseText.msg);
		   			};
		   			/*使用AJAX完成请求*/
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

	/*库位*/
	var cbScheduleStorageIncomingItem_storageLocation = {
		xtype:'combo',
		store:this.scheduleStorageIncomingItem_storageLocationStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择库位',
		fieldLabel:'库位',
		selectOnFocus:true,
		id:'cbScheduleStorageIncomingItem_storageLocation',
		width:300,
		allowBlank:false,
		blankText:'请选择库位',
		valueField:'id'
	};	
	/*产品数量*/
	var txtScheduleStorageIncomingItemAmount = {
		xtype:'numberfield',
		id:'txtScheduleStorageIncomingItemAmount',
		fieldLabel:'数量',
		width:300,
		allowBlank:false,
		blankText:'请输入数量',
		name:'txtScheduleStorageIncomingItemAmount'
	};
	
	/*工作令号*/
	var txtScheduleStorageIncomingItemJobCmdNo = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemJobCmdNo',
		fieldLabel:'工作令号',
		width:300,
		allowBlank:false,
		blankText:'请输入工作令号',
		name:'txtScheduleStorageIncomingItemJobCmdNo'
	};
	
	/*工作电压*/
	var txtScheduleStorageIncomingItemVoltage = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemVoltage',
		fieldLabel:'工作电压(V)',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemVoltage'
	};	
	
	/*容量*/
	var txtScheduleStorageIncomingItemCapacity = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemCapacity',
		fieldLabel:'容量(PF)',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemCapacity'
	};

	/*组别-湿度系数*/
	var txtScheduleStorageIncomingItemHumidity = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemHumidity',
		fieldLabel:'组别',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemHumidity'
	};	

	/*等级-产品代号*/
	var txtScheduleStorageIncomingItemProductCode = {
		xtype:'textfield',
		id:'txtScheduleStorageIncomingItemProductCode',
		fieldLabel:'等级',
		readOnly:true,
		width:300,
		name:'txtScheduleStorageIncomingItemProductCode'
	};
	
	/*备注-计划号*/
	var txtScheduleStorageIncomingItemMemo = {
		xtype:'clsys-schedule-dataview',
		id:'txtScheduleStorageIncomingItemMemo',
		fieldLabel:'备注',
		name:'txtScheduleStorageIncomingItemMemo',
		width:300,
		readOnly: false
	};
	
	/*生产日期*/
	var cbScheduleStorageIncomingItemProductionDate = {		
		xtype:'datefield',
		id:'cbScheduleStorageIncomingItemProductionDate',
		fieldLabel:'生产日期',
		width:300,
		value:new Date(),
		allowBlank:false,
		blankText:'请选择生产日期',		
		name:'cbScheduleStorageIncomingItemProductionDate'
	}
			
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'scheduleStorageIncomingProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'scheduleStorageIncomingProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
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
		    	  text:'产品综合查询',
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
		title:'增加入库单条目',
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
	/*增加明细*/
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
			clsys.message.info('请输入工作令号');
			return;			
		}	
		
		if (Ext.isEmpty(ScheduleStoreRecord.get('amount'))){
			clsys.message.info('请选择计划');
			return;			
		}

		if (!Ext.isEmpty(Ext.getCmp('txtScheduleStorageIncomingItemAmount').getValue())) {
			inputAmount = parseInt(Ext.getCmp('txtScheduleStorageIncomingItemAmount').getValue());
		} else {
			clsys.message.info('请输入数量');
			return;
		}
		
		if (restAmount < inputAmount){
			var strMessage = '输入的数量错误  [输入数量]:'+ inputAmount + '  [可入库数量]:' + restAmount; 
			clsys.message.info(strMessage);
			return;
		}
		
		if (Ext.isEmpty(Ext.getCmp('cbScheduleStorageIncomingItem_storageLocation').getValue())){
			clsys.message.info('请选择库位');
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
	/*修改明细*/
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
			titile:'确认重置', 
			buttons:Ext.MessageBox.YESNO,
			msg:'是否重置入库单条目信息', 
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
		var data = {Schedule:[{id:'', scheduleNo:'选择计划',finishedAmount:'',amount:''}]};
		ScheduleStore.loadData(data);
	}
};

Ext.extend(eus.window.ScheduleStorageIncomingProduct,Ext.Window,config);

Ext.reg('eus-scheduleStorageIncoming-product-window',eus.window.ScheduleStorageIncomingProduct);