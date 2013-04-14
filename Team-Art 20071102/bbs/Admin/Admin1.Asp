<!--#include file="Check.Asp"-->
<%
Dim Action,ID
ID=Request.QueryString("ID")
If ID="" Then ID=0

Action=Request.QueryString("Action")
Select case Action
Case"ExecuteSql"
	ExecuteSql
Case"SqlTable"
	SqlTable
Case"SaveAuteSqlTable"
	Response.flush
	SaveAuteSqlTable
Case"SaveAddSqlTable"
	Response.flush
	SaveAddSqlTable
Case"DelSqlTable"
	Response.flush
	DelSqlTable
Case"CompressData"
	Call CompressData()
Case"BackupDate"
	Call BackupDate()
Case"RestoreData"
	Call RestoreData()
Case"SpaceSize"
	SpaceSize
Case"SaveLock"
	SaveLock
Case"DelIp"
	DelIp
Case"SaveAddip"
	SaveAddip
Case"SaveEditip"
	SaveEditip
Case"EditIp"
	EditIp
Case"LockIp"
	LockIp
Case"SaveAdd"
	SaveAdd
Case"Edit"
	Edit
Case"SaveEdit"
	SaveEdit
Case"Update"
	UpdateLink
Case"Del"
	DelLink
Case Else
	Link
End select
AdminFooter()

Sub Link
	Dim Rs,I%>
	<form method=POST name=form style='margin:0' action=?Action=SaveAdd>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">添加论坛联盟</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>论坛名称：</td>
	<td><input type="text" name="bbsname" size="20"></td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛地址：</td>
	<td><input type="text" name="url" size="38"></td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛图片：</td>
	<td><input type="text" name="pic" size="38">(留空则显示文字连接)</td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛说明：</td>
	<td><input type="text" name="Readme" size="38">(可以留空)</td></tr>
	<tr bgcolor="#DEDEDE"><td>图片显示：</td>
	<td><input type="radio" name="ispic" value="yes"  checked>  是 <input type="radio" name="ispic" value="no" > 否</td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td>
</tr></table>
	</form><br>
	<form method=POST name=form style='margin:0' action=?Action=Update>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" ><b><font color="#FFFFFF">论坛联盟信息</font></b></td>
	<td align="center"><b><font color="#FFFFFF">排序</font></b></td>
	<td align="center"><b><font color="#FFFFFF">显示图片</font></b></td>
	<td align="center"><b><font color="#FFFFFF">操作</font></b></td>
	</tr>
	<%
	i=0
	Set Rs=YxBBs.Execute("Select ID,Ispic,Orders,BbsName,Url,Readme From[YX_Link] order by orders")
	Do while Not Rs.eof
		i=i+1
	%>
	<tr bgcolor="#DEDEDE"><td><a href="<%=Rs("Url")%>" target="_blank" title="<%=Rs("Readme")%>"><%=Rs("BbsName")%></a></td><td align="center"><input name="id" value="<%=Rs("ID")%>" type="hidden"><input type="text" name="orders" value="<%=Rs("Orders")%>" size="2"></td><td align="center"><input type="radio" name="ispic<%=i%>" value="yes" <%if Rs("isPic") then%> checked <%end if%>> 是 <input type="radio" name="ispic<%=i%>" value="no" <%if Not Rs("Ispic") then%> checked <%end if%>> 否</td>
	<td align="center"><a href="?Action=Edit&ID=<%=Rs("ID")%>"><img src="../images/edit.gif" width="18" height="13" border="0" align="absmiddle"> 编辑</a> <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href="?Action=Del&ID=<%=Rs("ID")%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"> 删除</a></td>
	</tr>
	<%Rs.movenext
	Loop
	Rs.Close
	%>
<tr bgcolor="#CCCCCC"><td colspan="6"  align="center"><input type="submit" value=" 更 新 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table></form>
<%
End Sub

