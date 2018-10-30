Ext.ns('eus.window.ContractProduct');

eus.window.ContractProduct = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	this.originalResult = {};
	
	/*��Ʒ��� Store*/
	this.contractItem_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getProductType.action',
		baseParams:{status:'Using'},
		root:'ProductType',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
	var contractItem_ProductCombination = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCapacitor.action',
		root:'Capacitor',
		fields:['id','productName','price','voltage','capacity','productCombination',
		        {name:'productCode',mapping:'productCode.code'},
		        {name:'humidity',mapping:'humidity.code'},
		        {name:'errorLevel',mapping:'errorLevel.code'}, 
		        {name:'unit',mapping:'unit.name'}]
	});	
	
	var loadHandler_ProductCombination = function(combo,record,index){
		Ext.getCmp('txtContractItemPrice').setValue(record.get('price'));
		Ext.getCmp('txtContractItemUnit').setValue(record.get('unit'));
		this.calcSubTotal();
	};
	
	var blurHandle_ProductCombination = function(field){
		var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbcontractItem_ProductCombination').getValue());
		if (isEmptyProductCombination) {
			Ext.getCmp('txtContractItemPrice').setValue(null);
			Ext.getCmp('txtContractItemUnit').setValue(null);
		}
		this.calcSubTotal();
	};
	
	var cbcontractItem_ProductType = {
		xtype:'combo',
		store:this.contractItem_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbcontractItem_ProductType',
		width:267,
		readOnly:true,
		allowBlank:false,
		blankText:'��ѡ���Ʒ���',
		valueField:'id'
	};
	
	var cbcontractItem_ProductCombination = {
		xtype:'combo',
		store:contractItem_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		loadingText:'��ѯ��...',
		selectOnFocus:true,
		id:'cbcontractItem_ProductCombination',
		listeners:{'select':loadHandler_ProductCombination,
				   'blur':blurHandle_ProductCombination,
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
				   					clsys.form.Util.updateComboWithGet('cbcontractItem_ProductType',temp2);
				   					var combo = Ext.getCmp('cbcontractItem_ProductCombination');
				   					combo.getStore().load({
				   							params:{id:temp1},
				   							callback : function(records, opt, success) {
				   								if (success) {
				   									combo.setValue(temp1);
				   									Ext.getCmp('txtContractItemPrice').setValue(records[0].get('price'));
				   									Ext.getCmp('txtContractItemUnit').setValue(records[0].get('unit'));
				   									var subTotal = 0.00;
				   									var amount = parseInt(Ext.getCmp('txtContractItemAmount').getValue());
				   									var price = parseFloat(Ext.getCmp('txtContractItemPrice').getValue());

				   									if (!amount) amount = 0;
				   									if (!price) price = 0.0;

				   									var strPrice = price.toString().split(".");
				   									var tempPrice;
				   									if (strPrice.length == 1){
				   										tempPrice = parseInt(price);
				   									}else{
					   									tempPrice = 100*parseInt(strPrice[0])+parseInt(strPrice[1]);				   										
				   									}
				   									subTotal = tempPrice * amount / 100;
				   								
				   								  
				   									/*ȷ��������ֻ����λС��������21��1.11���ô˸��ƣ���������*/
				   									Ext.getCmp('txtContractItemSubTotal').setValue(subTotal);
				   									Ext.getCmp('txtContractItemAmount').focus();
				   								}
				   							}
				   					});
				   				}
				   				else {
				   					Ext.getCmp('cbcontractItem_ProductType').clearValue();
				   					Ext.getCmp('cbcontractItem_ProductCombination').clearValue();
				   					Ext.getCmp('txtContractItemUnit').setValue(null);
				   					Ext.getCmp('txtContractItemPrice').setValue(0.00);
   									Ext.getCmp('txtContractItemAmount').setValue(0);
   									Ext.getCmp('txtContractItemSubTotal').setValue(0.00);
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
				  scope:this},
		width:267,
		readOnly:false,
		enableKeyEvents:true,
		allowBlank:false,
		blankText:'��ѡ���Ʒ���Ƽ��ͺ�',
		valueField:'id'
	};
	
	/*��Ʒ����*/
	var txtContractItemAmount = {
		xtype:'numberfield',
		id:'txtContractItemAmount',
		fieldLabel:'��Ʒ����',
		listeners:{'blur':this.calcSubTotal},
		width:250,
		allowBlank:false,
		blankText:'�������Ʒ����',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,
		name:'txtContractItemAmount'
	};	
	
	/*��Ʒ����*/
	var txtContractItemPrice = {
		xtype:'numberfield',
		id:'txtContractItemPrice',
		fieldLabel:'��Ʒ����',
		listeners:{'blur':this.calcSubTotal},
		allowDecimals: true, // ����С���� 
		allowNegative: false, // ������ 
		width:250,
		minValue:0.00,
		name:'txtContractItemPrice'
	};	
	
	/*����*/
	var txtContractItemDuration = {
		xtype:'numberfield',
		id:'txtContractItemDuration',
		fieldLabel:'����',
		width:250,
		allowBlank:false,
		blankText:'���������',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,		
		name:'txtContractItemDuration'
	};

	/*��λ*/
	var txtContractItemUnit = {
		xtype:'textfield',
		id:'txtContractItemUnit',
		fieldLabel:'��λ',
		readOnly:true,
		width:250,
		name:'txtContractItemUnit'
	};	

	/*С��*/
	var txtContractItemSubTotal = {
		xtype:'textfield',
		id:'txtContractItemSubTotal',
		fieldLabel:'С��',
		width:250,
		name:'txtContractItemUnit'
	};
	
	/*��ע*/
	var txtContractItemMemo = {
		xtype:'textfield',
		id:'txtContractItemMemo',
		fieldLabel:'��ע',
		width:250,
		name:'txtContractItemMemo'
	};
		
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'contractProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'contractProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'contractProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbcontractItem_ProductCombination,txtContractItemAmount,txtContractItemDuration,txtContractItemMemo]		
	};
		
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbcontractItem_ProductType,txtContractItemPrice,txtContractItemUnit,txtContractItemSubTotal]		
	};
	
	this.contractItemForm = new Ext.form.FormPanel({
		id:'capacitor-window-form',
		autoWidth:true,
		frame:false,
		labelWidth:150,
		border:false,
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
							var combo = Ext.getCmp('cbcontractItem_ProductCombination');
							combo.getStore().load({
									params:{id:attr.id},
									callback : function(records, opt, success) {
										if (success) {
											combo.setValue(attr.id);
											Ext.getCmp('txtContractItemPrice').setValue(records[0].get('price'));
											Ext.getCmp('txtContractItemUnit').setValue(records[0].get('unit'));	
											clsys.form.Util.updateComboWithGet('cbcontractItem_ProductType',attr.productTypeID);
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
	
	eus.window.ContractProduct.superclass.constructor.call(this, {
		id:'contractProduct-window',
		title:'���Ӳ�Ʒ��ϸ',
		buttonAlign:'center',
		autoHeight:true,
		width:880,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.contractItemForm]
	});
};

var config = {
	/*����С��*/
	calcSubTotal:function(){
		var subTotal = 0.00;
		var amount = parseInt(Ext.getCmp('txtContractItemAmount').getValue());
		var price = parseFloat(Ext.getCmp('txtContractItemPrice').getValue());
		if (!amount) amount = 0;
		if (!price) price = 0.0;
		var strPrice = price.toString().split(".");
		var tempPrice;
		/*JAVACRIPT���ȴ���ֱ�Ӽ���100*4.1 100*5.1 21*1.11�����*/
		if (strPrice.length == 1){
			tempPrice = parseInt(price);
			subTotal = tempPrice * amount;
		}else{
			tempPrice = 100*parseInt(strPrice[0])+parseFloat('0.'+strPrice[1])*100;
			subTotal = tempPrice * amount / 100;
		}

		Ext.getCmp('txtContractItemSubTotal').setValue(subTotal);
	},
	/*������ϸ*/
	upsert:function(){
		if (!this.contractItemForm.getForm().isValid()) return;
		this.calcSubTotal();
		var combo1 = clsys.form.Util.getComboValues('cbcontractItem_ProductCombination');
		var combo2 = clsys.form.Util.getComboValues('cbcontractItem_ProductType');
		var attributes = {
			product:{'id':combo1.id,'productCombination':combo1.name,'productType':{'id':combo2.id,'name':combo2.name},'unit':{'name':Ext.getCmp('txtContractItemUnit').getValue()}},
			amount:Ext.getCmp('txtContractItemAmount').getValue(),
			price:Ext.getCmp('txtContractItemPrice').getValue(),
			duration:Ext.getCmp('txtContractItemDuration').getValue(),
			subTotal:Ext.getCmp('txtContractItemSubTotal').getValue(),
			memo:Ext.getCmp('txtContractItemMemo').getValue()
		};
		
		this.fireEvent(this.mode,attributes);
		if (this.mode == 'update'){
			this.destroy();
		}
	},
	/*�޸���ϸ*/
	open:function(OldResult){
		this.mode = 'update';
		this.originalResult = OldResult;
		Ext.getCmp('txtContractItemAmount').setValue(this.originalResult.amount);
		Ext.getCmp('txtContractItemPrice').setValue(this.originalResult.price);
		Ext.getCmp('txtContractItemDuration').setValue(this.originalResult.duration);
		Ext.getCmp('txtContractItemMemo').setValue(this.originalResult.memo);
		Ext.getCmp('txtContractItemUnit').setValue(this.originalResult.unit);
		Ext.getCmp('txtContractItemSubTotal').setValue(this.originalResult.subTotal);
		clsys.form.Util.updateComboWithGet('cbcontractItem_ProductType',this.originalResult.productTypeID);
		clsys.form.Util.updateComboWithGet('cbcontractItem_ProductCombination',this.originalResult.productID);
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
			titile:'ȷ������', 
			buttons:Ext.MessageBox.YESNO,
			msg:'�Ƿ����ò�Ʒ��Ϣ', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	doAutoReload:function(){
	}
};

Ext.extend(eus.window.ContractProduct,Ext.Window,config);

Ext.reg('eus-contract-product-window',eus.window.ContractProduct);
