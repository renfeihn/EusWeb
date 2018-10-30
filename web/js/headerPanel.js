
Ext.ns('is.panel.HeaderPanel');

is.panel.HeaderPanel = function() {
	/*
	this.messageStore = new Ext.data.JsonStore({
		url: 'getMessage.action',
		root: 'MessageList',
		baseParams: { status: ['Using'] },
		totalProperty: 'results',
		fields: [ 'id', 'title', 'content', 'sender', {name:'type', type:'int'}, 
		          {name:'senddate', type:'date', dateFormat:'Y-m-d'} ]
	});
	*/
	
	this.employeeStore = new Ext.data.JsonStore({
		url: 'getCurrentEmployee.action',
		root: 'Employee',
		autoLoad: {
			callback: function(records, opts, success) {
				if (success) {
					var position = records[0].get('position');
					var field = Ext.getCmp('is-current-user');
					var text = position.department.name + ' ' + position.level.name + ' '
						+ position.name + ' ' + records[0].get('name');
					field.setValue(text);
				}
			}
		},
		fields: [ 'name', 'position']
	});
		
	is.panel.HeaderPanel.superclass.constructor.call(this, {
		id:'header-panel',
		region:'north',
		layout:'fit',
		margins:'0 0 4 0',
		contentEl: 'is-title',
		autoHeight: true,
		items:this.logoutForm,
		bbar:[{
			split: true,
			text: '颜色配置',
			menu: {
				id: 'system-color',
				stateful: true,
				items: [{
					text: '蓝色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-blue.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-blue.css');
					}
				/*}, {
					text: '深蓝',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-slate.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-slate.css');
					}
				}, {
					text: '浅蓝',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-bl.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-bl.css');
					}
				}, {
					text: '绿色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-olive.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-olive.css');
					}
				*/}, {
					text: '灰色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-gray.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-gray.css');
					}
				}/*, {
					text: '粉色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-pink.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-pink.css');
					}
				}, {
					text: '棕色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-brown.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-brown.css');
					}
				}, {
					text: '紫色',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-purple.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-purple.css');
					}
				}*/, {
					text: '灰黑',
					handler: function() {
						Ext.util.CSS.swapStyleSheet('theme', 'js/ext-3.1/resources/css/xtheme-access.css');
						Ext.state.Manager.set('theme', 'js/ext-3.1/resources/css/xtheme-access.css');
					}
				}]
			}
		},'-',{
			text:'关于',
			handler: function() {
				var about = Ext.getCmp('about-window');
				if (!about) {
					about = new is.window.About();
				}
				about.show();
			},
			scope:this
		}, '->', {
			iconCls: 'icon-user'			
		}, {
			xtype: 'displayfield',
			id: 'is-current-user'
		},/* '-', {
			text: '停止消息',
			handler: function() {
				if (this.msgInterval && this.msgInterval != 0) {
					clearInterval(this.msgInterval);
				}
			},
			scope: this
		}, {
			text:'消息',
			iconCls: 'icon-information',
			handler: function() {
				var messenger = Ext.getCmp('messenger-window');
				if (!messenger) {
					messenger = new is.window.Messenger(this.messageStore);
				}
				messenger.show();
			},
			scope:this
		},*/ '-', {
			xtype:'tbbutton',
			text:'退出系统',
			iconCls: 'icon-off',
			handler:this.exitSystem,
			scope:this
		}]
	});
};

Ext.extend(is.panel.HeaderPanel, Ext.Panel, {
	/*
	setMessengerInterval: function(id) {
		this.msgInterval = id;
	},
	fetchMessage: function() {
		this.messageStore.reload({add:true});
	},
	*/
	aboutWindow: function() {
		alert('About');
	},

	exitSystem: function() {
		Ext.getCmp('logout-window').show();
	}
});

Ext.reg('headerPanel', is.panel.HeaderPanel);
