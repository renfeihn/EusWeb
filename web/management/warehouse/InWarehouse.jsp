<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>直接入库</title>
<script type="text/javascript" src="js/capacitor/capacitorSelector.js"></script>
<script language="javascript">
  Ext.onReady(function(){

		/*产品类别 Store*/
		inWarehouse_ProductType = new Ext.data.JsonStore({
			autoDestroy:true,
			autoLoad:{params:{status:['Using']}},
			url:'findProductType.action',
			baseParams:{status:'Using'},
			root:'ProductTypeList',
			fields:['id','name']
		});
		
		/*产品名称及型号 Store*/
		inWarehouse_ProductCombination = new Ext.data.JsonStore({
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
		inWarehouse_storageLocationStore = new Ext.data.JsonStore({
			autoDestroy:true,
			autoLoad:{params:{status:['Using']}},
			url:'findStorageLocation.action',
			baseParams:{status:'Using'},
			root:'StorageLocationList',
			fields:['id','name']
		});
		
		var loadHandler = function(combo,record,index){
			inWarehouse_ProductCombination.removeAll();
			Ext.getCmp('cbInWarehouseItem_ProductCombination').setValue(null);
			
			var strProductType = record.get('id');
			var isEmptyProductType = Ext.isEmpty(strProductType);
			
			if (!isEmptyProductType){
				inWarehouse_ProductCombination.baseParams = {status:'Using',productType:strProductType};
				inWarehouse_ProductCombination.reload();
			}
		};
		
		var blurHandle = function(field){
			var isEmptyProductType = Ext.isEmpty(Ext.getCmp('cbInWarehouseItem_ProductType').getValue());
			if (isEmptyProductType) {
				inWarehouse_ProductCombination.removeAll();
				Ext.getCmp('cbInWarehouseItem_ProductCombination').setValue(null);
				Ext.getCmp('txtInWarehouseItemVoltage').setValue(null);
				Ext.getCmp('txtInWarehouseItemCapacity').setValue(null);
				Ext.getCmp('txtInWarehouseItemHumidity').setValue(null);
				Ext.getCmp('txtInWarehouseItemProductCode').setValue(null);
			}
		};
		
		var loadHandler_ProductCombination = function(combo,record,index){
			Ext.getCmp('txtInWarehouseItemVoltage').setValue(record.get('voltage'));
			Ext.getCmp('txtInWarehouseItemCapacity').setValue(record.get('capacity'));
			Ext.getCmp('txtInWarehouseItemHumidity').setValue(record.get('humidity'));
			Ext.getCmp('txtInWarehouseItemProductCode').setValue(record.get('productCode'));
		};
		
		var blurHandle_ProductCombination = function(field){
			var isEmptyProductCombination = Ext.isEmpty(Ext.getCmp('cbInWarehouseItem_ProductCombination').getValue());
			if (isEmptyProductCombination) {
				Ext.getCmp('txtInWarehouseItemVoltage').setValue(null);
				Ext.getCmp('txtInWarehouseItemCapacity').setValue(null);
				Ext.getCmp('txtInWarehouseItemHumidity').setValue(null);
				Ext.getCmp('txtInWarehouseItemProductCode').setValue(null);
			}
		};
		
		/*产品类别*/
		var cbInWarehouseItem_ProductType = {
			xtype:'combo',
			store:inWarehouse_ProductType,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择产品类别',
			fieldLabel:'产品类别',
			selectOnFocus:true,
			id:'cbInWarehouseItem_ProductType',
			valueField:'id',
			allowBlank:false,
			readOnly:true,
			width:237,
			blankText:'请选择产品类别'
		};

		/*产品名称及型号*/	
		var cbInWarehouseItem_ProductCombination = {
			xtype:'combo',
			store:inWarehouse_ProductCombination,
			displayField:'productCombination',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择产品名称及型号',
			fieldLabel:'产品名称及型号',
			selectOnFocus:true,
			id:'cbInWarehouseItem_ProductCombination',
			valueField:'id',
			allowBlank:false,
			readOnly:false,
			width:237,
			loadingText:'查询中...',
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
			   					clsys.form.Util.updateCombo('cbInWarehouseItem_ProductType',temp2);
			   					var combo = Ext.getCmp('cbInWarehouseItem_ProductCombination');
			   					combo.getStore().load({
			   							params:{id:temp1},
			   							callback : function(records, opt, success) {
			   								if (success) {
			   									combo.setValue(temp1);
			   									Ext.getCmp('txtInWarehouseItemVoltage').setValue(records[0].get('voltage'));
			   									Ext.getCmp('txtInWarehouseItemCapacity').setValue(records[0].get('capacity'));
			   									Ext.getCmp('txtInWarehouseItemHumidity').setValue(records[0].get('humidity'));
			   									Ext.getCmp('txtInWarehouseItemProductCode').setValue(records[0].get('productCode'));
			   								}
			   							}
			   					});
			   				}
			   				else {
			   					Ext.getCmp('cbInWarehouseItem_ProductType').clearValue();
			   					Ext.getCmp('cbInWarehouseItem_ProductCombination').clearValue();
			   					Ext.getCmp('txtInWarehouseItemVoltage').setValue(null);
			   					Ext.getCmp('txtInWarehouseItemCapacity').setValue(null);
			   					Ext.getCmp('txtInWarehouseItemHumidity').setValue(null);
			   					Ext.getCmp('txtInWarehouseItemProductCode').setValue(null);
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
			   				waitMsg:'查询中...',
			   				scope:this
			   			});	
			   			
			   		}
			  },
			  scope:this}
		};

		/*库位*/
		var cbInWarehouseItem_storageLocation = {
			xtype:'combo',
			store:inWarehouse_storageLocationStore,
			displayField:'name',
			typeAhead:true,
			mode:'local',
			forceSelection:true,
			triggerAction:'all',
			emptyText:'请选择库位',
			fieldLabel:'库位',
			selectOnFocus:true,
			id:'cbInWarehouseItem_storageLocation',
			valueField:'id',
			allowBlank:false,
			width:220,
			allowBlank:true,
			blankText:'请选择库位'
		};
			
		/*入库数量*/
		var txtInWarehouseItemAmount = {
			xtype:'numberfield',
			id:'txtInWarehouseItemAmount',
			fieldLabel:'入库数量',
			minLength:1,
			maxLength:8,
			name:'txtInWarehouseItemAmount',
			allowBlank:false,
			width:220,
			allowDecimals: false, // 允许小数点 
			allowNegative: false, // 允许负数 
			minValue:1,
			blankText:'请输入入库数量'
		};
		
		/*工作电压*/
		var txtInWarehouseItemVoltage = {
			xtype:'textfield',
			id:'txtInWarehouseItemVoltage',
			fieldLabel:'工作电压(V)',
			readOnly:true,
			width:220,
			name:'txtInWarehouseItemVoltage'
		};	
		
		/*容量*/
		var txtInWarehouseItemCapacity = {
			xtype:'textfield',
			id:'txtInWarehouseItemCapacity',
			fieldLabel:'容量(PF)',
			readOnly:true,
			width:220,
			name:'txtInWarehouseItemCapacity'
		};

		/*组别-湿度系数*/
		var txtInWarehouseItemHumidity = {
			xtype:'textfield',
			id:'txtInWarehouseItemHumidity',
			fieldLabel:'组别',
			readOnly:true,
			width:220,
			name:'txtInWarehouseItemHumidity'
		};	

		/*等级-产品代号*/
		var txtInWarehouseItemProductCode = {
			xtype:'textfield',
			id:'txtInWarehouseItemProductCode',
			fieldLabel:'等级',
			readOnly:true,
			width:220,
			name:'txtInWarehouseItemProductCode'
		};

		/*生产日期*/
		var cbInWarehouseItemProductionDate = {		
			xtype:'datefield',
			id:'cbInWarehouseItemProductionDate',
			fieldLabel:'生产日期',
			width:220,
			value:new Date(),
			allowBlank:false,
			blankText:'请选择生产日期',		
			name:'cbInWarehouseItemProductionDate'
		}
		
		/*备注*/
		var txtInWarehouseItemMemo = {
			xtype:'textfield',
			id:'txtInWarehouseItemMemo',
			fieldLabel:'备注',
			width:220,
			name:'txtInWarehouseItemMemo'			
		};
				
		var col1 = {
			columnWidth: .50,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[
				   cbInWarehouseItem_ProductType,
				   cbInWarehouseItem_ProductCombination,
			       cbInWarehouseItem_storageLocation,
			       txtInWarehouseItemAmount,
			       cbInWarehouseItemProductionDate]		
		};
		
		var col2 = {
			columnWidth: .50,
			layout: 'form',
			frame: false,
			border: false,
			defaultType: 'textfield',
			items:[
			       txtInWarehouseItemVoltage,
			       txtInWarehouseItemCapacity,
			       txtInWarehouseItemHumidity,
			       txtInWarehouseItemProductCode,
			       txtInWarehouseItemMemo
			       ]		
		};

		inWarehouseForm = new Ext.form.FormPanel({
			id:'inWarehouse-form',
			autoWidth:true,
			labelWidth:150,
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

		var btnGetProduct = {
	    	  text:'产品综合查询',
	    	  iconCls: 'icon-examine',
	    	  handler:function(){
				var wnd = Ext.getCmp('capacitor-selector-window');
				if (!wnd) {
					var wnd = new eus.window.CapacitorSelector();
					wnd.on('capacitorSelected', function(attr){
						var combo = Ext.getCmp('cbInWarehouseItem_ProductCombination');
						combo.getStore().load({
								params:{id:attr.id},
								callback : function(records, opt, success) {
									if (success) {
										combo.setValue(attr.id);
										Ext.getCmp('txtInWarehouseItemVoltage').setValue(records[0].get('voltage'));
										Ext.getCmp('txtInWarehouseItemCapacity').setValue(records[0].get('capacity'));
										Ext.getCmp('txtInWarehouseItemHumidity').setValue(records[0].get('humidity'));
										Ext.getCmp('txtInWarehouseItemProductCode').setValue(records[0].get('productCode'));
										clsys.form.Util.updateCombo('cbInWarehouseItem_ProductType',attr.productTypeID);
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
			text:'入库',
			iconCls:'icon-add',
			id:'InWarehouseProduct-window-submit',
			handler:function(){
			if (!inWarehouseForm.getForm().isValid()) return;
			inWarehouseForm.getForm().submit({
				url:'addInWarehouse.action',
				params:{
					product:Ext.getCmp('cbInWarehouseItem_ProductCombination').getValue(),
					productionDate:Ext.getCmp('cbInWarehouseItemProductionDate').getValue(),
					storageLocation:Ext.getCmp('cbInWarehouseItem_storageLocation').getValue(),
					amount:Ext.getCmp('txtInWarehouseItemAmount').getValue(),
					memo:Ext.getCmp('txtInWarehouseItemMemo').getValue()
				},
				success:function(f,a){clsys.message.info('入库成功');},
				failure:function(response,opts){clsys.message.systemerror(response.responseText.msg);},
				waitMsg:'正在提交数据,请稍后...',
				scope:this
			});},
			scope:this
		};
		
		var btnReset = {
			text:'重置',
			iconCls:'icon-refresh',
			id:'InWarehouseProduct-window-reset',
			handler:function(){inWarehouseForm.getForm().reset();},
			scope:this		
		};

		var inWarehousePanel = Ext.getCmp('InWarehouse-mainpanel');
		inWarehousePanel.add(inWarehouseForm);
		inWarehousePanel.getTopToolbar().add(btnGetProduct,btnSubmit,btnReset);
		inWarehousePanel.doLayout();
});
</script>
</head>
<body>
<div id="inWarehouseGridPanel"></div>
</body>
</html>