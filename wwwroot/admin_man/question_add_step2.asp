<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>�����Ŀ- ���߱��ռ���̨����</title>
<script language="javascript">
function OnAdd()
{
	var questioncontent = document.getElementById("questioncontent").value;
	var questiontype    = document.getElementById("questiontype").value;
	var questionchoose  = document.getElementById("questionchoose").value;
	if ( questioncontent.length < 1 )
	{
		window.alert("��Ŀ�����Ʋ���Ϊ��, ��������д��Ŀ����.");
		document.getElementById("questioncontent").focus();
		return false;
	}
	if ( questiontype<3 && questionchoose.length<1 )
	{
		window.alert("����Ŀ����Ϊ��ѡ���ѡʱ, ��Ŀ��ѡ�����Ϊ��, ��������д��Ŀѡ����.");
		document.getElementById("questionchoose").focus();
		return false;
	}
	document.getElementById("frmQuestionAdd").submit();
	return true;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>�����Ŀ</h1>
<p>�ڶ���.��д������Ŀ�����.</p>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sSQL
dim objConn
rem ��Ӧ�ύ�����Ŀ������
dim sAction
sAction = request.querystring.item("a")
if sAction = "add" then
	response.write "<script language='javascript'>"
	dim sQuestionContent, nQuestionType, sQuestionChoose, nQuestionProject
	sQuestionContent = trim(request.form.item("questioncontent"))
	nQuestionType    = trim(request.form.item("questiontype"))
	sQuestionChoose  = trim(request.form.item("questionchoose"))
	nQuestionProject = trim(request.form.item("projectid"))
	if len(sQuestionContent)<1 or (nQuestionType<>"1" and nQuestionType<>"2" and nQuestionType<>"3") or (len(nQuestionProject)<1 or isnumeric(nQuestionProject)=false) then
		response.write "window.alert('���ύ�����ݲ��Ϸ�, ��Ŀ���ʧ��.');"	
		response.write "window.location='question_add.asp';"
		response.write "</script>"
		response.end
	end if

	sQuestionContent = replace( sQuestionContent, "'", "''" )
	sQuestionChoose  = replace( sQuestionChoose,  "'", "''" )
	dim aChoose
	aChoose = split(sQuestionChoose, vbCrLf)
	'sQuestionChoose  = replace( sQuestionChoose,  vbCrLf, "///" ) '��Ŀ��ѡ����(��///Ϊ��ѡ��ķָ��)
	sSQL = "insert into tQuestion(project_id, question_type, question_title) values(" & nQuestionProject & "," & nQuestionType & ",'" & sQuestionContent & "');"

	if bDBConnection(objConn) = false then
		response.write "window.alert('���ݿ�����ʧ��, ��Ŀ���ʧ��.');"
		response.write "window.location='question_add.asp';"
		response.write "</script>"
		response.end
	end if

	' on error resume next
	objConn.execute sSQL

	if err.number<>0 then
		response.write "window.alert('ִ����Ӳ���ʧ��, ��Ŀ���ʧ��.\n" & replace(err.decription,"'","\'") & "');"
		response.write "//window.location='question_add_step2.asp?id=" & nQuestionProject & "';"
		response.write "</script>"
		response.end
	end if

	rem �����ѡ����, ��Ҫ�����ݿ������ѡ��
	if nQuestionType=1 or nQuestionType=2 then
		dim nQuestionId
		sSQL = "select top 1 @@identity from tQuestion;"
		dim objRsAdd
		set objRsAdd = server.createobject("adodb.recordset")
		objRsAdd.open sSQL, objConn, 0, 1
		nQuestionId = objRsAdd.fields(0)
		objRsAdd.close
		set objRsAdd = nothing
		
		dim nCountAdd
		for nCountAdd = 0 to ubound(aChoose)
			if len(trim(aChoose(nCountAdd)))>0 then
				sSQL = "insert into tOptions(question_id,option_value) values(" & nQuestionId & ",'" & aChoose(nCountAdd) & "');"
				objConn.execute sSQL
			end if
		next
	end if

	if err.number<>0 then
		response.write "window.alert('ִ����Ӳ���ʧ��, ��Ŀ���ʧ��.\n" & replace(err.decription,"'","\'") & "');"
	else
		response.write "window.alert('��Ŀ��ӳɹ�.');"
	end if
	on error goto 0

	call vDBDisConn(objConn)
	response.write "window.location='question_add_step2.asp?id=" & nQuestionProject & "';"
	response.write "</script>"
	response.end
end if
%>
<%
dim nProjectId
nProjectId = trim(request.querystring.item("id"))
if len(nProjectId)<1 or isnumeric(nProjectId)=false then
	response.write "���ύ�����ݲ��Ϸ�, �޷�������Ӳ�����Ŀ."
	response.end
end if
nProjectId = clng(nProjectId)

if bDBConnection(objConn) = false then
	response.write "���ݿ�����ʧ��."
	response.end
end if
dim objRs
sSQL = "select project_name, project_memo, project_addtime, project_type from tProject where project_id=" & nProjectId
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 1, 1
if objRs.eof and objRs.bof then
	objRs.close
	set objRs = nothing
	vDBDisConn(objConn)
	response.write "�Ҳ�������Ŀ, �޷���Ӳ�����Ŀ."
	response.end
end if
%>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th height="25" colspan="2" class="thTop">��Ŀ����</th>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2"><%=objRs.fields(0)%></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ����</td>
	<td class="row2"><%=getProjectTypeName(objRs.fields(3))%></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ���ʱ��</td>
	<td class="row2"><%=objRs.fields(2)%></td>
  </tr>
  <tr>
	<td class="row1">��Ŀ˵��</td>
	<td class="row2"><%=objRs.fields(1)%></td>
  </tr>
</table>
<%
objRs.close
%>
<br />
<%
sSQL = "select question_title, question_type from tQuestion where project_id=" & nProjectId & " order by question_id asc;"

objRs.open sSQL, objConn, 0, 1
dim nCount
nCount = 0
%>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th height="25" colspan="3" class="thTop">����Ŀ�����б�</th>
  </tr>
  <tr>
	<td class="row3" width="10%">���</td>
	<td class="row3" width="80%">��Ŀ</td>
	<td class="row3" width="10%">����</td>
  </tr>
<%
do while not objRs.eof
	nCount = nCount + 1
%>
  <tr>
	<td class="row1"><%=nCount%></td>
	<td class="row2"><%=objRs.fields(0)%></td>
	<td class="row1"><%=getQuestionTypeName(objRs.fields(1))%></td>
  </tr>
<%
	objRs.MoveNext
loop
%>
</table>
<%
objRs.close
set objRs = nothing

call vDBDisConn(objConn)
%>
</table>
<br />
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th class="thTop" colspan="2">����Ŀ����</th>
  </tr>
  <form id="frmQuestionAdd" method="post" action="question_add_step2.asp?a=add">
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2"><textarea id="questioncontent" name="questioncontent" cols="60" rows="6"></textarea>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2">
		<input type="hidden" name="projectid" value="<%=nProjectId%>" />
		<select id="questiontype" name="questiontype">
		<option value="1">����ѡ��</option>
		<option value="2">����ѡ��</option>
		<option value="3">�ʴ�</option>
		</select>
	</td>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀѡ����</td>
	<td class="row2"><textarea id="questionchoose" name="questionchoose" cols="60" rows="6"></textarea><div style="color:#f00;">ÿһ�б�ʾһ��ѡ����; �����Ŀ����Ϊ�ʴ�����, �������Ч</div>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="���" onclick="OnAdd();"/>&nbsp;&nbsp;<input type="reset" value="����"></td>
  </tr>
  </form>
</table>

</body>
</html>
