Ext.ns('eus.window.Schedule');

eus.window.Schedule = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	this.scheduleID = '';
	
	/*��Ʒ��� Store*/
	this.schedule_ProductType = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProductType.action',
		baseParams:{status:'Using'},
		root:'ProductTypeList',
		fields:['id','name']
	});
	
	/*��Ʒ���Ƽ��ͺ� Store*/
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
		emptyText:'��ѡ���Ʒ���',
		fieldLabel:'��Ʒ���',
		selectOnFocus:true,
		id:'cbSchedule_ProductType',
		width:317,
		readOnly:true,
		blankText:'��ѡ���Ʒ���',
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
		emptyText:'��ѡ���Ʒ���Ƽ��ͺ�',
		fieldLabel:'��Ʒ���Ƽ��ͺ�',
		selectOnFocus:true,
		id:'cbSchedule_ProductCombination',
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
	
	/*��Ʒ����*/
	var txtScheduleAmount = {
		xtype:'textfield',
		id:'txtScheduleAmount',
		fieldLabel:'��Ʒ����',
		width:300,
		allowBlank:false,
		blankText:'�������Ʒ����',
		allowDecimals: false, // ����С���� 
		allowNegative: false, // ������ 
		minValue:1,
		name:'txtScheduleAmount'
	};	
	
	/*�ƻ�����*/
	var txtScheduleDate = {
		xtype:'datefield',
		id:'txtScheduleDate',
		fieldLabel:'������',
		width:300,
		allowBlank:false,
		blankText:'��ѡ�񽻻���',
		name:'txtScheduleDate'
	};
	
	/*��λ*/
	var txtScheduleUnit = {
		xtype:'textfield',
		id:'txtScheduleUnit',
		fieldLabel:'��λ',
		readOnly:true,
		width:300,
		name:'txtScheduleUnit'
	};	
	
	/*��ע*/
	var txtScheduleMemo = {
		xtype:'textfield',
		id:'txtScheduleMemo',
		fieldLabel:'��ע',
		width:300,
		name:'txtScheduleMemo'
	};
		
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'scheduleProduct-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'scheduleProduct-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
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
		    	  text:'��Ʒ�ۺϲ�ѯ',
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
		title:'���Ӽƻ���Ʒ',
		buttonAlign:'center',
		autoHeight:true,
		width:990,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.scheduleForm]
	});
	
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'scheduleSaved':true});
};

var config = {
	/*����*/
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
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	/*�򿪴���*/
	open:function(scheduleID){
		this.mode = 'update';
		this.scheduleID = scheduleID;
		this.title = '�޸ļƻ�';
		
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

Ext.extend(eus.window.Schedule,Ext.Window,config);

Ext.reg('eus-schedule-product-window',eus.window.Schedule);
