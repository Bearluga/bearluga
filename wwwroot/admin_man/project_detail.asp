<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>项目详细信息 - 在线表单收集后台管理</title>
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
    	response.Write "alert('你提交的数据不合法.');" & vbCrLf
    	response.Write "window.location='project_list.asp';" & vbCrLf
	    response.write "</script>"
	    response.end
    end if
    
	dim objConn, objRs, sSQL
	dim bFound
	bFound = true
	if bDBConnection(objConn)=false then
		response.write "连接数据库失败."
		response.end
	end if
	
	dim sProjectName, sProjectMemo, sProjectTime, sProjectType
	sSQL = "select * from tProject where project_id=" & nProjectId & ";"
    set objRs = server.CreateObject("adodb.recordset")
    objRs.Open sSQL, objConn, 0, 1
    if objRs.BOF and objRs.EOF then
        bFound = false
    else
        sProjectName = objRs.Fields("project_name")
        sProjectMemo = objRs.Fields("project_memo")
        sProjectTime = objRs.Fields("project_addtime")
        sProjectType = getProjectTypeName(objRs.Fields("project_type"))
    end if
    objRs.Close
    set objRs = nothing
    call vDBDisConn(objConn)
    
    if bFound = false then
    	response.write "<script language='javascript'>" & vbCrLf
    	response.Write "alert('找不到相关的项目.');" & vbCrLf
    	response.Write "window.location='project_list.asp';" & vbCrLf
	    response.write "</script>"
	    response.end
    end if
%>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>项目详细信息</h1>
<table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
<form id="frmProjectAdd" method="post" action="project_add.asp?action=a">
  <tr>
	<th class="thTop" colspan="2">项目详细信息</th>
  </tr>
  <tr>
	<td class="row1" width="15%">项目名称</td>
	<td class="row2" width="85%"><%=sProjectName%></td>
  </tr> 
  <tr>
	<td class="row1">项目类型</td>
	<td class="row2"><%=sProjectType%></td>
  </tr>
  <tr>
	<td class="row1">项目说明</td>
	<td class="row2"><%=replace(sProjectMemo,vbCrLf,"<br>")%></td>
  </tr>
  <tr>
	<td class="row1">项目添加时间</td>
	<td class="row2"><%=sProjectTime%></td>
  </tr>
  <tr>
	<td colspan="2" style="text-align:center" class="catBottom"><input type="button" value="返回" onclick="window.location='project_list.asp';" /></td>
  </tr>
</form>
</table>
</body>
</html>



