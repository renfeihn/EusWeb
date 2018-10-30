Ext.ns('eus.window.StorageIncoming');

eus.window.StorageIncoming = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.storageIncomingID = '';
	
	this.storageIncomingStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getStorageIncoming.action',
		baseParams:{status:'Using'},
		root:'StorageIncoming',
		fields:['id',{name:'sicDate',type:'date',dateFormat:'Y-m-d'}]
	});

	this.storageIncomingItemsStore = new Ext.data.JsonStore({
		autoDestroy: true,
		root: 'items',
		fields: ['id','sicItemNo','amount','jobCmdNo','voltage','productionDate',
		         'capacity','humidity','productCode','memo','schedule',
		         {name:'storageLocation_id',mapping:'storageLocation.id'},
		         {name:'storageLocation',mapping:'storageLocation.name'},		         
		         {name:'productCombination',mapping:'productCombination.productName'},
		         {name:'productType_id',mapping:'productType.id'},
		         {name:'productCombination_id',mapping:'productCombination.id'}
		]
	});
	
	var Update = function(){
	  /*只有选中资料时才可以进行修改操作*/
	  var sm = Ext.getCmp('storageIncoming-storageIncomingItems-grid').getSelectionModel();
	  if (sm.getCount()<1) return;		  		
	
	  var oldResult = {
	      id:sm.getSelected().get('id'),
		  schedule:sm.getSelected().get('schedule'),
		  storageLocation:sm.getSelected().get('storageLocation_id'),
		  sicItemNo:sm.getSelected().get('sicItemNo'),
	      productType:sm.getSelected().get('productType_id'),
	      productCombination:sm.getSelected().get('productCombination_id'),
	      voltage:sm.getSelected().get('voltage'),
		  amount:sm.getSelected().get('amount'),
		  capacity:sm.getSelected().get('capacity'),
		  memo:sm.getSelected().get('memo'),
		  humidity:sm.getSelected().get('humidity'),
		  productCode:sm.getSelected().get('productCode'),
		  jobCmdNo:sm.getSelected().get('jobCmdNo'),
		  productionDate:sm.getSelected().get('productionDate')
	  };
		  
	  var storageIncomingProductWnd = Ext.getCmp('storageIncomingProduct-window');
	  if (!storageIncomingProductWnd){
		  storageIncomingProductWnd = new eus.window.StorageIncomingProduct();
		  storageIncomingProductWnd.on('update',this.updateStorageIncomingProduct,this);	    		 
	  }
	  storageIncomingProductWnd.show();	
	  storageIncomingProductWnd.open(oldResult);
	};

	var itemGrid = {
		xtype:'grid',
		id:'storageIncoming-storageIncomingItems-grid',
		width: 920,
	 	height: 250,
	 	stripeRows: true,
	 	autoScroll: true,
	 	store:this.storageIncomingItemsStore,
	 	renderTo:'storageIncomingItemsPanel',
	 	loadMask:true,
	 	listeners:{dblclick:Update,scope:this},
	 	cm:new Ext.grid.ColumnModel({
	 		defaults: {
	 			sortable: true,
	 			width: 50
	 		},
	 		columns: [
	 			{header: '序号',width:30,dataIndex: 'sicItemNo'},
	 			{header: '产品名称及型号',width:150,dataIndex: 'productCombination'},
	 			{header: '工作令号', width:50,dataIndex: 'jobCmdNo'},
	 			{header: '电压(V)',width:50, dataIndex: 'voltage'},
	 			{header: '容量(PF)',width:50, dataIndex: 'capacity'},
	 			{header: '组别', width:30,dataIndex: 'humidity'},
	 			{header: '等级', width:30,dataIndex: 'productCode'},
	 			{header: '数量', width:30,dataIndex: 'amount'},
	 			{header: '库位', width:80,dataIndex: 'storageLocation'},
	 			{header: '生产日期', width:60,dataIndex:'productionDate'},
	 			{header: '备注', width:110,dataIndex: 'memo'}	 			
	 		]
	 	}),
 		viewConfig: {
 			forceFit: true
		},
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:[
		      {
				text:'增加明细',
				id:'storageIncoming-add-item',
				iconCls:'icon-add',
				handler:function(btn,event){
		    	  var storageIncomingProductWnd = Ext.getCmp('storageIncomingProduct-window');
		    	  if (!storageIncomingProductWnd){
		    		  storageIncomingProductWnd = new eus.window.StorageIncomingProduct();
		    		  storageIncomingProductWnd.on('add',this.addStorageIncomingProduct,this);	    		 
		    	  }
		    	  storageIncomingProductWnd.doAutoReload();
		    	  storageIncomingProductWnd.show();
		      	},
				scope:this
		      },
		      {
				text:'修改明细',
				id:'storageIncoming-update-item',
				iconCls:'icon-prop',
				handler:Update,
				scope:this 
		      },
		      {
				text:'删除明细',
				id:'storageIncoming-remove-item',
				iconCls:'icon-remove',
				handler:this.removeStorageIncomingProduct,
				scope:this
		      }
		     ]
	};
	
	this.storageIncomingForm = new Ext.form.FormPanel({
		id:'storageIncoming-window-form',
		autoWidth:true,
		frame:false,
		border:false,
		labelAlign:'right',
		items:[itemGrid]
	});
	
	/* 窗口中的按钮 */
	var btnSubmit = {
		text:'保存',
		id:'storageIncoming-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'重置',
		id:'storageIncoming-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		id:'storageIncoming-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*设置窗口属性和含有控件*/
	eus.window.StorageIncoming.superclass.constructor.call(this, {
		id:'storageIncoming-window',
		title:'新增入库单明细',
		buttonAlign:'center',
		autoHeight:true,
		width:940,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.storageIncomingForm]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'storageIncomingSaved':true});
};