Sub Edit
	Set Rs=YxBBs.Execute("Select ID,Orders,IsPic,Pic,BbsName,Url,Readme From[YX_Link]where ID="&ID&"")
	IF Rs.eof Then
		Call GoBack("这条论坛联盟不存在！")
		Exit Sub
	End If
	%>
	<form method=POST name=form style='margin:0' action=?Action=SaveEdit>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">修改论坛联盟</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>论坛名称：</td>
	<td><input name="id" value="<%=Rs("ID")%>" type="hidden"><input type="text" name="bbsname" size="20" value="<%=Rs("BbsName")%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛地址：</td>
	<td><input type="text" name="url" size="38" value="<%=Rs("Url")%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛图片：</td>
	<td><input type="text" name="pic" size="38" value="<%=Rs("Pic")%>">(可以留空)</td></tr>
	<tr bgcolor="#DEDEDE"><td>论坛说明：</td>
	<td><input type="text" name="Readme" size="38" value="<%=Rs("Readme")%>">(可以留空)</td></tr>
	<tr bgcolor="#DEDEDE"><td>图片显示：</td>
	<td><input type="radio" name="ispic" value="yes" <%if Rs("isPic") then%> checked <%end if%>>  是 <input type="radio" name="ispic" value="no" <%if Not Rs("Ispic") then%> checked <%end if%>> 否</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
	<%Rs.close
End Sub

Sub UpdateLink
	Dim ID,I,Orders,IsPic
	For i=1 to Request.form("id").count
	ID = Replace(Request.form("id")(i),"'","")
	Orders = Replace(Request.form("orders")(i),"'","")
	IsPic= Replace(Request.form("ispic"&i&""),"'","")
	IF Not isnumeric(ID) or Not isnumeric(Orders) Then
		Call GoBack("","请用数字填写!")
		Exit Sub
	End IF
	YxBBs.Execute("Update [YX_Link]Set Orders="&Orders&",IsPic="&IsPic&" where ID="&ID&"")
	Next
	Cache.name="Link_List":Cache.clean()
	Call Suc("","更新论坛联盟信息成功！","?")
End Sub

Sub SaveAdd
	Dim BbsName,Url,Pic,Readme,Admin,Orders,IsPic
	BbsName=YxBBs.Fun.GetStr("bbsname")
	Url=YxBBs.Fun.ubbg(YxBBs.Fun.GetStr("url"))
	Pic=YxBBs.Fun.GetStr("pic")
	Readme=YxBBs.Fun.GetStr("Readme")
	IsPic=YxBBs.Fun.GetStr("ispic")
	If BbsName=""  or url=""  then
		Call GoBack("","")
		Exit Sub
	ElseIf Not YxBBs.Fun.CheckName(BbsName) Or (Admin<>"" And Not YxBBs.Fun.CheckName(Admin)) Then
		Call GoBack("","请不要使用了非法字符")
		Exit Sub
	End if
	Orders=YxBBs.execute("select Count(ID) From[YX_Link]")(0)
	Orders=Int(Orders+1)
	YxBBs.execute("insert into[YX_Link](Bbsname,Url,Pic,Readme,Orders,IsPic)values('"&BbsName&"','"&Url&"','"&Pic&"','"&Readme&"',"&Orders&","&IsPic&")")
	Cache.name="Link_List":Cache.clean()
	Call Suc("","添加论坛联盟连接成功！","?")
End Sub

Sub SaveEdit
	Dim BbsName,Url,Pic,Readme,ID,IsPic
	ID=YxBBs.Fun.GetStr("id")
	BbsName=YxBBs.Fun.GetStr("bbsname")
	Url=YxBBs.Fun.ubbg(YxBBs.Fun.GetStr("url"))
	Pic=YxBBs.Fun.GetStr("pic")
	Readme=YxBBs.Fun.GetStr("Readme")
	IsPic=YxBBs.Fun.GetStr("ispic")	
	If BbsName=""  or url=""  then
		Call GoBack("","")
		Exit Sub
	ElseIf Not YxBBs.Fun.CheckName(BbsName) Then
		Call GoBack("","请不要使用了非法字符")
		Exit Sub
	End if
	YxBBs.execute("Update [YX_Link]Set Url='"&Url&"',Pic='"&Pic&"',BbsName='"&BbsName&"',Readme='"&Readme&"',IsPic="&IsPic&" where ID="&ID&"")
	Cache.name="Link_List":Cache.clean()
	Call Suc("","修改论坛联盟连接成功！","?")
End Sub

Sub DelLink
	Dim ID
	ID=Request.QueryString("ID")
	IF  Not isnumeric(ID) Then
		Call GoBack("","提交的参数不正确！")
	Else
		YxBBs.execute("delete from [YX_link] where ID="&ID&"")
		Cache.name="Link_List":Cache.clean()
		Call Suc("","删除论坛联盟连接成功！","?")
	End If
End Sub
%>


