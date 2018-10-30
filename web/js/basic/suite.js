
Ext.ns('is.window.Suite');
is.window.Suite = function() {
	this.mode = 'add';
	
	this.store = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'getSuite.action',
		root: 'Suite',
		fields:['id', 'code','name','filepath',{name:'model', mapping:'model.name'}]			 
	});

    this.suiteForm = new Ext.form.FormPanel({
//        labelAlign: 'top',
//        title: '��������',
//        bodyStyle:'padding:5px',
			//allowBlank: false,
			//vtype: 'alphanum',
			//vypeText: '����ֻ�������ֻ���ĸ��',
			//blankText:"���벻��Ϊ��",
        frame: false,
        border: false,
        labelAlign: 'right',
        fileUpload: true,
        defaultType: 'textfield', 
        width: 280,
        items: [{
			xtype: 'hidden',
			id: 'suite_id',
			width: 150,
			name: 'id'
		}, {
			xtype: 'textfield',
            id: 'suite_codes',
            name: 'codes',
            fieldLabel: '����'
        }, {
			xtype: 'textfield',
            id: 'suite_name',
            name: 'name',
            fieldLabel: '����'
        }, {
   			xtype: 'combo',
   			id: 'suite_model',
			width: 140,
               store:  new Ext.data.JsonStore({
                   //idProperty: 'modelId',
                   url: 'findModel.action',
                   root: 'ModelList',
                   baseParams: {
					states : ['Using'], status: ['Using']
                   },
           		fields:['id', 'name']
               }),
			triggerAction: 'all',
			editable:false,
			forceSelection: true,
			emptyText: 'ѡ����',
			valueField: 'id',
			displayField: 'name',
			hiddenName: 'model',
			fieldLabel: '����'
        }, {
            xtype: 'fileuploadfield',
           id: 'uploadFile',
            width: 140,
//            renderTo: 'suiteUploadFile',
            emptyText: 'ѡ����ϸ��Ϣ�ļ�',
            fieldLabel: '��ϸ��Ϣ',
//           inputType:'file',
            name: 'uploadFile',
            buttonText: '���'
        }]
    });

		
	is.window.Suite.superclass.constructor.call(this, {
		id: 'suite-window',
		title: '��������',
		buttonAlign: 'center',
		autoHeight: true,
		width:300,
		resizable:false,
		plain:true,
		modal:true,
		autoScroll:true,
		buttons:[{
			text:'ȷ��',
			iconCls: 'icon-commit',
			handler:this.submit,
			scope:this
		},{
			text:'����',
			handler:this.reset,
			scope:this
		},{
			text: 'ȡ��',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope:this
		}],
		items: [this.suiteForm]
	});
	
	this.addEvents({'suiteSaved':true});
};

Ext.extend(is.window.Suite, Ext.Window, {	
	
	open: function(id) {
		this.mode = 'update';
		this.title = '��������';
		this.store.load({
			params: {id: id},
			callback: function() {
				if (this.store.getCount() > 0) {
					var record = this.store.getAt(0);
					Ext.getCmp('suite_id').setValue(record.get('id'));
					Ext.getCmp('suite_codes').setValue(record.get('code'));
					Ext.getCmp('suite_name').setValue(record.get('name'));
//					Ext.getCmp('suite_particular').setValue(record.get('filepath'));
					clsys.form.Util.updateCombo('suite_model', record.json.model.id);
				}
			},
			scope: this
		});
	},
	
	submit: function() {
		if (!this.suiteForm.getForm().isValid()) {
			clsys.message.info('��֤ʧ��');
			return;
		}
		this.suiteForm.getForm().submit({
			url: this.mode == 'add' ? 'addSuite.action' : 'updateSuite.action',
			enctype:"multipart/form-data",		
			success: function(form, action) {
				this.fireEvent('suiteSaved');
				this.destroy();
			},
			failure: function(form, action) {
				if (!form.isValid()) {
					clsys.message.info('���ݲ�����.');
				} else {
					clsys.message.error(action.result.msg);
				}
			},
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	reset: function() {
		this.suiteForm.getForm().reset();
	}
});

Ext.reg('is-suite-window', is.window.Suite);