var config = {
	/*删除明细*/
	removeStorageIncomingProduct:function(){
		var selected = Ext.getCmp('storageIncoming-storageIncomingItems-grid').getSelectionModel().getSelected();
		if (!selected) return;
		Ext.getCmp('storageIncoming-storageIncomingItems-grid').getStore().remove(selected);	
	},
	/*增加明细*/
	addStorageIncomingProduct:function(attributes){
		var sicItemNo = Ext.getCmp('storageIncoming-storageIncomingItems-grid').getStore().getCount() + 1;
		var product = {
			items:[{
				id:'',
				sicItemNo:sicItemNo,
				schedule:attributes.schedule,
				storageLocation:attributes.storageLocation,
				productType:attributes.productType,
				productCombination:attributes.productCombination,
				jobCmdNo:attributes.jobCmdNo,
				voltage:attributes.voltage,
				amount:attributes.amount,
				capacity:attributes.capacity,
				productCode:attributes.productCode,
				humidity:attributes.humidity,
				memo:attributes.memo,
				productionDate:new Date(attributes.productionDate).format('Y-m-d')
			}]
		};
		
		this.storageIncomingItemsStore.loadData(product,true);
	},
	/*修改明细*/
	updateStorageIncomingProduct:function(attributes){
		var len = this.storageIncomingItemsStore.getCount();
		for (var i=0;i<len;i++){
			var record = this.storageIncomingItemsStore.getAt(i);
			if (attributes.sicItemNo == record.get('sicItemNo')){
				record.set('schedule',attributes.schedule);
				record.set('storageLocation',attributes.storageLocation.name);
				record.set('storageLocation_id',attributes.storageLocation.id);			
				record.set('jobCmdNo',attributes.jobCmdNo);
				record.set('voltage',attributes.voltage);
				record.set('amount',attributes.amount);
				record.set('capacity',attributes.capacity);
				record.set('humidity',attributes.humidity);
				record.set('productCode',attributes.productCode);
				record.set('memo',attributes.memo);
				record.set('productType_id',attributes.productType.id);
				record.set('productCombination',attributes.productCombination.productName);
				record.set('productCombination_id',attributes.productCombination.id);
				record.set('productionDate',attributes.productionDate);
				record.commit();
				return;
			}
		}
	},
	/*新增和修改*/
	upsert:function(){
		
		var len = this.storageIncomingItemsStore.getCount();
		if (len<=0){
			clsys.message.info('请填写入库单内容!');
			return;
		}
		
		var aSicItemNo=[],aProductID=[],aAmount=[],aJobCmdNo=[],aSchedule=[],aStorageLocation=[],aProductionDate=[];
		for (var i=0;i<len;i++){
			var record = this.storageIncomingItemsStore.getAt(i);
			aSicItemNo.push(record.get('sicItemNo'));
			aProductID.push(record.json.productCombination.id);
			aJobCmdNo.push(record.get('jobCmdNo'));
			aAmount.push(record.get('amount'));
			aSchedule.push(record.get('schedule'));
			aStorageLocation.push(record.json.storageLocation.id);
			aProductionDate.push(record.get('productionDate'));
		}
		
		var url = this.mode == 'add' ? 'addStorageIncoming.action' : 'updateStorageIncoming.action';
		var params = {
			id:this.storageIncomingID,
			itemNos:aSicItemNo,
			productIDs:aProductID,
			amounts:aAmount,
			jobCmdNos:aJobCmdNo,
			storageLocationIDs:aStorageLocation,
			scheduleIDs:aSchedule,
			ProductionDates:aProductionDate
		};
		
		/*成功时的处理函数*/
		var successFunc = function(response,opts){
			var result = Ext.decode(response.responseText);
			if (result.success) {
				this.fireEvent('storageIncomingSaved',{});
				this.destroy();
			}
			else {
				clsys.message.error(result.msg);
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
	},
	/*修改时打开窗口*/
	open:function(storageIncomingID){
		
		this.storageIncomingID = storageIncomingID;
		this.mode = 'update';
		this.title = '修改入库单';
		
		var callbackFunc = function(){
			if (this.storageIncomingStore.getCount()<1) return;
			var record = this.storageIncomingStore.getAt(0);
		};

		this.storageIncomingStore.load({
			params:{id:storageIncomingID},
			callback:callbackFunc,
			scope:this
		});
	},
	/*重置*/
	reset:function(){
		var resetFunc = function(btn){
			var ID = this.storageIncomingID;
			if (btn == 'yes' && this.mode == 'add'){
				this.storageIncomingForm.getForm().reset();
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

	}
};

Ext.extend(eus.window.StorageIncoming,Ext.Window,config);

Ext.reg('eus-storageIncoming-window',eus.window.StorageIncoming);
