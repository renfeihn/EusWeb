
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
//        title: '新增配置',
//        bodyStyle:'padding:5px',
			//allowBlank: false,
			//vtype: 'alphanum',
			//vypeText: '编码只能是数字或字母！',
			//blankText:"编码不能为空",
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
            fieldLabel: '编码'
        }, {
			xtype: 'textfield',
            id: 'suite_name',
            name: 'name',
            fieldLabel: '名称'
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
			emptyText: '选择车型',
			valueField: 'id',
			displayField: 'name',
			hiddenName: 'model',
			fieldLabel: '车型'
        }, {
            xtype: 'fileuploadfield',
           id: 'uploadFile',
            width: 140,
//            renderTo: 'suiteUploadFile',
            emptyText: '选择详细信息文件',
            fieldLabel: '详细信息',
//           inputType:'file',
            name: 'uploadFile',
            buttonText: '浏览'
        }]
    });

		
	is.window.Suite.superclass.constructor.call(this, {
		id: 'suite-window',
		title: '新增配置',
		buttonAlign: 'center',
		autoHeight: true,
		width:300,
		resizable:false,
		plain:true,
		modal:true,
		autoScroll:true,
		buttons:[{
			text:'确定',
			iconCls: 'icon-commit',
			handler:this.submit,
			scope:this
		},{
			text:'重置',
			handler:this.reset,
			scope:this
		},{
			text: '取消',
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
		this.title = '更新配置';
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
			clsys.message.info('验证失败');
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
					clsys.message.info('数据不完整.');
				} else {
					clsys.message.error(action.result.msg);
				}
			},
			waitMsg: '正在提交数据，请稍候...',
			scope: this
		});
	},
	reset: function() {
		this.suiteForm.getForm().reset();
	}
});

Ext.reg('is-suite-window', is.window.Suite);
