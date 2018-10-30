
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
					fieldLabel: '���',
					id: 'schedule-info-scheduleNo'
				}, {
					fieldLabel: '����',
					id: 'schedule-info-name'
				}, {
					fieldLabel: '�绰',
					id: 'schedule-info-tel'
				}, {
					fieldLabel: '�Ա�',
					id: 'schedule-info-sex'
				}]
			}, {
				columnWidth: .5,
				layout: 'form',
				defaultType: 'displayfield',
				border: false,
				frame: false,
				items: [{
					fieldLabel: '��ַ',
					id: 'schedule-info-address'
				}, {
					fieldLabel: '��������',
					id: 'schedule-info-zipcode'
				}, {
					fieldLabel: '���',
					id: 'schedule-info-individual'
				}, {
					fieldLabel: '֤������',
					id: 'schedule-info-idnum'
				}]
			}]
		}, {
			xtype: 'grid',
			id: 'schedule-info-contacts',
			autoScroll: true,
			height: 200,
			tbar: [ '��ϵ���б�' ],
			store: new Ext.data.JsonStore({
				root: 'contacts',
				fields: ['id', 'code','name', 'sex','tel','mobile','idnum']
			}),
    		colModel: new Ext.grid.ColumnModel({
    			defaults: {
    				sortable: true
    			},	        
     	        columns: [
        		  {header: '���', dataIndex: 'id'},
 	 	          {header: '����', dataIndex: 'code'},
 	 	          {header: '����', dataIndex: 'name'},
 	 	          {header: '�Ա�', dataIndex: 'sex'},
 	 	          {header: '�绰', dataIndex: 'tel'},
 	 	          {header: '�ƶ��绰', dataIndex: 'mobile'},
 	 	          {header: '֤������', dataIndex: 'idnum'}
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
		title: '�ͻ���Ϣ',
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