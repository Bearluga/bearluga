<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>��Ŀ���� - ���߱��ռ���̨����</title>
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
	response.write "window.alert('���ύ�Ĳ�������ȷ.');"
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
	response.write "���ݿ�����ʧ��."
	response.end
end if

dim sSQL
sSQL = "update tproject set project_isrelease=true where project_id=" & nProjectId
objConn.execute sSQL

call vDBDisConn(objConn)
response.write "window.alert('����Ŀ�ѳɹ�����.');"
response.write "window.location='project_list.asp';"
%>
</script>
</head>
<body>
</body>
</html>
