<!--#include file="Check.asp"-->
<!--#include file="../inc/page_Cls.asp"-->
<%
Server.ScriptTimeout =999999
Const TopicFile="../UploadFile/TopicFile/"
Const Del="../UploadFile/Del/"'移动文件的目录
Call ShowTable("上传文件管理","<center><a href=?>管理上传记录</a> |  <a href=?Action=delnouse>清理无用上传文件</a> | <a href=?Action=delnovisit>清理没有访问的文件</a> | <a href=?Action=deluphalfyear>批量清理上传文件</a></center>")
Select Case Request("Action")
Case"deluphalfyear"
	notFso
	deluphalfyear
Case"delnovisit"
	notFso
	delnovisit
Case"delnouse"
	notFso
	delnouse
Case"delall"
	notFso
	DelAll
Case"DelOptFile"
	notFso
	DelOptFile
Case Else
	UploadFile
end select
AdminFooter()

Rem #核心函数(2005-5-27)
Function FileList(str)
	Dim re,Test,temp
	Dim LoopCount
	Set re=new RegExp
	re.IgnoreCase =True
	re.Global=True
	LoopCount=0
	Str = Replace(Str, chr(10), "")
	Do While True
		re.Pattern="\[upload=(.[^\[]*)\]"
		Test=re.Test(Str)
		If Test Then
			re.Pattern="\[\/upload\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="(^.*)\[upload=(.[^\[]*)\](.[^\[]*)\[\/upload\](.*)"
				Temp=Temp&re.Replace(Str,"$3")&","
				Str=re.Replace(Str,"$1$4")
			Else
				Exit Do
			End If 
		Else
			Exit Do
		End If
		LoopCount=LoopCount + 1
		If LoopCount>40 Then Exit Do'防止死循环
	Loop
	Set re=nothing
	FileList=Temp
End Function

Sub UploadFile
	Dim intPageNow,arr_Rs,i,Pages,Conut,page,strPageInfo
	Response.Write"<form name='yimxu' method='POST' action='?Action=DelOptFile'>"
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="6">用户文件上传记录</td>
	</tr>
	<tr bgcolor='#D7DAEA'><td width="5%" align="center"><b>选择</b></td><td width="40%" height="25" align="center"><b>上传的文件</b></td><td width="10%" align="center"><b>类型</b></td><td width="15%" align="center"><b>上传用户</b></td><td width="18%" align="center"><b>上传日期</b></td><td width="12%" align="center"><b>大小</b></td></tr>  
	<%
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strFieldsList = "FileID,FileName,userName,FileType,FileSize,UpTime"
	Pages.strTableName = "[YX_UpFile]"
	Pages.strPrimaryKey = "FileID"
	Pages.strOrderList = "FileID desc"
	Pages.intPageSize = 25
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "UpFile"'cookies名称
	Pages.Reloadtime=3'cookies有效分钟
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
	%>
	<tr bgcolor="#DEDEDE">
	<td align="center"><input type="checkbox" name="FileName" value=<%=Arr_rs(1,i)%>>
	<td align="center"><a href="../UploadFile/TopicFile/<%=Arr_rs(1,i)%>" target=_blank><%=Arr_rs(1,i)%></a></td>        
	<td align="center"><img src="../images/FileType/<%=Arr_rs(3,i)%>.gif"></td> 
	<td align="center"><%=Arr_rs(2,i)%></td><td align="center"><%=Arr_rs(5,i)%></td><td align="center"><%=Arr_rs(4,i)%></td>        
	</tr>  
	<%
	Next
	Else
	Response.Write"<tr><td height=25 colspan='6'>没有上传文件的记录</td></tr>"
	End If
	%><tr bgcolor="#D7DAEA"><td colspan="6"><input type=checkbox name=chkall value=on onClick="CheckAll(this.form)"> 全选&nbsp;&nbsp;<input type="submit"  value="删除所选" onclick=checkclick('删除后将不能恢复！您确定要删除吗？')> </td></tr></form>
	<tr bgcolor="#CCCCCC"><td height=20 colspan="6"><%=strPageInfo%></td>
	</tr></tbody></table><%
End Sub
'记取帖子数据
Sub Delnouse
	Call LoginTxt("正在读取数据")
	Dim Alltable,i,temp
	Temp=""
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
    Set Rs=YxBBs.Execute("Select Content From [YX_Bbs"&AllTable(i)&"]")
	do while not rs.eof
	Temp=Temp&FileList(rs(0))
    rs.movenext
	loop
	rs.close
	Next
	Call ShowTable("开始清理无效文件","<form method=POST action='?Action=delall'><input name='files' type='hidden' value='"&temp&"'> 说明：此操作将删除没有在帖子上连接的无用文件。<br><input name='Go' type='radio' value='move' checked> 移动到<font color=red>"&Del&"</font>目录中（建议，为防止误删除，查看无错后再删除这个目录即可）<br><input name='Go' type='radio' value='del'> 直接从空间删除 <hr><input value=' 确 定 ' type=submit></form><script>abc.style.visibility = ""hidden"";</script>")
End Sub

'清除无用
Sub DelAll
	Call LoginTxt("正在处理文件")
	Dim Fso,Folder,Files,upname,bbsfiles,Go
	bbsFiles=Request.Form("files")
	Go=Request.Form("Go")
	If bbsFiles="" Then bbsFiles="0"
	Set Fso=server.createobject("scripting.filesystemobject")
	If not Fso.FolderExists(server.mappath(Del)) then Fso.CreateFolder(server.mappath(Del))
	Set Folder=fso.Getfolder(server.MapPath(TopicFile))
	Set files=folder.files
	For Each Upname In files
		If instr(bbsFiles,upname.name)<=0 then
		YxBBs.execute("Delete * From [YX_UpFile] Where FileName='"&upname.name&"'")
		If Go="move" Then
			Fso.MoveFile Server.mappath(TopicFile&upname.name),server.mappath(Del&upname.name)
		Else
			Fso.DeleteFile(Server.MapPath(TopicFile&Upname.name))
		End If
		End If
	Next
	Set Folder=nothing
	Set Files=nothing
	Set Fso=nothing
	Response.Write"<script>abc.style.visibility = ""hidden"";</script>"
	If Go="move" Then
		Call Suc("","无用的上传文件已经被转移至"&Del&"目录下 !","?")
	Else
		Call Suc("","无用的上传文件已经删除 !","?")
	End If
End Sub

'批量清理
Sub Deluphalfyear
	Dim Go,DelTime,Fso,Folder,Files,upname
	Go=Request.Form("Go")
	DelTime=Request.Form("DelTime")
	If Go="" And DelTime="" Then
		Response.Write"<form method=POST>"
		Call ShowTable("批量清理多少天以前上传的文件","<input name='Go' type='radio' value='move' checked> 移动到<font color=red>"&Del&"</font>目录中（为防止误删除，查看无错后再删除这个目录即可）<br><input name='Go' type='radio' value='del'> 直接从空间删除 <hr>清理在<input name='DelTime' type='text' size=4 value='180'>天以前上传的文件 <input value=' 确 定 ' type=submit></form>")
	Else
		If Not isnumeric(DelTime) Then Call GoBack("","天数必需用数字填写！"):Exit Sub
		Call LoginTxt("正在处理文件")
	Set Fso=server.createobject("scripting.filesystemobject")
	If not Fso.FolderExists(server.mappath(Del)) then Fso.CreateFolder(server.mappath(Del))
	Set Folder=fso.Getfolder(server.MapPath(TopicFile))
	Set Files=Folder.files
	For Each upName In Files
		If datediff("D",upName.datecreated,now)>DelTime then
		If Go="move" Then
			Fso.MoveFile Server.mappath(TopicFile&upname.name),server.mappath(Del&upname.name)
		Else
			Fso.DeleteFile(Server.MapPath(TopicFile&Upname.name))
		End If
		End if
	Next
	Set Folder=nothing
	Set Files=nothing
	Set Fso=nothing
	Response.Write"<script>abc.style.visibility = ""hidden"";</script>"
	If Go="move" Then
	Call Suc("","在"&DelTime&"天以前上传的文件已经被转移至"&Del&"目录下 !","?")
	Else
	Call Suc("","在"&DelTime&"天以前上传的文件已经删除！","?")
	End If
	End IF
End Sub

'清理没有访问的文件
Sub DelNoVisit
	Dim Go,DelTime,Fso,Folder,Files,upname
	Go=Request.Form("Go")
	DelTime=Request.Form("DelTime")
	If Go="" And DelTime="" Then
	Response.Write"<form method=POST>"
		Call ShowTable("清理多少天以前没有访问的上传文件","<input name='Go' type='radio' value='move' checked> 移动到<font color=red>"&Del&"</font>目录中（为防止误删除，查看无错后再删除这个目录即可）<br><input name='Go' type='radio' value='del'> 直接从空间删除 <hr>清理在<input name='DelTime' size=4 type='text' value='60'>天以前没有访问的上传文件 <input value=' 确 定 ' type=submit></form>")
	Else
		If Not isnumeric(DelTime) Then Call GoBack("","天数必需用数字填写！"):Exit Sub
		Call LoginTxt("正在处理文件")
		Set Fso=server.createobject("scripting.filesystemobject")
		If not Fso.FolderExists(server.mappath(Del)) then Fso.CreateFolder(server.mappath(Del))
		Set Folder=fso.Getfolder(server.MapPath(TopicFile))
		Set Files=Folder.files
		For Each Upname In Files
			if Datediff("d",UpName.DateLastAccessed,now)>DelTime then
			If Go="move" Then
				Fso.MoveFile Server.mappath(TopicFile&upname.name),server.mappath(Del&upname.name)
			Else
				Fso.DeleteFile(Server.MapPath(TopicFile&Upname.name))
			End If
			End if
		Next
		Set Folder=nothing
		Set Files=nothing
		Set Fso=nothing
		Response.Write"<script>abc.style.visibility = ""hidden"";</script>"
		If Go="move" Then
			Call Suc("","超过"&DelTime&"天以前没有访问的文件已经被转移至"&Del&"目录下 !","?")
		Else
			Call Suc("","超过"&DelTime&"天以前没有访问的文件已经删除 !","?")
		End If
	End If
End Sub

'删除所选
Sub DelOptFile
	Dim FileName,FSO,Folder,Files,Upname,Temp,i
	FileName=Request("FileName")
	If FileName="" Then Call GoBack("","请先选择项目。"):Exit Sub
	Temp=Split(FileName,",")
	For i=0 To uBound(Temp)	
		YxBBs.execute("Delete * From [YX_UpFile] Where FileName='"&Trim(Temp(i))&"'")
	Next
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
	Set Folder=fso.Getfolder(server.MapPath(TopicFile))
	Set files=folder.files
	For Each Upname In files
	If instr(FileName,Upname.name)>0 then
        FSO.DeleteFile(Server.MapPath(TopicFile&Upname.name))
	End if
	Next
	Set Folder=nothing
	Set Files=nothing
	Set Fso=nothing
	Call Suc("","成功删除了所选的文件。","?")
End Sub

Sub NotFso
	If Session(YxBBs.CacheName&"fso")="no" Then
		Call GoBack("","空间不支持FSO文件读写。无法进入下一步。")
		Call Adminfooter()
		Response.End
	End If
End Sub

Sub LoginTxt(txt)
%>
<script language="JavaScript">
<!--
function flashit(){ 
if (!document.all) 
return 
if (flashtable.style.borderColor=="white") 
flashtable.style.borderColor="#FAA343" 
else 
flashtable.style.borderColor="white" 
} 
setInterval("flashit()", 100)
-->
</script>
<%
Response.Write"<center><DIV id=abc><br><br><table id=flashtable style='BORDER-RIGHT: white 2px solid; BORDER-TOP: white 2px solid; BORDER-LEFT: white 2px solid; BORDER-BOTTOM: white 2px solid'><tr><td>"&Txt&"，请稍候。。。</td></tr></table></DIV></center>"
Response.Flush
End Sub
%>
<script language="JavaScript">
<!--
function CheckAll(form){
  for (var i=0;i<form.elements.length;i++){
    var e = form.elements[i];
    if (e.name != 'chkall'){
	e.checked = form.chkall.checked;}
	}
  }
//-->
</script>