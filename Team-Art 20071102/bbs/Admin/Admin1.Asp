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
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">������̳����</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>��̳���ƣ�</td>
	<td><input type="text" name="bbsname" size="20"></td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳��ַ��</td>
	<td><input type="text" name="url" size="38"></td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳ͼƬ��</td>
	<td><input type="text" name="pic" size="38">(��������ʾ��������)</td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳˵����</td>
	<td><input type="text" name="Readme" size="38">(��������)</td></tr>
	<tr bgcolor="#DEDEDE"><td>ͼƬ��ʾ��</td>
	<td><input type="radio" name="ispic" value="yes"  checked>  �� <input type="radio" name="ispic" value="no" > ��</td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td>
</tr></table>
	</form><br>
	<form method=POST name=form style='margin:0' action=?Action=Update>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" ><b><font color="#FFFFFF">��̳������Ϣ</font></b></td>
	<td align="center"><b><font color="#FFFFFF">����</font></b></td>
	<td align="center"><b><font color="#FFFFFF">��ʾͼƬ</font></b></td>
	<td align="center"><b><font color="#FFFFFF">����</font></b></td>
	</tr>
	<%
	i=0
	Set Rs=YxBBs.Execute("Select ID,Ispic,Orders,BbsName,Url,Readme From[YX_Link] order by orders")
	Do while Not Rs.eof
		i=i+1
	%>
	<tr bgcolor="#DEDEDE"><td><a href="<%=Rs("Url")%>" target="_blank" title="<%=Rs("Readme")%>"><%=Rs("BbsName")%></a></td><td align="center"><input name="id" value="<%=Rs("ID")%>" type="hidden"><input type="text" name="orders" value="<%=Rs("Orders")%>" size="2"></td><td align="center"><input type="radio" name="ispic<%=i%>" value="yes" <%if Rs("isPic") then%> checked <%end if%>> �� <input type="radio" name="ispic<%=i%>" value="no" <%if Not Rs("Ispic") then%> checked <%end if%>> ��</td>
	<td align="center"><a href="?Action=Edit&ID=<%=Rs("ID")%>"><img src="../images/edit.gif" width="18" height="13" border="0" align="absmiddle"> �༭</a> <a onclick=checkclick('ɾ���󽫲��ָܻ�����ȷ��Ҫɾ����') href="?Action=Del&ID=<%=Rs("ID")%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"> ɾ��</a></td>
	</tr>
	<%Rs.movenext
	Loop
	Rs.Close
	%>
<tr bgcolor="#CCCCCC"><td colspan="6"  align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table></form>
<%
End Sub

Sub Edit
	Set Rs=YxBBs.Execute("Select ID,Orders,IsPic,Pic,BbsName,Url,Readme From[YX_Link]where ID="&ID&"")
	IF Rs.eof Then
		Call GoBack("������̳���˲����ڣ�")
		Exit Sub
	End If
	%>
	<form method=POST name=form style='margin:0' action=?Action=SaveEdit>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">�޸���̳����</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>��̳���ƣ�</td>
	<td><input name="id" value="<%=Rs("ID")%>" type="hidden"><input type="text" name="bbsname" size="20" value="<%=Rs("BbsName")%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳��ַ��</td>
	<td><input type="text" name="url" size="38" value="<%=Rs("Url")%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳ͼƬ��</td>
	<td><input type="text" name="pic" size="38" value="<%=Rs("Pic")%>">(��������)</td></tr>
	<tr bgcolor="#DEDEDE"><td>��̳˵����</td>
	<td><input type="text" name="Readme" size="38" value="<%=Rs("Readme")%>">(��������)</td></tr>
	<tr bgcolor="#DEDEDE"><td>ͼƬ��ʾ��</td>
	<td><input type="radio" name="ispic" value="yes" <%if Rs("isPic") then%> checked <%end if%>>  �� <input type="radio" name="ispic" value="no" <%if Not Rs("Ispic") then%> checked <%end if%>> ��</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table>
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
		Call GoBack("","����������д!")
		Exit Sub
	End IF
	YxBBs.Execute("Update [YX_Link]Set Orders="&Orders&",IsPic="&IsPic&" where ID="&ID&"")
	Next
	Cache.name="Link_List":Cache.clean()
	Call Suc("","������̳������Ϣ�ɹ���","?")
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
		Call GoBack("","�벻Ҫʹ���˷Ƿ��ַ�")
		Exit Sub
	End if
	Orders=YxBBs.execute("select Count(ID) From[YX_Link]")(0)
	Orders=Int(Orders+1)
	YxBBs.execute("insert into[YX_Link](Bbsname,Url,Pic,Readme,Orders,IsPic)values('"&BbsName&"','"&Url&"','"&Pic&"','"&Readme&"',"&Orders&","&IsPic&")")
	Cache.name="Link_List":Cache.clean()
	Call Suc("","������̳�������ӳɹ���","?")
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
		Call GoBack("","�벻Ҫʹ���˷Ƿ��ַ�")
		Exit Sub
	End if
	YxBBs.execute("Update [YX_Link]Set Url='"&Url&"',Pic='"&Pic&"',BbsName='"&BbsName&"',Readme='"&Readme&"',IsPic="&IsPic&" where ID="&ID&"")
	Cache.name="Link_List":Cache.clean()
	Call Suc("","�޸���̳�������ӳɹ���","?")
