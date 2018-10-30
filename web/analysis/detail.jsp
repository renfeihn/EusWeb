<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	function findSWF(movieName) {
		if (navigator.appName.indexOf("Microsoft")!= -1) {
			//return window["ie_" + movieName];
			//return window[movieName];
			return document.getElementById(movieName);
		} else {
			return document[movieName];
		}
	}
	
	var dailyGrid = new is.panel.OlapGridPanel(null, null, 'name', 'InventoryDaily', 
			'inventoryDetailDailyGrid.action',
			['name', {name:'count', type:'int'}], 
 	        [
 	 	  	            {id: 'name', header: '����', sortable: true, dataIndex: 'name'},
 	 	  	            {id: 'count', header: '����', dataIndex: 'count'}
 	 	  	        ], 'InventoryDetailDailyGridPanel', 'InventoryDetailDailyGrid');

	swfobject.embedSWF("open-flash-chart.swf", "InventoryDetailDailyChart", 450, 300, "9.0.0", 
			"expressInstall.swf",
			{"data-file": "inventoryDetailDailyBar.action" },
			{"wmode" : "opaque"}
			);

	var dailyChartSWF = document.getElementById('InventoryDetailDailyChart');
	/*var dailyChart = new is.panel.OlapChartPanel(
			null,
		475, 300, 'InventoryDetailDailyChartPanel', 'InventoryDetailDailyChart',
		450, 300, 'inventoryDetailDailyBar.action');   */ 
	var dailyChart = new Ext.Panel({
		renderTo: 'InventoryDetailDailyChartPanel',
		contentEl: 'InventoryDetailDailyChart'
	});

 	var inventoryDetailPortalTools = [{
 	 	id:'close',
 	 	handler: function(e, target, panel) {
 	 		panel.ownerCt.remove(panel, true);
 		}
 	}];

 	function updateDailyDetailByModel() {
 		var ds = dailyGrid.getOlapDatastore();
 		ds.removeAll();
 		ds.baseParams = {'query':'model'};
 		ds.load();
 	 	dailyChartSWF.reload('inventoryDetailDailyBar.action?query=model');
 	 };
 	function updateDailyDetailBySerial() {
 		var ds = dailyGrid.getOlapDatastore();
 		ds.removeAll();
 		ds.baseParams = {'query':'serial'};
 		ds.load();
 	 	dailyChartSWF.reload('inventoryDetailDailyBar.action?query=serial');
 	};
 	function updateDailyDetailByColor() {
 		var ds = dailyGrid.getOlapDatastore();
 		ds.removeAll();
 		ds.baseParams = {'query':'color'};
 		ds.load();
 	 	dailyChartSWF.reload('inventoryDetailDailyBar.action?query=color');
 	 };
 	
	var inventoryDetailPortalPanel = new Ext.Panel({
		border:false,
		autoScroll:false,
        renderTo: 'InventoryDatail',
        tbar:[
              {
				xtype: 'datefield',
				fieldLabel: '����',
				listeners:{
  					change: function(field, newValue, oldValue) {
						alert(newValue);
              		}
              	}
              }, '-',
              {
                  text: '������',
                  handler: updateDailyDetailByModel
              },
              {
                  text: '������',
                  handler: updateDailyDetailBySerial
              },
              {
                  text: '����ɫ',
                  handler: updateDailyDetailByColor
              },'->',{
                  text: '��ʾ�ϼ�'
              },{
                  text: 'ά������',
                  iconCls:'config',
                  menu: {
                  	id:'dimensionscope',
                  	width:100,
                  	items:[{
                      	text: '�滻��',
                  		checked:true,
                  		group:'ds-group',
                  		scope:this
              	  	}, {
                  	  	text: '�滻��',
                  	  	group:'ds-group',
                  	  	scope:this
              	  	},{
                  	  	text: '����',
                  	  	group: 'ds-group',
                  	  	scope:this
              	  	}]
              	}
              }
        ],
        items:[{
            autoScroll:true,
            xtype:'portal',
            margins:'35 5 5 0',
            border:false,
            items:[{
                width:475,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    title:'�տ��',
                    tools: inventoryDetailPortalTools,
                    items: dailyChart
                },{
                    layout:'fit',
                    title:'�տ���б�',
                    tools: inventoryDetailPortalTools,
                    items: new Ext.Panel()
                }]
            }, {
                width:300,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools: inventoryDetailPortalTools,
                    items: dailyGrid
                },{
                    layout:'fit',
                    title:'�տ���б�',
                    tools: inventoryDetailPortalTools,
                    items: dailyGrid
                }]
            }, {
                width:200,
                style:'padding:10px 0 10px 10px',
                items:[{
                    layout:'fit',
                    tools: inventoryDetailPortalTools,
                    items: new Ext.Panel()
                },{
                    layout:'fit',
                    tools: inventoryDetailPortalTools,
                    items: new Ext.Panel()
                }]
            }]
        }]
    });
 });
</script>
</head>

<body onunload="javascript:swfobject.removeSWF('InventoryDetailDailyChart');">
<div id="InventoryDatail"></div>
<div id="InventoryDetailDaily"></div>
<div id="InventoryDetailDailyChart"></div>
<div id="InventoryDetailDailyChartPanel"></div>
<div id="InventoryDetailDailyGrid"></div>
<div id="InventoryDetailDailyGridPanel"></div>
</body>
</html>