<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>修改题目- 在线表单收集后台管理</title>
<script language="javascript">
function OnEdit()
{
	var questioncontent = document.getElementById("questioncontent").value;
	var questiontype    = document.getElementById("questiontype").value;
	var questionchoose  = document.getElementById("questionchoose").value;
	if ( questioncontent.length < 1 )
	{
		window.alert("题目的名称不能为空, 请重新填写题目名称.");
		document.getElementById("questioncontent").focus();
		return false;
	}
	if ( questiontype<3 && questionchoose.length<1 )
	{
		window.alert("当题目类型为单选或多选时, 题目的选择项不能为空, 请重新填写题目选择项.");
		document.getElementById("questionchoose").focus();
		return false;
	}
	document.getElementById("frmQuestionAdd").submit();
	return true;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>修改题目</h1>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sSQL
dim objConn
rem 响应提交修改题目的数据
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
		response.write "window.alert('你提交的数据不合法, 题目修改失败.');"	
		response.write "window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if
	
	if bDBConnection(objConn) = false then
		response.write "window.alert('数据库连接失败, 题目修改失败.');"
		response.write "window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if
	
	'如果是选择题, 先把以前的选项都删除了, 所以这里的修改其实是先删除后添加
	if nQuestionType = "1" or nQuestionType = "2" then
		sSQL = "delete from toptions where question_id =" & nQuestionId
		objConn.execute sSQL
	end if

	sQuestionContent = replace( sQuestionContent, "'", "''" )
	sQuestionChoose  = replace( sQuestionChoose,  "'", "''" )
	dim aChoose
	aChoose = split(sQuestionChoose, vbCrLf)
	'sQuestionChoose  = replace( sQuestionChoose,  vbCrLf, "///" ) '题目的选择项(以///为各选择的分割符)
	sSQL = "update tQuestion set question_type=" & nQuestionType & ",question_title='" & sQuestionContent & "' where question_id=" & nQuestionId & ";"

	' on error resume next
	objConn.execute sSQL

	if err.number<>0 then
		response.write "window.alert('执行添加操作失败, 题目修改失败.\n" & replace(err.decription,"'","\'") & "');"
		response.write "//window.location='question_edit.asp?id=" & nQuestionId & "';"
		response.write "</script>"
		response.end
	end if

	rem 如果是选择题, 还要往数据库中添加选项
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
		response.write "window.alert('执行添加操作失败, 题目修改失败.\n" & replace(err.decription,"'","\'") & "');"
	else
		response.write "window.alert('题目修改成功.');"
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
	response.write "你提交的数据不合法, 无法继续添加测试题目."
	response.end
end if
nQuestionId = clng(nQuestionId)

if bDBConnection(objConn) = false then
	response.write "数据库连接失败."
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
	response.write "找不到此题目, 无法编辑题目."
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
	<th class="thTop" colspan="2">题目内容</th>
  </tr>
  <form id="frmQuestionAdd" method="post" action="question_edit.asp?a=edit">
  <tr>
	<td class="row1" width="60">题目问题</td>
	<td class="row2"><textarea id="questioncontent" name="questioncontent" cols="60" rows="6"><%=sQuestionContent%></textarea>
  </tr>
  <tr>
	<td class="row1" width="60">题目类型</td>
	<td class="row2">
		<input type="hidden" name="questionid" value="<%=nQuestionId%>" /><input type="hidden" name="projectid" value="<%=nProjectId%>" />
		<select id="questiontype" name="questiontype">
		<option value="1" <%if nQuestionType=1 then response.write "selected"%>>单项选择</option>
		<option value="2" <%if nQuestionType=2 then response.write "selected"%>>多项选择</option>
		<option value="3" <%if nQuestionType=3 then response.write "selected"%>>问答</option>
		</select>
	</td>
  </tr>
  <tr>
	<td class="row1" width="60">题目选择项</td>
	<td class="row2"><textarea id="questionchoose" name="questionchoose" cols="60" rows="6"><%=sQuestionChoose%></textarea><div style="color:#f00;">每一行表示一个选择项; 如果题目类型为问答类型, 则此项无效</div>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="修改" onclick="OnEdit();"/>&nbsp;&nbsp;<input type="reset" value="重置"></td>
  </tr>
  </form>
</table>

</body>
</html>
