Ext.ns('eus.window.StorageOutcoming');

eus.window.StorageOutcoming = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.contractID = '';
	this.contractNo = '';
	this.companyID = '';
		
	this.companyForSOCStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCompany.action',
		baseParams:{status:'Using'},
		root:'Company',
		fields:['id','name','contract','delegatee']
	});
	
	this.contractGetItemsForSOCStore = new Ext.data.JsonStore({
  		url:'getContractView.action',
  		root:'ContractView',
		fields: ['id','items']
  	});

  	this.contractItemsForSOCStore = new Ext.data.JsonStore({
  		autoDestroy:true,
  		root:'items',
  		fields:['id','amount','price','originalPrice','subTotal','finishedAmount','checkingAmount',
  		        'restAmount','varAmount',
  		      	{name:'contractItemNo', type:'int'},
	  	        {name:'productCombination',mapping:'product.productCombination'}],
 		sortInfo: {field:'contractItemNo',direction:'ASC'} 
  	});
	
  	/*库位信息*/
	this.storageOutcomingItem_storageLocationStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using']}},
		url:'findStorageLocation.action',
		baseParams:{status:'Using'},
		root:'StorageLocationList',
		fields:['id','name']
	});
	
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
	
	var txtCompany = {
		xtype:'textfield',
		id:'txtCompany',
		fieldLabel:'购货单位',
		readOnly:true,
		width:680,
		name:'txtCompany'
	};	
	
	var txtStorageOutcomingDate = {
		xtype:'datefield',
		id:'txtStorageOutcomingDate',
		fieldLabel:'开票日期',
		allowBlank:false,
		value: new Date(),
		blankText:'请选择开票日期',
		width:220,
		name:'txtStorageOutcomingDate'
	};

	var txtContract = {
		xtype:'textfield',
		id:'txtContract',
		fieldLabel:'合同号',
		width:220,
		readOnly:true,
		name:'txtContract'
	};
	
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'备注',
		width:220,
		readOnly:false,
		name:'txtMemo'
	};
				
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtContract]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtStorageOutcomingDate]		
	};
	
	var txtSOCAmount = new Ext.form.NumberField({
		allowBlank:true,
		allowNegative:false
	});
	
	var itemGrid = new Ext.grid.EditorGridPanel({
		id:'storageOutcoming-storageOutcomingItems-grid',
		width: 920,
	 	height: 250,
	 	stripeRows: true,
	 	autoScroll: true,
	 	store:this.contractItemsForSOCStore,
	 	renderTo:'storageOutcomingItemsPanel',
	 	clicksToEdit:1,
	 	cm:new Ext.grid.ColumnModel({
	 		defaults: {
	 			sortable: true,
	 			width: 50
	 		},
	 		columns: [
	 		    {header:'序号',width:30,dataIndex:'contractItemNo'},
				{header:'产品名称及型号',width:110,dataIndex:'productCombination'},
				{header:'合同数量',width:40,dataIndex:'amount'},
				{header:'库存结余',width:40,dataIndex:'restAmount'},	
				{header:'资源数量',width:40,dataIndex:'varAmount'},	
				{header:'完成数量',width:40,dataIndex:'finishedAmount'},	
				{header:'审核数量',width:40,dataIndex:'checkingAmount'},
				{header:'出库数量',width:40,dataIndex:"socAmount",editor:txtSOCAmount},
				{
					header:'出库库位',width:80,dataIndex:'storageLocation',editor:cbStorageOutcomingItem_storageLocation,hidden:true,
					renderer:function(value,metadata,record){
						var index = this.storageOutcomingItem_storageLocationStore.find('id',value);
						if(index!=-1){   
							return this.storageOutcomingItem_storageLocationStore.getAt(index).data.name;   
						}   
						return record.get('name');   
					},scope:this
				},
				{header:'备注',width:60,dataIndex:"memo",editor:txtMemo}
	 		]
	 	}),
 		viewConfig: {
 			forceFit: true
		},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	this.storageOutcomingForm = new Ext.form.FormPanel({
		id:'storageOutcoming-window-form',
		autoWidth:true,
		frame:false,
		border:false,
		labelAlign:'right',
		items:[txtCompany,{		
			layout:'column',
			frame:false,
			border:false,
			items:[
			       {
			    	columnWidth: 1/2,
			    	border: false,
			    	frame: false,
			    	layout: 'form',
			    	items: [col1]},
			    	{	
			    	columnWidth: 1/2,
					border: false,
					frame: false,
					layout: 'form',
					items: [col2]}
			       ]
		},itemGrid]
	});
	
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'storageOutcoming-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'关闭',
		id:'storageOutcoming-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.StorageOutcoming.superclass.constructor.call(this, {
		id:'storageOutcoming-window',
		title:'新增出库申请单',
		buttonAlign:'center',
		autoHeight:true,
		width:940,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.storageOutcomingForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'storageOutcomingSaved':true});
};

