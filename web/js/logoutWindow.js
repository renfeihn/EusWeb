
LogoutWindow = function() {
	this.label = new Ext.form.Label({
		html:'ȷ��Ҫ<em>�˳�</em>��?'
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
		title:'�˳�ȷ��',
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
		        	 text:'ȷ��',
		        	 handler: function() {
		        	 	/*this.form.getForm().submit({
		        	 		url: 'logoutAction.action'
		        	 	});*/
		        	 	window.location = 'logout.action';
		         },
		        	 scope:this
		         },
		         {
		        	 text:'�ر�',
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