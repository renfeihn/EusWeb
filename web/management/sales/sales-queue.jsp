<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<script type="text/javascript">

Ext.onReady(function() {
	var salesQueueStore = new Ext.data.JsonStore({
		url: 'listSalesQueue.action',
		autoLoad: { start: 0, limit: 25 },
		root: 'CarResourceList',
		fields: ['id',
	 		{name:'model', mapping:'model.name'},
	 		{name:'suite', mapping:'suite.name'},
			{name:'color', mapping:'color.name'},
			{name:'decoration', mapping:'decoration.name'},
			{name:'state', type:'int'},
			'contract']
	});

	var salesQueuePanel = Ext.getCmp('SalesQueue-mainpanel');

	salesQueuePanel.add({
		xtype: 'grid',
		store: salesQueueStore,
		id: 'sales-queue-grid',
		stripeRows: true,
		border: false,
		frame: false,
		autoScroll: true,
		autoHeight: true,
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				sortable: false
			},
			columns: [
	        	{header: '车型', dataIndex: 'model'},
	        	{header: '配置', dataIndex: 'suite'},
	        	{header: '颜色', dataIndex: 'color'},
	        	{header: '内饰', dataIndex: 'decoration'},
	        	{header: '状态', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: '合同', dataIndex: 'contract'},
	        	{header: '客户', dataindex: 'contract'}
			]
		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	clsys.form.Util.PagingToolbar(salesQueueStore, salesQueuePanel.bbar, 'salesQueue-paging');
	salesQueuePanel.getTopToolbar().hide();
	salesQueuePanel.getBottomToolbar().hide();
	salesQueuePanel.doLayout();
});
</script>
</head>
<body>
</body>
</html>
