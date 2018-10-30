<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/basic/basic.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	/*
	 * ����������.
	 * ��Ҫ���������õ�Hidden��.
	 */
	var openAddBasic = function() {
		var basic = Ext.getCmp('basic-window');
		if (!basic) {
			basic = new clsys.window.Basic();
			basic.on('basicSaved', function(attr) {
				basicStore.reload();
			});
		}
		basic.setTitle('����' + Ext.getCmp('basic-find-type').getRawValue());
		basic.reset();
		Ext.getCmp('basic_type').setValue(Ext.getCmp('basic-find-type').getValue());
		basic.show();
	};
	
	var delBasic = function() {
		clsys.message.confirm('ȷ��Ҫɾ�����ݿ��м�¼?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = basicGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'removeBasic.action',
					params: { 'id': id ,'type': Ext.getCmp('basic-find-type').getValue() },
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							basicStore.reload();
						} else {
							clsys.messsage.error(result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.systemerror();
					}
				});
			}
		});
	};
	
	var usingBasic = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
				if (buttonId == 'yes') {
					var selected = basicGrid.getSelectionModel().getSelected();
					if (!selected) return;
					var id = selected.get('id');
					Ext.Ajax.request({
						url: 'changeBasic.action',
						params: { 'id': id ,'type': Ext.getCmp('basic-find-type').getValue(),'state': 'Using'},
						success: function(response, opt) {
							var result = Ext.decode(response.responseText);
							if (result.success) {
								basicStore.reload();
							} else {
								clsys.messsage.error('���ô�����Ϣ:' + result.msg);
							}
						},
						failure: function(response, opt) {
							clsys.message.systemerror();
						}
					});
				}
		});
	};
	
	var suspendedBasic = function() {
		clsys.message.confirm('��ȷ��Ҫ���øü�¼��?', function(buttonId) {
			if (buttonId == 'yes') {
				var selected = basicGrid.getSelectionModel().getSelected();
				if (!selected) return;
				var id = selected.get('id');
				Ext.Ajax.request({
					url: 'changeBasic.action',
					params: { 'id': id ,'type': Ext.getCmp('basic-find-type').getValue(),'state': 'Suspended'},
					success: function(response, opt) {
						var result = Ext.decode(response.responseText);
						if (result.success) {
							basicStore.reload();
						} else {
							clsys.messsage.error('���ô�����Ϣ:' + result.msg);
						}
					},
					failure: function(response, opt) {
						clsys.message.systemerror();
					}
				});
			}
		});
	};
	
	var openUpdBasic = function() {
		var basicId = basicGrid.getSelectionModel().getSelected().get('id');
		var window = Ext.getCmp('basic-window');
		if (!window) {
			window = new clsys.window.Basic();
			window.on('basicSaved', function(attr) {
				basicStore.reload();
			});
		}
		window.open(basicId);
		window.setTitle('����');
		window.show();
	};
	
	var importBasicFromExcel = function() {
		var basicFromExcel = Ext.getCmp('basic-uplaod-excel-window');
		if (!basicFromExcel) {
			basicFromExcel = new clsys.window.BasicExcel();
		}
		basicFromExcel.reset();
		basicFromExcel.show();
	};
	
	var basicStore = new Ext.data.JsonStore({
        autoDestroy:true,
        baseParams:{ start: 0, limit: 25,
        	status: ['Using', 'Suspended']
        },
		url: "findBasic.action",
		root: "BasicList",
		idProperty: "id",
		totalProperty: 'results',
//      autoLoad:true,
		fields: 
			['id','code','name',{name:'state',type:'int'}],
		sortInfo: {field: 'code',direction: 'ASC'}
	});
	
	var basicPanel = Ext.getCmp('basic-mainpanel');

	clsys.form.Util.PagingToolbar(basicStore, basicPanel.bbar, 'basic-info-paging');
	
	var basicGrid = new Ext.grid.GridPanel({
		store: basicStore,
		hidden: true,
		autoScroll:true,
	 	autoHeight:true,
	 	stripeRows: true,
	 	border: false,
	 	frame: false,
	 	id: 'basicGrid',
 	    renderTo: 'basicGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	         //   width: 120,
 	            sortable: true
 	        },
 	        columns: [
	 	 	          {header: '����', dataIndex: 'code'},
	 	 	          {header: '����', dataIndex: 'name'},
	 	 	          {header: '״̬', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
 		}), 
 		viewConfig: {
 			forceFit: true
		}
	});

	var informationTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div class="information-panel">',
	    '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
	    '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc">',
	        '<h3 style="margin-bottom:5px; align:center">��ѡ�����</h3>',
	    '</div></div></div>',
	    '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
        '</div></tpl>'
	);

	var informationPanel = new Ext.DataView({
		id: 'basic-information-panel',
		width: 400,
		tpl: informationTpl,
		store: new Ext.data.ArrayStore({
			fields: ['text'],
			data: [ ['abc']]
		}),
		itemSelector: 'div.information-panel' 
	});

	basicPanel.add(informationPanel);
	
	basicPanel.getTopToolbar().add({
			xtype: 'combo',
			id: 'basic-find-type',
			emptyText: 'ѡ�����',
			store: new Ext.data.ArrayStore({
				fields: [ 'type', 'typeName' ],
				data: [
						[ 'Level', 'Ա������' ],
						['StorageLocation','��λ'],
						['ErrorLevel','���ȼ�'],
						['Humidity','ʪ��ָʾ'],
						['ProductCode','��Ʒ����'],
						['ProductType','��Ʒ���'],
						['Unit','��Ʒ��λ'],
						['UsageType','��Ʒ��;']
					]
			}),
			mode: 'local',
			triggerAction: 'all',
			displayField: 'typeName',
			valueField: 'type',
			width: 150,
			selectOnFocus: true,
			forceSelection: true,
			editable: false,
			listeners: {
				'select': function(combo, record, index) {
					var search = Ext.getCmp('basic-search');
					basicStore.baseParams['type'] = record.get('type');
					basicStore.baseParams['value'] = '';
					basicStore.reader.meta.root = record.get('type') + 'List';
					delete basicStore.reader.ef;
					basicStore.reader.buildExtractors();
					basicStore.reload({
						params: { start: 0 }
					});
					Ext.getCmp('addBasic').setDisabled(false);
					basicGrid.show();
					Ext.getCmp('basic-information-panel').hide();
				}, 
				scope: this
			},
			sm: new Ext.grid.RowSelectionModel({})	
		}, '-', {
			text: '����',
			id: 'addBasic',
			disabled: true,
			iconCls: 'icon-add',
			handler: openAddBasic
		},{
			text: 'ɾ��',
			id: 'delBasic',
			disabled: true,
			iconCls: 'icon-remove',
			handler: delBasic
		},{
			text: '����',
			id: 'updBasic',
			disabled: true,
			iconCls: 'icon-update',
			handler: openUpdBasic
		}, '-', {
			text: '����',
			id: 'usingBasic',
			disabled: true,
			iconCls: 'icon-using',
			handler: usingBasic
		},{
			text: '����',
			id: 'suspendedBasic',
			disabled: true,
			iconCls: 'icon-suspended',
			handler: suspendedBasic
		}, '-', {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				basicStore.reload();
			},
			scope:this
		}, '->', {
			xtype: 'is-search-field',
			id: 'basic-search',
			emptyText: '��������',
			store: basicStore,
			paramTypeName: 'type'
		}, ' '
	);

	basicPanel.getBottomToolbar().hide();
	basicPanel.doLayout();

	basicGrid.getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('updBasic').setDisabled(sm.getCount() < 1);
		Ext.getCmp('delBasic').setDisabled(sm.getCount() < 1);
		Ext.getCmp('suspendedBasic').setDisabled(sm.getCount() < 1);
		Ext.getCmp('usingBasic').setDisabled(sm.getCount() < 1);
	});
	
});
</script>
</head>
<body>
<div id="basicPanel"></div>
<div id="basicWindow"></div>
<div id="basicGridPanel"></div>
</body>
</html>