<%@ page session="true" contentType="text/html; charset=GBK"%>
<html>
<head>
<title>ึ๗าณ</title>
<link rel="stylesheet" type="text/css" href="js/ext-3.1/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="css/is.css" />
<script type="text/javascript" src="js/ext-3.1/ext-base.js"></script>
<script type="text/javascript" src="js/ext-3.1/ext-all.js"></script>
<script type="text/javascript" src="js/ext-3.1/ext-lang-zh_CN.js" charset="utf-8"></script>
<script type="text/javascript">
Ext.onReady(function() {
	var store = new Ext.data.ArrayStore({
		fields: [{name:'d', type:'date'}],
		data: [ ['2003-03-03'], ['2005-5-5'] ]
	});


	for (var i = 0; i < store.getCount(); i++) {
		var record = store.getAt(i);
		var dt = record.get('d');
		alert(dt);
	}
});
</script>
</head>
<body>
</body>
</html>