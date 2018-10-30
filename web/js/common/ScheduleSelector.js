
/***********************************************************
 *            Schedule Selector.                             *
 ***********************************************************/

Ext.ns('clsys.window.ScheduleSelector');

clsys.window.ScheduleSelector = function(singleSelect) {
	this.status = status;
	
	this.datastore = new Ext.data.JsonStore({
		url: 'findProductSchedule.action',
		root: 'ScheduleList',
	  	fields:['id','scheduleNo','productCombination','scheduleDate',
	  	      	'amount','finishedAmount','memo','contractNo','q1','q2','q3','q4',
	  	        {name:'productName',mapping:'product.productName'},
		        {name:'productCode',mapping:'product.productCode.code'},
		        {name:'voltage',mapping:'product.voltage'},
		        {name:'capacity',mapping:'product.capacity'},
		        {name:'humidity',mapping:'product.humidity.code'},
		        {name:'errorLevel',mapping:'product.errorLevel.code'}] 
	});
	
	this.sm = new Ext.grid.CheckboxSelectionModel({singleSelect: singleSelect ? true: false});
	    
	this.results = new Ext.grid.GridPanel({
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
				this.sm,
			    {header:'�ƻ����',width:80,dataIndex:'scheduleNo'},
				{header:'��Ʒ���Ƽ��ͺ�',width:150,renderer:clsys.grid.columnrender.ProductCombination,dataIndex:'id'},
				{header:'�ƻ�����',width:40,dataIndex:'amount'},
				{header:'�������',width:40,dataIndex:'finishedAmount'},	
				{header:'һ��',width:20,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q1'},
				{header:'����',width:20,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q2'},
				{header:'����',width:20,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q3'},
				{header:'�ļ�',width:20,renderer:clsys.grid.columnrender.Quarter,dataIndex:'q4'},				
				{header:'�ƻ�����',width:80,dataIndex:'scheduleDate'},
				{header:'��ͬ��',width:100,dataIndex:'contractNo'},
				{header:'��ע',width:50,dataIndex:'memo'}	
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	clsys.window.ScheduleSelector.superclass.constructor.call(this, {
		title: 'ѡ��ƻ�',
		id: 'schedule-selector-window',
		width:1200,
		height: 400,
		resizable: false,
		plain: true,
		modal: true,
		autoScroll: true,
		buttonAlign: 'center',
		items: [ this.results ], 
		buttons: [{
			text: 'ȷ��',
			id: 'storageincoming-selector-ok',
			handler: function(button) {
				var json = {
					Schedule:[  this.sm.getSelected().json  ]
				};
				var data = singleSelect? json : this.sm.getSelections();
				this.fireEvent('schedulesSelected', {
					schedule: data
				});
				this.destroy();
			},
			scope: this
		}, {
			text: 'ȡ��',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});

	this.addEvents({'schedulesSelected':true});

	this.sm.on('selectionchange', function(sm) {
		Ext.getCmp('storageincoming-selector-ok').setDisabled(sm.getCount() < 1);
	});
};

Ext.extend(clsys.window.ScheduleSelector, Ext.Window, {
	updateStatus: function(status) {
		this.status = status;
		this.datastore.removeAll();
	},
	doAutoReload:function(productID){
		/*�г����õļƻ�state=0,���Ҽƻ��еĲ�Ʒ��ѡ��Ĳ�Ʒһ��*/
		this.datastore.baseParams = {productID:productID};
		this.datastore.reload();
	}
});
									
Ext.reg('clsys-schedule-selector-window', clsys.window.ScheduleSelector);