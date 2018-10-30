
Ext.ns('is.form.EmployeeDataview');


is.form.EmployeeDataview = function(config) {
	/*
	 * employee store.
	 */
	this.employeeStore = new Ext.data.JsonStore({
		url: 'getEmployee.action',
		root: 'Employee',
		fields: ['id', 'name', 'position']
	});
	
	/*
	 * dataview store.
	 */
	this.dataviewStore = new Ext.data.JsonStore({
		fields: [ 'id', 'name', 'department', 'position', 'level'],
		root: 'Employee',
		data: {
			Employee: [{
				id:'', name:'—°‘Ò‘±π§', position: '', department: '', level:''
			}]
		}
	});
	
	this.employeeTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="employee-info">',
		config.readOnly ? '<p><a href="#" onclick="dataviewOpenEmployeeInfo(\'{id}\');">{department} {position} {name}</a></p>' 
				: '<p><a href="#" onclick="dataviewOpenEmployeeSelector(\'' + config.id + '\');">{department} {position} {level} {name}</a></p>',
		'</div>',
		'</tpl>'
	);
	
	this.addEvents({'employeeSelected':true});
	
	is.form.EmployeeDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.employeeTpl,
		itemSelector: 'div.employee-info'		
	});
};

Ext.extend(is.form.EmployeeDataview, Ext.DataView, {	
	/*
	 * open employee dataview.
	 */
	open: function(id) {
		this.employeeStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData(this.createEmployee(records[0]));
				}
			},
			scope: this
		});
	},
	/*
	 * convert value to empty string.
	 */
	nonEmptyName: function(value) {
		return value? value.name: '';
	},
	/*
	 * create employee for dataview.
	 */
	createEmployee: function(record) {
		return {
			Employee: [{
				name: record.get('name'),
				id: record.get('id'),
				position:  this.nonEmptyName(record.get('position')),
				department: this.nonEmptyName(record.get('position').department),
				level: this.nonEmptyName(record.get('position').level)
			}]
		};
	},
	/*
	 * on employee selected.
	 */
	onEmployeeSelected: function(attr) {
		this.dataviewStore.loadData(this.createEmployee(attr.employee));
	},
	/*
	 * get employee id.
	 */
	getEmployeeId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('is-employee-dataview', is.form.EmployeeDataview);