End Sub

Sub DelLink
	Dim ID
	ID=Request.QueryString("ID")
	IF  Not isnumeric(ID) Then
		Call GoBack("","�ύ�Ĳ�������ȷ��")
	Else
		YxBBs.execute("delete from [YX_link] where ID="&ID&"")
		Cache.name="Link_List":Cache.clean()
		Call Suc("","ɾ����̳�������ӳɹ���","?")
	End If
End Sub
%>


<%Sub LockIp%>
	<form method=POST name=form style='margin:0' action=?Action=SaveAddip>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">IP����</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="20%" height="25">��ʼIP��<br>
	  (����)</td><td width="80%"><input name='StartIp' type='text'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">����IP��<br>
	  (��������IPʱ������д)</td><td><input name='EndIp' type='text'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">���˵����<br>
	  (���255���ַ�)</td><td><input name='Readme' type='text' style="width:90%"></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table>
	</form><br>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25"  colspan="3"><b><font color="#FFFFFF">�Ѿ������IP��¼</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="40%" height="25" align='center'><b>����</b></td>
	<td width="40%"><b>˵��</b></td>
	<td width="20%" align='center'><b>����</b></td>
	</tr>
	<% 
	Set Rs=YxBBs.Execute("Select StartIp,EndIp,Readme,Lock,ID From[YX_LockIp] where Lock")
	If Rs.eof Then
	Response.Write"<tr bgcolor=""#DEDEDE""><td colspan='4'>û�з�����¼</td></tr>"
	Else
	Do while not Rs.eof
		Response.Write"<tr bgcolor=""#DEDEDE""><td align='center'>"&YxBBs.Fun.IpDecode(Rs("StartIp"))&" - "&YxBBs.Fun.IpDecode(Rs("EndIp"))&"</td><td>&nbsp;"&Rs("Readme")&"</td><td align='center'><a href=?Action=EditIp&Id="&rs("ID")&"><img src=../images/edit.gif border=0 align='absmiddle'> �޸�<a> <a href=?Action=SaveLock&ID="&rs("ID")&"><img src=../images/Lock.GIF align='absmiddle' border=0> ���</a></td></tr>"
	Rs.MoveNext
	Loop
	End If
	Rs.Close
	%>
