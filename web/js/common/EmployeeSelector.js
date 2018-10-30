
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
	        	{header: '编号', dataIndex: 'code'},
	        	{header: '姓名', dataIndex: 'name'},
	        	{header: '部门', renderer: clsys.grid.columnrender.DepartmentRender, dataIndex: 'department'},
	        	{header: '级别', renderer: clsys.grid.columnrender.LevelRender, dataIndex: 'level'},
	        	{header: '岗位', renderer: clsys.grid.columnrender.PositionRender, dataIndex: 'position'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({single:true})
	});

	is.window.EmployeeSelector.superclass.constructor.call(this, {
		title: '选择员工',
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
			//emptyText: '输入查询条件,按回车或点击查询',
			store: this.datastore,
			paramName: 'search',
			width: 400,
			height:30,
			tooltip: '输入查询条件,按回车或点击查询.'
		}, '->', {
			text: '所有',
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
			text: '确定',
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
			text: '取消',
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
