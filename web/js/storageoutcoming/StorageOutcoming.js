Ext.ns('eus.window.StorageOutcoming');

eus.window.StorageOutcoming = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
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
	
  	/*��λ��Ϣ*/
	this.storageOutcomingItem_storageLocationStore = new Ext.data.JsonStore({
		autoDestroy:true,
		autoLoad:{params:{status:['Using']}},
		url:'findStorageLocation.action',
		baseParams:{status:'Using'},
		root:'StorageLocationList',
		fields:['id','name']
	});
	
	/*��λ*/
	var cbStorageOutcomingItem_storageLocation = {
		xtype:'combo',
		store:this.storageOutcomingItem_storageLocationStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'��ѡ���λ',
		fieldLabel:'��λ',
		selectOnFocus:true,
		id:'cbStorageOutcomingItem_storageLocation',
		valueField:'id',
		allowBlank:false,
		width:220,
		blankText:'��ѡ���λ'
	};
	
	var txtCompany = {
		xtype:'textfield',
		id:'txtCompany',
		fieldLabel:'������λ',
		readOnly:true,
		width:680,
		name:'txtCompany'
	};	
	
	var txtStorageOutcomingDate = {
		xtype:'datefield',
		id:'txtStorageOutcomingDate',
		fieldLabel:'��Ʊ����',
		allowBlank:false,
		value: new Date(),
		blankText:'��ѡ��Ʊ����',
		width:220,
		name:'txtStorageOutcomingDate'
	};

	var txtContract = {
		xtype:'textfield',
		id:'txtContract',
		fieldLabel:'��ͬ��',
		width:220,
		readOnly:true,
		name:'txtContract'
	};
	
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'��ע',
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
	 		    {header:'���',width:30,dataIndex:'contractItemNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:110,dataIndex:'productCombination'},
				{header:'��ͬ����',width:40,dataIndex:'amount'},
				{header:'������',width:40,dataIndex:'restAmount'},	
				{header:'��Դ����',width:40,dataIndex:'varAmount'},	
				{header:'�������',width:40,dataIndex:'finishedAmount'},	
				{header:'�������',width:40,dataIndex:'checkingAmount'},
				{header:'��������',width:40,dataIndex:"socAmount",editor:txtSOCAmount},
				{
					header:'�����λ',width:80,dataIndex:'storageLocation',editor:cbStorageOutcomingItem_storageLocation,hidden:true,
					renderer:function(value,metadata,record){
						var index = this.storageOutcomingItem_storageLocationStore.find('id',value);
						if(index!=-1){   
							return this.storageOutcomingItem_storageLocationStore.getAt(index).data.name;   
						}   
						return record.get('name');   
					},scope:this
				},
				{header:'��ע',width:60,dataIndex:"memo",editor:txtMemo}
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
	
	/* �����еİ�ť */
	var btnSubmit = {
		text:'����',
		id:'storageOutcoming-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'storageOutcoming-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.StorageOutcoming.superclass.constructor.call(this, {
		id:'storageOutcoming-window',
		title:'�����������뵥',
		buttonAlign:'center',
		autoHeight:true,
		width:940,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnCancel],
		items:[this.storageOutcomingForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
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
				clsys.message.info('��'+ (i+1) + '��  �����¼�ĳ���������������������!')
				return;
			}
			
			//TODO:�п�λ��ʱ����Ҫ�ſ�������
//			if (Ext.isEmpty(storageLocation)) {
//				clsys.message.info('��'+ (i+1) + '��  �����¼û��ѡ������λ��������ѡ��!')
//				return;				
//			}
			aContractItemNo.push(record.get('id'));
			aSOCAmount.push(SOCAmount);
			aStorageLocation.push(storageLocation);
			aMemoes.push(memo);
		}
		
		if (aSOCAmount.length == 0){
			clsys.message.info('��������������һ�ʼ�¼�ĳ�������!');
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
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	open:function(contractID,contractNo,companyID){
		
		this.contractID = contractID;
		this.companyID = companyID;
		this.contractNo = contractNo;
		this.mode = 'add';
		this.title = '�½��������뵥';
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
