<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	var resources = Ext.getCmp('SalesResources-mainpanel');

	/*
	 * salesResources resources store.
	 */
	var salesResourcesStore = new Ext.data.JsonStore({
		autoDestroy: true,
		autoLoad: true,
		url: 'findCarResource.action',
		baseParams: {
			start: 0,
			limit: 25
		},
		root: 'CarResourceList',
		totalProperty: 'results',
		idProperty: 'id',
		fields: ['id',
	 		{name:'model', mapping:'model.name'},
	 		{name:'suite', mapping:'suite.name'},
			{name:'color', mapping:'color.name'},
			{name:'decoration', mapping:'decoration.name'},
			{name:'engine', mapping:'car.engine'},
			{name:'frame', mapping:'car.frame'},
			{name:'productDate', type:'date', mapping:'car.productDate'}, 
			{name:'certificate', mapping:'car.certificate'},
			{name:'state', type:'int'}, 
			{name:'carstate', mapping:'car.state', type:'int'}]
	});

	resources.getTopToolbar().add({
			text: '详细',
			id: 'salesResourcesDetail',
			disabled: true,
			iconCls: 'icon-prop',
			handler: function() {
				var salesResourcesId = Ext.getCmp('salesResources-grid').getSelectionModel().getSelected().get('id');
				var window = Ext.getCmp('salesResources-window');
				if (!window) {
					window = new is.window.CarResource();
				}
				window.open(salesResourcesId);
				window.setTitle('更改');
				window.show();
			},
			scope: this
		}, {
			text: 'Excel导出',
			iconCls: 'icon-leading-out',
			handler: function() {
				var type = Ext.getCmp('salesResources-find-type').getValue();
				var value = Ext.getCmp('salesResources-search').getValue();
				window.open('exportCheckinExcel.action?findType=' + type + '&findValue=' + value);
			}
		}, {
			text: 'Excel导出所有',
			iconCls: 'icon-out',
			handler: function() {
				window.open('exportAllCheckinExcel.action');
			}
		}, '-', {
			text: '跟踪',
			iconCls: 'icon-pkg',
			id: 'traceCheckin',
			disabled: true,
			handler: function() {
			},
			scope: this
		}, {
			text: '刷新',
			iconCls: 'icon-refresh',
			handler: function() {
				salesResourcesStore.reload();
			},
			scope: this
		}, '->', ' ', {
			xtype: 'is-search-field',
			id: 'salesResources-search',
			store: salesResourcesStore,
			paramName: 'search',
			tooltip: '输入查询条件,按回车或点击查询.'
		}, ' '
	);	
	
	resources.add({
		xtype: 'grid',
		id: 'sales-resources-grid',
		stripeRows: true,
		store: salesResourcesStore,
		border: false,
		frame: false,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: true
			},
			columns: [
	        	{header: '车型', dataIndex: 'model'},
	        	{header: '配置', dataIndex: 'suite'},
	        	{header: '颜色', dataIndex: 'color'},
	        	{header: '内饰', dataIndex: 'decoration'},
	        	{header: '车架号', dataIndex: 'frame'},
	        	{header: '发动机号', dataIndex: 'engine'},
	        	{header: '合格证号', dataIndex: 'certificate'},
	        	{header: '生产日期', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'},
	        	{header: '状态', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: '实车状态', renderer: clsys.grid.columnrender.CarStatusRender, dataIndex: 'carstate'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	clsys.form.Util.PagingToolbar(salesResourcesStore, resources.bbar, 'Resource-paging');		
	resources.getBottomToolbar().hide();

	resources.doLayout();
});
</script>
</head>
<body>
</body>
</html>