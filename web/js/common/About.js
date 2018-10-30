
Ext.ns('is.window.About');

is.window.About = function() {
	this.aboutTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div id="about">',
		'<p><span>{software}</span></p>',
		'<p><span>{developer}</span></p>',
		'<p><span>{contact}</span></p>',
		'</div>',
		'</tpl>'
	);
	
	is.window.About.superclass.constructor.call(this, {
		id: 'about-window',
		title: '关于',
		width: 400,
		height: 300,
		modal: true,
		resizable: false,
		buttonAlign: 'center',
		items: [{
			xtype: 'dataview',
			id: 'is-about-dataview',
			store: new Ext.data.JsonStore({
				root: 'About',
				fields: ['software', 'developer', 'contact'],
				data: {
					About: [{
						software: '西安创联电容器有限责任公司   销售管理系统',
						developer: '雒晓西',
						contact: 'ROEC_LUO@HOTMAIL.COM'
					}]
				}
			}),
			tpl: this.aboutTpl,
			itemSelector: 'div.about'
		}],
		buttons: [{
			text: '关闭',
			handler: this.destroy.createDelegate(this, []),
			scope: this
		}]
	});
};

Ext.extend(is.window.About, Ext.Window, {});

Ext.reg('is-about', is.window.About);