<%Sub LockIp%>
	<form method=POST name=form style='margin:0' action=?Action=SaveAddip>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">IP封锁</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="20%" height="25">起始IP：<br>
	  (必填)</td><td width="80%"><input name='StartIp' type='text'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">结束IP：<br>
	  (封锁单个IP时不必填写)</td><td><input name='EndIp' type='text'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">封禁说明：<br>
	  (最大255个字符)</td><td><input name='Readme' type='text' style="width:90%"></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form><br>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25"  colspan="3"><b><font color="#FFFFFF">已经被封的IP记录</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="40%" height="25" align='center'><b>网段</b></td>
	<td width="40%"><b>说明</b></td>
	<td width="20%" align='center'><b>操作</b></td>
	</tr>
	<% 
	Set Rs=YxBBs.Execute("Select StartIp,EndIp,Readme,Lock,ID From[YX_LockIp] where Lock")
	If Rs.eof Then
	Response.Write"<tr bgcolor=""#DEDEDE""><td colspan='4'>没有封锁记录</td></tr>"
	Else
	Do while not Rs.eof
		Response.Write"<tr bgcolor=""#DEDEDE""><td align='center'>"&YxBBs.Fun.IpDecode(Rs("StartIp"))&" - "&YxBBs.Fun.IpDecode(Rs("EndIp"))&"</td><td>&nbsp;"&Rs("Readme")&"</td><td align='center'><a href=?Action=EditIp&Id="&rs("ID")&"><img src=../images/edit.gif border=0 align='absmiddle'> 修改<a> <a href=?Action=SaveLock&ID="&rs("ID")&"><img src=../images/Lock.GIF align='absmiddle' border=0> 解除</a></td></tr>"
	Rs.MoveNext
	Loop
	End If
	Rs.Close
	%>
</table><br>
	<form method=POST name=form style='margin:0' action=?Action=LockIp>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25"  colspan="3"><b><font color="#FFFFFF">未被封的IP记录</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="40%" height="25" align='center'><b>网段</b></td>
	<td width="40%"><b>说明</b></td>
	<td width="20%" align='center'><b>管理</b></td>
	</tr>
	<% 
	Set Rs=YxBBs.Execute("Select StartIp,EndIp,Readme,Lock,ID From[YX_LockIp] where not Lock")
	If Rs.eof Then
	Response.Write"<tr bgcolor=""#DEDEDE""><td colspan='4'>没有IP记录</td></tr>"
	Else
	Do while not Rs.eof
		Response.Write"<tr bgcolor=""#DEDEDE""><td align='center'>"&YxBBs.Fun.IpDecode(Rs("StartIp"))&" - "&YxBBs.Fun.IpDecode(Rs("EndIp"))&"</td><td>&nbsp;"&Rs("Readme")&"</td><td align='center'><a href=?Action=SaveLock&ID="&Rs("ID")&"><img src=../images/lock.GIF border=0 align='absmiddle'> 封锁</a> <a href=?Action=DelIp&ID="&Rs("ID")&"><img src=../images/del.gif border='0' align='absmiddle'> 删除</td></tr>"
	Rs.MoveNext
	Loop
	End If
	Rs.Close
	%>
</table>
	<%
End Sub

Sub EditIp
	Set Rs=YxBBs.execute("Select StartIp,EndIp,Readme,ID From[YX_LockIp] where ID="&ID&"")
	IF Rs.eof Then
		Call GoBack("","记录不存在"):Exit Sub
	End If
%>
	<form method=POST name=form style='margin:0' action=?Action=SaveEditip>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">IP封锁</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="20%" height="25">起始IP：<br>
	  (必填)</td><td width="80%"><input name="id" value="<%=Rs("ID")%>" type="hidden"><input name='StartIp' type='text' value="<%=YxBBs.Fun.IpDecode(Rs("StartIp"))%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">结束IP：<br>
	  (封锁单个IP时不必填写)</td><td><input name='EndIp' type='text' value="<%=YxBBs.Fun.IpDecode(Rs("EndIp"))%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">封禁说明：<br>
	  (最大255个字符)</td><td><input name='Readme' type='text' style="width:90%" value="<%=Rs("Readme")%>"></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
	<%
	Rs.Close
End Sub

Sub DelIp
	Dim ID
	ID=Int(Request("ID"))
	YxBBs.Execute("Delete From[YX_LockIP] Where ID="&ID&"")
	Cache.Name="IPData"
	Cache.clean()
	Response.redirect "?Action=LockIp"
End Sub

