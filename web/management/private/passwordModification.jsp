<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>密码修改</title>
<script language="javascript">
  Ext.onReady(function(){
	  
		var txtUserPassword = {
			xtype:'textfield',
			id:'txtUserPassword',
			fieldLabel:'原有密码',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'请输入原有密码',
			minLength:6,
			maxLength:16,			
			name:'txtUserPassword'
		};

		var txtNewPassword = {
			xtype:'textfield',
			id:'txtNewPassword',
			fieldLabel:'新的密码',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'请输入新的密码',
			minLength:6,
			maxLength:16,	
			name:'txtNewPassword'
		};	

		var txtComfirmPassword = {
			xtype:'textfield',
			id:'txtComfirmPassword',
			fieldLabel:'再次确认',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'请输入再次确认的密码',
			minLength:6,
			maxLength:16,	
			name:'txtComfirmPassword'
		};	

		var col1 = {
				columnWidth: .50,
				layout: 'form',
				frame: false,
				border: false,
				defaultType: 'textfield',
				items:[txtUserPassword,txtNewPassword,txtComfirmPassword]		
			};

		
		var passwordModificationForm = new Ext.form.FormPanel({
			id:'passwordModification-form',
			autoWidth:true,
			labelWidth:150,
			frame:false,
			border:false,
			labelAlign:'right',
			items:[{		
				layout:'column',
				frame:false,
				border:false,
				items:[col1]
			}]
		});

	
		/* 窗口中的按钮 */
		var btnSubmit = {
			text:'修改密码',
			iconCls:'icon-add',
			id:'PasswordModification-window-submit',
			handler:function(){
			if (!passwordModificationForm.getForm().isValid()) return;
			var newPassword = Ext.getCmp('txtNewPassword').getValue()
			var comfirmPassword = Ext.getCmp('txtComfirmPassword').getValue();

			if (newPassword != comfirmPassword) {
				alert ('新的密码和再次确认的密码不一致,请重新输入!');
				return;
			}
			
			passwordModificationForm.getForm().submit({
				url:'modifyPassword.action',
				params:{
					password:Ext.getCmp('txtUserPassword').getValue(),
					newPassword:Ext.getCmp('txtNewPassword').getValue()
				},
				success:function(f,a){clsys.message.info('密码修改成功');},
				failure:function(form,action){clsys.message.error(action.result.msg);},
				waitMsg:'正在提交数据,请稍后...',
				scope:this
			});},
			scope:this
		};
		
		var btnReset = {
			text:'重置',
			iconCls:'icon-refresh',
			id:'PasswordModification-window-reset',
			handler:function(){passwordModificationForm.getForm().reset();},
			scope:this		
		};

		var passwordModificationPanel = Ext.getCmp('PasswordModification-mainpanel');
		passwordModificationPanel.add(passwordModificationForm);
		passwordModificationPanel.getTopToolbar().add(btnSubmit,btnReset);
		passwordModificationPanel.doLayout();
});
</script>
</head>
<body>
<div id="inWarehouseGridPanel"></div>
</body>
</html>