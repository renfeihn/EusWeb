<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>�����޸�</title>
<script language="javascript">
  Ext.onReady(function(){
	  
		var txtUserPassword = {
			xtype:'textfield',
			id:'txtUserPassword',
			fieldLabel:'ԭ������',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'������ԭ������',
			minLength:6,
			maxLength:16,			
			name:'txtUserPassword'
		};

		var txtNewPassword = {
			xtype:'textfield',
			id:'txtNewPassword',
			fieldLabel:'�µ�����',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'�������µ�����',
			minLength:6,
			maxLength:16,	
			name:'txtNewPassword'
		};	

		var txtComfirmPassword = {
			xtype:'textfield',
			id:'txtComfirmPassword',
			fieldLabel:'�ٴ�ȷ��',
			width:200,
			inputType:'password',
			allowBlank:false,
			blankText :'�������ٴ�ȷ�ϵ�����',
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

	
		/* �����еİ�ť */
		var btnSubmit = {
			text:'�޸�����',
			iconCls:'icon-add',
			id:'PasswordModification-window-submit',
			handler:function(){
			if (!passwordModificationForm.getForm().isValid()) return;
			var newPassword = Ext.getCmp('txtNewPassword').getValue()
			var comfirmPassword = Ext.getCmp('txtComfirmPassword').getValue();

			if (newPassword != comfirmPassword) {
				alert ('�µ�������ٴ�ȷ�ϵ����벻һ��,����������!');
				return;
			}
			
			passwordModificationForm.getForm().submit({
				url:'modifyPassword.action',
				params:{
					password:Ext.getCmp('txtUserPassword').getValue(),
					newPassword:Ext.getCmp('txtNewPassword').getValue()
				},
				success:function(f,a){clsys.message.info('�����޸ĳɹ�');},
				failure:function(form,action){clsys.message.error(action.result.msg);},
				waitMsg:'�����ύ����,���Ժ�...',
				scope:this
			});},
			scope:this
		};
		
		var btnReset = {
			text:'����',
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