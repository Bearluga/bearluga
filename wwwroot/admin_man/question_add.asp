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
<script language="javascript">
function OnStep()
{
	var projectid = document.getElementById("projectid").value;
	if ( projectid < 1 )
	{
		window.alert("����ѡ����Ŀ��������Ŀ���ƺ���ܽ�����һ��.");
		return false;
	}
	window.location = "question_add_step2.asp?id=" + projectid;
	return true;
}
</script>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn
if bDBConnection(objConn)=false then
	response.write "�������ݿ�ʧ��."
	response.end
end if

dim sSQL
sSQL = "select project_id, project_name from tProject order by project_id desc;"
%>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>�����Ŀ</h1>
<p>��һ��.��ѡ��Ҫ�����Ŀ��������Ŀ.</p>
<%
dim objRs
set objRs = server.createobject("adodb.recordset")
on error resume next
objRs.open sSQL, objConn, 0, 1
if err.number<>0 then
	response.write "���ݿ��ѯʧ��"
	response.end
end if
on error goto 0
%>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th class="thTop" colspan="2">�����Ŀ</th>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2">
		<select id="projectid" name="projectid">
<%
while not objRs.eof
%>
		<option value="<%=objRs.fields(0)%>"><%=objRs.fields(1)%></option>
<%
	objRs.movenext
wend
objRs.close
set objRs = nothing
call vDBDisConn(objConn)
%>
		</select>
	</td>
  </tr> 
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="��һ��" onclick="OnStep();"/></td>
  </tr>
</table>
</body>
</html>

