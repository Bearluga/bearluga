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
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sAccount
dim objConn
if bDBConnection(objConn)=false then
	response.write "连接数据库失败."
	response.end
end if

dim sTrueName
dim sSQL

rem 处理提交修改数据
dim sAction
sAction = request.querystring.item("action")
if sAction = "u" then
	sAccount  = request.form.item("account")
	sTrueName = request.form.item("truename")
	dim sPwd, sPwd2
	sPwd      = request.form.item("pwd1")
	sPwd2     = request.form.item("pwd2")

	' 校验数据
	if len(sAccount)<5 or len(sAccount)>16 or instr(sAccount,"'")>0 or len(sTrueName)<1 or instr(sTrueName,"'")>0 or len(sPwd)<6 or len(sPwd)>16 or sPwd<>sPwd2 then
		response.write "<script language='javascript'>"
		response.write "alert('提交的数据不合法, 管理员信息修改失败.');"
		response.write "window.location = 'admin_update_step2.asp?account=" & sAccount & "';"
		response.write "</script>"
		response.end
	end if
	sPwd = replace(sPwd, "'", "''")
	sSQL = "update tAdmins set admin_name='" & sTrueName & "'"
	if sPwd <> "******" then sSQL = sSQL & ",admin_pwd='" & sPwd & "'"
	sSQL = sSQL & " where admin_account='" & sAccount & "';"

	response.write "<script language='javascript'>"
	on error resume next
	objConn.execute sSQL
	if err.number=0 then
		response.write "alert('修改管理员信息成功.\n');"
	else
		response.write "alert('修改管理员信息失败.');"
	end if
	response.write "window.location = 'admin_update_step1.asp';"
	response.write "</script>"
	on error goto 0
	call vDBDisConn(objConn)
	response.end
end if

rem 以下是如果从admin_update_step1.asp传过来的用户名, 显示其他属性, 让用户修改
sAccount = trim(request.querystring.item("account"))
if len(sAccount)<1 then
	response.write "<script language='javascript'>"
	response.write "window.alert('你提交的数据不合法.');"
	response.write "window.location='admin_update_step1.asp';"
	response.write "</script>"
	response.end
end if

sTrueName = ""
sSQL = "select top 1 admin_name from tAdmins where admin_account='" & sAccount & "';"
dim objRs
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 0, 1
if not(objRs.eof and objRs.bof) then
	sTrueName = objRs.fields(0)
end if
objRs.close
set objRs = nothing

if len(sTrueName)<1 then
	response.write "<script language='javascript'>"
	response.write "window.alert('找不到此管理员.');"
	response.write "window.location='admin_update_step1.asp';"
	response.write "</script>"
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

function OnUpdate()
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
<h1>修改管理员</h1>
<form id="frmAdd" action="admin_update_step2.asp?action=u" method="post">
  <table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline" align="center">
	<tr>
	  <th class="thHead" colspan="2">修改管理员</th>
	</tr>
	<tr>
	  <td class="row1">管理员用户名</td>
	  <td class="row2"><input type="text" size="25" id="account" name="account" value="<%=sAccount%>" maxlength="16" class="post" readonly/> <span style="color:#555">(注:管理员用户名不能修改)</span></td>
	</tr>
	<tr>
	  <td class="row1">管理员姓名</td>
	  <td class="row2"><input type="text" size="25" id="truename" name="truename" value="<%=sTrueName%>" maxlength="10" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">密码</td>
	  <td class="row2"><input type="password" size="25" id="pwd1" name="pwd1" value="******" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">确认密码</td>
	  <td class="row2"><input type="password" size="25" id="pwd2" name="pwd2" value="******" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center">
	    <input type="button" name="btnSub" value="修改" class="mainoption" onclick="OnUpdate();" />
	    <input type="reset" name="btnReset" value="重置" class="mainoption" />
	  </td>
	</tr>
  </table>
</form>
</body>
</html>


