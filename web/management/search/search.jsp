<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function() {
	var search = Ext.getCmp('SearchNTrace-mainpanel');

	search.getTopToolbar().hide();
	search.getBottomToolbar().hide();
});
</script>
</head>
<body>

<br/>
<div style="width:600px;">
    <div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>
    <div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc">
        <h3 style="margin-bottom:5px;">搜索</h3>
        <input type="text" size="40" name="search" id="search" />
        <div style="padding-top:4px;">
            输入任意关键字.
        </div>
    </div></div></div>
    <div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>
</div>
        

</body>
</html>