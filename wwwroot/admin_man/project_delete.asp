<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>ɾ����Ŀ - ���߱��ռ���̨����</title>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim nProjectId, bCheck
bCheck = true
nProjectId = trim(Request.QueryString.Item("id"))
if len(nProjectId)<1 or isnumeric(nProjectId)=false then
	bCheck = false
elseif clng(nProjectId)<1 then
	bCheck = false
end if
    
if bCheck = false then
	response.write "<script language='javascript'>" & vbCrLf
	response.Write "alert('���ύ�����ݲ��Ϸ�.');" & vbCrLf
    	response.Write "window.location='project_list.asp';" & vbCrLf
	response.write "</script>"
	response.end
end if

	dim objConn
	if bDBConnection(objConn)=false then
		response.write "�������ݿ�ʧ��."
		response.end
	end if

	dim sSQL
	sSQL = "delete from tProject where project_id=" & nProjectId & ";"

	response.write "<script language='javascript'>"
	on error resume next
	objConn.execute sSQL
	call vDBDisConn(objConn)
	if err.number<>0 then
		response.write "window.alert('��Ŀɾ��ʧ��.');"
	else
		response.write "window.alert('��Ŀɾ���ɹ�.');"
	end if
	on error goto 0
	response.write "window.location='project_list.asp';"
	response.write "</script>"
%>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
</body>
</html>
</html>

