
Ext.ns('clsys.window.ScheduleInfo');

clsys.window.ScheduleInfo = function() {
	this.datastore = new Ext.data.JsonStore({
		url: 'getSchedule.action',
		root: 'Schedule',
		fields: ['id', 'scheduleNo']
	});
	
	this.scheduleForm = new Ext.form.FormPanel({
		id: 'schedule-info-form',
		width: 450,
		labelAlign: 'right',
		border: false,
		frame: false,
		items: [{
			layout: 'column',
			border: false,
			frame: false,
			items: [{
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '编号',
					id: 'schedule-info-scheduleNo'
				}, {
					fieldLabel: '名称',
					id: 'schedule-info-name'
				}, {
					fieldLabel: '电话',
					id: 'schedule-info-tel'
				}, {
					fieldLabel: '性别',
					id: 'schedule-info-sex'
				}]
			}, {
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '地址',
					id: 'schedule-info-address'
				}, {
					fieldLabel: '邮政编码',
					id: 'schedule-info-zipcode'
				}, {
					fieldLabel: '类别',
					id: 'schedule-info-individual'
				}, {
					fieldLabel: '证件号码',
					id: 'schedule-info-idnum'
				}]
			}]
		}, {
			xtype: 'grid',
			id: 'schedule-info-contacts',
			autoScroll: true,
			height: 200,
			tbar: [ '联系人列表' ],
			store: new Ext.data.JsonStore({
				root: 'contacts',
				fields: ['id', 'code','name', 'sex','tel','mobile','idnum']
			}),
    		colModel: new Ext.grid.ColumnModel({
    			defaults: {
    				sortable: true
    			},	        
     	        columns: [
        		  {header: '编号', dataIndex: 'id'},
 	 	          {header: '编码', dataIndex: 'code'},
 	 	          {header: '姓名', dataIndex: 'name'},
 	 	          {header: '性别', dataIndex: 'sex'},
 	 	          {header: '电话', dataIndex: 'tel'},
 	 	          {header: '移动电话', dataIndex: 'mobile'},
 	 	          {header: '证件号码', dataIndex: 'idnum'}
      	 	    ]
    		}),
     		viewConfig: {
     			forceFit: true
    		},    
     		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		}]
	});
	
	clsys.window.ScheduleInfo.superclass.constructor.call(this, {
		id: 'schedule-info-window',
		width: 480,
		title: '客户信息',
		items: this.scheduleForm
	});
};

Ext.extend(clsys.window.ScheduleInfo, Ext.Window, {
	/*
	 * open schedule information window.
	 */
	open: function(id) {
		if (!this.loadMask) {
			this.loadMask = new Ext.LoadMask(this.body, {
				store: this.datastore,
				msg: clsys.form.Util.waitMsg
			});
		}
		this.datastore.load({
			params: { id: id },
			callback: function() {
				var record = this.datastore.getAt(0);
				if (record) {
					clsys.form.Util.updateField('schedule-info-code', record.get('code'));
					clsys.form.Util.updateField('schedule-info-sex', record.get('sex'));
					clsys.form.Util.updateField('schedule-info-name', record.get('name'));
					clsys.form.Util.updateField('schedule-info-tel', record.get('tel'));
					clsys.form.Util.updateField('schedule-info-address', record.get('address'));
					clsys.form.Util.updateField('schedule-info-zipcode', record.get('zipcode'));
					clsys.form.Util.updateField('schedule-info-individual', record.get('individual'));
					clsys.form.Util.updateField('schedule-info-idnum', record.get('idnum'));
					Ext.getCmp('schedule-info-contacts').getStore().loadData(record.json);
				}
			},
			scope: this
		});
	}
});

Ext.reg('clsys-schedule-info-window', clsys.window.ScheduleInfo);