<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>ֱ�����</title>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script language="javascript">

  Ext.onReady(function(){

		/*��Ʒ��� Store*/
		OutWarehouse_ProductType = new Ext.data.JsonStore({
			autoDestroy:true,
			autoLoad:{params:{status:['Using']}},
			url:'findProductType.action',
			baseParams:{status:'Using'},
			root:'ProductTypeList',
			fields:['id','name']
		});
		
		/*��Ʒ���Ƽ��ͺ� Store*/
		OutWarehouse_ProductCombination = new Ext.data.JsonStore({
			autoDestroy:true,
			url:'getCapacitor.action',
			root:'Capacitor',
			fields:['id','productName','price','voltage','capacity','productCombination',
			        {name:'productCode',mapping:'productCode.code'},
			        {name:'humidity',mapping:'humidity.code'},
			        {name:'errorLevel',mapping:'errorLevel.code'}, 
			        {name:'unit',mapping:'unit.name'}]
		});	
		
		/*��λ��Ϣ*/
		OutWarehouse_storageLocationStore = new Ext.data.JsonStore({
			autoDestroy:true,
			autoLoad:{params:{status:['Using']}},
			url:'findStorageLocation.action',
			baseParams:{status:'Using'},
			root:'StorageLocationList',
			fields:['id','name']
		});
		
		var loadHandler = function(combo,record,index){
			OutWarehouse_ProductCombination.removeAll();
			Ext.getCmp('cbOutWarehouseItem_ProductCombination').setValue(null);
			
			var strProductType = record.get('id');
			var isEmptyProductType = Ext.isEmpty(strProductType);
			
			if (!isEmptyProductType){
				OutWarehouse_ProductCombination.baseParams = {status:'Using',productType:strProductType};
				OutWarehouse_ProductCombination.reload();
			}
		};
		
		var blurHandle = function(field){
			var isEmptyProductType = Ext.isEmpty(Ext.getCmp('cbOutWarehouseItem_ProductType').getValue());
			if (isEmptyProductType) {
				OutWarehouse_ProductCombination.removeAll();
				Ext.getCmp('cbOutWarehouseItem_ProductCombination').setValue(null);
				Ext.getCmp('txtOutWarehouseItemVoltage').setValue(null);
				Ext.getCmp('txtOutWarehouseItemCapacity').setValue(null);
				Ext.getCmp('txtOutWarehouseItemHumidity').setValue(null);
				Ext.getCmp('txtOutWarehouseItemProductCode').setValue(null);
			}
		};
		
		var loadHandler_ProductCombination = function(combo,record,index){
			Ext.getCmp('txtOutWarehouseItemVoltage').setValue(record.get('voltage'));
			Ext.getCmp('txtOutWarehouseItemCapacity').setValue(record.get('capacity'));
			Ext.getCmp('txtOutWarehouseItemHumidity').setValue(record.get('humidity'));
			Ext.getCmp('txtOutWarehouseItemProductCode').setValue(record.get('productCode'));
		};
		
		var blurHandle_ProductCombination = function(field){
			var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbOutWarehouseItem_ProductCombination').getValue());
			if (isEmptyProductCombination) {
				Ext.getCmp('txtOutWarehouseItemVoltage').setValue(null);
				Ext.getCmp('txtOutWarehouseItemCapacity').setValue(null);
				Ext.getCmp('txtOutWarehouseItemHumidity').setValue(null);
				Ext.getCmp('txtOutWarehouseItemProductCode').setValue(null);
			}
		};
		
		/*��Ʒ���*/
		var cbOutWarehouseItem_ProductType = {
			xtype:'combo',
			store:OutWarehouse_ProductType,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'��ѡ���Ʒ���',
			fieldLabel:'��Ʒ���',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_ProductType',
			valueField:'id',
			allowBlank:false,
			readOnly:true,
			width:237,
			blankText:'��ѡ���Ʒ���'
		};

		/*��Ʒ���Ƽ��ͺ�*/	
		var cbOutWarehouseItem_ProductCombination = {
			xtype:'combo',
			store:OutWarehouse_ProductCombination,
			displayField:'productCombination',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
			fieldLabel:'��Ʒ���Ƽ��ͺ�',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_ProductCombination',
			valueField:'id',
			allowBlank:false,
			width:237,
			loadingText:'��ѯ��...',
			readOnly:false,
			blankText:'��ѡ���Ʒ���Ƽ��ͺ�',
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
			   					clsys.form.Util.updateCombo('cbOutWarehouseItem_ProductType',temp2);
			   					var combo = Ext.getCmp('cbOutWarehouseItem_ProductCombination');
			   					combo.getStore().load({
			   							params:{id:temp1},
			   							callback : function(records, opt, success) {
			   								if (success) {
			   									combo.setValue(temp1);
			   									Ext.getCmp('txtOutWarehouseItemVoltage').setValue(records[0].get('voltage'));
			   									Ext.getCmp('txtOutWarehouseItemCapacity').setValue(records[0].get('capacity'));
			   									Ext.getCmp('txtOutWarehouseItemHumidity').setValue(records[0].get('humidity'));
			   									Ext.getCmp('txtOutWarehouseItemProductCode').setValue(records[0].get('productCode'));
			   								}
			   							}
			   					});
			   				}
			   				else {
			   					Ext.getCmp('cbOutWarehouseItem_ProductType').clearValue();
			   					Ext.getCmp('cbOutWarehouseItem_ProductCombination').clearValue();
			   					Ext.getCmp('txtOutWarehouseItemVoltage').setValue(null);
			   					Ext.getCmp('txtOutWarehouseItemCapacity').setValue(null);
			   					Ext.getCmp('txtOutWarehouseItemHumidity').setValue(null);
			   					Ext.getCmp('txtOutWarehouseItemProductCode').setValue(null);
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
		var cbOutWarehouseItem_storageLocation = {
			xtype:'combo',
			store:OutWarehouse_storageLocationStore,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'��ѡ���λ',
			fieldLabel:'��λ',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_storageLocation',
			valueField:'id',
			allowBlank:true,
			width:220,
			blankText:'��ѡ���λ'
		};
			
		/*��������*/
		var txtOutWarehouseItemAmount = {
			xtype:'numberfield',
			id:'txtOutWarehouseItemAmount',
			fieldLabel:'��������',
			minLength:1,
			maxLength:8,
			name:'txtOutWarehouseItemAmount',
			allowBlank:false,
			width:220,
			allowDecimals: false, // ����С���� 
			allowNegative: false, // ������ 
			minValue:1,
			blankText:'�������������'
		};
		
		/*������ѹ*/
		var txtOutWarehouseItemVoltage = {
			xtype:'textfield',
			id:'txtOutWarehouseItemVoltage',
			fieldLabel:'������ѹ(V)',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemVoltage'
		};	
		
		/*����*/
		var txtOutWarehouseItemCapacity = {
			xtype:'textfield',
			id:'txtOutWarehouseItemCapacity',
			fieldLabel:'����(PF)',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemCapacity'
		};

		/*���-ʪ��ϵ��*/
		var txtOutWarehouseItemHumidity = {
			xtype:'textfield',
			id:'txtOutWarehouseItemHumidity',
			fieldLabel:'���',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemHumidity'
		};	

		/*�ȼ�-��Ʒ����*/
		var txtOutWarehouseItemProductCode = {
			xtype:'textfield',
			id:'txtOutWarehouseItemProductCode',
			fieldLabel:'�ȼ�',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemProductCode'
		};

		/*��ע*/
		var txtOutWarehouseItemMemo = {
			xtype:'textfield',
			id:'txtOutWarehouseItemMemo',
			fieldLabel:'��ע',
			width:220,
			name:'txtOutWarehouseItemMemo'			
		};
				
		var col1 = {
			columnWidth: .50,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[
				   cbOutWarehouseItem_ProductType,
				   cbOutWarehouseItem_ProductCombination,
			       cbOutWarehouseItem_storageLocation,
			       txtOutWarehouseItemAmount,txtOutWarehouseItemMemo]		
		};
		
		var col2 = {
			columnWidth: .50,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[
			       txtOutWarehouseItemVoltage,
			       txtOutWarehouseItemCapacity,
			       txtOutWarehouseItemHumidity,
			       txtOutWarehouseItemProductCode
			       ]		
		};
		
		OutWarehouseForm = new Ext.form.FormPanel({
			id:'OutWarehouse-form',
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

		var btnGetProduct = {
	    	  text:'��Ʒ�ۺϲ�ѯ',
	    	  iconCls: 'icon-examine',
	    	  handler:function(){
				var wnd = Ext.getCmp('capacitor-selector-window');
				if (!wnd) {
					var wnd = new eus.window.CapacitorSelector();
					wnd.on('capacitorSelected', function(attr){
						var combo = Ext.getCmp('cbOutWarehouseItem_ProductCombination');
						combo.getStore().load({
								params:{id:attr.id},
								callback : function(records, opt, success) {
									if (success) {
										combo.setValue(attr.id);
										Ext.getCmp('txtOutWarehouseItemVoltage').setValue(records[0].get('voltage'));
										Ext.getCmp('txtOutWarehouseItemCapacity').setValue(records[0].get('capacity'));
										Ext.getCmp('txtOutWarehouseItemHumidity').setValue(records[0].get('humidity'));
										Ext.getCmp('txtOutWarehouseItemProductCode').setValue(records[0].get('productCode'));
										clsys.form.Util.updateCombo('cbOutWarehouseItem_ProductType',attr.productTypeID);
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
		};
      	
		/* �����еİ�ť */
		var btnSubmit = {
			text:'����',
			iconCls:'icon-add',
			id:'OutWarehouseProduct-window-submit',
			handler:function(){
				if (!OutWarehouseForm.getForm().isValid()) return;
				OutWarehouseForm.getForm().submit({
				url:'addOutInWarehouse.action',
				params:{
					product:Ext.getCmp('cbOutWarehouseItem_ProductCombination').getValue(),
					storageLocation:Ext.getCmp('cbOutWarehouseItem_storageLocation').getValue(),
					amount:Ext.getCmp('txtOutWarehouseItemAmount').getValue(),
					memo:Ext.getCmp('txtOutWarehouseItemMemo').getValue()
				},
				success:function(f,a){clsys.message.info('����ɹ�');},
				failure:function(form,action){clsys.message.info(action.result.msg);},
				waitMsg:'�����ύ����,���Ժ�...',
				scope:this
			});},
			scope:this
		};
		
		var btnReset = {
			text:'����',
			iconCls:'icon-refresh',
			id:'OutWarehouseProduct-window-reset',
			handler:function(){OutWarehouseForm.getForm().reset();},
			scope:this		
		};

		var OutWarehousePanel = Ext.getCmp('OutWarehouse-mainpanel');
		OutWarehousePanel.add(OutWarehouseForm);
		OutWarehousePanel.getTopToolbar().add(btnGetProduct,btnSubmit,btnReset);
		OutWarehousePanel.doLayout();
});
</script>
</head>
<body>
<div id="OutWarehouseGridPanel"></div>
</body>
</html>