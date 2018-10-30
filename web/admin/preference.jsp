<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript" src="js/admin/DataAccess.js"></script>
<script type="text/javascript" src="js/admin/DataAccessItem.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var preferencePanel = Ext.getCmp('SystemPreferences-mainpanel');
	preferencePanel.add({
		xtype: 'form',
		id: 'system-preference-panel',
		labelAlign: 'right',
		style: {
			marginTop: 20,
			marginLeft: 10,
			marginRight: 10
		},
		items: [{
			xtype: 'combo',
			id: 'client-refresh-duration',
			fieldLabel: '刷新间隔',
			name: 'clients-refresh-duration',
			width: 175,
			displayField: 'name',
			valueField: 'id',
			triggerAction: 'all',
			editable: false,
			forceSelection: true,
			mode: 'local',
			store: new Ext.data.ArrayStore({
				fields: ['id', 'name'],
				data: [
					[30, '30秒'],
					[60, '60秒'],
					[90, '90秒']
				]
			}),
			emptyText: '选择客户端刷新间隔'
		}, {
			xtype: 'button',
			text: '数据权限',
			width: 175,
			id: 'manage-data-access',
			fieldLabel: '数据权限',
			handler: function() {
				var win = Ext.getCmp('data-access-window');
				if (!win) {
					win = new is.window.DataAccess();
				}
				win.show();
			},
			scope: this
		}]
	});

	preferencePanel.getTopToolbar().hide();
	preferencePanel.getBottomToolbar().hide();

	preferencePanel.doLayout();
});
</script>
</head>
<body>
</body>
</html>