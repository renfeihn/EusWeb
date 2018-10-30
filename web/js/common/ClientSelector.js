
/***********************************************************
 *            Client Selector.                             *
 ***********************************************************/

Ext.ns('is.window.ClientSelector');

is.window.ClientSelector = function(singleSelect) {
	this.status = status;
	
	this.datastore = new Ext.data.JsonStore({
		url: 'findClient.action',
		root: 'ClientList',
		baseParams: {
			status: this.status
		},
		fields: ['id', 'code','name','address','tel','zipcode',{name:'individual', type:'int'}, 'ContactsList']
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
				  {header: '编号', dataIndex: 'id'},
				  {header: '编码', dataIndex: 'code'},
				  {header: '姓名', dataIndex: 'name'},
				  {header: '电话', dataIndex: 'tel'},
				  {header: '地址', dataIndex: 'address'},
				  {header: '邮政编码', dataIndex: 'zipcode'},
				  {header: '个人', renderer: clsys.grid.columnrender.ContactRender, dataIndex: 'individual'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.ClientSelector.superclass.constructor.call(this, {
		title: '选择客户',
		id: 'client-selector-window',
		width: 600,
		height: 400,
		resizable: false,
		plain: true,
		modal: true,
		autoScroll: true,
		buttonAlign: 'center',

		items: [ this.results ], 
		tbar: [{
			xtype: 'is-search-field',
			id: 'client-selector-search',
			store: this.datastore,
			paramName: 'search',
			width: 200,
			height:30,
			tooltip: '输入查询条件,按回车或点击查询.'
		}, '->', {
			text: '所有',
			iconCls: 'icon-prop',
			handler: function(button, event) {
				var search = Ext.getCmp('client-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('client-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: '确定',
			id: 'contract-selector-ok',
			handler: function(button) {
				var json = {
					Client:[  this.sm.getSelected().json  ]
				};
				var data = singleSelect? json : this.sm.getSelections();
				this.fireEvent('clientsSelected', {
					client: data
				});
				this.destroy();
			},
			scope: this
		}, {
			text: '取消',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});

	this.addEvents({'clientsSelected':true});

	this.sm.on('selectionchange', function(sm) {
		Ext.getCmp('contract-selector-ok').setDisabled(sm.getCount() < 1);
	});
};

Ext.extend(is.window.ClientSelector, Ext.Window, {
	updateStatus: function(status) {
		this.status = status;
		this.datastore.removeAll();
	}
});

Ext.reg('is-client-selector-window', is.window.ClientSelector);