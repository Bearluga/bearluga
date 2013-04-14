<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>删除管理员 - 在线表单收集后台管理</title>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn, sSQL
if bDBConnection(objConn) = false then
	response.write "数据库连接失败."
	response.end
end if

' 删除一个管理员用户
dim sAccount
sAccount = trim(request.querystring.item("account"))
if len(sAccount)>0 then
	sSQL = "delete from tAdmins where admin_account='" & sAccount & "';"

	response.write "<script language='javascript'>"
	on error resume next

	objConn.execute sSQL

	if err.number<>0 then
		response.write "window.alert('删除管理员失败.');"
	else
		response.write "window.alert('删除管理员成功.');"
	end if
	on error goto 0
	response.write "window.location='admin_delete.asp';"
	response.write "</script>"
	response.end

end if
%>
<script language="javascript">
function subDel(account)
{
	if ( confirm("确实要删除管理员 " + account + " 吗?") == true )
	{
		window.location = "admin_delete.asp?account=" + account;
		return true;	
	}	
	else
		return false;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>删除管理员</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th width="15%" nowrap="nowrap" height="25" class="thCornerL">管理员账号</th>
	<th width="30%" height="25" class="thTop">管理员姓名</th>
	<th width="35%" class="thTop">账号添加时间</th>
	<th width="20%" class="thCornerR">操作</th>
  </tr>
<%
dim objRs
sSQL = "select admin_account,admin_name,admin_addtime from tAdmins;"
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 1, 1
if not (objRs.eof and objRs.bof) then
	do while not objRs.eof
%>
  <tr>
	<td class="row1" nowrap="nowrap"><%=objRs.fields(0)%></td>
	<td class="row2"><b><%=objRs.fields(1)%></b></td>
	<td class="row1"><%=objRs.fields(2)%></td>
	<td class="row2"><a href="#" onclick="subDel('<%=objRs.fields(0)%>');">删除</a></td>
  </tr>
<%
		objRs.movenext
	loop
end if
objRs.close
set objRs = nothing

call vDBDisConn(objConn)
%>
</table>
</body>
</html>

