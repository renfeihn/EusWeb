
LogoutWindow = function() {
	this.label = new Ext.form.Label({
		html:'确定要<em>退出</em>吗?'
	});
	
	this.form = new Ext.form.FormPanel({
		labelAlign:'top',
		border:false,
        bodyStyle:'background:transparent;padding:10px;',
		onSubmit:Ext.emptyFn,
		items:[ this.label ] /*,
		submit:function() {
			this.getEl().dom.action = "logoutAction";
			this.getEl().dom.submit();			
		}*/
	});
	
	LogoutWindow.superclass.constructor.call(this, {
		title:'退出确认',
		//iconCls:'logout-icon',
		id:'logout-window',
		autoHeight:true,
		width:500,
		resizable:false,
		plain:true,
		modal:true,
		y:100,
		autoScroll:true,
		
		buttons:[
		         {
		        	 text:'确定',
		        	 handler: function() {
		        	 	/*this.form.getForm().submit({
		        	 		url: 'logoutAction.action'
		        	 	});*/
		        	 	window.location = 'logout.action';
		         },
		        	 scope:this
		         },
		         {
		        	 text:'关闭',
		        	 handler:this.hide.createDelegate(this, []),
		        	 scope:this
		         }
		],
		items: [ this.form ]
	});
};

Ext.extend(LogoutWindow, Ext.Window, {
});

Ext.reg('logoutWindow', LogoutWindow);