<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	var yearlyGrid = new is.panel.OlapGridPanel(null, null, 'month', 'InventoryYearly', 
			'inventoryDurationYearlyGrid.action',
		[{name:'month', type:'int'}, {name:'count', type:'int'}, {name:'cost', type:'float'}], 
	        [{id: 'month', header: '月份', sortable: true, dataIndex: 'month'},
	 	  	{id: 'count', header: '数量', dataIndex: 'count'},
	 	  	{id: 'cost', header: '金额', dataIndex: 'cost'} ], 'yearlyGridPanel', 'yearlyGrid');

	var yearlyChart = new is.panel.OlapChartPanel(
			null,
		450, 300, 'yearlyChartPanel', 'yearlyChart',
		450, 300, 'inventoryDurationYearlyBar.action'); 

 	var inventoryDurationsPortalTools = [{
 	 	id:'close',
 	 	handler: function(e, target, panel) {
 	 		panel.ownerCt.remove(panel, true);
 		}
 	}];

	var inventoryDurationsPortalPanel = new Ext.Panel({
        renderTo: 'InventoryDurationsPortal',
        items:[{
            xtype:'portal',
            margins:'35 5 5 0',
            items:[{
                width:475,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    title:'年度库存库龄',
                    tools: inventoryDurationsPortalTools,
                    items: yearlyChart
                },{
                    layout:'fit',
                    title:'年度库存库龄列表',
                    tools: inventoryDurationsPortalTools,
                    items: yearlyGrid
                }]
            }, {
                width:300,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools: inventoryDurationsPortalTools,
                    items: new Ext.Panel()
                },{
                    layout:'fit',
                    tools: inventoryDurationsPortalTools,
                    items: new Ext.Panel()
                }]
            }, {
                width:200,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools: inventoryDurationsPortalTools,
                    items: new Ext.Panel()
                },{
                    layout:'fit',
                    tools: inventoryDurationsPortalTools,
                    items: new Ext.Panel()
                }]
            }]
        }]
    });
 });
</script>
</head>

<body>
<div id="InventoryDurationsPortal"></div>
<div id="yearlyGrid"></div>
<div id="yearlyGridPanel"></div>
<div id="yearlyChart"></div>
<div id="yearlyChartPanel"></div>
</body>
</html>