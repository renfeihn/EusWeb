
Ext.ns('is.window.Sequencer');

is.window.Sequencer = function(config) {
	this.store = new Ext.data.JsonStore({
		url: 'sequencePreference.action',
		root: 'SequenceList',
		fields: [ 'id', 'type', 'head', 'prefix', 'middle', 'postfix', 'tail']
	});
	
	this.tablePanel = new Ext.TabPanel({
		id: 'sequence-tabel-panel',
		width: 500,
		activeTab: 0,
		items: [{
			title: '订货单',
			seqType: 'Order',
			layout: 'form',
			labelAlign: 'right',
			items: [{
				xtype: 'hidden',
				id: 'order-sequence-id'
			}, {
				xtype: 'combo',
				id: 'order-sequence-head',
				name: 'orderHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择订货单头编码头部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'order-sequence-prefix',
				name: 'orderPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'DH',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'order-sequence-middle',
				name: 'orderMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择订货单头编码中部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'order-sequence-postfix',
				name: 'orderPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'order-sequence-tail',
				name: 'orderMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择订货单头编码尾部'	,
				listeners: {
					'select': this.preview, scope: this
				}
				
			}]
		}, {
			title: '发货单',
			seqType: 'Shipment',
			layout: 'form',
			labelAlign: 'right',
			items: [{
				xtype: 'hidden',
				id: 'shipment-sequence-id'
			}, {
				xtype: 'combo',
				id: 'shipment-sequence-head',
				name: 'shipmentHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择发货头编码头部',
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'shipment-sequence-prefix',
				name: 'shipmentPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'FH',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'shipment-sequence-middle',
				name: 'shipmentMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择发货单头编码中部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'shipment-sequence-postfix',
				name: 'shipmentPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'shipment-sequence-tail',
				name: 'shipmentMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择发货单头编码尾部'	,
				listeners: {
					'select': this.preview, scope: this
				}
				
			}]
		}, {
			title: '入库单',
			seqType: 'Checkin',
			layout: 'form',
			labelAlign: 'right',
			items: [{
				xtype: 'hidden',
				id: 'checkin-sequence-id'
			}, {
				xtype: 'combo',
				id: 'checkin-sequence-head',
				name: 'checkinHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择入库头编码头部',
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'checkin-sequence-prefix',
				name: 'checkinPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'RK',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'checkin-sequence-middle',
				name: 'checkinMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择入库头编码中部',
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'checkin-sequence-postfix',
				name: 'checkinPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'checkin-sequence-tail',
				name: 'checkinMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择入库头编码尾部',
				listeners: {
					'select': this.preview, scope: this
				}
				
			}]
		}, {
			title: '销售合同',
			labelAlign: 'right',
			seqType: 'Contract',
			layout: 'form',
			items: [{
				xtype: 'hidden',
				id: 'contract-sequence-id'
			}, {
				xtype: 'combo',
				id: 'contract-sequence-head',
				name: 'contractHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择销售合同头编码头部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'contract-sequence-prefix',
				name: 'contractPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'DH',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'contract-sequence-middle',
				name: 'contractMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择销售合同头编码中部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'contract-sequence-postfix',
				name: 'contractPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'contract-sequence-tail',
				name: 'contractMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择销售合同头编码尾部'	,
				listeners: {
					'select': this.preview, scope: this
				}				
			}]
		}, {
			title: '销售单',
			seqType: 'Sales',
			layout: 'form',
			labelAlign: 'right',
			items: [{
				xtype: 'hidden',
				id: 'sales-sequence-id'
			}, {
				xtype: 'combo',
				id: 'sales-sequence-head',
				name: 'salesHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择销售单头编码头部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'sales-sequence-prefix',
				name: 'salesPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'DH',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'sales-sequence-middle',
				name: 'salesMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择销售单头编码中部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'sales-sequence-postfix',
				name: 'salesPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'sales-sequence-tail',
				name: 'salesMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择销售单头编码尾部'	,
				listeners: {
					'select': this.preview, scope: this
				}				
			}]
		}, {
			title: '出库单',
			seqType: 'Checkout',
			layout: 'form',
			labelAlign: 'right',
			items: [{
				xtype: 'hidden',
				id: 'checkout-sequence-id'
			}, {
				xtype: 'combo',
				id: 'checkout-sequence-head',
				name: 'checkoutHead',
				fieldLabel: '头部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '公司名称'],
						['2', '集团+公司名称']
					]
				}),
				emptyText: '选择出库单头编码头部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'checkout-sequence-prefix',
				name: 'checkoutPrefix',
				fieldLabel: '前缀',
				xtype: 'textfield',
				value: 'DH',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'checkout-sequence-middle',
				name: 'checkoutMiddle',
				fieldLabel: '中部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['1', '日期(格式:20100428)']
					]
				}),
				emptyText: '选择出库单头编码中部'	,
				listeners: {
					'select': this.preview, scope: this
				}
			}, {
				id: 'checkout-sequence-postfix',
				name: 'checkoutPostfix',
				fieldLabel: '后缀',
				xtype: 'textfield',
				width: 175,
				listeners: {
					'change': this.preview, scope: this
				}
			}, {
				xtype: 'combo',
				id: 'checkout-sequence-tail',
				name: 'checkoutMiddle',
				fieldLabel: '尾部',
				width: 175,
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				editable: false,
				forceSelection: true,
				mode: 'local',
				store: new Ext.data.ArrayStore({
					fields: ['id', 'name'],
					data: [
						['0', '无'],
						['3', '3位序列号'],
						['5', '5位序列号']
					]
				}),
				emptyText: '选择出库单头编码尾部',
				listeners: {
					'select': this.preview, scope: this
				}			
			}]
		}]
	});
	
	this.tablePanel.on('tabchange', function(tp, panel) {
		this.preview();
	}, this);
	
	this.seqs = [
	     ['Order', 'order'],
	     ['Shipment', 'shipment'],
	     ['Checkin', 'checkin'],
	     ['Contract', 'contract'],
	     ['Sales', 'sales'],
	     ['Checkout', 'checkout']
    ];
	
	this.previewPanel = new Ext.Panel({
		layout: 'form',
		labelAlign: 'right',
		items: [{
			xtype: 'displayfield',
			fieldLabel: '预览',
			id: 'sequence-preview'
		}]
	});
	
	this.corporationStore = new Ext.data.JsonStore({
		url: 'getCorporationPreference.action',
		root: 'Corporation',
		fields: ['id', 'name', 'code']
	});
	
	is.window.Sequencer.superclass.constructor.call(this, {
		id: 'sequencer-window',
		title: '编码生成配置',
		width: 530,
		buttonAlign: 'center',
		items: [ this.tablePanel, this.previewPanel ],
		buttons: [{
			text: '应用',
			iconCls: 'icon-commit',
			handler: this.submit,
			scope: this
		}, {
			text: '取消',
			iconCls: 'icon-remove',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
};

Ext.extend(is.window.Sequencer, Ext.Window, {
	createHead: function(head) {
		if (head == '1' || head == '2') {
			if (this.corporationStore.getCount() > 0) {
				var r = this.corporationStore.getAt(0);
				return r.get('code');
			}
		}
		return '';
	},
	
	createMiddle: function(middle) {
		if (middle == '1') {
			var d = new Date();
			var dt = d.getDate();
			var month = d.getMonth() + 1;
			return d.getFullYear().toString()
				+ (month < 10 ? ('0' + month.toString()) : month.toString())
				+ (dt < 10 ? ('0' + dt.toString()) : dt.toString());
		}
		return '';
	},
	
	createTail: function(tail) {
		if (tail == '3') {
			return '001';
		} else if (tail == '5') {
			return '00001';
		}
		return '';
	},
	/*
	 * preview sequence.
	 */
	preview: function() {
		var panel = this.tablePanel.getActiveTab();
		if (!panel) return;
		for (var i = 0; i < this.seqs.length; i++) {
			if (this.seqs[i][0] == panel.seqType) {
				var id = this.seqs[i][1];
				var head = panel.get(id + '-sequence-head').getValue();
				var prefix = panel.get(id + '-sequence-prefix').getValue();
				var middle = panel.get(id + '-sequence-middle').getValue();
				var postfix = panel.get(id + '-sequence-postfix').getValue();
				var tail = panel.get(id + '-sequence-tail').getValue();
				var display = this.createHead(head) + prefix + this.createMiddle(middle) + postfix + this.createTail(tail);
				Ext.getCmp('sequence-preview').setValue(display);
			}
		}
	},
	
	updatePanel: function(record) {
		for (var i = 0; i < this.seqs.length; i++) {
			if (this.seqs[i][0] == record.get('type')) {
				var id = this.seqs[i][1];
				clsys.form.Util.updateField(id + '-sequence-id', record.get('id'));
				clsys.form.Util.updateField(id + '-sequence-head', record.get('head'));
				clsys.form.Util.updateField(id + '-sequence-prefix', record.get('prefix'));
				clsys.form.Util.updateField(id + '-sequence-middle', record.get('middle'));
				clsys.form.Util.updateField(id + '-sequence-postfix', record.get('postfix'));
				clsys.form.Util.updateField(id + '-sequence-tail', record.get('tail'));
			}
		}
	},
	
	open: function() {
		this.loadMask = new Ext.LoadMask(this.body, {
			store: this.store,
			msg: clsys.form.Util.waitMsg
		});
		
		this.corporationStore.load();
		
		this.store.load({
			callback: function(records, opts, success) {
				if (success) {
					for (var i = 0; i < records.length; i++) {
						var record = records[i];
						this.updatePanel(record);
					}
				}
			},
			scope: this
		});
	},
	
	submit: function() {		
		var ids = [], heads =[], prefixes = [], middles = [], postfixes = [], tails = [];
		for (var i = 0; i < this.seqs.length; i++) {
			var id = this.seqs[i][1];
			ids.push(clsys.form.Util.getFieldValue(id + '-sequence-id'));
			heads.push(clsys.form.Util.getComboValues(id + '-sequence-head').id);
			prefixes.push(clsys.form.Util.getFieldValue(id + '-sequence-prefix'));
			middles.push(clsys.form.Util.getComboValues(id + '-sequence-middle').id);
			postfixes.push(clsys.form.Util.getFieldValue(id + '-sequence-postfix'));
			tails.push(clsys.form.Util.getComboValues(id + '-sequence-tail').id);
		}
		
		Ext.Ajax.request({
			url: 'applySequencePreference.action',
			params: {
				ids: ids,
				sequenceHead: heads,
				sequencePrefix: prefixes,
				sequenceMiddle: middles,
				sequencePostfix: postfixes,
				sequenceTail: tails
			},
			success: function(response, opts) {
				var result = Ext.decode(response.responseText);
				if (result.success) {
					this.destroy();
				} else {
					clsys.message.error(result.msg);
				}
			},
			failure: function(response, opts) {
				clsys.message.error(Ext.decode(response.responseText).msg);
			},
			scope: this
		});
	}
});

Ext.reg('is-sequence-window', is.window.Sequencer);