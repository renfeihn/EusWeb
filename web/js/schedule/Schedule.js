Ext.ns('eus.window.Schedule');

eus.window.Schedule = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.scheduleID = '';
	
	/*产品类别 Store*/
	this.schedule_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*产品名称及型号 Store*/
	this.schedule_ProductCombination = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCapacitor.action',
		root:'Capacitor',
		fields:['id','productCombination']
	});	
	
	this.scheduleStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getSchedule.action',
		baseParams:{status:'Using'},
		root:'Schedule',
		fields:['id','scheduleDate','amount','memo']
	});	
	
	var cbSchedule_ProductType = {
		xtype:'combo',
		store:this.schedule_ProductType,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品类别',
		fieldLabel:'产品类别',
		selectOnFocus:true,
		id:'cbSchedule_ProductType',
		width:317,
		readOnly:true,
		blankText:'请选择产品类别',
		valueField:'id'
	};
	
	var cbSchedule_ProductCombination = {
		xtype:'combo',
		store:this.schedule_ProductCombination,
		displayField:'productCombination',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择产品名称及型号',
		fieldLabel:'产品名称及型号',
		selectOnFocus:true,
		id:'cbSchedule_ProductCombination',
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
		   					clsys.form.Util.updateCombo('cbSchedule_ProductType',temp2);
		   					var combo = Ext.getCmp('cbSchedule_ProductCombination');
		   					combo.getStore().load({
		   							params:{id:temp1},
		   							callback : function(records, opt, success) {
		   								if (success) {
		   									var record = combo.getStore().getAt(0);
		   									combo.setValue(temp1);
		   									Ext.getCmp('txtScheduleUnit').setValue(record.json.unit.name);
		   								}
		   							}
		   					});
		   				}
		   				else {
		   					Ext.getCmp('cbSchedule_ProductType').clearValue();
		   					Ext.getCmp('cbSchedule_ProductCombination').clearValue();
		   					Ext.getCmp('txtScheduleUnit').setValue(null);
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
	
	/*产品数量*/
	var txtScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleAmount',
		fieldLabel:'产品数量',
		width:300,
		allowBlank:false,
		blankText:'请输入产品数量',
		allowDecimals: false, // 允许小数点 
		allowNegative: false, // 允许负数 
		minValue:1,
		name:'txtScheduleAmount'
	};	
	
	/*计划日期*/
	var txtScheduleDate = {
		xtype:'datefield',
		id:'txtScheduleDate',
		fieldLabel:'交货期',
		width:300,
		allowBlank:false,
		blankText:'请选择交货期',
		name:'txtScheduleDate'
	};
	
	/*单位*/
	var txtScheduleUnit = {
		xtype:'textfield',
		id:'txtScheduleUnit',
		fieldLabel:'单位',
		readOnly:true,
		width:300,
		name:'txtScheduleUnit'
	};	
	
	/*备注*/
	var txtScheduleMemo = {
		xtype:'textfield',
		id:'txtScheduleMemo',
		fieldLabel:'备注',
		width:300,
		name:'txtScheduleMemo'
	};
		
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'scheduleProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'scheduleProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'scheduleProduct-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSchedule_ProductCombination,txtScheduleAmount,txtScheduleDate]		
	};
		
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[cbSchedule_ProductType,txtScheduleUnit,txtScheduleMemo]		
	};
	
	this.scheduleForm = new Ext.form.FormPanel({
		id:'capacitor-window-form',
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
							var combo = Ext.getCmp('cbSchedule_ProductCombination');
							combo.getStore().load({
									params:{id:attr.id},
									callback : function(records, opt, success) {
										if (success) {
											combo.setValue(attr.id);
											var record = combo.getStore().getAt(0);
											Ext.getCmp('txtScheduleUnit').setValue(record.json.unit.name);
											clsys.form.Util.updateCombo('cbSchedule_ProductType',attr.productTypeID);
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
	
	eus.window.Schedule.superclass.constructor.call(this, {
		id:'scheduleProduct-window',
		title:'增加计划产品',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.scheduleForm]
	});
	
	/*添加窗口相应的事件*/
	this.addEvents({'scheduleSaved':true});
};

var config = {
	/*增加*/
	upsert:function(){
		if (!this.scheduleForm.getForm().isValid()) return;
		var url = this.mode == 'add' ? 'addSchedule.action' : 'updateSchedule.action';
		var params = {
			id:this.scheduleID,
			productID:Ext.getCmp('cbSchedule_ProductCombination').getValue(),
			amount:Ext.getCmp('txtScheduleAmount').getValue(),
			scheduleDate:Ext.getCmp('txtScheduleDate').getValue(),
			memo:Ext.getCmp('txtScheduleMemo').getValue()		
		};
		
		this.scheduleForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('scheduleSaved',{});
				if (this.mode != 'add') {
					this.destroy();
				}
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	/*打开窗口*/
	open:function(scheduleID){
		this.mode = 'update';
		this.scheduleID = scheduleID;
		this.title = '修改计划';
		
		var callbackFunc = function(){
			if (this.scheduleStore.getCount()<1) return;
			var record = this.scheduleStore.getAt(0);
			Ext.getCmp('txtScheduleAmount').setValue(record.get('amount'));
			Ext.getCmp('txtScheduleMemo').setValue(record.get('memo'));
			Ext.getCmp('txtScheduleDate').setValue(record.get('scheduleDate'));
			Ext.getCmp('txtScheduleUnit').setValue(record.json.product.unit.name);
			clsys.form.Util.updateCombo('cbSchedule_ProductType',record.json.product.productType.id);
			clsys.form.Util.updateComboWithGet('cbSchedule_ProductCombination',record.json.product.id);
		};

		this.scheduleStore.load({
			params:{id:scheduleID},
			callback:callbackFunc,
			scope:this
		});
		

	},
	reset:function(){
		var resetFunc = function(btn){
			if (btn == 'yes' && this.mode == 'add'){
				this.scheduleForm.getForm().reset();
			}
			if (this.mode == 'update'){
				this.open(this.scheduleID);
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
	}
};

Ext.extend(eus.window.Schedule,Ext.Window,config);

Ext.reg('eus-schedule-product-window',eus.window.Schedule);
