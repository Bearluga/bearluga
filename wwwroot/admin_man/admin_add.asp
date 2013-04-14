<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>添加管理员 - 在线表单收集后台管理</title>
<%
rem 添加管理员
dim sAction
sAction = request.querystring.item("action")
if sAction = "a" then
	' 先检查参数
	dim sAccount, sName, sPwd, sPwd2
	sAccount = trim(request.form.item("account"))
	sName    = trim(request.form.item("truename"))
	sPwd     = trim(request.form.item("pwd1"))
	sPwd2    = trim(request.form.item("pwd2"))
	if len(sAccount)<5 or len(sAccount)>16 or instr(sAccount,"'")>0 or len(sName)<1 or instr(sName,"'")>0 or len(sPwd)<6 or len(sPwd)>16 or sPwd<>sPwd2 then
		response.write "<script language='javascript'>"
		response.write "alert('提交的数据不合法, 管理员添加失败.');"
		response.write "window.location = 'admin_add.asp';"
		response.write "</script>"
		response.end
	end if
	sPwd = replace(sPwd, "'", "''")
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
	dim objConn
	if bDBConnection(objConn)=false then
		response.write "连接数据库失败."
		response.end
	end if

	dim bAddFlag
	bAddFlag = true

	dim sSQL
	sSQL = "insert into tAdmins(admin_account,admin_name,admin_pwd) values('" & sAccount & "','" & sName & "','" & sPwd & "');"
	on error resume next
	objConn.execute sSQL
	if err.number<>0 then bAddFlag = false
	on error goto 0

	vDBDisConn(objConn)
	if bAddFlag = true then
		response.write "<script language='javascript'>"
		response.write "alert('添加管理员成功.\n');"
		response.write "window.location = 'admin_show.asp';"
		response.write "</script>"
	else
		response.write "<script language='javascript'>"
		response.write "alert('添加管理员失败, 请确认此管理员用户名是否已经存在.');"
		response.write "window.location = 'admin_add.asp';"
		response.write "</script>"
	end if

	response.end
end if
%>
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

function OnSubmit()
{
	var account  = document.getElementById("account").value;
	var truename = document.getElementById("truename").value;
	var pwd1     = document.getElementById("pwd1").value;
	var pwd2     = document.getElementById("pwd2").value;
	
	if ( len(account)<5 || len(account)>16 )
	{	
		alert("管理员用户名长度应该在5到16字节之间,请重新输入管理员用户名");
		document.getElementById("account").focus();
		return false;
	}
	if ( len(truename)<1 )
	{
		alert("管理员姓名不能为空.");
		document.getElementById("truename").focus();
		return false;
	}
	if ( len(pwd1)<6 || len(pwd2)>16 )
	{
		alert("密码长度应该在6到16字节之间,请重新输入密码");
		document.getElementById("pwd1").focus();
		return false;
	}
	if ( pwd1 != pwd2 )
	{
		alert("两次密码输入不相同，请重新输入用户密码.");
		document.getElementById("pwd1").focus();
		return false;
	}
	
	document.getElementById("frmAdd").submit();
	return true;
}
</script>

</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>添加管理员</h1>
<form id="frmAdd" action="admin_add.asp?action=a" method="post">
  <table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline" align="center">
	<tr>
	  <th class="thHead" colspan="2">添加管理员</th>
	</tr>
	<tr>
	  <td class="row1">管理员用户名</td>
	  <td class="row2"><input type="text" size="25" id="account" name="account" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">管理员姓名</td>
	  <td class="row2"><input type="text" size="25" id="truename" name="truename" value="" maxlength="10" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">密码</td>
	  <td class="row2"><input type="password" size="25" id="pwd1" name="pwd1" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">确认密码</td>
	  <td class="row2"><input type="password" size="25" id="pwd2" name="pwd2" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center">
	    <input type="button" name="btnSub" value="添加" class="mainoption" onclick="OnSubmit();" />
	    <input type="reset" name="btnReset" value="重置" class="mainoption" />
	  </td>
	</tr>
  </table>
</form>
</body>
</html>

