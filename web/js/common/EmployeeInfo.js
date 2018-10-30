
Ext.ns('is.window.EmployeeInfo');

/*
 * Open Employee information window.
 */
var openEmployee = function(id) {
	var win = Ext.getCmp('employee-info-window');
	if (!win) {
		win = new is.window.EmployeeInfo();
	}
	win.open(id);
	win.show();
};

is.window.EmployeeInfo = function() {
	this.datastore = new Ext.data.JsonStore({
		audoDestroy: true,
		url: 'getEmployee.action',
		root: 'Employee',
		fields: ['id', 'code', 'name', 
		     {name:'position', mapping:'position.name'}, 
	         {name:'department', mapping:'position.department.name'}, 
	         {name:'level', mapping:'position.level.name'},
	         'sex', 'tel', 'birthday']
	});
	
	this.employeeTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="employee-info">',
		'<p><span>编号:{code}</span>  <span>姓名:{name}</span></p>',
		'<p><span>部门:{department}</span>  <span>级别:{level}</span></p>',
		'</div>',
		'</tpl>'
	);
	
	this.employeePanel = new Ext.form.FormPanel({
		width: 300,
		autoHeight: true,
		labelAlign: 'right',
		style: 'padding: 5px 5px 5px 5px;',
		defaultType: 'displayfield',
		items: [{
			id: 'employee-info-code',
			width: 100,
			itemCls: 'x-grid3-row',
			fieldLabel: '编号'
		}, {
			id: 'employee-info-name',
			width: 100,
			itemCls: 'x-grid3-row-alt',
			fieldLabel: '姓名'
		}, {
			id: 'employee-info-position',
			width: 100,
			itemCls: 'x-grid3-row',
			fieldLabel: '职位'
		}, {
			id: 'employee-info-department',
			width: 100,
			itemCls: 'x-grid3-row-alt',
			fieldLabel: '部门'	
		}, {
			id: 'employee-info-level',
			width: 100,
			itemCls: 'x-grid3-row',
			fieldLabel: '级别'
		}, {
			id: 'employee-info-tel',
			width: 100,
			itemCls: 'x-grid3-row-alt',
			fieldLabel: '电话'
		}, {
			id: 'employee-info-sex',
			width: 100,
			fieldLabel: '性别'
		}, {
			id: 'employee-info-birthday',
			width: 100,
			fieldLabel: '生日'
		}]
	});
	
	is.window.EmployeeInfo.superclass.constructor.call(this, {
		id: 'employee-info-window',
		title: '员工',
		width: 320,
		//height: 300,
		items: this.employeePanel
		/*
		items: [{
			xtype: 'dataview',
			id: 'employee-info-dataview',
			store: this.datastore,
			tpl: this.employeeTpl,
			itemSelector: 'div.employee-info'
		}]
		*/
	});
};

Ext.extend(is.window.EmployeeInfo, Ext.Window, {
	/*
	 * open employee.
	 */
	open: function(id) {
		this.datastore.load({
			params:{id:id},
			callback: function() {
				var record = this.datastore.getAt(0);
				clsys.form.Util.updateField('employee-info-code', record.get('code'));
				clsys.form.Util.updateField('employee-info-name', record.get('name'));
				clsys.form.Util.updateField('employee-info-department', record.get('department'));
				clsys.form.Util.updateField('employee-info-position', record.get('position'));
				clsys.form.Util.updateField('employee-info-level', record.get('level'));
				clsys.form.Util.updateField('employee-info-sex', record.get('sex'));
				clsys.form.Util.updateField('employee-info-tel', record.get('tel'));
				clsys.form.Util.updateField('employee-info-birthday', record.get('birthday'));
			},
			scope: this
		});
	}
});

Ext.reg('is-employee-info-window', is.window.EmployeeInfo);