<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>项目发布 - 在线表单收集后台管理</title>
<script language="javascript">
<%
dim nProjectId, bCheck
bCheck = true
nProjectId = trim(request.querystring.item("id"))
if len(nProjectId)<1 then
	bCheck = false
elseif isnumeric(nProjectId)=false then
	bCheck = false
end if
if bCheck = false then
	response.write "window.alert('你提交的参数不正确.');"
	response.write "window.location='project_list.asp';"
	response.write "</script>"
	response.end
end if
nProjectId = clng(nProjectId)
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn
if bDBConnection(objConn) = false then
	response.write "数据库连接失败."
	response.end
end if

dim sSQL
sSQL = "update tproject set project_isrelease=true where project_id=" & nProjectId
objConn.execute sSQL

call vDBDisConn(objConn)
response.write "window.alert('此项目已成功发布.');"
response.write "window.location='project_list.asp';"
%>
</script>
</head>
<body>
</body>
</html>
