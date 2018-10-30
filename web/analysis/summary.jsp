<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	var inventorySummaryChartUrl = 'inventorySummarySalesAndOrders.action';
	
	var summaryChart = new is.panel.OlapChartPanel(
			'出入库',
			600, 400, 'inventorySummaryChartPanel', 'inventorySummaryChart',
			575, 375, inventorySummaryChartUrl);

	var durationChart = new is.panel.OlapChartPanel(
			'库龄',
			400, 300, 'inventorySummaryDurationChartPanel', 'inventorySummaryDurationChart',
			375, 275, 'inventorySummaryDurationBar.action'
	);
	
	var durationPie = new is.panel.OlapChartPanel(
			'库龄',
			400, 300, 'inventorySummaryDurationPiePanel', 'inventorySummaryDurationPie',
			375, 275, 'inventorySummaryDurationPie.action'
	);

	var summarySalesGrid = new is.panel.OlapGridPanel('出库列表', null, 'month', 'InventoryYearly', 
			'inventorySalesYearlyGrid.action',
			[{name:'month', type:'int'}, {name:'count', type:'int'}, {name:'cost', type:'float'}], 
		        [{id: 'month', header: '月份', sortable: true, dataIndex: 'month'},
		 	  	{id: 'count', header: '数量', dataIndex: 'count'},
		 	  	{id: 'cost', header: '金额', dataIndex: 'cost'} ], 'summarySalesGridPanel', 'summarySalesGrid');
	  	
	var summaryOrderGrid = new is.panel.OlapGridPanel('入库列表', null, 'month', 'InventoryOrders', 
			'inventoryOrdersYearlyGrid.action',
			[{name:'month', type:'int'}, {name:'count', type:'int'}, {name:'cost', type:'float'}], 
		        [{id: 'month', header: '月份', sortable: true, dataIndex: 'month'},
		 	  	{id: 'count', header: '数量', dataIndex: 'count'},
		 	  	{id: 'cost', header: '金额', dataIndex: 'cost'} ], 'summaryOrderGridPanel', 'summaryOrderGrid');

 	  	
	var viewAction = function(action) {
	};
	
	var summaryPanel = new Ext.Panel({
		layout: 'table',
		renderTo: 'inventorySummaryMain',
		tbar: [{
			text: '出入库',
			iconCls: 'add16',
			pressed: true,
			enableToggle: true,
			scope:this,
			toggleHandler:function(btn, pressed) {},
			handler: viewAction.createCallback('出入库')
		},{
			text: '资源库存',
			iconCls: 'add16',
			handler: viewAction.createCallback('出入库')
		},{
			text: '库存周期',
			iconCls: 'add16',
			handler: viewAction.createCallback('出入库')
		}],
		items: [ {
			items: [summaryChart, summarySalesGrid, summaryOrderGrid ]},
		{
			items:[ durationChart, durationPie ]
		}]
	});
});
</script>
</head>

<body onunload="javascript:swfobject.removeSWF('inventorySummaryChart');">
<div id="inventorySummary"></div>
<div id="inventorySummaryMain"></div>
<div id="inventorySummarySide"></div>
<div id="inventorySummaryChartPanel"></div>
<div id="inventorySummaryChart"></div>
<!-- 出库数据表 -->
<div id="summarySalesGridPanel"></div>
<div id="summarySalesGrid"></div>
<!-- 入库数据表 -->
<div id="summaryOrderGridPanel"></div>
<div id="summaryOrderGrid"></div>
<!-- 库龄柱状图 -->
<div id="inventorySummaryDurationChartPanel"></div>
<div id="inventorySummaryDurationChart"></div>
<!-- 库龄饼状图 -->
<div id="inventorySummaryDurationPie"></div>
<div id="inventorySummaryDurationPiePanel"></div>
</body>
</html>