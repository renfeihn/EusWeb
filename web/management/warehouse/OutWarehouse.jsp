<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>直接入库</title>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script language="javascript">

  Ext.onReady(function(){

		/*产品类别 Store*/
		OutWarehouse_ProductType = new Ext.data.JsonStore({
			autoDestroy:true,
			autoLoad:{params:{status:['Using']}},
			url:'findProductType.action',
			baseParams:{status:'Using'},
			root:'ProductTypeList',
			fields:['id','name']
		});
		
		/*产品名称及型号 Store*/
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
		
		/*库位信息*/
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
		
		/*产品类别*/
		var cbOutWarehouseItem_ProductType = {
			xtype:'combo',
			store:OutWarehouse_ProductType,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择产品类别',
			fieldLabel:'产品类别',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_ProductType',
			valueField:'id',
			allowBlank:false,
			readOnly:true,
			width:237,
			blankText:'请选择产品类别'
		};

		/*产品名称及型号*/	
		var cbOutWarehouseItem_ProductCombination = {
			xtype:'combo',
			store:OutWarehouse_ProductCombination,
			displayField:'productCombination',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择产品名称及型号',
			fieldLabel:'产品名称及型号',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_ProductCombination',
			valueField:'id',
			allowBlank:false,
			width:237,
			loadingText:'查询中...',
			readOnly:false,
			blankText:'请选择产品名称及型号',
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
		var cbOutWarehouseItem_storageLocation = {
			xtype:'combo',
			store:OutWarehouse_storageLocationStore,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择库位',
			fieldLabel:'库位',
			selectOnFocus:true,
			id:'cbOutWarehouseItem_storageLocation',
			valueField:'id',
			allowBlank:true,
			width:220,
			blankText:'请选择库位'
		};
			
		/*出库数量*/
		var txtOutWarehouseItemAmount = {
			xtype:'numberfield',
			id:'txtOutWarehouseItemAmount',
			fieldLabel:'出库数量',
			minLength:1,
			maxLength:8,
			name:'txtOutWarehouseItemAmount',
			allowBlank:false,
			width:220,
			allowDecimals: false, // 允许小数点 
			allowNegative: false, // 允许负数 
			minValue:1,
			blankText:'请输入出库数量'
		};
		
		/*工作电压*/
		var txtOutWarehouseItemVoltage = {
			xtype:'textfield',
			id:'txtOutWarehouseItemVoltage',
			fieldLabel:'工作电压(V)',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemVoltage'
		};	
		
		/*容量*/
		var txtOutWarehouseItemCapacity = {
			xtype:'textfield',
			id:'txtOutWarehouseItemCapacity',
			fieldLabel:'容量(PF)',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemCapacity'
		};

		/*组别-湿度系数*/
		var txtOutWarehouseItemHumidity = {
			xtype:'textfield',
			id:'txtOutWarehouseItemHumidity',
			fieldLabel:'组别',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemHumidity'
		};	

		/*等级-产品代号*/
		var txtOutWarehouseItemProductCode = {
			xtype:'textfield',
			id:'txtOutWarehouseItemProductCode',
			fieldLabel:'等级',
			readOnly:true,
			width:220,
			name:'txtOutWarehouseItemProductCode'
		};

		/*备注*/
		var txtOutWarehouseItemMemo = {
			xtype:'textfield',
			id:'txtOutWarehouseItemMemo',
			fieldLabel:'备注',
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
	    	  text:'产品综合查询',
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
      	
		/* 窗口中的按钮 */
		var btnSubmit = {
			text:'出库',
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
				success:function(f,a){clsys.message.info('出库成功');},
				failure:function(form,action){clsys.message.info(action.result.msg);},
				waitMsg:'正在提交数据,请稍后...',
				scope:this
			});},
			scope:this
		};
		
		var btnReset = {
			text:'重置',
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