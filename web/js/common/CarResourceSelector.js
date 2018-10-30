
/* ----------------------------------------------------------
 *         Car Selector.                                    *
 * ---------------------------------------------------------*/

Ext.ns('is.window.CarResourceSelector');

is.window.CarResourceSelector = function(states) {
	this.datastore = new Ext.data.JsonStore({
		url: 'findCarResource.action',
		root: 'CarResourceList',
		baseParams: {
			states: states
		},
		fields: ['id',
			 {name:'model', mapping:'model.name'}, 
			 {name:'suite', mapping:'suite.name'},
			 {name:'color', mapping:'color.name'}, 
			 {name:'decoration', mapping:'decoration.name'},
			 {name:'productDate', type:'date'},
			 {name: 'state', type:'int'},
			 {name:'frame', mapping:'car.frame'},
			 {name:'engine', mapping:'car.engine'},
			 {name:'certificate', mapping:'car.certificate'},
			 {name:'productDate', mapping:'car.productDate', type:'date'}]
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
			    {header: '״̬', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: '����', dataIndex: 'model'},
	        	{header: '��ɫ', dataIndex: 'color'},
	        	{header: '����', dataIndex: 'decoration'},
	        	{header: '���ܺ�', dataIndex: 'frame'},
	        	{header: '��������', dataIndex: 'engine'},
	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
	        	{header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: this.sm
	});

	is.window.CarResourceSelector.superclass.constructor.call(this, {
		title: 'ѡ����',
		id: 'car-resource-selector-window',
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
			id: 'car-resource-selector-search',
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
				var search = Ext.getCmp('car-resource-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('car-resource-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			handler: function(button) {
				this.fireEvent('carResourceSelected', {
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

	this.addEvents({'carResourceSelected':true});
};

Ext.extend(is.window.CarResourceSelector, Ext.Window, {
});

Ext.reg('is-car-resource-selector-window', is.window.CarResourceSelector);
