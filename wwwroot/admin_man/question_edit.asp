<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>�޸���Ŀ- ���߱��ռ���̨����</title>
<script language="javascript">
function OnEdit()
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
<h1>�޸���Ŀ</h1>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sSQL
dim objConn
rem ��Ӧ�ύ�޸���Ŀ������
dim sAction
dim sQuestionContent, nQuestionType, sQuestionChoose, nQuestionId, nProjectId
sAction = request.querystring.item("a")
if sAction = "edit" then
	response.write "<script language='javascript'>"
	sQuestionContent = trim(request.form.item("questioncontent"))
	nQuestionType    = trim(request.form.item("questiontype"))
	sQuestionChoose  = trim(request.form.item("questionchoose"))
	nQuestionId      = trim(request.form.item("questionid"))
	nProjectId       = trim(request.form.item("projectid"))
	if len(sQuestionContent)<1 or (nQuestionType<>"1" and nQuestionType<>"2" and nQuestionType<>"3") or (len(nQuestionId)<1 or isnumeric(nQuestionId)=false) then
		response.write "window.alert('���ύ�����ݲ��Ϸ�, ��Ŀ�޸�ʧ��.');"	
		response.write "window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if
	
	if bDBConnection(objConn) = false then
		response.write "window.alert('���ݿ�����ʧ��, ��Ŀ�޸�ʧ��.');"
		response.write "window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if
	
	'�����ѡ����, �Ȱ���ǰ��ѡ�ɾ����, ����������޸���ʵ����ɾ�������
	if nQuestionType = "1" or nQuestionType = "2" then
		sSQL = "delete from toptions where question_id =" & nQuestionId
		objConn.execute sSQL
	end if

	sQuestionContent = replace( sQuestionContent, "'", "''" )
	sQuestionChoose  = replace( sQuestionChoose,  "'", "''" )
	dim aChoose
	aChoose = split(sQuestionChoose, vbCrLf)
	'sQuestionChoose  = replace( sQuestionChoose,  vbCrLf, "///" ) '��Ŀ��ѡ����(��///Ϊ��ѡ��ķָ��)
	sSQL = "update tQuestion set question_type=" & nQuestionType & ",question_title='" & sQuestionContent & "' where question_id=" & nQuestionId & ";"

	' on error resume next
	objConn.execute sSQL

	if err.number<>0 then
		response.write "window.alert('ִ����Ӳ���ʧ��, ��Ŀ�޸�ʧ��.\n" & replace(err.decription,"'","\'") & "');"
		response.write "//window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if

	rem �����ѡ����, ��Ҫ�����ݿ������ѡ��
	if nQuestionType=1 or nQuestionType=2 then
		dim nCountAdd
		for nCountAdd = 0 to ubound(aChoose)
			if len(trim(aChoose(nCountAdd)))>0 then
				sSQL = "insert into tOptions(question_id,option_value) values(" & nQuestionId & ",'" & aChoose(nCountAdd) & "');"
				objConn.execute sSQL
			end if
		next
	end if

	if err.number<>0 then
		response.write "window.alert('ִ����Ӳ���ʧ��, ��Ŀ�޸�ʧ��.\n" & replace(err.decription,"'","\'") & "');"
	else
		response.write "window.alert('��Ŀ�޸ĳɹ�.');"
	end if
	on error goto 0

	call vDBDisConn(objConn)
	response.write "window.location='question_list.asp?pid=" & nProjectId & "';"
	response.write "</script>"
	response.end
end if
%>
<%
nQuestionId = trim(request.querystring.item("id"))
if len(nQuestionId)<1 or isnumeric(nQuestionId)=false then
	response.write "���ύ�����ݲ��Ϸ�, �޷�������Ӳ�����Ŀ."
	response.end
end if
nQuestionId = clng(nQuestionId)

if bDBConnection(objConn) = false then
	response.write "���ݿ�����ʧ��."
	response.end
end if
dim objRs
sSQL = "select question_type,question_title,project_id from tquestion where question_id=" & nQuestionId
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 1, 1
if objRs.eof and objRs.bof then
	objRs.close
	set objRs = nothing
	vDBDisConn(objConn)
	response.write "�Ҳ�������Ŀ, �޷��༭��Ŀ."
	response.end
else
	nQuestionType    = objRs.fields(0)
	sQuestionContent = objRs.fields(1)
	sQuestionChoose  = ""
	nProjectId       = objRs.fields(2)
	if nQuestionType=1 or nQuestionType=2 then
		sSQL = "select option_value from tOptions where question_id=" & nQuestionId & " order by option_id asc"
		dim objRs2
		set objRs2 = server.createobject("adodb.recordset")
		objRs2.open sSQl, objConn, 0, 1
		while not objRs2.eof
			sQuestionChoose = sQuestionChoose & objRs2.fields(0) & vbCrLf
			objRs2.movenext
		wend
		objRs2.close
		set objRs2 = nothing
		
	end if
end if
objRs.close
set objRs = nothing
call vDBDisConn(objConn)
%>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th class="thTop" colspan="2">��Ŀ����</th>
  </tr>
  <form id="frmQuestionAdd" method="post" action="question_edit.asp?a=edit">
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2"><textarea id="questioncontent" name="questioncontent" cols="60" rows="6"><%=sQuestionContent%></textarea>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀ����</td>
	<td class="row2">
		<input type="hidden" name="questionid" value="<%=nQuestionId%>" /><input type="hidden" name="projectid" value="<%=nProjectId%>" />
		<select id="questiontype" name="questiontype">
		<option value="1" <%if nQuestionType=1 then response.write "selected"%>>����ѡ��</option>
		<option value="2" <%if nQuestionType=2 then response.write "selected"%>>����ѡ��</option>
		<option value="3" <%if nQuestionType=3 then response.write "selected"%>>�ʴ�</option>
		</select>
	</td>
  </tr>
  <tr>
	<td class="row1" width="60">��Ŀѡ����</td>
	<td class="row2"><textarea id="questionchoose" name="questionchoose" cols="60" rows="6"><%=sQuestionChoose%></textarea><div style="color:#f00;">ÿһ�б�ʾһ��ѡ����; �����Ŀ����Ϊ�ʴ�����, �������Ч</div>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="�޸�" onclick="OnEdit();"/>&nbsp;&nbsp;<input type="reset" value="����"></td>
  </tr>
  </form>
</table>

</body>
</html>
