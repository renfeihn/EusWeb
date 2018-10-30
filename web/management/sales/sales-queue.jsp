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
	        	{header: '����', dataIndex: 'model'},
	        	{header: '����', dataIndex: 'suite'},
	        	{header: '��ɫ', dataIndex: 'color'},
	        	{header: '����', dataIndex: 'decoration'},
	        	{header: '״̬', renderer: clsys.grid.columnrender.ResourceStatusRender, dataIndex: 'state'},
	        	{header: '��ͬ', dataIndex: 'contract'},
	        	{header: '�ͻ�', dataindex: 'contract'}
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
