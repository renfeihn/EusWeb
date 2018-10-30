<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	var inventorySummaryChartUrl = 'inventorySummarySalesAndOrders.action';
	
	var summaryChart = new is.panel.OlapChartPanel(
			'�����',
			600, 400, 'inventorySummaryChartPanel', 'inventorySummaryChart',
			575, 375, inventorySummaryChartUrl);

	var durationChart = new is.panel.OlapChartPanel(
			'����',
			400, 300, 'inventorySummaryDurationChartPanel', 'inventorySummaryDurationChart',
			375, 275, 'inventorySummaryDurationBar.action'
	);
	
	var durationPie = new is.panel.OlapChartPanel(
			'����',
			400, 300, 'inventorySummaryDurationPiePanel', 'inventorySummaryDurationPie',
			375, 275, 'inventorySummaryDurationPie.action'
	);

	var summarySalesGrid = new is.panel.OlapGridPanel('�����б�', null, 'month', 'InventoryYearly', 
			'inventorySalesYearlyGrid.action',
			[{name:'month', type:'int'}, {name:'count', type:'int'}, {name:'cost', type:'float'}], 
		        [{id: 'month', header: '�·�', sortable: true, dataIndex: 'month'},
		 	  	{id: 'count', header: '����', dataIndex: 'count'},
		 	  	{id: 'cost', header: '���', dataIndex: 'cost'} ], 'summarySalesGridPanel', 'summarySalesGrid');
	  	
	var summaryOrderGrid = new is.panel.OlapGridPanel('����б�', null, 'month', 'InventoryOrders', 
			'inventoryOrdersYearlyGrid.action',
			[{name:'month', type:'int'}, {name:'count', type:'int'}, {name:'cost', type:'float'}], 
		        [{id: 'month', header: '�·�', sortable: true, dataIndex: 'month'},
		 	  	{id: 'count', header: '����', dataIndex: 'count'},
		 	  	{id: 'cost', header: '���', dataIndex: 'cost'} ], 'summaryOrderGridPanel', 'summaryOrderGrid');

 	  	
	var viewAction = function(action) {
	};
	
	var summaryPanel = new Ext.Panel({
		layout: 'table',
		renderTo: 'inventorySummaryMain',
		tbar: [{
			text: '�����',
			iconCls: 'add16',
			pressed: true,
			enableToggle: true,
			scope:this,
			toggleHandler:function(btn, pressed) {},
			handler: viewAction.createCallback('�����')
		},{
			text: '��Դ���',
			iconCls: 'add16',
			handler: viewAction.createCallback('�����')
		},{
			text: '�������',
			iconCls: 'add16',
			handler: viewAction.createCallback('�����')
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
<!-- �������ݱ� -->
<div id="summarySalesGridPanel"></div>
<div id="summarySalesGrid"></div>
<!-- ������ݱ� -->
<div id="summaryOrderGridPanel"></div>
<div id="summaryOrderGrid"></div>
<!-- ������״ͼ -->
<div id="inventorySummaryDurationChartPanel"></div>
<div id="inventorySummaryDurationChart"></div>
<!-- �����״ͼ -->
<div id="inventorySummaryDurationPie"></div>
<div id="inventorySummaryDurationPiePanel"></div>
</body>
</html>