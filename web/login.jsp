<%@ page session="true" contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>销售管理系统</title>
<script language="JavaScript"  src="js/inc_validation.js"></script>
<link rel='stylesheet' href='js/public.css' type='text/css'>
<script language="JavaScript">
function SubmitForm(form)
 {
  if (!ValidateForm()) return false;
  form.submit();
 }
 
  function myClk(form) {
   if (event.keyCode==13) {
      SubmitForm(form);
   }   
 }
 
 function myClick(item) {
   if (event.keyCode==13)
     if (item == 1) {
       document.all.password.focus();
     }else
     {
       document.all.validate_code.focus();
     }
 }
</script>
</head>
<body>
<form method="post" action="login.action">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td background="images/login_05.gif"  width="100%" height="25" class="text_footer" >西安创联电容器有限责任公司&nbsp;&nbsp;销售管理系统</td>
  </tr>
  <tr>
    <td  background="images/login_02.gif" height="30%"></td>
  </tr>
  <tr>
    <td  width="100%" height="389" background="images/login_04.jpg"><table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="140" height="389">&nbsp;</td>
          <td width="242"><table width="100%" height="389" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height=80>&nbsp;</td>
              </tr>
              <tr>
                <td valign=top>
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td align="center"><font color="#FF0000"><b><s:actionerror/></td>
                      </tr>
                      <tr>
                        <td align="center">操作员<input name="userName" value=""   mycheck="B" class="editor"  maxlength="20" onkeyup="myClick(1)" title="操作员"></td>
                      </tr>
                      <tr>
                        <td align="center">密&nbsp;&nbsp;码<input type="password" value="" name="password" mycheck="B" class="editor"  maxlength="20" onkeyup="myClick(2)" title="密码"></td>
                      </tr>
                      <tr>
                        <td align="center">验证码<input type="input" name="validate_code" maxlength="4" onkeyup="myClk(this.form)" class="editor"></td><td><img src="<s:url action='loginValidation.action'/>"></td>
                      </tr>
                      <tr>
                        <td align=center>&nbsp;&nbsp;<input type="submit" name="login" value="登&nbsp;&nbsp;录" class="button" >&nbsp;&nbsp;
                        <input type="reset" name="cancel" value="重&nbsp;&nbsp;置" class="button" >
                        </td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
            </table></td>
          <td valign=top><table width="97%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="19%" height="105">&nbsp;</td>
                <td width="81%" class="td_title_login" align="left">西安创联电容器有限责任公司</td>
              </tr>
              <tr>
                <td height="40" class="td_title_login" align="center" colspan=2>销售管理系统</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="100%" height="25" align="left" background="images/login_05.gif" class="text_footer" >建议在IE8下使用&nbsp;</td>
  </tr>
</table>
</body>
</form>
</body>
</html>