Sub SaveAddip
	Dim StartIP,EndIP,Readme
	StartIp=YxBBs.Fun.GetStr("StartIp")
	EndIp=YxBBs.Fun.GetStr("EndIp")
	Readme=YxBBs.Fun.GetStr("Readme")
	If StartIp="" Then
		Call GoBack("","")
		Exit Sub
	End If
	if EndIp="" then EndIp=StartIp
	YxBBs.execute("Insert into [YX_LockIp](StartIp,EndIp,Readme,lock)values("&YxBBs.Fun.IpEncode(StartIp)&","&YxBBs.Fun.IpEncode(EndIp)&",'"&Readme&"',true)")
	Call Suc("操作成功","成功添加封锁IP纪录!","?Action=LockIp")
	Cache.Name="IPData"
	Cache.clean()
End Sub

Sub SaveEditip
	Dim ID,StartIP,EndIP,Readme
	ID=YxBBs.Fun.GetStr("ID")
	StartIp=YxBBs.Fun.GetStr("StartIp")
	EndIp=YxBBs.Fun.GetStr("EndIp")
	Readme=YxBBs.Fun.GetStr("Readme")
	If StartIp="" Then
		Call GoBack("",""):Exit Sub
	End If
	If EndIp="" then EndIp=StartIp
	YxBBs.execute("update [YX_LockIp]Set StartIp="&YxBBs.Fun.IpEncode(StartIp)&",EndIp="&YxBBs.Fun.IpEncode(EndIp)&",Readme='"&Readme&"' where ID="&ID&"")
	Call Suc("","修改封锁IP成功!","?Action=LockIp")
	Cache.Name="IPData"
	Cache.clean()
End Sub

Sub SaveLock
	Dim ID,IsLock
	ID=Int(Request("ID"))
	IsLock=YxBBs.Execute("Select Lock From[YX_LockIp] where Id="&ID&"")(0)
	If IsLock Then
		YxBBs.Execute("update [YX_LockIp] set Lock=False where Id="&ID&"") 
	Else
		YxBBs.Execute("update [YX_LockIp] set Lock=True where Id="&ID&"") 
	End IF
	Cache.Name="IPData"
	Cache.clean()
	Response.redirect "?Action=LockIp"
End Sub

Sub ExecuteSql
	Dim Sql,Caption,Content
	Sql=Request.Form("sql")
	Caption="执行SQL语句"
	Content="<form onSubmit=checkclick('注意！操作不当有可能破坏数据库！\n\n您确定要执行SQL语句吗？') method=post style='margin:0'>指令：<input type=text name='sql' value='"&Sql&"' style='width:90%'><br>注意：此操作不可恢复，如果对SQL语法不了解，请慎用！<input type=submit value=' 确定执行 '></Form>"
	Call ShowTable(Caption,Content)
	If Sql<>"" then
	Response.Write("<br>")
	On Error Resume Next 
	YxBBs.Execute(Sql)
	If err.number=0 then
		Caption="执行成功":Content="<li>Sql语句正确，已经成功的执行了下面这条语句！<li><font color=red>"&Sql&"</font>"
	Else
		Caption="错误信息":Content="<li>不能执行，语句有问题，具体出错如下：<li>"&Err.Description&"<br>"
		Err.clear
	End if
	Call ShowTable(Caption,Content)
	End if
End Sub

Sub CompressData()
	Dim DbPath,boolIs97,Caption,Content
	Caption="压缩数据库"
	Content="<b>注意：</b>输入数据库所在相对路径，并且输入数据库名称（如果正在使用中数据库不能压缩，请选择备份数据库进行压缩操作）<hr size=1>"&_
	"<form style='margin:0' method='post'>压缩数据库：<input type='text' name='DbPath' value='请输入数据库路径'>&nbsp;<input type='submit' value='开始压缩'><br><form>"&_
	"<input type='checkbox' name='boolIs97' value='True'>如果使用 Access 97 数据库请选择(默认为 Access 2000 数据库)"
	Call ShowTable(Caption,Content)
	Response.flush
	DbPath = Request("DbPath")
	boolIs97 = Request("boolIs97")
	If DbPath <> "" Then
	If Session(YxBBs.CacheName&"fso")="no" Then
		Call GoBack("","空间不支持FSO文件读写。无法进入下一步。")
		Exit Sub
	End If
	DbPath = server.mappath(DbPath)
	Content=CompactDB(DbPath,boolIs97)
	Call ShowTable(Caption,Content)
	End If
End sub

