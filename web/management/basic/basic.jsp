<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/basic/basic.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	/*
	 * 打开新增窗口.
	 * 需要将类型设置到Hidden栏.
	 */
	var openAddBasic = function() {
		var basic = Ext.getCmp('basic-window');
		if (!basic) {
			basic = new clsys.window.Basic();
			basic.on('basicSaved', function(attr) {
				basicStore.reload();
			});
		}
		basic.setTitle('新增' + Ext.getCmp('basic-find-type').getRawValue());
		basic.reset();
		Ext.getCmp('basic_type').setValue(Ext.getCmp('basic-find-type').getValue());
		basic.show();
	};
	
	var delBasic = function() {
		clsys.message.confirm('确定要删除数据库中记录?', function(buttonId) {
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
		clsys.message.confirm('你确定要启用该记录吗?', function(buttonId) {
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
								clsys.messsage.error('启用错误，消息:' + result.msg);
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
		clsys.message.confirm('你确定要禁用该记录吗?', function(buttonId) {
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
							clsys.messsage.error('禁用错误，消息:' + result.msg);
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
		window.setTitle('更改');
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
	 	 	          {header: '编码', dataIndex: 'code'},
	 	 	          {header: '名称', dataIndex: 'name'},
	 	 	          {header: '状态', renderer: clsys.grid.columnrender.StateRender, dataIndex: 'state'}]
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
	        '<h3 style="margin-bottom:5px; align:center">先选择类别</h3>',
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
			emptyText: '选择类别',
			store: new Ext.data.ArrayStore({
				fields: [ 'type', 'typeName' ],
				data: [
						[ 'Level', '员工级别' ],
						['StorageLocation','库位'],
						['ErrorLevel','误差等级'],
						['Humidity','湿度指示'],
						['ProductCode','产品代号'],
						['ProductType','产品类别'],
						['Unit','产品单位'],
						['UsageType','产品用途']
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
			text: '新增',
			id: 'addBasic',
			disabled: true,
			iconCls: 'icon-add',
			handler: openAddBasic
		},{
			text: '删除',
			id: 'delBasic',
			disabled: true,
			iconCls: 'icon-remove',
			handler: delBasic
		},{
			text: '更新',
			id: 'updBasic',
			disabled: true,
			iconCls: 'icon-update',
			handler: openUpdBasic
		}, '-', {
			text: '启用',
			id: 'usingBasic',
			disabled: true,
			iconCls: 'icon-using',
			handler: usingBasic
		},{
			text: '禁用',
			id: 'suspendedBasic',
			disabled: true,
			iconCls: 'icon-suspended',
			handler: suspendedBasic
		}, '-', {
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				basicStore.reload();
			},
			scope:this
		}, '->', {
			xtype: 'is-search-field',
			id: 'basic-search',
			emptyText: '输入条件',
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