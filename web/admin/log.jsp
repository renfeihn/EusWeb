<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<script type="text/javascript" src="js/Log.js"></script>
<script type="text/javascript">
Ext.onReady(function() {
	var logStore = new Ext.data.JsonStore({
		autoLoad: true,
		autoDestroy: true,
		url: 'findSystemLog.action',
		root: 'LogList',
		fields: ['id', 'type', 'user', 'text']
	});

	var logGridPanel = Ext.getCmp('SystemLogging-mainpanel');

	logGridPanel.add({
		xtype: 'grid',
		id: 'logGrid',
		//title: '���',
		store: logStore,
 	    autoHeight:true,
		border: false,
		frame: false,
 	    renderTo: 'logGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            //width: 120,
 	            sortable: true
 	        },
 	        columns: [
     	        {header: '���', dataIndex: 'id'},
      	        {header: '����', dataIndex: 'type'},
      	        {header: '����Ա', dataIndex: 'user'},
      	        {header: '����', dataIndex: 'log'}
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		}, 
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	logGridPanel.getBottomToolbar().hide();
});
</script>
</head>
<body>
<div id="logPanel"></div>
<div id="logWindow"></div>
<div id="logGridPanel"></div>
<div id="logExcelUploadForm"></div>
<div id="logExcelUpload"></div>
<div id="logExelUploadPreviewForm"></div>
<div id="logExportExcelForm"></div>
</body>
</html>