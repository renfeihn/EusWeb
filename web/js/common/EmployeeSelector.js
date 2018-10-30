
/* ----------------------------------------------------------
 *         Employee Selector.                               *
 * ---------------------------------------------------------*/

Ext.ns('is.window.EmployeeSelector');

is.window.EmployeeSelector = function() {

	this.datastore = new Ext.data.JsonStore({
		url: 'findEmployee.action',
		root: 'EmployeeList',
		baseParams: {
			status: ['Using']
		},
		fields: ['id', 'position', 
	         {name:'level', mapping:'position.level'},
	         {name:'department', mapping:'position.department'},
	         'name', 'code']
	});
	    
	this.results = new Ext.grid.GridPanel({
		store: this.datastore,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
	        	{header: '���', dataIndex: 'code'},
	        	{header: '����', dataIndex: 'name'},
	        	{header: '����', renderer: clsys.grid.columnrender.DepartmentRender, dataIndex: 'department'},
	        	{header: '����', renderer: clsys.grid.columnrender.LevelRender, dataIndex: 'level'},
	        	{header: '��λ', renderer: clsys.grid.columnrender.PositionRender, dataIndex: 'position'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({single:true})
	});

	is.window.EmployeeSelector.superclass.constructor.call(this, {
		title: 'ѡ��Ա��',
		id: 'employee-selector-window',
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
			id: 'employee-selector-search',
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
				var search = Ext.getCmp('employee-selector-search');
				if (search.getRawValue() != '') {
					search.reset();
					Ext.getCmp('employee-selector-search').onTrigger1Click();
				} else {
					this.datastore.reload();
				}
			},
			scope: this
		}],
		buttons: [{
			text: 'ȷ��',
			id: 'employee-selector-select',
			disabled: true,
			handler: function(button) {
				var record = this.results.getSelectionModel().getSelected();
				this.fireEvent('employeeSelected', {
					employee: record
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

	this.addEvents({'employeeSelected':true});
	
	this.results.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('employee-selector-select').setDisabled(sm.getCount() < 1);
	});
};

Ext.extend(is.window.EmployeeSelector, Ext.Window, {
});

Ext.reg('is-employee-selector-window', is.window.EmployeeSelector);
