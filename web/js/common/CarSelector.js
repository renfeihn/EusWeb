
/* ----------------------------------------------------------
 *         Car Selector.                                    *
 * ---------------------------------------------------------*/

Ext.ns('is.window.CarSelector');

is.window.CarSelector = function(states) {
	this.states = states;

	this.datastore = new Ext.data.JsonStore({
		url: 'findCar.action',
		root: 'CarList',
		baseParams: {
			states: this.states,
			status: ['Using']
		},
		fields: ['id',
		         {name:'model', mapping:'model.name'}, 
		         {name:'suite', mapping:'suite.name'},
		         {name:'color', mapping:'color.name'}, 
		         {name:'decoration', mapping:'decoration.name'},
		         'frame', 'engine', 'certificate', 
		         {name:'productDate', type:'date', dateFormat:'Y-m-d'},
		         {name: 'state', type:'int'}]
	});

	this.sm = new Ext.grid.CheckboxSelectionModel();
	    
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
	        	{header: '����', dataIndex: 'model'},
	        	{header: '����', dataIndex: 'suite'},
	        	{header: '��ɫ', dataIndex: 'color'},
	        	{header: '����', dataIndex: 'decoration'},
	        	{header: '���ܺ�', dataIndex: 'frame'},
	        	{header: '��������', dataIndex: 'engine'},
	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
	        	{header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'},
	        	{header: '״̬', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: 'ʵ��״̬', renderer: clsys.grid.columnrender.CarStatusRender, dataIndex: 'carstate'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.CarSelector.superclass.constructor.call(this, {
		title: 'ѡ����',
		id: 'car-selector-window',
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
			id: 'car-selector-search',
			//emptyText: '�����ѯ����,���س�������ѯ',
			store: this.datastore,
			paramName: 'search',
			width: 400,
			height:30,
			tooltip: '�����ѯ����,���س�������ѯ.'
		}, '->', {
			text: '����',
			iconCls: 'icon-prop',
			handler: function(button, event) {
				var search = Ext.getCmp('car-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('car-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			handler: function(button) {
				this.fireEvent('carsSelected', {
					records: this.sm.getSelections()
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

	this.addEvents({'carsSelected':true});
};

Ext.extend(is.window.CarSelector, Ext.Window, {
	updateStatus: function(states) {
		this.states = states;
		this.datastore.removeAll();
	}
});

Ext.reg('is-car-selector-window', is.window.CarSelector);
