<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>�����Ŀ - ���߱��ռ���̨����</title>
<%
dim sAct
sAct = request.querystring.item("action")
if sAct = "a" then
	dim sProjectName, nProjectType, sProjectMemo
	sProjectName = trim(request.form.item("projectname"))
	nProjectType = trim(request.form.item("projecttype"))
	sProjectMemo = trim(request.form.item("projectmemo"))
	if len(sProjectName)<1 then
		response.write "��Ŀ���Ʋ��ܿ�, ��Ŀ���ʧ��."
		response.end
	end if
	if nProjectType<>1 and nProjectType<>2 and nProjectType<>3 then
		response.write "��Ŀ���Ͳ���ȷ, ��Ŀ���ʧ��."
		response.end
	end if
	if len(sProjectMemo)<1 then
		response.write "��Ŀ˵������Ϊ��, ��Ŀ���ʧ��."
		response.end
	end if

	rem �������ݿ�, �����Ŀ
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
	dim objConn
	if bDBConnection(objConn)=false then
		response.write "�������ݿ�ʧ��."
		response.end
	end if

	sProjectName = replace(sProjectName, "'", "''")
	sProjectMemo = replace(sProjectMemo, "'", "''")
	dim sSQL
	sSQL = "insert into tProject(project_name,project_memo,project_type) values('" & sProjectName & "','" & sProjectMemo & "'," & nProjectType & ");"

	response.write "<script language='javascript'>"

	on error resume next
	objConn.execute sSQL
	call vDBDisConn(objConn)
	if err.number<>0 then
		response.write "window.alert('��Ŀ���ʧ��.');"
		response.write "window.location='project_add.asp';"
	else
		response.write "window.alert('��Ŀ��ӳɹ�.');"
		response.write "window.location='project_list.asp';"
	end if
	on error goto 0
	response.write "</script>"
	response.end
end if
%>
<script language="javascript">
function OnAdd()
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
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>�����Ŀ</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
<form id="frmProjectAdd" method="post" action="project_add.asp?action=a">
  <tr>
	<th class="thTop" colspan="2">�����Ŀ</th>
  </tr>
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><input type="text" name="projectname" id="projectname" maxlength="255" size="60"></td>
  </tr> 
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><select name="projecttype" id="projecttype"><option value="1">���߲���</option><option value="2">���ߵ���</option><option value="3">���߱�</option></select></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ˵��</td>
	<td class="row2"><textarea name="projectmemo" id="projectmemo" cols="60" rows="10"></textarea></td>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="���" onclick="OnAdd();"/>&nbsp;&nbsp;<input type="reset" value="����"></td>
  </tr>
</form>
</table>
</body>
</html>



