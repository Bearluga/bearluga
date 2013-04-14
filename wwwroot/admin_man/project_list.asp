<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>项目列表 - 在线表单收集后台管理</title>
<%
dim sQueryType, sQueryName '查询项目类型, 项目名称
sQueryType = trim(request.querystring.item("projecttype"))
sQueryName = trim(request.querystring.item("projectname"))
rem 参数projecttype的合法性判断, 它只能取1,2,3,99四个数字, 所以下面的判断语句最优:
if sQueryType<>"99" and sQueryType<>"1" and sQueryType<>"2" and sQueryType<>"3" then sQueryType="99"
rem 而不用下面的方法:
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
	if ( confirm('确认要删除此项目吗?') == true )
	{
		window.location='project_delete.asp?id=' + n;
	}	
	return true;
}
</script>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4" onload="OnPageLoad();">
<h1>项目列表</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th width="20%" nowrap="nowrap" height="25" class="thCornerL">查询条件</th>
	<th class="thCornerR">条件选择</th>
  </tr>
  <tr>
	<td class="row1">项目类型</td>
	<td class="row2"><select name="projecttype" id="projecttype"><option value="99">全部</option><option value="1">在线测试</option><option value="2">在线调查</option><option value="3">在线表单</option></select></td>
  </tr>
  <tr>
	<td class="row1">项目名称</td>
	<td class="row2"><input type="text" name="projectname" id="projectname" value="<%=sQueryName%>" maxlength="255" size="60"></td>
  </tr>  
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="查询" onclick="OnQuery();"/></td>
  </tr>
</table>
<br />
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
  <tr>
	<th width="40%" nowrap="nowrap" height="25" class="thCornerL">项目名称</th>
	<th width="10%" class="thTop">项目状态</th>
	<th width="10%" class="thTop">项目类型</th>
	<th width="20%" class="thTop">项目添加时间</th>
	<th width="20%" class="thCornerR">操作</th>
  </tr>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim objConn
if bDBConnection(objConn) = false then
	response.write "数据库连接失败."
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
	<td class="row2"><%if cbool(objRs.fields("project_isrelease"))=true then response.write "已发布" else response.write "<span style='color:#f00;'>未发布</span>"%></td>
	<td class="row1"><%=getProjectTypeName(objRs.fields(2))%></td>
	<td class="row2"><%=objRs.fields(1)%></td>
	<td class="row1"><a href="project_detail.asp?id=<%=objRs.fields(3)%>">详细</a>&nbsp;<a href="project_edit.asp?id=<%=objRs.fields(3)%>">编辑</a>&nbsp;<a href="#" onclick="OnDelete(<%=objRs.fields(3)%>);">删除</a>&nbsp;<%
if cbool(objRs.fields("project_isrelease"))=false then
	response.write "<a href='project_release.asp?id=" & objRs.fields("project_id") & "'>发布</a>"
else
	response.write "<a href='" & ROOTPATH & "userlogin.asp?pid=" & objRs.fields("project_id") & "' target='_blank'>前台</a>"
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
