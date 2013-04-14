<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>添加题目- 在线表单收集后台管理</title>
<script language="javascript">
function OnAdd()
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
<h1>添加题目</h1>
<p>第二步.编写测试题目并添加.</p>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sSQL
dim objConn
rem 响应提交添加题目的数据
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
		response.write "window.alert('你提交的数据不合法, 题目添加失败.');"	
		response.write "window.location='question_add.asp';"
		response.write "</script>"
		response.end
	end if

	sQuestionContent = replace( sQuestionContent, "'", "''" )
	sQuestionChoose  = replace( sQuestionChoose,  "'", "''" )
	dim aChoose
	aChoose = split(sQuestionChoose, vbCrLf)
	'sQuestionChoose  = replace( sQuestionChoose,  vbCrLf, "///" ) '题目的选择项(以///为各选择的分割符)
	sSQL = "insert into tQuestion(project_id, question_type, question_title) values(" & nQuestionProject & "," & nQuestionType & ",'" & sQuestionContent & "');"

	if bDBConnection(objConn) = false then
		response.write "window.alert('数据库连接失败, 题目添加失败.');"
		response.write "window.location='question_add.asp';"
		response.write "</script>"
		response.end
	end if

	' on error resume next
	objConn.execute sSQL

	if err.number<>0 then
		response.write "window.alert('执行添加操作失败, 题目添加失败.\n" & replace(err.decription,"'","\'") & "');"
		response.write "//window.location='question_add_step2.asp?id=" & nQuestionProject & "';"
		response.write "</script>"
		response.end
	end if

	rem 如果是选择题, 还要往数据库中添加选项
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
		response.write "window.alert('执行添加操作失败, 题目添加失败.\n" & replace(err.decription,"'","\'") & "');"
	else
		response.write "window.alert('题目添加成功.');"
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
	response.write "你提交的数据不合法, 无法继续添加测试题目."
	response.end
end if
nProjectId = clng(nProjectId)

if bDBConnection(objConn) = false then
	response.write "数据库连接失败."
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
	response.write "找不到此项目, 无法添加测试题目."
	response.end
end if
%>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th height="25" colspan="2" class="thTop">项目概述</th>
  </tr>
  <tr>
	<td class="row1" width="60">项目名称</td>
	<td class="row2"><%=objRs.fields(0)%></td>
  </tr>
  <tr>
	<td class="row1">项目类型</td>
	<td class="row2"><%=getProjectTypeName(objRs.fields(3))%></td>
  </tr>
  <tr>
	<td class="row1">项目添加时间</td>
	<td class="row2"><%=objRs.fields(2)%></td>
  </tr>
  <tr>
	<td class="row1">项目说明</td>
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
	<th height="25" colspan="3" class="thTop">此项目问题列表</th>
  </tr>
  <tr>
	<td class="row3" width="10%">序号</td>
	<td class="row3" width="80%">题目</td>
	<td class="row3" width="10%">类型</td>
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
	<th class="thTop" colspan="2">新题目内容</th>
  </tr>
  <form id="frmQuestionAdd" method="post" action="question_add_step2.asp?a=add">
  <tr>
	<td class="row1" width="60">题目问题</td>
	<td class="row2"><textarea id="questioncontent" name="questioncontent" cols="60" rows="6"></textarea>
  </tr>
  <tr>
	<td class="row1" width="60">题目类型</td>
	<td class="row2">
		<input type="hidden" name="projectid" value="<%=nProjectId%>" />
		<select id="questiontype" name="questiontype">
		<option value="1">单项选择</option>
		<option value="2">多项选择</option>
		<option value="3">问答</option>
		</select>
	</td>
  </tr>
  <tr>
	<td class="row1" width="60">题目选择项</td>
	<td class="row2"><textarea id="questionchoose" name="questionchoose" cols="60" rows="6"></textarea><div style="color:#f00;">每一行表示一个选择项; 如果题目类型为问答类型, 则此项无效</div>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="添加" onclick="OnAdd();"/>&nbsp;&nbsp;<input type="reset" value="重置"></td>
  </tr>
  </form>
</table>

</body>
</html>
