<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<%

rem 管理员登录处理

rem 如果已经登录, 直接跳转到index.asp
if isAdminLog = true then response.redirect "index.asp"

rem 定义当登录失败时显示的内容
sub AdminLoginFailed
	response.write "<script language='javascript'>"
	response.write "window.alert('登录失败, 管理员用户名或密码不正确.');"
	response.write "window.location = 'loginadmin.asp';"
	response.write "</script>"
end sub

dim sAction
sAction = request.querystring.item("a")
if sAction = "login" then
	' 第一步 校验提交上来的数据, 如果参数不正确, 直接提示错误
	dim sAccount, sPwd
	sAccount = request.form.item("adminaccount")
	sPwd     = request.form.item("pwd")
	if len(sAccount)<5 or len(sPwd)<6 then
		call AdminLoginFailed
	end if

	' 第二步 到数据库中去验证密码是否正确
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
	' 连接数据库
	dim bIsLogin
	bIsLogin = true
	dim objConn
	if bDBConnection(objConn) = false then
		response.write "数据库连接失败."
		response.end
	end if

	' 读数据表
	dim sSQL
	sSQL = "select top 1 1 from tAdmins where admin_account='" & sAccount & "' and admin_pwd='" & sPwd & "';"
	dim objRs
	set objRs = server.createobject("adodb.recordset")
	objRs.open sSQL, objConn, 0, 1
	if objRs.eof and objRs.bof then bIsLogin = false
	objRs.close
	set objRs = nothing 
	
	' 关闭数据库
	call vDBDisConn(objConn)
	
	' 第三步 登录结果的处理, 如果登录成功, 产生session, 并且转到管理员的首页; 如果登录失败, 则跳转到登录页
	if bIsLogin = true then
		session.contents.item("admin_u") = sAccount
		response.redirect "index.asp"
	else
		call AdminLoginFailed
	end if
 
	response.end
end if
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style\style1.css" type="text/css">
<title>管理员登录</title>

<script language="javascript">
function len(str)
{
  var nLen = 0;
  for( var n=0; n<str.length; n++ )
  {
    if( str.charAt(n) <= '~' )
      nLen += 1;
    else
      nLen += 2;
  }
  return nLen;
}

function editsub()
{
  var sAccount = document.getElementById("adminaccount").value;
  if( len(sAccount)<5 || len(sAccount)>16 )
  {	
	alert("管理员用户名长度应该在5到16字节之间,请重新输入管理员用户名");
	document.getElementById("pwd").focus();
	return false;
  }  

  var sPwd = document.getElementById("pwd").value;
  if( len(sPwd)<6 || len(sPwd)>16 )
  {
	alert("密码长度应该在6到16字节之间,请重新输入密码");
	document.getElementById("pwd").focus();
	return false;
  }  

  document.getElementById("subbut").disabled = true;
  document.getElementById("post").submit();
}
</script>

</head>

<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td align="center" valign="middle" height="300">
<form name="post" id="post" method="post" action="loginadmin.asp?a=login">
<table border="0" cellpadding="3" cellspacing="1" class="forumline" align="center" width="300">
	<tr>
	  <th class="thHead" colspan="2">管理员登录</th>
	</tr>
	<tr>
	  <td class="row2" align="center" width="30%">管理员用户名</td>
	  <td class="row2" width="70%"><input type="text" size="16" maxlength="16" name="adminaccount" id="adminaccount" /></td>
	</tr>
	<tr>
	  <td class="row2" align="center" width="30%">密码</td>
	  <td class="row2" width="70%"><input type="password" size="16" maxlength="16" name="pwd" id="pwd" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center"><span class="cattitle">
		<input type="button" id="subbut" name="subbut" value="登录" class="mainoption" onclick="editsub();" />
		&nbsp;&nbsp;
		<input type="reset" value="重置" id="subres" name="subres" class="liteoption" />
		</span></td>
	</tr>
</table>
</form>
</td></tr>
</table>

</body>
</html>
