<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>�޸���Ŀ - ���߱��ռ���̨����</title>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn, objRs, sSQL
dim nProjectId, sProjectName, nProjectType, sProjectMemo
dim sAct
sAct = request.querystring.item("action")
'�����ύ���޸�
if sAct = "edit" then
	
	nProjectId   = trim(request.Form.Item("projectid"))
	sProjectName = trim(request.form.item("projectname"))
	nProjectType = trim(request.form.item("projecttype"))
	sProjectMemo = trim(request.form.item("projectmemo"))
	if len(nProjectId)<1 or isnumeric(nProjectId) = false then
		response.write "��Ŀ��Ų���ȷ, ��Ŀ�޸�ʧ��."
		response.end
	end if
	
	if len(sProjectName)<1 then
		response.write "��Ŀ���Ʋ��ܿ�, ��Ŀ�޸�ʧ��."
		response.end
	end if
	if nProjectType<>1 and nProjectType<>2 and nProjectType<>3 then
		response.write "��Ŀ���Ͳ���ȷ, ��Ŀ�޸�ʧ��."
		response.end
	end if
	if len(sProjectMemo)<1 then
		response.write "��Ŀ˵������Ϊ��, ��Ŀ�޸�ʧ��."
		response.end
	end if

	rem ������Ŀ
	if bDBConnection(objConn)=false then
		response.write "�������ݿ�ʧ��."
		response.end
	end if

	sProjectName = replace(sProjectName, "'", "''")
	sProjectMemo = replace(sProjectMemo, "'", "''")
	sSQL = "update tProject set project_name='" & sProjectName & "', project_memo='" & sProjectMemo & "', project_type=" & nProjectType & " where project_id = " & nProjectId

	response.write "<script language='javascript'>"
	'response.write sSQL
	'response.end

	on error resume next
	objConn.execute sSQL
	call vDBDisConn(objConn)
	if err.number<>0 then
		response.write "window.alert('��Ŀ�޸�ʧ��.');"
	else
		response.write "window.alert('��Ŀ�޸ĳɹ�.');"
	end if
	on error goto 0
	response.write "window.location='project_list.asp';"
	response.write "</script>"
	response.end
end if

rem �޸���Ŀ��������
dim bCheck
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
    
dim bFound
bFound = true
if bDBConnection(objConn)=false then
	response.write "�������ݿ�ʧ��."
	response.end
end if
	
sSQL = "select * from tProject where project_id=" & nProjectId & ";"
set objRs = server.CreateObject("adodb.recordset")
objRs.Open sSQL, objConn, 0, 1
if objRs.BOF and objRs.EOF then
	bFound = false
else
	sProjectName = objRs.Fields("project_name")
	sProjectMemo = objRs.Fields("project_memo")
	nProjectType = objRs.Fields("project_type")
end if
objRs.Close
set objRs = nothing
call vDBDisConn(objConn)
    
if bFound = false then
	response.write "<script language='javascript'>" & vbCrLf
	response.Write "alert('�Ҳ�����ص���Ŀ.');" & vbCrLf
	response.Write "window.location='project_list.asp';" & vbCrLf
	response.write "</script>"
	response.end
end if
%>
<script language="javascript">
function OnEdit()
{
	var pname = document.getElementById("projectname").value;
	var pmemo = document.getElementById("projectmemo").value;
	if ( pname.length < 1 )
	{
		window.alert("��Ŀ���Ʋ���Ϊ��, ������������Ŀ����.\n");
		document.getElementById("projectname").focus();
		return false;
	}
	if ( pmemo.length < 1 )
	{
		window.alert("��Ŀ˵������Ϊ��, ������������Ŀ˵��.\n");
		document.getElementById("projectmemo").focus();
		return false;
	}
	document.getElementById("frmProjectAdd").submit();
	return true;
}

function onPageLoaded()
{
	document.getElementById("projecttype").value = <%=nProjectType%>;
	return true;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4" onload="onPageLoaded();">
<h1>�޸���Ŀ</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
<form id="frmProjectAdd" method="post" method="post" action="project_edit.asp?action=edit">
  <tr>
	<th class="thTop" colspan="2">�޸���Ŀ</th>
  </tr>
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><input type="hidden" name="projectid" value="<%=nProjectId%>"><input type="text" name="projectname" id="projectname" maxlength="255" size="60" value="<%=sProjectName%>"></td>
  </tr> 
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><select name="projecttype" id="projecttype"><option value="1">���߲���</option><option value="2">���ߵ���</option><option value="3">���߱�</option></select></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ˵��</td>
	<td class="row2"><textarea name="projectmemo" id="projectmemo" cols="60" rows="10"><%=sProjectMemo%></textarea></td>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="�޸�" onclick="OnEdit();"/>&nbsp;&nbsp;<input type="reset" value="����"></td>
  </tr>
</form>
</table>
</body>
</html>

