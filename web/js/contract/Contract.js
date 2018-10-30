Ext.ns('eus.window.Contract');

eus.window.Contract = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.contractID = '';
	this.contractNo = '';
	
	this.companyStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCompany.action',
		baseParams:{status:'Using'},
		root:'Company',
		fields:['id','name']
	});
	
	this.contractStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getContract.action',
		baseParams:{status:'Using'},
		root:'Contract',
		fields:['id','items',
			 	{name:'company',mapping:'company.name'},'contractNo',
			 	{name:'contractDate',type:'date',dateFormat:'Y-m-d'}
		]
	});

	this.contractItemsStore = new Ext.data.JsonStore({
		autoDestroy: true,
		root: 'items',
		fields: ['id',		         
		         {name:'productTypeID',mapping:'product.productType.id'},
		         {name:'productType',mapping:'product.productType.name'},
		         {name:'productCombination',mapping:'product.productCombination'},	         
		         {name:'productID',mapping:'product.id'},
		         {name:'unit',mapping:'product.unit.name'},	
		         'contractItemNo','amount','price','duration','subTotal','memo'],
		sortInfo: {field:'contractItemNo',direction:'ASC'}
	});
	
	var cbCompany = {
		xtype:'combo',
		store:this.companyStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择合同厂商',
		fieldLabel:'合同厂商',
		selectOnFocus:true,
		id:'cbCompany',
		width:700,
		readOnly:true,
		allowBlank:false,
		blankText:'请选择合同厂商',
		valueField:'id'
	};	
	
	var txtContractDate = {
		xtype:'datefield',
		id:'txtContractDate',
		fieldLabel:'交货期',
		width:220,
		allowBlank:false,
		blankText:'请选择交货期',		
		name:'txtContractDate'
	};
	
	var txtContractNo = {
		xtype:'textfield',
		id:'txtContractNo',
		fieldLabel:'合同号',
		width:220,
		allowBlank:false,
		blankText:'请选择合同号',		
		name:'txtContractNo'
	};	
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtContractNo]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtContractDate]		
	};
	
	var Update = function(){
	  /*只有选中资料时才可以进行修改操作*/
	  var sm = Ext.getCmp('contract-contractItems-grid').getSelectionModel();
	  if (sm.getCount()<1) return;		  		
	
	  var oldResult = {
		  contractItemNo:sm.getSelected().get('contractItemNo'),			  
	      productTypeID:sm.getSelected().get('productTypeID'),
	      productID:sm.getSelected().get('productID'),
		  price:sm.getSelected().get('price'),
		  amount:sm.getSelected().get('amount'),
		  subTotal:sm.getSelected().get('subTotal'),
		  memo:sm.getSelected().get('memo'),
		  unit:sm.getSelected().get('unit'),
		  duration:sm.getSelected().get('duration')
	  };
		  
	  var contractProductWnd = Ext.getCmp('contractProduct-window');
	  if (!contractProductWnd){
		  contractProductWnd = new eus.window.ContractProduct();
		  contractProductWnd.on('update',this.updateContractProduct,this);	    		 
	  }
	  contractProductWnd.open(oldResult);
	  contractProductWnd.show();		
	};
	
	var itemGrid = {
		xtype:'grid',
		id:'contract-contractItems-grid',
		width: 920,
	 	height: 200,
	 	stripeRows: true,
	 	autoScroll: true,
	 	store:this.contractItemsStore,
	 	renderTo:'contractItemsPanel',
	 	loadMask:true,
	 	listeners:{dblclick:Update,scope:this},
	 	cm:new Ext.grid.ColumnModel({
	 		defaults: {
	 			sortable: true,
	 			width: 50
	 		},
	 		columns: [
	 		    {header: '序号',width:30, dataIndex: 'contractItemNo'},
	 			{header: '产品类别',width:50, dataIndex: 'productType'},
	 			{header: '产品名称及型号',width:150, dataIndex:'productCombination'},
	 			{header: '数量',width:30, dataIndex: 'amount'},
	 			{header: '价格',width:30, dataIndex: 'price'},
	 			{header: '小计',width:30, dataIndex: 'subTotal'},
	 			{header: '货期',width:30, dataIndex: 'duration'},
	 			{header: '单位',width:30, dataIndex: 'unit'},
	 			{header: '备注',width:40, dataIndex: 'memo'}
	 		]
	 	}),
 		viewConfig: {
 			forceFit: true
		},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:[
		      {
				text:'增加明细',
				id:'contract-add-item',
				iconCls:'icon-add',
				handler:function(btn,event){
		    	  var contractProductWnd = Ext.getCmp('contractProduct-window');
		    	  if (!contractProductWnd){
		    		  contractProductWnd = new eus.window.ContractProduct();
		    		  contractProductWnd.on('add',this.addContractProduct,this);	    		 
		    	  }
		    	  contractProductWnd.doAutoReload();
		    	  contractProductWnd.show();
		      	},
				scope:this
		      },
		      {
				text:'修改明细',
				id:'contract-update-item',
				iconCls:'icon-prop',
				handler:Update,
				scope:this 
		      },
		      {
				text:'删除明细',
				id:'contract-remove-item',
				iconCls:'icon-remove',
				handler:this.removeContractProduct,
				scope:this
		      }
		     ]
	};
	
	this.contractForm = new Ext.form.FormPanel({
		id:'contract-window-form',
		autoWidth:true,
		frame:false,
		border:false,
		labelAlign:'right',
		items:[cbCompany,{		
			layout:'column',
			frame:false,
			border:false,
			items:[col1,col2]
		},itemGrid],
		tbar:[
		      	{
		    	  text:'厂商综合查询',
		    	  iconCls: 'icon-examine',
		    	  handler:function(){
					var wnd = Ext.getCmp('company-selector-window');
					if (!wnd) {
						var wnd = new eus.window.CompanySelector();
						wnd.on('companySelected', function(attr){
							var combo = Ext.getCmp('cbCompany');
							combo.getStore().load({
									params:{id:attr.id},
									callback : function(records, opt, success) {
										if (success) {
											combo.setValue(attr.id);
											/*选择完毕后关闭窗口*/
											wnd.destroy();
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
	
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'contract-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'contract-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'contract-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.Contract.superclass.constructor.call(this, {
		id:'contract-window',
		title:'新增合同明细',
		buttonAlign:'center',
		autoHeight:true,
		width:940,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.contractForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'contractSaved':true});
};

var config = {
	/*删除明细*/
	removeContractProduct:function(){
		var selected = Ext.getCmp('contract-contractItems-grid').getSelectionModel().getSelected();
		if (!selected) return;
		Ext.getCmp('contract-contractItems-grid').getStore().remove(selected);
		/*更新序列号*/
		var store = Ext.getCmp('contract-contractItems-grid').getStore();
		for (var i=0;i<store.getCount();i++) {
			var record = store.getAt(i);
			record.set('contractItemNo',i+1);
			record.commit();
		}
	},
	/*增加明细*/
	addContractProduct:function(attributes){
		var itemNo = Ext.getCmp('contract-contractItems-grid').getStore().getCount() + 1;
		var product = {
			items:[{
				id:'',
				contractItemNo:itemNo,
				product:attributes.product,
				amount:attributes.amount,
				price:attributes.price,
				duration:attributes.duration,
				subTotal:attributes.subTotal,
				memo:attributes.memo
			}]
		};
		this.contractItemsStore.loadData(product,true);
	},
	/*修改明细*/
	updateContractProduct:function(attributes){
		var selected = Ext.getCmp('contract-contractItems-grid').getSelectionModel().getSelected();
		if (!selected) return;
		selected.set('product',attributes.product);
		selected.set('amount',attributes.amount);
		selected.set('price',attributes.price);
		selected.set('duration',attributes.duration);
		selected.set('subTotal',attributes.subTotal);
		selected.set('memo',attributes.memo);
		selected.commit();
	},
	/*新增和修改*/
	upsert:function(){
		if (!this.contractForm.getForm().isValid()) return;
		var len = this.contractItemsStore.getCount();
		if (len<=0){
			clsys.message.info('请填写合同内容!');
			return;
		}
		
		var aContractItemNo=[],aProductID=[], aPrice=[],aAmount=[];
		var aSubTotal=[],aDuration=[],aMemo=[];
		for (var i=0;i<len;i++){
			var record = this.contractItemsStore.getAt(i);
			aContractItemNo.push(record.get('contractItemNo'));
			aProductID.push(record.get('productID'));
			aPrice.push(record.get('price'));
			aAmount.push(record.get('amount'));
			aSubTotal.push(record.get('subTotal'));
			aDuration.push(record.get('duration'));
			aMemo.push(record.get('memo'));	
		}
		
		var url = this.mode == 'add' ? 'addContract.action' : 'updateContract.action';
		var strTempNo = this.contractNo.split("-");
		var strTempCNo = '';
		
		if (this.mode == 'add') {
			strTempCNo = Ext.getCmp('txtContractNo').getValue();
		} else {
			strTempCNo = strTempNo[0]+ '-' + Ext.getCmp('txtContractNo').getValue() + '-' +strTempNo[2];
		}

		var params = {
			id:this.contractID,
			contractNo:strTempCNo,
			contractItemNo:aContractItemNo,
			companyID:Ext.getCmp('cbCompany').getValue(),
			contractDate:Ext.getCmp('txtContractDate').getValue(),
			ProductIDs:aProductID,
			Prices:aPrice,
			Amounts:aAmount,
			SubTotals:aSubTotal,
			Durations:aDuration,
			Memoes:aMemo
		};

		this.contractForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('contractSaved',{});
				this.destroy();
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	/*修改时打开窗口*/
	open:function(contractID){
		
		this.contractID = contractID;
		this.mode = 'update';
		this.title = '修改合同';
		
		var callbackFunc = function(){
			if (this.contractStore.getCount()<1) return;
			var record = this.contractStore.getAt(0);
			if (record){
				this.contractNo = record.json.contractNo;
				clsys.form.Util.updateComboWithGet('cbCompany',record.json.company.id);
				Ext.getCmp('txtContractDate').setValue(record.json.contractDate);
				var strTemp = record.json.contractNo.split("-");
				Ext.getCmp('txtContractNo').setValue(strTemp[1]);
				this.contractItemsStore.loadData(record.json);				
			}
		};

		this.contractStore.load({
			params:{id:contractID},
			callback:callbackFunc,
			scope:this
		});
	},
	/*重置*/
	reset:function(){
		var resetFunc = function(btn){
			var ID = this.contractID;
			if (btn == 'yes' && this.mode == 'add'){
				this.contractForm.getForm().reset();
			}
			if (this.mode == 'update'){
				this.open(ID);
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
	/*只有新增的时需要auto-load*/
	doAutoReload:function(){
//		this.companyStore.baseParams = {status:'Using'};
//		this.companyStore.reload();
	}
};

Ext.extend(eus.window.Contract,Ext.Window,config);

Ext.reg('eus-contract-window',eus.window.Contract);
