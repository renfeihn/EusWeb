<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/drill.js"></script>
<script type="text/javascript">
var drillMap = {};

function drillDown(row, col) {
 	var drill = drillMap[row][col];
	//alert('about to drill:' + row + ', ' + col + '->' + drill);
 	drill.drilldown();
};

Ext.onReady(function() {
 	var inventoryOrdersTools = [{
 	 	//id:'close',
 	 	handler: function(e, target, panel) {
 	 		panel.ownerCt.remove(panel, true);
 		}
 	}];
 	
 	function rowCaptionRenderer(value, meta, record, rowIndex, colIndex, store) {
 	 	if (!value || value == '') {
 	 	 	//Don't render empty value.
 	 	 	return;
 	 	}
 	 	var columns = ['count', 'cost'], types = ['string_field', 'string_field'], drills = [];
 	 	for (var i = 0; i < 128; i++) {
 	 	 	var name = '_drill_name_' + i;
 	 	 	if (!record.get(name)) break;
 	 	 	drills.push(record.get(name));
 	 	}

		//alert(store.catalog);
		if (!drillMap[rowIndex]) {
			drillMap[rowIndex] = [];
		}
 	 	
 	 	drillMap[rowIndex][colIndex] = new is.data.Drill({
 	 	 	id: 'drill_' + new Date().getTime(),
 	 	 	drillstore: store,
 	 	 	record: record,
 	 	 	catalog: store.catalog,
 	 	 	analysis: store.analysis,
 	 	 	dimension: colIndex,
 	 	 	position: rowIndex,
 			columns: columns.toString(),
 			types: types.toString(),
 			drills: drills,
 			query: store.queryId
 	 	});
 	 	
 	 	var hasChildren = record.get('hasChildren' + colIndex);
 	 	//alert('record.get(\'hasChildren' + colIndex + '\') got:' + hasChildren);
 	 	if (hasChildren) {
 	 	 	var img;
 	 	 	if (record.get('drilled' + colIndex)) {
 	 	 	 	img = 'images/minus.gif';
 	 	 	} else {
 	 	 	 	img = 'images/plus.gif';
 	 	 	}
 	 	 	
 	 	 	return '<img height="12" src="' + img + '" onclick="drillDown(\'' + rowIndex + '\', \'' + colIndex + '\');"></img><span>' + value + '</span>';
 	 	} else {
 	 	 	var img;
 	 	 	if (record.get('drilled' + colIndex)) {
 	 	 	 	img = 'images/elbow.gif';
 	 	 	} else {
 	 	 		return '<span>' + value + '</span>';
 	 	 	}
 	 		return '<img height="12" src="' + img + '"></img><span>' + value + '</span>';
 	 	}
 	}

 	var yearlyGrid = new Ext.grid.GridPanel({
 	 	store: new Ext.data.JsonStore({
 	        autoDestroy:true,
 	        autoLoad:true,
 			url: 'inventoryOrdersYearlyGrid.action',
 			reader: new Ext.data.JsonReader()
 		}),
 		stripeRows: true,
 	    autoHeight:true,
 	 	renderTo: 'inventoryOrdersYearlyGridPanel',
 	 	columns: [
 	 	 	 {header: '车型', renderer: rowCaptionRenderer, /*sortable: true,*/ dataIndex: 'header0'},
 	 	 	 {header: '款型', renderer: rowCaptionRenderer, dataIndex: 'header1'},
 	 	 	 {header: '颜色', renderer: rowCaptionRenderer, dataIndex: 'header2'},
 	  	     {header: '数量', dataIndex: 'count'},
 	  	     {header: '成本', dataIndex: 'cost'}
 		]
 	});

 	yearlyGrid.store.on('metachange', function(store, meta) {
		store.catalog = meta.catalog;
		store.analysis = meta.analysis;
		store.queryId = meta.query;
 	});


 	/*
	var yearlyChart = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventoryOrdersYearlyChartPanel', 'inventoryOrdersYearlyChart',
			450, 300, 'inventoryOrdersYearlyBar.action');
*/
	/*
	/*
	var monthlyChart = new is.panel.OlapChartPanel(
			null,
			475, 300, 'inventoryOrdersMonthlyChartPanel', 'inventoryOrdersMonthlyChart',
			450, 300, 'inventoryOrdersMonthlyBar.action');
	*/
 	
	var inventoryOrdersPortalPanel = new Ext.Panel({
        renderTo:'inventoryOrdersPortal',
        items:[{
            xtype:'portal',
            margins:'35 5 5 0',
            items:[{
                width:550,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools:inventoryOrdersTools,
                    items: []//yearlyChart
                },{
                    layout:'fit',
                    tools:inventoryOrdersTools,
                    items: []//monthlyChart
                },{
                    layout:'fit',
                    tools:inventoryOrdersTools,
                    items: []//monthlyChart
                },{
                    title:'出库',
                    layout:'fit',
                    tools:inventoryOrdersTools,
                    items: yearlyGrid//monthlyChart
                }]
            }, {
                width:200,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools:inventoryOrdersTools,
                	items: []//yearlyGrid
                }, {
                    layout:'fit',
                    title:'Testing is.GridPanel',
                    tools:inventoryOrdersTools,
                	items: new Ext.Panel({})
               }]
            }, {
                width:200,
                style:'padding:10px 0 10px 10px',
                items:[{
                	layout:'fit',
                    tools:inventoryOrdersTools,
                	items: new Ext.Panel({})
                }]
            }]
        }]
    });
 });
</script>
</head>

<body>
<div id="inventoryOrdersPortal"></div>
<div id="inventoryOrdersYearlyChartPanel"></div>
<div id="inventoryOrdersYearlyChart"></div>
<div id="inventoryOrdersMonthlyChartPanel"></div>
<div id="inventoryOrdersMonthlyChart"></div>
<div id="inventoryOrdersYearlyGrid"></div>
<div id="inventoryOrdersYearlyGridPanel"></div>
<div id="testingGridPanel"></div>
<div id="debugingGridPanel"></div>
<div id="debuging2GridPanel"></div>
</body>
</html>
