Ext.ns('eus.window.StorageOutcomingProduct');

eus.window.StorageOutcomingProduct = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.socItemNo = '';
	this.originalResult = {};
	
	/*库位信息*/
	this.storageOutcomingItem_storageLocationStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using']}},
		url:'findStorageLocation.action',
		baseParams:{status:'Using'},
		root:'StorageLocationList',
		fields:['id','name']
	});
	
	/*产品类别 Store*/
	this.storageOutcomingItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*产品名称及型号 Store*/
	this.storageOutcomingItem_ProductCombination = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findCapacitor.action',
		root:'CapacitorList',
		fields:['id','productName','price','voltage','capacity','productCombination',
		        {name:'productCode',mapping:'productCode.code'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'}, 
		        {name:'unit',mapping:'unit.name'}],
		listeners:{
			'load': function(store, records, opts){
				clsys.basic.BizDisplay.getPC('productCombination',store,records,'-',true);
			}
		}
	});	
	
	var loadHandler = function(combo,record,index){
		this.storageOutcomingItem_ProductCombination.removeAll();
		Ext.getCmp('cbStorageOutcomingItem_ProductCombination').setValue(null);
		
		var strProductType = record.get('id');
		var isEmptyProductType = Ext.isEmpty(strProductType);
		
		if (!isEmptyProductType){
			this.storageOutcomingItem_ProductCombination.baseParams = {status:'Using',productType:strProductType};
			this.storageOutcomingItem_ProductCombination.reload();
		}
		this.calcSubTotal();
	};
	
	var blurHandle = function(field){
		var isEmptyProductType = Ext.isEmpty(Ext.getCmp('cbStorageOutcomingItem_ProductType').getValue());
		if (isEmptyProductType) {
			this.storageOutcomingItem_ProductCombination.removeAll();
			Ext.getCmp('cbStorageOutcomingItem_ProductCombination').setValue(null);
			Ext.getCmp('txtStorageOutcomingItemPrice').setValue(null);
			Ext.getCmp('txtStorageOutcomingItemUnit').setValue(null);
		}
		this.calcSubTotal();
	};
	
	var loadHandler_ProductCombination = function(combo,record,index){
		Ext.getCmp('txtStorageOutcomingItemPrice').setValue(record.get('price'));
		Ext.getCmp('txtStorageOutcomingItemUnit').setValue(record.get('unit'));
		this.calcSubTotal();
	};
	
	var blurHandle_ProductCombination = function(field){
		var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbStorageOutcomingItem_ProductCombination').getValue());
		if (isEmptyProductCombination) {
			Ext.getCmp('txtStorageOutcomingItemPrice').setValue(null);
			Ext.getCmp('txtStorageOutcomingItemUnit').setValue(null);
		}
		this.calcSubTotal();
	};
	
	var cbStorageOutcomingItem_ProductType = {
		xtype:'combo',
		store:this.storageOutcomingItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbStorageOutcomingItem_ProductType',
		listeners:{'select':loadHandler,'blur':blurHandle,scope:this},
		width:220,
		allowBlank:false,
		blankText:'请选择产品类别',
		valueField:'id'
	};
	
	var cbStorageOutcomingItem_ProductCombination = {
		xtype:'combo',
		store:this.storageOutcomingItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品名称及型号',
		fieldLabel:'产品名称及型号',
		selectOnFocus:true,
		id:'cbStorageOutcomingItem_ProductCombination',
		listeners:{'select':loadHandler_ProductCombination,'blur':blurHandle_ProductCombination,scope:this},
		width:220,
		allowBlank:false,
		blankText:'请选择产品名称及型号',
		valueField:'id'
	};
	
	/*库位*/
	var cbStorageOutcomingItem_storageLocation = {
		xtype:'combo',
		store:this.storageOutcomingItem_storageLocationStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择库位',
		fieldLabel:'库位',
		selectOnFocus:true,
		id:'cbStorageOutcomingItem_storageLocation',
		valueField:'id',
		allowBlank:false,
		width:220,
		blankText:'请选择库位'
	};
	
	/*出库数量*/
	var txtStorageOutcomingItemAmount = {
		xtype:'numberfield',
		id:'txtStorageOutcomingItemAmount',
		fieldLabel:'出库数量',
		listeners:{'blur':this.calcSubTotal},
		width:220,
		allowBlank:false,
		minLength:1,
		maxLength:8,
		blankText:'请输入出库数量',
		name:'txtStorageOutcomingItemAmount'
	};	
	
	/*产品单价-含税价格*/
	var txtStorageOutcomingItemPrice = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemPrice',
		fieldLabel:'产品单价',
		listeners:{'blur':this.calcSubTotal},
		width:220,
		name:'txtStorageOutcomingItemPrice'
	};
	
	/*产品单价-不含税价格*/
	var txtStorageOutcomingItemPriceWithoutTax = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemPriceWithoutTax',
		fieldLabel:'不含税价格',
		listeners:{'blur':this.calcSubTotal},
		width:220,
		name:'txtStorageOutcomingItemPriceWithoutTax'
	};	
	
	/*税率*/
	var txtStorageOutcomingItemTax = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemTax',
		fieldLabel:'税率',
		width:220,
		minLength:1,
		maxLength:2,
		regex:/\d{1,2}/,
		regexText:'请输入数字',
		listeners:{'blur':this.calcSubTotal},
		allowBlank:false,
		blankText:'请输入税率',
		name:'txtStorageOutcomingItemTax'
	};

	/*税额*/
	var txtStorageOutcomingItemTaxAmount = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemTaxAmount',
		fieldLabel:'税额',
		width:220,
		readOnly:true,
		name:'txtStorageOutcomingItemTaxAmount'
	};	
	
	/*单位*/
	var txtStorageOutcomingItemUnit = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemUnit',
		fieldLabel:'单位',
		readOnly:true,
		width:220,
		name:'txtStorageOutcomingItemUnit'
	};	

	/*金额-含税*/
	var txtStorageOutcomingItemSubTotal = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemSubTotal',
		fieldLabel:'金额',
		width:220,
		name:'txtStorageOutcomingItemUnit'
	};
	
	/*金额-不含税*/
	var txtStorageOutcomingItemSubTotalWithoutTax = {
			xtype:'textfield',
			id:'txtStorageOutcomingItemSubTotalWithoutTax',
			fieldLabel:'不含税金额',
			width:220,
			readOnly:true,
			name:'txtStorageOutcomingItemSubTotalWithoutTax'
	};
	
	/*备注*/
	var txtStorageOutcomingItemMemo = {
		xtype:'textfield',
		id:'txtStorageOutcomingItemMemo',
		fieldLabel:'备注',
		width:220,
		name:'txtStorageOutcomingItemMemo'
	};
		
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'StorageOutcomingProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'StorageOutcomingProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'StorageOutcomingProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbStorageOutcomingItem_ProductType,
		       txtStorageOutcomingItemUnit,
		       txtStorageOutcomingItemPrice,
		       txtStorageOutcomingItemSubTotal,
		       txtStorageOutcomingItemTax,
		       cbStorageOutcomingItem_storageLocation
		       ]		
	};
		
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbStorageOutcomingItem_ProductCombination,
		       txtStorageOutcomingItemAmount,
		       txtStorageOutcomingItemPriceWithoutTax,
		       txtStorageOutcomingItemSubTotalWithoutTax,
		       txtStorageOutcomingItemTaxAmount,
		       txtStorageOutcomingItemMemo
		       ]		
	};
	
	this.storageOutcomingItemForm = new Ext.form.FormPanel({
		id:'storageOutcomingItem-window-form',
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
	
	eus.window.StorageOutcomingProduct.superclass.constructor.call(this, {
		id:'StorageOutcomingProduct-window',
		title:'增加出库明细',
		buttonAlign:'center',
		autoHeight:true,
		width:750,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.storageOutcomingItemForm]
	});
};