var config = {
	upsert:function(){
	    if (!this.storageOutcomingForm.getForm().isValid()) return;
	    
		var len = this.contractItemsForSOCStore.getCount();	
		var aContractItemNo=[],aSOCAmount=[],aStorageLocation=[],aMemoes=[];
		
		for (var i=0;i<len;i++){
			var record = this.contractItemsForSOCStore.getAt(i);
			var SOCAmount = record.get('socAmount');
			var storageLocation = record.get('storageLocation');
			var memo = record.get('memo');
			
			if (Ext.isEmpty(SOCAmount)) continue;
			
			var amount = record.get('amount');
			var finishedAmount = record.get('finishedAmount');
			var checkingAmount = record.get('checkingAmount');
			var restAmount = amount - finishedAmount - checkingAmount - SOCAmount;
			if (restAmount < 0) {
				clsys.message.info('第'+ (i+1) + '条  出库记录的出库数量过大，请重新输入!')
				return;
			}
			
			//TODO:有库位的时候需要放开此设置
//			if (Ext.isEmpty(storageLocation)) {
//				clsys.message.info('第'+ (i+1) + '条  出库记录没有选择出库库位，请重新选择!')
//				return;				
//			}
			aContractItemNo.push(record.get('id'));
			aSOCAmount.push(SOCAmount);
			aStorageLocation.push(storageLocation);
			aMemoes.push(memo);
		}
		
		if (aSOCAmount.length == 0){
			clsys.message.info('请输入至少输入一笔记录的出库数量!');
			return;						
		}
		
		var url = 'addStorageOutcoming.action';
		var params = {
			contractID:this.contractID,
			contractItemNos:aContractItemNo,
			SOCAmounts:aSOCAmount,
			memoes:aMemoes,
			storageOutcomingDate:Ext.getCmp('txtStorageOutcomingDate').getValue(),
			storageLocations:aStorageLocation
		};
		
		this.storageOutcomingForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('storageOutcomingSaved',{});
				this.destroy();
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	open:function(contractID,contractNo,companyID){
		
		this.contractID = contractID;
		this.companyID = companyID;
		this.contractNo = contractNo;
		this.mode = 'add';
		this.title = '新建出库申请单';
		var callbackFunc = function(){
			if (this.companyForSOCStore.getCount()<1) return;
			var record = this.companyForSOCStore.getAt(0);
			Ext.getCmp('txtCompany').setValue(record.get('name')+" (" + record.get('delegatee') +")");
			Ext.getCmp('txtContract').setValue(contractNo);
		};
		
		this.companyForSOCStore.load({
			params:{id:companyID},
			callback:callbackFunc,
			scope:this
		});
		
		this.contractGetItemsForSOCStore.reload({
			params:{id:contractID},
			callback:function(r,o,s){
				var rc = this.contractGetItemsForSOCStore.getAt(0);
				if (rc) {
					this.contractItemsForSOCStore.loadData(rc.json);
				}
			},
			scope:this});
	}
};

Ext.extend(eus.window.StorageOutcoming,Ext.Window,config);

Ext.reg('eus-storageOutcoming-window',eus.window.StorageOutcoming);
