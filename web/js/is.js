Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = 'js/ext-3.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	
	var fetMessageInterval = 0;
	var logout = new LogoutWindow();
	var headerPanel = new is.panel.HeaderPanel();
	var navigator = new is.panel.Navigator();
	var mainPanel = new is.panel.MainPanel();
	var viewPort = new Ext.Viewport( {
		layout : 'border',
		items : [ headerPanel, navigator, mainPanel ]
	});

	function addCategoryPanel(categories) {
		for (var i = 0; i < categories.length; i++) {
			var component = new is.panel.ControlPanel(categories[i].id, categories[i].title);
			navigator.add(component);
		}
		navigator.doLayout();
	};

	function failedGetPanel() {
		Ext.Msg.alert('错误!', '无法获得系统功能.');
	};
	
	Ext.Ajax.request({
		url : 'functionCategories.action',
		success: function(response, opts) {
			var result = Ext.decode(response.responseText);
			if (result.success) {
				addCategoryPanel(result.categories);
			} else {
				clsys.message.error('无法获得系统功能，请联系管理员分配权限.');
			}
		},
		failure: function(response, opts) {
			clsys.message.systemerror();
		}
	});
	
	var theme = Ext.state.Manager.get('theme') || 'js/ext-3.1/resources/css/xtheme-access.css';
	Ext.util.CSS.swapStyleSheet('theme', theme);
	
	setTimeout(function() {
		Ext.get('loading').remove();
		Ext.get('loading-mask').fadeOut({
			remove : true
		});
	}, 250);

	/*
	var fetchMessage = function() {
		if (headerPanel) {
			headerPanel.fetchMessage();
		}
	};

	headerPanel.setMessengerInterval(setInterval(fetchMessage, 30000));
	*/
});