var config = {
	/*计算小计*/
	calcSubTotal:function(){
		var subTotal = 0.00;
		var subTotalWithoutTax = 0.00;
		var amount = parseInt(Ext.getCmp('txtStorageOutcomingItemAmount').getValue());
		var price = parseFloat(Ext.getCmp('txtStorageOutcomingItemPrice').getValue());
		var tax = parseFloat(Ext.getCmp('txtStorageOutcomingItemTax').getValue());
		
		if (!amount) amount = 0;
		if (!price) price = 0.0;
		if (!tax) tax = 0;
		
		
		subTotal = price * amount;
		priceWithoutTax = price * (100 - tax)/100;
	
		/*确保计算结果只有两位小数，比如21×1.11不用此改善，则会出问题*/
		subTotal = Math.floor(Math.round(subTotal * 100));
		subTotal = subTotal / 100;

		/*不含税价格*/
		priceWithoutTax = Math.floor(Math.round(priceWithoutTax * 100));
		priceWithoutTax = priceWithoutTax / 100;
		
		/*不含税金额*/
		subTotalWithoutTax = priceWithoutTax * amount;
		subTotalWithoutTax = Math.floor(Math.round(subTotalWithoutTax * 100));
		subTotalWithoutTax = subTotalWithoutTax / 100;
		
		/*税额*/
		var subTax = 0.00;
		subTax = subTotal - subTotalWithoutTax;
		subTax = Math.floor(Math.round(subTax * 100));
		subTax = subTax / 100;
		
		Ext.getCmp('txtStorageOutcomingItemSubTotal').setValue(subTotal);
		Ext.getCmp('txtStorageOutcomingItemSubTotalWithoutTax').setValue(subTotalWithoutTax);
		Ext.getCmp('txtStorageOutcomingItemPriceWithoutTax').setValue(priceWithoutTax);
		Ext.getCmp('txtStorageOutcomingItemTaxAmount').setValue(subTax);
	},
	/*增加明细*/
	upsert:function(){
		if (!this.storageOutcomingItemForm.getForm().isValid()) return;
		this.calcSubTotal();
		var combo = clsys.form.Util.getComboValues('cbStorageOutcomingItem_ProductCombination');
		var combo2 = clsys.form.Util.getComboValues('cbStorageOutcomingItem_storageLocation');
		var attributes = {
			sicItemNo:			this.sicItemNo,
			productType:		clsys.form.Util.getComboValues('cbStorageOutcomingItem_ProductType'),
			productCombination:	{'id':combo.id,'productName':combo.name},
			unit:				Ext.getCmp('txtStorageOutcomingItemUnit').getValue(),
			amount:				Ext.getCmp('txtStorageOutcomingItemAmount').getValue(),
			price: 				Ext.getCmp('txtStorageOutcomingItemPrice').getValue(),
			subTotal: 			Ext.getCmp('txtStorageOutcomingItemSubTotal').getValue(),
			subTotalWithoutTax: Ext.getCmp('txtStorageOutcomingItemSubTotalWithoutTax').getValue(),
			priceWithoutTax:	Ext.getCmp('txtStorageOutcomingItemPriceWithoutTax').getValue(),
			taxAmount:			Ext.getCmp('txtStorageOutcomingItemTaxAmount').getValue(),
			tax:				Ext.getCmp('txtStorageOutcomingItemTax').getValue(),			
			memo:				Ext.getCmp('txtStorageOutcomingItemMemo').getValue(),
			storageLocation:	{'id':combo2.id,'name':combo2.name}
		};
		this.fireEvent(this.mode,attributes);
		if (this.mode == 'update'){
			this.destroy();
		}
	},
	/*修改明细*/
	open:function(OldResult){
		this.mode = 'update';
		this.sicItemNo = this.originalResult.sicItemNo;
		this.originalResult = OldResult;
		clsys.form.Util.updateCombo('cbStorageOutcomingItem_ProductType',this.originalResult.productType);	
		clsys.form.Util.updateCombo('cbStorageOutcomingItem_ProductCombination',this.originalResult.productCombination);
		clsys.form.Util.updateCombo('cbStorageOutcomingItem_storageLocation',this.originalResult.storageLocation);
		Ext.getCmp('txtStorageOutcomingItemUnit').setValue(this.originalResult.unit);
		Ext.getCmp('txtStorageOutcomingItemAmount').setValue(this.originalResult.amount);
		Ext.getCmp('txtStorageOutcomingItemPrice').setValue(this.originalResult.price);
		Ext.getCmp('txtStorageOutcomingItemSubTotal').setValue(this.originalResult.subTotal);
		Ext.getCmp('txtStorageOutcomingItemSubTotalWithoutTax').setValue(this.originalResult.subTotalWithoutTax);
		Ext.getCmp('txtStorageOutcomingItemPriceWithoutTax').setValue(this.originalResult.priceWithoutTax);
		Ext.getCmp('txtStorageOutcomingItemTaxAmount').setValue(this.originalResult.taxAmount);
		Ext.getCmp('txtStorageOutcomingItemTax').setValue(this.originalResult.tax);			
		Ext.getCmp('txtStorageOutcomingItemMemo').setValue(this.originalResult.memo);		
	},
	reset:function(){
		var resetFunc = function(btn){
			if (btn == 'yes' && this.mode == 'add'){
				this.contractItemForm.getForm().reset();
			}
			if (this.mode == 'update'){
				this.open(this.originalResult);
			}

		};
		Ext.MessageBox.show({
			titile:'确认重置', 
			buttons:Ext.MessageBox.YESNO,
			msg:'是否重置产品信息', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	doAutoReload:function(){
		this.storageOutcomingItem_ProductType.baseParams = {status:'Using'};
		this.storageOutcomingItem_ProductType.reload();
	}
};

Ext.extend(eus.window.StorageOutcomingProduct,Ext.Window,config);

Ext.reg('eus-storageOutcoming-product-window',eus.window.StorageOutcomingProduct);
