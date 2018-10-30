
Ext.ns('clsys.form.ScheduleDataview');

clsys.form.ScheduleDataview = function(config) {

	this.scheduleStore = new Ext.data.JsonStore({
		url: 'getSchedule.action',
		root: 'Schedule',
		fields: ['id', 'scheduleNo']
	});
	
	this.dataviewStore = new Ext.data.JsonStore({
		fields: ['id', 'scheduleNo','finishedAmount','amount'],
		root: 'Schedule',
		data: {Schedule:[{id:'', scheduleNo:'选择计划',finishedAmount:'',amount:''}]}
	});
	
	this.scheduleTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="schedule-info">',
		config.readOnly ? '<p><a href="#" onclick="dataviewOpenScheduleSelector(\'{id}\');">{scheduleNo}</a></p>' 
				: '<p><a href="#" onclick="dataviewOpenScheduleSelector(\'' + config.id + '\');">{scheduleNo}</a></p>',
		'</div>',
		'</tpl>'
	);
	
	this.addEvents({'scheduleSelected':true});
	
	clsys.form.ScheduleDataview.superclass.constructor.call(this, {
		id: config.id,
		fieldLabel: config.fieldLabel,
		frame: false,
		border: false,
		store: this.dataviewStore,
		tpl: this.scheduleTpl,
		itemSelector: 'div.schedule-info'		
	});
};

Ext.extend(clsys.form.ScheduleDataview, Ext.DataView, {	

	open: function(id) {
		if (!this.loadMask) {
			this.loadMask = new Ext.LoadMask(this.el, {
				store: this.scheduleStore,
				msg: '正在加载...'
			});
		}
		this.scheduleStore.load({
			params: {
				id: id
			},
			callback: function(records, opts, success) {
				if (success) {
					this.dataviewStore.loadData({
						Schedule: [records[0].json]
					});
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
	 * on schedule selected.
	 */
	onScheduleSelected: function(attr) {
		this.dataviewStore.loadData(attr.schedule);
	},
	/*
	 * get schedule id.
	 */
	getScheduleId: function() {
		if (this.dataviewStore.getCount() > 0) {
			return this.dataviewStore.getAt(0).get('id');
		}
		return null;
	}
});

Ext.reg('clsys-schedule-dataview', clsys.form.ScheduleDataview);