Function CompactDB(DbPath, boolIs97)
	Dim fso,Engine,strDbPath,JET_3X,Content
	strDbPath = left(DbPath,instrrev(DbPath,"\"))
	Set fso = CreateObject("Scripting.FileSystemObject")
	If fso.FileExists(DbPath) Then
		fso.CopyFile DbPath,strDbPath & "temp.mdb"
		Set Engine = CreateObject("JRO.JetEngine")
		If boolIs97 = "True" Then
			Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDbPath & "temp.mdb", _
			"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDbPath & "temp1.mdb;" _
			& "Jet OLEDB:Engine Type=" & JET_3X
		Else
			Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDbPath & "temp.mdb", _
			"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDbPath & "temp1.mdb"
		End If
	fso.CopyFile strDbPath & "temp1.mdb",DbPath
	fso.DeleteFile(strDbPath & "temp.mdb")
	fso.DeleteFile(strDbPath & "temp1.mdb")
	Set fso = nothing
	Set Engine = nothing
		CompactDB = "<li>你的数据库 " & DbPath & "，已经压缩成功！" 
	Else
		CompactDB = "<li>数据库名称或路径不正确！ 请重试！" 
	End If
End Function

Sub BackupDate()
	Dim Caption,Content
	Caption="备份论坛数据"
	Content="<b>注意事项：</b><br>论坛数据库备份几乎是站长每天必做的事！<br>为保证您的数据安全，备份时请不要用默认名称来命名备份数据库。<br>发现数据丢失的时候，就可以用你最后备份的数据库恢复。<br>注意：所有路径都是相对与程序空间根目录的相对路径<hr size=1>"&_
	"<form style='margin:0' method='post' action='?Action=BackupDate&Go=Start'>当前数据库路径(相对路径)：<input type=text size=15 name=DbPath value='请输入数据库路径'><br>"&_
	"备份数据库目录(相对路径)：<input type=text size='15' name='BkFolder' value='DataBak'>&nbsp;如目录不存在，程序将自动创建<BR>"&_
	"备份数据库名称(填写名称)：<input type=text size=15 name=BkDbName value='"&formatdatetime(Now(),2)&".Asp'>&nbsp;如备份目录有该文件，将覆盖，如没有，将自动创建<BR>"&_
	"<input type=submit value=' 开始备份 '></form>"
	Call ShowTable(Caption,Content)
	If Request("Go")="Start" then
		If Session(YxBBs.CacheName&"fso")="no" Then
			Call GoBack("","空间不支持FSO文件读写。无法进入下一步。")
			Exit Sub
		End If
	 Dim fso,DbPath,BkFolder,BkDbName
			DbPath=YxBBs.Fun.GetStr("DbPath")
			DbPath=server.mappath(DbPath)
			BkFolder=YxBBs.Fun.GetStr("BkFolder")
			BkDbName=YxBBs.Fun.GetStr("BkDbName")
			Set Fso=server.createobject("scripting.filesystemobject")
			if fso.fileexists(DbPath) then
				If CheckDir(BkFolder) = True Then
				fso.copyfile DbPath,BkFolder& "\"& BkDbName
				else
				MakeNewsDir BkFolder
				fso.copyfile DbPath,BkFolder& "\"& BkDbName
				end if
				Caption="备份成功":Content="备份数据库成功！您备份的数据库路径为 " &BkFolder& "\"& BkDbName
			Else
				Caption="错误信息":Content="找不到您所需要备份的文件。"
			End if
		Call ShowTable(Caption,Content)
	End if
End sub
'检测目录是否存在
Function CheckDir(FolderPath)
	Dim Fso1
	Folderpath=Server.MapPath(".")&"\"&folderpath
    Set fso1 = CreateObject("Scripting.FileSystemObject")
    If fso1.FolderExists(FolderPath) then
       '存在
       CheckDir = True
    Else
       '不存在
       CheckDir = False
    End if
    Set fso1 = nothing
End Function
'建立目录
Function MakeNewsDir(foldername)
	Dim fso1
	dim f
    Set fso1 = CreateObject("Scripting.FileSystemObject")
        Set f = fso1.CreateFolder(foldername)
        MakeNewsDir = True
    Set fso1 = nothing
End Function

Sub RestoreData()
	Dim Caption,Content
	Caption="恢复论坛数据"
	Content="<b>注意事项：</b>恢复数据库 一般是用来恢复(数据丢失或被破坏)的当前使用数据库。<br>是用备份的数据库直接把当前使用的数据库直接覆盖，请注意！<br>下面的路径都是相对与程序空间根目录的相对路径。<hr size=1>"&_
	"<form method='post' style='margin:0' action='?Action=RestoreData&Go=Start'>备份数据库(相对路径)：<input type='text' size='30' name='BackPath' value='DataBak/"&formatdatetime(Now(),2)&".Asp'> 请填写用来恢复的备份文件<BR>"&_
	"当前数据库(相对路径)：<input type='text' size='30' name='DbPath' value='请输入数据库路径'> 填写您当前使用的数据库<BR><input onclick=checkclick('您确定要用备份的数据库覆盖当然使用的数据库吗！？') type=submit value=' 恢复数据 '></form> "
	Call ShowTable(Caption,Content)
	If Request("Go")="Start" then
		If Session(YxBBs.CacheName&"fso")="no" Then
			Call GoBack("","空间不支持FSO文件读写。无法进入下一步。")
			Exit Sub
		End If
	 Caption="错误信息"
	 Dim FSO,Dbpath,BackPath
		DbPath=YxBBs.Fun.GetStr("DbPath")
		BackPath=YxBBs.Fun.GetStr("BackPath")
		if BackPath="" or DbPath="" then
			Content="请把全名填写完整！"	
		'ElseIF Lcase(Dbpath)<>Lcase(Db) Then
			'Content="您输入的不是当前使用数据库全名!"	
		Else
			DbPath=server.mappath(DbPath)
			BackPath=server.mappath(BackPath)
			Set Fso=server.createobject("scripting.filesystemobject")
			if fso.fileexists(DbPath) then  					
			On Error Resume Next
			fso.copyfile BackPath,DbPath
				If err.number=0 then
				Caption="恢复成功":Content="成功的恢复数据库！"
				Else
				Caption="错误信息":Content="不是当前使用的数据库全名"
				Err.clear
				End If
			else
			Content= "备份目录下并无您的备份文件！"	
		end if
	 End IF
	Call ShowTable(Caption,Content)
	End If
End sub

Sub SqlTable
	Dim AllTable,i
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" colspan="4" bgcolor="#CCCCCC"><b><font color="#FFFFFF">数据表管理</font></b></td>
	</tr>
<tr><td height="25" colspan="4" bgcolor="#DEDEDE"><b>说明：</b><br>
  默认选中的为当前论坛所使用来保存帖子数据的表，<br>删除数据表将同时全部删除该数据表的所有帖子，请注意！！！<br>
一般帖子数量超过4万左右，请再添加一个数据表，这样您会发现论坛会快很多。</td></tr></tbody></table><br>
	<form method=POST name=form style='margin:0' action=?Action=SaveAuteSqlTable>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="4"><b><font color="#FFFFFF">设置默认数据表</font></b></td>
	</tr>	<tr bgcolor="#DEDEDE"><td height="25"><b>数据表</b></td>
	<td><b>帖数</b></td>
	<td><b>默认</b></td>
	<td><b>操作</b></td>
	</tr>
	<%AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
	Response.Write"<tr bgcolor=""#DEDEDE""><td height='25'>YX_Bbs"&AllTable(i)&"</td><td>"&YxBBs.execute("Select Count(BBSID) From[YX_bbs"&AllTable(i)&"]")(0)&"</td><td><input name='Aute' type='radio' value='"&AllTable(i)&"'"
	If YxBBs.BBSTable(1)=AllTable(i) Then
	 Response.Write" checked></td><td><a onclick=alert('该数据表为默认数据表，不能删除默认的数据表！') href='#'>"
	 Else
	 Response.Write"></td><td><a onclick=checkclick('注意！删除将包括数据表的所有帖子！\n\n删除后将不能恢复！您确定要删除吗？') href='?Action=DelSqlTable&ID="&AllTable(i)&"'>"
	 End If
	 Response.Write"<img src='../images/del.gif' width='15' height='15' border='0' align='absmiddle'> 删除</a></td></tr>"
	Next
	%>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form><br>
	<form method=POST name=form style='margin:0' action=?Action=SaveAddSqlTable>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" bgcolor="#CCCCCC"><b><font color="#FFFFFF">增加数据表</font></b></td>
	</tr>
	<tr><td height="35" colspan="4" bgcolor="#DEDEDE">新数据表名称：YX_bbs
	  <input type="text" name="TableName"  size="2" value="<%=int(uBound(AllTable)+2)%>" ONKEYPRESS='event.returnValue=(event.keyCode >= 48) && (event.keyCode <= 57);'> （只填写数字，不能和现有的数据表相同。)</td>
	</tr>
<tr bgcolor="#4D65A4"><td align="center" bgcolor="#CCCCCC"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
<%
End Sub

Sub SaveAuteSqlTable
	Dim Aute,Temp,AllTable,i
	Aute=YxBBs.Fun.GetStr("Aute")
	AllTable=Split(YxBBs.BBSTable(0),",")
	Temp=""
	For i=0 To uBound(AllTable)
		If Aute=AllTable(i) Then Temp="yes"
	Next
	If Temp="" Then
		Call Goback("系统出错","无效的数据表名称！"):Exit Sub
	End If
	IF Int(Aute)<>Int(YxBBs.BBSTable(1)) Then
		Temp=YxBBs.BBSTable(0)&"|"&Int(Aute)
		YxBBs.execute("Update [YX_Config] Set BbsTable='"&Temp&"' ")
	End If
	Cache.name="Config"
	Cache.clean()
	Call Suc("","更改论坛默认数据表成功！","?Action=SqlTable")
End Sub

Sub SaveAddSqlTable
	Dim TableName,AllTable,I,Temp
	TableName=YxBBs.Fun.GetStr("TableName")
	If not YxBBs.Fun.isInteger(TableName) then
		Call GoBack("","请用正整数的数字填写！")
		Exit Sub
	End If
	If Int(TableName)=0 Then
		Call GoBack("","数据表名不能为0")
		Exit Sub
	End If
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
	If Int(TableName)=Int(AllTable(i)) then
		Call GoBack("","数据表名已经存在！")
		Exit Sub
	End if
	Next
	Temp=YxBBs.BBSTable(0)&","&TableName&"|"&YxBBs.BBSTable(1)
	YxBBs.execute("update [YX_config] Set BbsTable='"&Temp&"'")
	YxBBs.execute("CREATE TABLE [YX_bbs"&TableName&"](BbsID int IDENTITY (1, 1) NOT NULL CONSTRAINT PrimaryKey PRIMARY KEY,TopicID int default 0,ReplyTopicID int default 0,BoardID int default 0,Name varchar(20),Caption varchar(255),Content text,Face int Default 0,AddTime Datetime,LastTime datetime,IsDel bit,Buyer text,Ip varchar(40),UbbString varchar(255))")
	YxBBs.execute("create index TopicID on [YX_bbs"&TableName&"] (TopicID)")
	YxBBs.execute("create index BoardID on [YX_bbs"&TableName&"] (BoardID)")
	YxBBs.execute("create index ReplyTopicID on [YX_bbs"&TableName&"] (ReplyTopicID)")
	Cache.name="Config"
	Cache.clean()
	Call Suc("","成功的添加了 YX_Bbs"&TableName&" 数据表！","?Action=SqlTable")
End Sub

Sub DelSqlTable
	Dim ID,Temp,AllTable,I
	ID=Request.QueryString("ID")
	If int(ID)=int(YxBBs.BBSTable(1)) Then
		Call GoBack("","该表被设定为默认使用表，不能删除！")
		Exit Sub
	End if
	AllTable=Split(YxBBs.BBSTable(0),",")
	Temp=""
	For i=0 To uBound(AllTable)
		If int(ID)=Int(AllTable(i)) Then Temp="yes"
	Next
	If Temp="" Then
		Call Goback("系统出错","无效的数据表名称！"):Exit Sub
	End If
	Temp=""
	For i=0 To uBound(AllTable)
		If Int(ID)<>int(AllTable(i)) then
			Temp=Temp&AllTable(i)&","
		End if
	Next
	Temp=Left(Temp,len(Temp)-1)
	Temp=Temp&"|"&YxBBs.BBSTable(1)
	YxBBs.execute("update [YX_Config] Set BbsTable='"&Temp&"'")
	YxBBs.Execute("Drop table [YX_bbs"&ID&"]")
	YxBBs.Execute("Delete*From [YX_Topic] where SqlTableID="&ID&"")
	Cache.name="Config"
	Cache.clean()
	Call Suc("","成功的删除名称为 YX_Bbs"&ID&" 的数据表！同时也删除了该数据表的所有帖子！","?Action=SqlTable")
End Sub
Sub SpaceSize
	If Session(YxBBs.CacheName&"fso")="no" Then Call GoBack("","空间不支持FSO文件读写。无法进入下一步。"):Exit Sub
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" colspan="2" bgcolor="#CCCCCC"><b><font color="#FFFFFF">系统空间占用情况</font></b></td>
	</tr>
	<tr><td height="25" bgcolor="#DEDEDE">论坛数据占用空间：<img src="../images/hr1.gif" width=<%=drawbar("../Data")%> height=10>&nbsp;
	  <%showSpaceinfo("../Data")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">管理目录占用空间：<img src="../images/hr2.gif" width=<%=drawbar("../"&YxBBs.BBSSetting(2)&"")%> height=10>&nbsp;
	
	  <%showSpecialSpaceinfo("Program")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">图片目录占用空间：<img src="../images/hr4.gif" width=<%=drawbar("../Images")%> height=10>&nbsp;
	  <%showSpaceinfo("../Images")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">皮肤目录占用空间：<img src="../images/hr5.gif" width=<%=drawbar("../skins")%> height=10>&nbsp;
	  <%showSpaceinfo("../skins")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">上传头像占用空间：<img src="../images/hr6.gif" width=<%=drawbar("../UploadFile/Head")%> height=10>&nbsp;
	  <%showSpaceinfo("../UploadFile/Head")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">上传文件占用空间：<img src="../images/hr1.gif" width=<%=drawbar("../UploadFile/TopicFile")%> height=10>&nbsp;
	  <%showSpaceinfo("../UploadFile/TopicFile")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">Inc 目录占用空间：<img src="../images/hr2.gif" width=<%=drawbar("../inc")%> height=10>&nbsp;
	  <%showSpaceinfo("../inc")%></td></tr>
<tr><td height="25" bgcolor="#DEDEDE">论坛占用空间总计：<img src="../images/hr3.gif" width=400 height=10> <%showSpaceinfo("../")%></td>
</tr></tbody></table>
	<%
End Sub

Sub ShowSpaceInfo(drvpath)
	dim fso,d,size,showsize
	set fso=server.createobject("scripting.filesystemobject") 		
	drvpath=server.mappath(drvpath) 		 		
	set d=fso.getfolder(drvpath) 		
	size=d.size
	showsize=size & "&nbsp;Byte" 
	if size>1024 then
	   size=(size\1024)
	   showsize=size & "&nbsp;KB"
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;MB"		
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;GB"	   
	end if   
	response.write "<font face=verdana>" & showsize & "</font>"
End Sub	 	

Sub Showspecialspaceinfo(method)
	dim fso,d,fc,f1,size,showsize,drvpath 		
	set fso=server.createobject("scripting.filesystemobject")
	drvpath=server.mappath("pic")
	drvpath=left(drvpath,(instrrev(drvpath,"\")-1))
	set d=fso.getfolder(drvpath) 	
	if method="All" then 		
		size=d.size
	elseif method="Program" then
		set fc=d.Files
		for each f1 in fc
			size=size+f1.size
		next	
	end if			
	showsize=size & "&nbsp;Byte" 
	if size>1024 then
	   size=(size\1024)
	   showsize=size & "&nbsp;KB"
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;MB"		
	end if
	if size>1024 then
	   size=(size/1024)
	   showsize=formatnumber(size,2) & "&nbsp;GB"	   
	end if   
	response.write "<font face=verdana>" & showsize & "</font>"
end sub
 	 	 	
Function Drawbar(drvpath)
	dim fso,drvpathroot,d,size,totalsize,barsize
	set fso=server.createobject("scripting.filesystemobject")
	drvpathroot=server.mappath("pic")
	drvpathroot=left(drvpathroot,(instrrev(drvpathroot,"\")-1))
	set d=fso.getfolder(drvpathroot)
	totalsize=d.size
	drvpath=server.mappath(drvpath) 		
	set d=fso.getfolder(drvpath)
	size=d.size
	barsize=cint((size/totalsize)*20)
	Drawbar=barsize
End Function 	

Function Drawspecialbar()
	dim fso,drvpathroot,d,fc,f1,size,totalsize,barsize
	set fso=server.createobject("scripting.filesystemobject")
	drvpathroot=server.mappath("pic")
	drvpathroot=left(drvpathroot,(instrrev(drvpathroot,"\")-1))
	set d=fso.getfolder(drvpathroot)
	totalsize=d.size
	set fc=d.files
	for each f1 in fc
		size=size+f1.size
	next
	barsize=cint((size/totalsize)*400)
	Drawspecialbar=barsize
End Function
%>