</table><br>
	<form method=POST name=form style='margin:0' action=?Action=LockIp>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25"  colspan="3"><b><font color="#FFFFFF">δ�����IP��¼</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="40%" height="25" align='center'><b>����</b></td>
	<td width="40%"><b>˵��</b></td>
	<td width="20%" align='center'><b>����</b></td>
	</tr>
	<% 
	Set Rs=YxBBs.Execute("Select StartIp,EndIp,Readme,Lock,ID From[YX_LockIp] where not Lock")
	If Rs.eof Then
	Response.Write"<tr bgcolor=""#DEDEDE""><td colspan='4'>û��IP��¼</td></tr>"
	Else
	Do while not Rs.eof
		Response.Write"<tr bgcolor=""#DEDEDE""><td align='center'>"&YxBBs.Fun.IpDecode(Rs("StartIp"))&" - "&YxBBs.Fun.IpDecode(Rs("EndIp"))&"</td><td>&nbsp;"&Rs("Readme")&"</td><td align='center'><a href=?Action=SaveLock&ID="&Rs("ID")&"><img src=../images/lock.GIF border=0 align='absmiddle'> ����</a> <a href=?Action=DelIp&ID="&Rs("ID")&"><img src=../images/del.gif border='0' align='absmiddle'> ɾ��</td></tr>"
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
		Call GoBack("","��¼������"):Exit Sub
	End If
%>
	<form method=POST name=form style='margin:0' action=?Action=SaveEditip>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">IP����</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="20%" height="25">��ʼIP��<br>
	  (����)</td><td width="80%"><input name="id" value="<%=Rs("ID")%>" type="hidden"><input name='StartIp' type='text' value="<%=YxBBs.Fun.IpDecode(Rs("StartIp"))%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">����IP��<br>
	  (��������IPʱ������д)</td><td><input name='EndIp' type='text' value="<%=YxBBs.Fun.IpDecode(Rs("EndIp"))%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td height="25">���˵����<br>
	  (���255���ַ�)</td><td><input name='Readme' type='text' style="width:90%" value="<%=Rs("Readme")%>"></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table>
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
	Call Suc("�����ɹ�","�ɹ����ӷ���IP��¼!","?Action=LockIp")
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
	Call Suc("","�޸ķ���IP�ɹ�!","?Action=LockIp")
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
	Caption="ִ��SQL���"
	Content="<form onSubmit=checkclick('ע�⣡���������п����ƻ����ݿ⣡\n\n��ȷ��Ҫִ��SQL�����') method=post style='margin:0'>ָ�<input type=text name='sql' value='"&Sql&"' style='width:90%'><br>ע�⣺�˲������ɻָ��������SQL�﷨���˽⣬�����ã�<input type=submit value=' ȷ��ִ�� '></Form>"
	Call ShowTable(Caption,Content)
	If Sql<>"" then
	Response.Write("<br>")
	On Error Resume Next 
	YxBBs.Execute(Sql)
	If err.number=0 then
		Caption="ִ�гɹ�":Content="<li>Sql�����ȷ���Ѿ��ɹ���ִ��������������䣡<li><font color=red>"&Sql&"</font>"
	Else
		Caption="������Ϣ":Content="<li>����ִ�У���������⣬����������£�<li>"&Err.Description&"<br>"
		Err.clear
	End if
	Call ShowTable(Caption,Content)
	End if
End Sub

Sub CompressData()
	Dim DbPath,boolIs97,Caption,Content
	Caption="ѹ�����ݿ�"
	Content="<b>ע�⣺</b>�������ݿ��������·���������������ݿ����ƣ��������ʹ�������ݿⲻ��ѹ������ѡ�񱸷����ݿ����ѹ��������<hr size=1>"&_
	"<form style='margin:0' method='post'>ѹ�����ݿ⣺<input type='text' name='DbPath' value='���������ݿ�·��'>&nbsp;<input type='submit' value='��ʼѹ��'><br><form>"&_
	"<input type='checkbox' name='boolIs97' value='True'>���ʹ�� Access 97 ���ݿ���ѡ��(Ĭ��Ϊ Access 2000 ���ݿ�)"
	Call ShowTable(Caption,Content)
	Response.flush
	DbPath = Request("DbPath")
	boolIs97 = Request("boolIs97")
	If DbPath <> "" Then
	If Session(YxBBs.CacheName&"fso")="no" Then
		Call GoBack("","�ռ䲻֧��FSO�ļ���д���޷�������һ����")
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
		CompactDB = "<li>������ݿ� " & DbPath & "���Ѿ�ѹ���ɹ���" 
	Else
		CompactDB = "<li>���ݿ����ƻ�·������ȷ�� �����ԣ�" 
	End If
End Function

