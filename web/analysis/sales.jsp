<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
 	var inventorySalesTools = [{
 	 	id:'close',
 	 	handler: function(e, target, panel) {
 	 		panel.ownerCt.remove(panel, true);
 		}
 	}];

 	/* �������״ͼ */
 	var yearlyChart = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesPiePanel', 'inventorySalesPie',
			450, 300, 'inventorySalesYearlyBar.action');

 	/*
	var montylyChart = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesMonthlyBarPanel', 'inventorySalesMonthlyBar',
			450, 300, 'inventorySalesMonthlyBar.action');
	*/
	/* ���������� */
	var monthlyCountLine = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesMonthlyCountLinePanel', 'inventorySalesMonthlyCountLine',
			450, 300, 'inventorySalesMonthlyCountLine.action');
	/*�½������ */
	var monthlyMoneyLine = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesMonthlyMoneyLinePanel', 'inventorySalesMonthlyMoneyLine',
			450, 300, 'inventorySalesMonthlyMoneyLine.action');
	

	var yearlyCountPie = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesYearlyCountPanel', 'inventorySalesYearlyCount',
			450, 300, 'inventorySalesYearlyCountPie.action');
	
	var yearlyMoneyPie = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventorySalesYearlyMoneyPanel', 'inventorySalesYearlyMoney',
			450, 300, 'inventorySalesYearlyMoneyPie.action');

	var yearlyGrid = new is.panel.OlapGridPanel(null, null, 'month', 'InventoryYearly', 
			'inventorySalesYearlyGrid.action',
		['name', {name:'count', type:'int'}, {name:'sell', type:'float'}], 
	        [{id: 'name', header: '����', sortable: true, dataIndex: 'name'},
	 	  	{id: 'count', header: '����', dataIndex: 'count'},
	 	  	{id: 'sell', header: '���', dataIndex: 'sell'} ], 'inventorySalesYearlyGridPanel', 'inventorySalesYearlyGrid');
	  	
	var inventorySalesPortalPanel = new Ext.Panel({
        renderTo:'inventorySalesPortal',
        tbar:[{
            text:'������'
        },{
            text:'������'},{

                text:'����ɫ'
        }],
        items:[{
            xtype:'portal',
            margins:'35 5 5 0',
            items:[{
                width:475,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    title:'����',
                    tools:inventorySalesTools,
                    items: yearlyChart
                },{
                    layout:'fit',
                    tools:inventorySalesTools,
                    items: monthlyCountLine
                }, {
                    layout:'fit',
                    tools:inventorySalesTools,
                    items: monthlyMoneyLine
                }]
            }, {
                width:300,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools:inventorySalesTools,
                	items: yearlyCountPie
                }, {
                    layout:'fit',
                    tools:inventorySalesTools,
                	items: yearlyMoneyPie
                }]
            }, {
                width:200,
                style:'padding:10px 0 10px 10px',
                items:[{
                	layout:'fit',
                    tools:inventorySalesTools,
                	items: yearlyGrid
                }]
            }]
        }]
    });
 });
</script>
</head>

<body>
<div id="inventorySalesPortal"></div>
<div id="inventorySalesPiePanel"></div>
<div id="inventorySalesPie"></div>
<div id="inventorySalesMonthlyBarPanel"></div>
<div id="inventorySalesMonthlyBar"></div>
<div id="inventorySalesYearlyCount"></div>
<div id="inventorySalesYearlyMoney"></div>
<div id="inventorySalesYearlyCountPanel"></div>
<div id="inventorySalesYearlyMoneyPanel"></div>
<div id="inventorySalesYearlyGrid"></div>
<div id="inventorySalesYearlyGridPanel"></div>

<div id=""></div>
<div id=""></div>
<!-- ���������� -->
<div id="inventorySalesMonthlyCountLinePanel"></div>
<div id="inventorySalesMonthlyCountLine"></div>
<!-- �½������ -->
<div id="inventorySalesMonthlyMoneyLinePanel"></div>
<div id="inventorySalesMonthlyMoneyLine"></div>
</body>
</html>