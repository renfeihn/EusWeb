<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<script type="text/javascript" src="js/common/ContractCarSelector.js"></script>
<script type="text/javascript" src="js/common/ContractCarDataview.js"></script>
<script type="text/javascript" src="js/common/ClientDataview.js"></script>
<script type="text/javascript" src="js/common/ClientInfo.js"></script>
<script type="text/javascript" src="js/common/EmployeeInfo.js"></script>
<script type="text/javascript" src="js/common/EmployeeDataview.js"></script>
<script type="text/javascript" src="js/common/ContractDataview.js"></script>
<script type="text/javascript" src="js/common/ContractSelector.js"></script>
<script type="text/javascript" src="js/common/ContractInfo.js"></script>
<script type="text/javascript" src="js/sales/Sales.js"></script>
<script type="text/javascript">
Ext.onReady(function() {
	/*
	 * sales store.
	 */
	var salesStore = new Ext.data.JsonStore({
        autoDestroy:true,
        autoLoad: { params: { status: ['Using'], start:0, limit:25 } },
        baseParams: { status: ['Using'], start:0, limit:25 },
		url: "findSales.action",
		root: "SalesList",
		idProperty: "id",
		fields: [ 'id', 'code', {name:'selldate', type:'date', dateFormat:'Y-m-d'},
		  		'contract', 
		  		{name:'client', mapping:'contract.client'}, 
		  		'employee', 'car', 
		  		{name:'resstate', mapping:'car.state', type:'int'},
		  		{name:'model', mapping:'car.model.name'},
		  		{name:'suite', mapping:'car.suite.name'},
		  		{name:'color', mapping:'car.color.name'},
		  		{name:'decoration', mapping:'car.decoration.name'},
		  		{name:'carstate', mapping:'car.car.state', type:'int'},
		  		{name:'frame', mapping:'car.car.frame'},
		  		{name:'certificate', mapping:'car.car.certificate'},
		  		{name:'engine', mapping:'car.car.engine'},
		  		{name:'productDate', mapping:'car.car.productDate', type:'date', dateFormat:'Y-m-d'}
		  		]
	});

	var salesPanel = Ext.getCmp('Sold-mainpanel');

	clsys.form.Util.PagingToolbar(salesStore, salesPanel.bbar, 'sales-paging');
	
	var salesGrid = new Ext.grid.GridPanel({
		id: 'salesGrid',
		//title: '���',
		store: salesStore,
 	    autoHeight:true,
		border: false,
		frame: false,
 	    renderTo: 'salesGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            //width: 120,
 	            sortable: true
 	        },
 	        columns: [
     	        {header: '���۵����', dataIndex: 'code'},
     	        {header: '���ۺ�ͬ', renderer: clsys.grid.columnrender.ContractRender, dataIndex: 'contract'},
     	        {header: '�ͻ�', renderer: clsys.grid.columnrender.ClientRender, dataIndex: 'client'},
      	        {header: '���۹���', renderer: clsys.grid.columnrender.EmployeeRender, dataIndex: 'employee'},
	        	{header: '����', dataIndex: 'model'},
	        	{header: '��ɫ', dataIndex: 'color'},
	        	{header: '����', dataIndex: 'decoration'},
	        	{header: '���ܺ�', dataIndex: 'frame'},
	        	{header: '��������', dataIndex: 'engine'},
	        	{header: '�ϸ�֤��', dataIndex: 'certificate'},
	        	{header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'productDate'}
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		}, 
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	salesPanel.getTopToolbar().add({
			text: '����',
			iconCls: 'icon-add',
			handler: function(button) {
				var window = Ext.getCmp('sales-form-window');
				if (!window) {
					window = new is.window.Sales();
				}
				window.show();
			},
			scope: this
		}, {
			text: '��ϸ',
			id: 'sales-detail',
			iconCls: 'icon-prop',
			handler: function() {
				var rv = Ext.getCmp('sales-resource-view');
				if (rv.pressed) {
					var win = Ext.getCmp('car-information-window');
					if (!win) {
						win = new is.window.Car();
					}
					win.open(salesResourcesGrid.getSelectionModel().getSelected().get('id'));
					win.show();
				} else {
					var win = Ext.getCmp('sales-form-window');
					if (!win) {
						win = new is.window.Sales();
					}
					win.open(salesGrid.getSelectionModel().getSelected().get('id'));
					win.show();
				}
			},
			scope: this
		}, {
			text: 'Excel����',
			iconCls: 'icon-leading-out',
			handler: function() {
				var type = Ext.getCmp('sales-find-type').getValue();
				var value = Ext.getCmp('sales-search').getValue();
				window.open('exportSalesExcel.action?findType=' + type + '&findValue=' + value);
			}
		}, {
			text: 'Excel��������',
			iconCls: 'icon-out',
			handler: function() {
				window.open('exportAllSalesExcel.action');
			}
		}, {
			text: '����',
			iconCls: 'icon-pkg',
			id: 'traceSales',
			disabled: true,
			handler: function() {
			},
			scope: this
		}, {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				salesStore.reload();
			},
			scope: this
		}, '->', {
			xtype: 'is-search-field',
			id: 'sales-search',
			store: salesStore,
			paramName: 'search'
		}, ' '
	);
       
	salesPanel.add(salesGrid);
	salesPanel.getBottomToolbar().hide();
	salesPanel.doLayout();	
	
	salesGrid.getSelectionModel().on('selectionchange', function(sm) {
		//Ext.getCmp('removeSales').setDisabled(sm.getCount() > 1);
		Ext.getCmp('traceSales').setDisabled(sm.getCount() > 1);
		Ext.getCmp('sales-detail').setDisabled(sm.getCount() > 1);
	});
});
</script>
</head>
<body>
<div id="salesPanel"></div>
<div id="salesWindow"></div>
<div id="salesGridPanel"></div>
<div id="salesExcelUploadForm"></div>
<div id="salesExcelUpload"></div>
<div id="salesExelUploadPreviewForm"></div>
<div id="salesExportExcelForm"></div>
</body>
</html>