Sub BackupDate()
	Dim Caption,Content
	Caption="������̳����"
	Content="<b>ע�����</b><br>��̳���ݿⱸ�ݼ�����վ��ÿ��������£�<br>Ϊ��֤�������ݰ�ȫ������ʱ�벻Ҫ��Ĭ�������������������ݿ⡣<br>�������ݶ�ʧ��ʱ�򣬾Ϳ���������󱸷ݵ����ݿ�ָ���<br>ע�⣺����·��������������ռ��Ŀ¼�����·��<hr size=1>"&_
	"<form style='margin:0' method='post' action='?Action=BackupDate&Go=Start'>��ǰ���ݿ�·��(���·��)��<input type=text size=15 name=DbPath value='���������ݿ�·��'><br>"&_
	"�������ݿ�Ŀ¼(���·��)��<input type=text size='15' name='BkFolder' value='DataBak'>&nbsp;��Ŀ¼�����ڣ������Զ�����<BR>"&_
	"�������ݿ�����(��д����)��<input type=text size=15 name=BkDbName value='"&formatdatetime(Now(),2)&".Asp'>&nbsp;�籸��Ŀ¼�и��ļ��������ǣ���û�У����Զ�����<BR>"&_
	"<input type=submit value=' ��ʼ���� '></form>"
	Call ShowTable(Caption,Content)
	If Request("Go")="Start" then
		If Session(YxBBs.CacheName&"fso")="no" Then
			Call GoBack("","�ռ䲻֧��FSO�ļ���д���޷�������һ����")
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
				Caption="���ݳɹ�":Content="�������ݿ�ɹ��������ݵ����ݿ�·��Ϊ " &BkFolder& "\"& BkDbName
			Else
				Caption="������Ϣ":Content="�Ҳ���������Ҫ���ݵ��ļ���"
			End if
		Call ShowTable(Caption,Content)
	End if
End sub
'���Ŀ¼�Ƿ����
Function CheckDir(FolderPath)
	Dim Fso1
	Folderpath=Server.MapPath(".")&"\"&folderpath
    Set fso1 = CreateObject("Scripting.FileSystemObject")
    If fso1.FolderExists(FolderPath) then
       '����
       CheckDir = True
    Else
       '������
       CheckDir = False
    End if
    Set fso1 = nothing
End Function
'����Ŀ¼
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
	Caption="�ָ���̳����"
	Content="<b>ע�����</b>�ָ����ݿ� һ���������ָ�(���ݶ�ʧ���ƻ�)�ĵ�ǰʹ�����ݿ⡣<br>���ñ��ݵ����ݿ�ֱ�Ӱѵ�ǰʹ�õ����ݿ�ֱ�Ӹ��ǣ���ע�⣡<br>�����·��������������ռ��Ŀ¼�����·����<hr size=1>"&_
	"<form method='post' style='margin:0' action='?Action=RestoreData&Go=Start'>�������ݿ�(���·��)��<input type='text' size='30' name='BackPath' value='DataBak/"&formatdatetime(Now(),2)&".Asp'> ����д�����ָ��ı����ļ�<BR>"&_
	"��ǰ���ݿ�(���·��)��<input type='text' size='30' name='DbPath' value='���������ݿ�·��'> ��д����ǰʹ�õ����ݿ�<BR><input onclick=checkclick('��ȷ��Ҫ�ñ��ݵ����ݿ⸲�ǵ�Ȼʹ�õ����ݿ��𣡣�') type=submit value=' �ָ����� '></form> "
	Call ShowTable(Caption,Content)
	If Request("Go")="Start" then
		If Session(YxBBs.CacheName&"fso")="no" Then
			Call GoBack("","�ռ䲻֧��FSO�ļ���д���޷�������һ����")
			Exit Sub
		End If
	 Caption="������Ϣ"
	 Dim FSO,Dbpath,BackPath
		DbPath=YxBBs.Fun.GetStr("DbPath")
		BackPath=YxBBs.Fun.GetStr("BackPath")
		if BackPath="" or DbPath="" then
			Content="���ȫ����д������"	
		'ElseIF Lcase(Dbpath)<>Lcase(Db) Then
			'Content="������Ĳ��ǵ�ǰʹ�����ݿ�ȫ��!"	
		Else
			DbPath=server.mappath(DbPath)
			BackPath=server.mappath(BackPath)
			Set Fso=server.createobject("scripting.filesystemobject")
			if fso.fileexists(DbPath) then  					
			On Error Resume Next
			fso.copyfile BackPath,DbPath
				If err.number=0 then
				Caption="�ָ��ɹ�":Content="�ɹ��Ļָ����ݿ⣡"
				Else
				Caption="������Ϣ":Content="���ǵ�ǰʹ�õ����ݿ�ȫ��"
				Err.clear
				End If
			else
			Content= "����Ŀ¼�²������ı����ļ���"	
		end if
	 End IF
	Call ShowTable(Caption,Content)
	End If
