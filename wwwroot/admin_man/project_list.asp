<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>��Ŀ�б� - ���߱��ռ���̨����</title>
<%
dim sQueryType, sQueryName '��ѯ��Ŀ����, ��Ŀ����
sQueryType = trim(request.querystring.item("projecttype"))
sQueryName = trim(request.querystring.item("projectname"))
rem ����projecttype�ĺϷ����ж�, ��ֻ��ȡ1,2,3,99�ĸ�����, ����������ж��������:
if sQueryType<>"99" and sQueryType<>"1" and sQueryType<>"2" and sQueryType<>"3" then sQueryType="99"
rem ����������ķ���:
'if len(sQueryType)<>1 or isnumeric(sQueryType)=false then sQueryType=99
'sQueryType = cint(sQueryType)
'if sQueryType<>99 and (sQueryType<1 or sQueryType>3) then sQueryType=99
%>
<script language="javascript">
function OnQuery()
{
	var pname = document.getElementById("projectname").value;
	var ptype = document.getElementById("projecttype").value;
	window.location = "project_list.asp?projecttype=" + ptype + "&projectname=" + pname;
	return true;	
}
function OnPageLoad()
{
	document.getElementById("projecttype").value = <%=sQueryType%>;
}
function OnDelete(n)
{
	if ( confirm('ȷ��Ҫɾ������Ŀ��?') == true )
	{
		window.location='project_delete.asp?id=' + n;
	}	
	return true;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4" onload="OnPageLoad();">
<h1>��Ŀ�б�</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th width="20%" nowrap="nowrap" height="25" class="thCornerL">��ѯ����</th>
	<th class="thCornerR">����ѡ��</th>
  </tr>
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><select name="projecttype" id="projecttype"><option value="99">ȫ��</option><option value="1">���߲���</option><option value="2">���ߵ���</option><option value="3">���߱�</option></select></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><input type="text" name="projectname" id="projectname" value="<%=sQueryName%>" maxlength="255" size="60"></td>
  </tr>  
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="��ѯ" onclick="OnQuery();"/></td>
  </tr>
</table>
<br />
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th width="40%" nowrap="nowrap" height="25" class="thCornerL">��Ŀ����</th>
	<th width="10%" class="thTop">��Ŀ״̬</th>
	<th width="10%" class="thTop">��Ŀ����</th>
	<th width="20%" class="thTop">��Ŀ���ʱ��</th>
	<th width="20%" class="thCornerR">����</th>
  </tr>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn
if bDBConnection(objConn) = false then
	response.write "���ݿ�����ʧ��."
	response.end
end if
dim objRs, sSQL
sSQL = "select project_name, project_addtime, project_type, project_id, project_isrelease from tProject where 1=1"
if sQueryType<>"99"  then sSQL = sSQL & " and project_type=" & sQueryType
if len(sQueryName)>0 then
	sQueryName = replace(sQueryName, "'", "''")
	sSQL = sSQL & " and project_name like '%" & sQueryName & "%'"
end if
sSQL = sSQL & " order by project_addtime desc"
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 1, 1
if not (objRs.eof and objRs.bof) then
	do while not objRs.eof
%>
  <tr>
	<td class="row1" nowrap="nowrap"><%=objRs.fields(0)%></td>
	<td class="row2"><%if cbool(objRs.fields("project_isrelease"))=true then response.write "�ѷ���" else response.write "<span style='color:#f00;'>δ����</span>"%></td>
	<td class="row1"><%=getProjectTypeName(objRs.fields(2))%></td>
	<td class="row2"><%=objRs.fields(1)%></td>
	<td class="row1"><a href="project_detail.asp?id=<%=objRs.fields(3)%>">��ϸ</a>&nbsp;<a href="project_edit.asp?id=<%=objRs.fields(3)%>">�༭</a>&nbsp;<a href="#" onclick="OnDelete(<%=objRs.fields(3)%>);">ɾ��</a>&nbsp;<%
if cbool(objRs.fields("project_isrelease"))=false then
	response.write "<a href='project_release.asp?id=" & objRs.fields("project_id") & "'>����</a>"
else
	response.write "<a href='" & ROOTPATH & "userlogin.asp?pid=" & objRs.fields("project_id") & "' target='_blank'>ǰ̨</a>"
end if	
%></td>
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
