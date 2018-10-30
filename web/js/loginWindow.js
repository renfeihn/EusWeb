
LoginWindow = function() {	
	this.name = new Ext.form.TextField({
		id:'userName',
		name:'userName',
		allowBlank:false,
		fieldLabel:'用户名'
	});	
	
	this.password = new Ext.form.TextField({
		id:'password',
		name:'password',
		allowBlank:false,
		inputType:'password',
		fieldLabel:'密码'
	});
	
	this.loginForm = new Ext.form.FormPanel({
		labelAlign:'top',
		border:false,
        bodyStyle:'background:transparent;padding:10px;',
		onSubmit:Ext.emptyFn,
		submit : function() {
			this.getEl().dom.action = "loginAction.action";
			this.getEl().dom.submit();
		},
        items:[this.name, this.password]
	});
	
	LoginWindow.superclass.constructor.call(this, {
		title:'登录',
		id:'login',
		autoHeight:true,
		width:350,
		resizable:false,
		plain:true,
		modal:true,
		autoScroll:true,
		closable:false,
		el:'loginWindow',
		buttons:[{
			text:'确定',
			handler:this.login,
			scope:this
		},{
			text:'重置',
			handler:this.reset,
			scope:this
		}],
		items:this.loginForm
	});
};

Ext.extend(LoginWindow, Ext.Window, {	
	login : function() {
		this.loginForm.form.submit();
	},
	reset : function() {
		this.loginForm.form.reset();
	},
	show : function() {
		if (this.rendered) {
			this.name.setValue('');
			this.password.setValue('');
		}
		LoginWindow.superclass.show.apply(this, arguments);
	}
});

Ext.reg('loginWindow', LoginWindow);

Ext.onReady(function() {
	var login = new LoginWindow();
	login.show();
});