End sub

Sub SqlTable
	Dim AllTable,i
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" colspan="4" bgcolor="#CCCCCC"><b><font color="#FFFFFF">���ݱ�����</font></b></td>
	</tr>
<tr><td height="25" colspan="4" bgcolor="#DEDEDE"><b>˵����</b><br>
  Ĭ��ѡ�е�Ϊ��ǰ��̳��ʹ���������������ݵı���<br>ɾ�����ݱ���ͬʱȫ��ɾ�������ݱ����������ӣ���ע�⣡����<br>
һ��������������4�����ң���������һ�����ݱ����������ᷢ����̳���ܶࡣ</td></tr></tbody></table><br>
	<form method=POST name=form style='margin:0' action=?Action=SaveAuteSqlTable>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="4"><b><font color="#FFFFFF">����Ĭ�����ݱ�</font></b></td>
	</tr>	<tr bgcolor="#DEDEDE"><td height="25"><b>���ݱ�</b></td>
	<td><b>����</b></td>
	<td><b>Ĭ��</b></td>
	<td><b>����</b></td>
	</tr>
	<%AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
	Response.Write"<tr bgcolor=""#DEDEDE""><td height='25'>YX_Bbs"&AllTable(i)&"</td><td>"&YxBBs.execute("Select Count(BBSID) From[YX_bbs"&AllTable(i)&"]")(0)&"</td><td><input name='Aute' type='radio' value='"&AllTable(i)&"'"
	If YxBBs.BBSTable(1)=AllTable(i) Then
	 Response.Write" checked></td><td><a onclick=alert('�����ݱ�ΪĬ�����ݱ�������ɾ��Ĭ�ϵ����ݱ���') href='#'>"
	 Else
	 Response.Write"></td><td><a onclick=checkclick('ע�⣡ɾ�����������ݱ����������ӣ�\n\nɾ���󽫲��ָܻ�����ȷ��Ҫɾ����') href='?Action=DelSqlTable&ID="&AllTable(i)&"'>"
	 End If
	 Response.Write"<img src='../images/del.gif' width='15' height='15' border='0' align='absmiddle'> ɾ��</a></td></tr>"
	Next
	%>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table>
	</form><br>
	<form method=POST name=form style='margin:0' action=?Action=SaveAddSqlTable>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" bgcolor="#CCCCCC"><b><font color="#FFFFFF">�������ݱ�</font></b></td>
	</tr>
	<tr><td height="35" colspan="4" bgcolor="#DEDEDE">�����ݱ����ƣ�YX_bbs
	  <input type="text" name="TableName"  size="2" value="<%=int(uBound(AllTable)+2)%>" ONKEYPRESS='event.returnValue=(event.keyCode >= 48) && (event.keyCode <= 57);'> ��ֻ��д���֣����ܺ����е����ݱ���ͬ��)</td>
	</tr>
<tr bgcolor="#4D65A4"><td align="center" bgcolor="#CCCCCC"><input type="submit" value=" �� �� ">&nbsp;&nbsp;<input type="reset" value=" �� �� "></td></tr></table>
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
		Call Goback("ϵͳ����","��Ч�����ݱ����ƣ�"):Exit Sub
	End If
	IF Int(Aute)<>Int(YxBBs.BBSTable(1)) Then
		Temp=YxBBs.BBSTable(0)&"|"&Int(Aute)
		YxBBs.execute("Update [YX_Config] Set BbsTable='"&Temp&"' ")
	End If
	Cache.name="Config"
	Cache.clean()
	Call Suc("","������̳Ĭ�����ݱ��ɹ���","?Action=SqlTable")
