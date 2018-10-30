<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="js/ext-3.1/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="css/is.css" />
<script type="text/javascript" src="js/ext-3.1/ext-base.js"></script>
<script type="text/javascript" src="js/ext-3.1/ext-all.js"></script>
<script type="text/javascript">
Ext.onReady(function() {
	var data = [ ['a', 'b'], ['c', 'd'] ];
	
	  var comboFromArray = new Ext.form.ComboBox({
	        store: data,
	        typeAhead: true,
	        forceSelection: true,
	        triggerAction: 'all',
	        emptyText:'Select a state...',
	        selectOnFocus:true,
	        applyTo: 'outgoingPanel'
	    });
	   new Ext.Panel({
	    	contentEl: 'array-combo-code',
	    	autoScroll: true,
	    	width: Ext.getBody().child('p').getWidth(),
	    	title: 'View code to create this combo',
	    	hideCollapseTool: true,
	    	titleCollapse: true,
	    	collapsible: true,
	    	collapsed: true,
	    	renderTo: 'array-combo-code-panel'
	    });
});
</script>
</head>
<body>
<p>
The combo box can also use plain array data directly as its data source, wrapping the array internally
with a ArrayStore as needed.  You can pass a 1-dimensional or multi-dimensional array as the store config:</p>
<div>
    <input type="text" id="array-states" size="20"/>
</div>
<div id="array-combo-code-panel" style="margin-top:10px">
<pre id="array-combo-code" class="code"><code>var comboFromArray = new Ext.form.ComboBox({
    store: exampleData, //direct array data
    typeAhead: true,
    triggerAction: 'all',
    emptyText:'Select a state...',
    selectOnFocus:true,
    applyTo: 'array-states'
});
</code></pre></div>
<br />
<input type="text" id="outgoingPanel" size="20"></input>
<div id="outgoingWindow"></div>
<div id="outgoingGridPanel"></div>
<div id="outgoingExcelUploadForm"></div>
<div id="outgoingExcelUpload"></div>
<div id="outgoingExelUploadPreviewForm"></div>
<div id="outgoingExportExcelForm"></div>
<div id="incomingPanel"></div>
<div id="incomingSupplyName"></div>
<div id="incomingGridPanel"></div>
<div id="incomingExcelUploadForm"></div>
<div id="incomingExcelUpload"></div>
<div id="incomingExelUploadPreviewForm"></div>
<div id="incomingExportExcelForm"></div>
</body>
</html>