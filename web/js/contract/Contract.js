Ext.ns('eus.window.Contract');

eus.window.Contract = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
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
		emptyText:'��ѡ���ͬ����',
		fieldLabel:'��ͬ����',
		selectOnFocus:true,
		id:'cbCompany',
		width:700,
		readOnly:true,
		allowBlank:false,
		blankText:'��ѡ���ͬ����',
		valueField:'id'
	};	
	
	var txtContractDate = {
		xtype:'datefield',
		id:'txtContractDate',
		fieldLabel:'������',
		width:220,
		allowBlank:false,
		blankText:'��ѡ�񽻻���',		
		name:'txtContractDate'
	};
	
	var txtContractNo = {
		xtype:'textfield',
		id:'txtContractNo',
		fieldLabel:'��ͬ��',
		width:220,
		allowBlank:false,
		blankText:'��ѡ���ͬ��',		
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
	  /*ֻ��ѡ������ʱ�ſ��Խ����޸Ĳ���*/
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
	 		    {header: '���',width:30, dataIndex: 'contractItemNo'},
	 			{header: '��Ʒ���',width:50, dataIndex: 'productType'},
	 			{header: '��Ʒ���Ƽ��ͺ�',width:150, dataIndex:'productCombination'},
	 			{header: '����',width:30, dataIndex: 'amount'},
	 			{header: '�۸�',width:30, dataIndex: 'price'},
	 			{header: 'С��',width:30, dataIndex: 'subTotal'},
	 			{header: '����',width:30, dataIndex: 'duration'},
	 			{header: '��λ',width:30, dataIndex: 'unit'},
	 			{header: '��ע',width:40, dataIndex: 'memo'}
	 		]
	 	}),
 		viewConfig: {
 			forceFit: true
		},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:[
		      {
				text:'������ϸ',
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
				text:'�޸���ϸ',
				id:'contract-update-item',
				iconCls:'icon-prop',
				handler:Update,
				scope:this 
		      },
		      {
				text:'ɾ����ϸ',
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
		    	  text:'�����ۺϲ�ѯ',
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
											/*ѡ����Ϻ�رմ���*/
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
	
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'contract-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'contract-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'contract-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.Contract.superclass.constructor.call(this, {
		id:'contract-window',
		title:'������ͬ��ϸ',
		buttonAlign:'center',
		autoHeight:true,
		width:940,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.contractForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'contractSaved':true});
};

var config = {
	/*ɾ����ϸ*/
	removeContractProduct:function(){
		var selected = Ext.getCmp('contract-contractItems-grid').getSelectionModel().getSelected();
		if (!selected) return;
		Ext.getCmp('contract-contractItems-grid').getStore().remove(selected);
		/*�������к�*/
		var store = Ext.getCmp('contract-contractItems-grid').getStore();
		for (var i=0;i<store.getCount();i++) {
			var record = store.getAt(i);
			record.set('contractItemNo',i+1);
			record.commit();
		}
	},
	/*������ϸ*/
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
	/*�޸���ϸ*/
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
	/*�������޸�*/
	upsert:function(){
		if (!this.contractForm.getForm().isValid()) return;
		var len = this.contractItemsStore.getCount();
		if (len<=0){
			clsys.message.info('����д��ͬ����!');
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
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	/*�޸�ʱ�򿪴���*/
	open:function(contractID){
		
		this.contractID = contractID;
		this.mode = 'update';
		this.title = '�޸ĺ�ͬ';
		
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
	/*����*/
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
			titile:'ȷ������', 
			buttons:Ext.MessageBox.YESNO,
			msg:'�Ƿ����ò�Ʒ��Ϣ', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	/*ֻ��������ʱ��Ҫauto-load*/
	doAutoReload:function(){
//		this.companyStore.baseParams = {status:'Using'};
//		this.companyStore.reload();
	}
};

Ext.extend(eus.window.Contract,Ext.Window,config);

Ext.reg('eus-contract-window',eus.window.Contract);