End Sub

Sub SaveAddSqlTable
	Dim TableName,AllTable,I,Temp
	TableName=YxBBs.Fun.GetStr("TableName")
	If not YxBBs.Fun.isInteger(TableName) then
		Call GoBack("","������������������д��")
		Exit Sub
	End If
	If Int(TableName)=0 Then
		Call GoBack("","���ݱ�������Ϊ0")
		Exit Sub
	End If
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
	If Int(TableName)=Int(AllTable(i)) then
		Call GoBack("","���ݱ����Ѿ����ڣ�")
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
	Call Suc("","�ɹ��������� YX_Bbs"&TableName&" ���ݱ���","?Action=SqlTable")
End Sub

Sub DelSqlTable
	Dim ID,Temp,AllTable,I
	ID=Request.QueryString("ID")
	If int(ID)=int(YxBBs.BBSTable(1)) Then
		Call GoBack("","�ñ����趨ΪĬ��ʹ�ñ�������ɾ����")
		Exit Sub
	End if
	AllTable=Split(YxBBs.BBSTable(0),",")
	Temp=""
	For i=0 To uBound(AllTable)
		If int(ID)=Int(AllTable(i)) Then Temp="yes"
	Next
	If Temp="" Then
		Call Goback("ϵͳ����","��Ч�����ݱ����ƣ�"):Exit Sub
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
	Call Suc("","�ɹ���ɾ������Ϊ YX_Bbs"&ID&" �����ݱ���ͬʱҲɾ���˸����ݱ����������ӣ�","?Action=SqlTable")
End Sub
Sub SpaceSize
	If Session(YxBBs.CacheName&"fso")="no" Then Call GoBack("","�ռ䲻֧��FSO�ļ���д���޷�������һ����"):Exit Sub
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" colspan="2" bgcolor="#CCCCCC"><b><font color="#FFFFFF">ϵͳ�ռ�ռ�����</font></b></td>
	</tr>
	<tr><td height="25" bgcolor="#DEDEDE">��̳����ռ�ÿռ䣺<img src="../images/hr1.gif" width=<%=drawbar("../Data")%> height=10>&nbsp;
	  <%showSpaceinfo("../Data")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">����Ŀ¼ռ�ÿռ䣺<img src="../images/hr2.gif" width=<%=drawbar("../"&YxBBs.BBSSetting(2)&"")%> height=10>&nbsp;
	
	  <%showSpecialSpaceinfo("Program")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">ͼƬĿ¼ռ�ÿռ䣺<img src="../images/hr4.gif" width=<%=drawbar("../Images")%> height=10>&nbsp;
	  <%showSpaceinfo("../Images")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">Ƥ��Ŀ¼ռ�ÿռ䣺<img src="../images/hr5.gif" width=<%=drawbar("../skins")%> height=10>&nbsp;
	  <%showSpaceinfo("../skins")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">�ϴ�ͷ��ռ�ÿռ䣺<img src="../images/hr6.gif" width=<%=drawbar("../UploadFile/Head")%> height=10>&nbsp;
	  <%showSpaceinfo("../UploadFile/Head")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">�ϴ��ļ�ռ�ÿռ䣺<img src="../images/hr1.gif" width=<%=drawbar("../UploadFile/TopicFile")%> height=10>&nbsp;
	  <%showSpaceinfo("../UploadFile/TopicFile")%></td></tr>
	<tr><td height="25" bgcolor="#DEDEDE">Inc Ŀ¼ռ�ÿռ䣺<img src="../images/hr2.gif" width=<%=drawbar("../inc")%> height=10>&nbsp;
	  <%showSpaceinfo("../inc")%></td></tr>
<tr><td height="25" bgcolor="#DEDEDE">��̳ռ�ÿռ��ܼƣ�<img src="../images/hr3.gif" width=400 height=10> <%showSpaceinfo("../")%></td>
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