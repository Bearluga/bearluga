<!--#include file="Check.asp"-->
<!--#include file="../inc/page_Cls.asp"-->
<%
Server.ScriptTimeout =999999
Const TopicFile="../UploadFile/TopicFile/"
Const Del="../UploadFile/Del/"'�ƶ��ļ���Ŀ¼
Call ShowTable("�ϴ��ļ�����","<center><a href=?>�����ϴ���¼</a> |  <a href=?Action=delnouse>���������ϴ��ļ�</a> | <a href=?Action=delnovisit>����û�з��ʵ��ļ�</a> | <a href=?Action=deluphalfyear>���������ϴ��ļ�</a></center>")
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

Rem #���ĺ���(2005-5-27)
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
		If LoopCount>40 Then Exit Do'��ֹ��ѭ��
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
	<tr bgcolor="#CCCCCC"><td height="25" colspan="6">�û��ļ��ϴ���¼</td>
	</tr>
	<tr bgcolor='#D7DAEA'><td width="5%" align="center"><b>ѡ��</b></td><td width="40%" height="25" align="center"><b>�ϴ����ļ�</b></td><td width="10%" align="center"><b>����</b></td><td width="15%" align="center"><b>�ϴ��û�</b></td><td width="18%" align="center"><b>�ϴ�����</b></td><td width="12%" align="center"><b>��С</b></td></tr>  
	<%
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strFieldsList = "FileID,FileName,userName,FileType,FileSize,UpTime"
	Pages.strTableName = "[YX_UpFile]"
	Pages.strPrimaryKey = "FileID"
	Pages.strOrderList = "FileID desc"
	Pages.intPageSize = 25
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "UpFile"'cookies����
	Pages.Reloadtime=3'cookies��Ч����
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
	Response.Write"<tr><td height=25 colspan='6'>û���ϴ��ļ��ļ�¼</td></tr>"
	End If
	%><tr bgcolor="#D7DAEA"><td colspan="6"><input type=checkbox name=chkall value=on onClick="CheckAll(this.form)"> ȫѡ&nbsp;&nbsp;<input type="submit"  value="ɾ����ѡ" onclick=checkclick('ɾ���󽫲��ָܻ�����ȷ��Ҫɾ����')> </td></tr></form>
	<tr bgcolor="#CCCCCC"><td height=20 colspan="6"><%=strPageInfo%></td>
	</tr></tbody></table><%
End Sub
'��ȡ��������
Sub Delnouse
	Call LoginTxt("���ڶ�ȡ����")
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
	Call ShowTable("��ʼ������Ч�ļ�","<form method=POST action='?Action=delall'><input name='files' type='hidden' value='"&temp&"'> ˵�����˲�����ɾ��û�������������ӵ������ļ���<br><input name='Go' type='radio' value='move' checked> �ƶ���<font color=red>"&Del&"</font>Ŀ¼�У����飬Ϊ��ֹ��ɾ�����鿴�޴����ɾ�����Ŀ¼���ɣ�<br><input name='Go' type='radio' value='del'> ֱ�Ӵӿռ�ɾ�� <hr><input value=' ȷ �� ' type=submit></form><script>abc.style.visibility = ""hidden"";</script>")
End Sub

'�������
Sub DelAll
	Call LoginTxt("���ڴ����ļ�")
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
		Call Suc("","���õ��ϴ��ļ��Ѿ���ת����"&Del&"Ŀ¼�� !","?")
	Else
		Call Suc("","���õ��ϴ��ļ��Ѿ�ɾ�� !","?")
	End If
End Sub

'��������
Sub Deluphalfyear
	Dim Go,DelTime,Fso,Folder,Files,upname
	Go=Request.Form("Go")
	DelTime=Request.Form("DelTime")
	If Go="" And DelTime="" Then
		Response.Write"<form method=POST>"
		Call ShowTable("���������������ǰ�ϴ����ļ�","<input name='Go' type='radio' value='move' checked> �ƶ���<font color=red>"&Del&"</font>Ŀ¼�У�Ϊ��ֹ��ɾ�����鿴�޴����ɾ�����Ŀ¼���ɣ�<br><input name='Go' type='radio' value='del'> ֱ�Ӵӿռ�ɾ�� <hr>������<input name='DelTime' type='text' size=4 value='180'>����ǰ�ϴ����ļ� <input value=' ȷ �� ' type=submit></form>")
	Else
		If Not isnumeric(DelTime) Then Call GoBack("","����������������д��"):Exit Sub
		Call LoginTxt("���ڴ����ļ�")
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
	Call Suc("","��"&DelTime&"����ǰ�ϴ����ļ��Ѿ���ת����"&Del&"Ŀ¼�� !","?")
	Else
	Call Suc("","��"&DelTime&"����ǰ�ϴ����ļ��Ѿ�ɾ����","?")
	End If
	End IF
End Sub

'����û�з��ʵ��ļ�
Sub DelNoVisit
	Dim Go,DelTime,Fso,Folder,Files,upname
	Go=Request.Form("Go")
	DelTime=Request.Form("DelTime")
	If Go="" And DelTime="" Then
	Response.Write"<form method=POST>"
		Call ShowTable("�����������ǰû�з��ʵ��ϴ��ļ�","<input name='Go' type='radio' value='move' checked> �ƶ���<font color=red>"&Del&"</font>Ŀ¼�У�Ϊ��ֹ��ɾ�����鿴�޴����ɾ�����Ŀ¼���ɣ�<br><input name='Go' type='radio' value='del'> ֱ�Ӵӿռ�ɾ�� <hr>������<input name='DelTime' size=4 type='text' value='60'>����ǰû�з��ʵ��ϴ��ļ� <input value=' ȷ �� ' type=submit></form>")
	Else
		If Not isnumeric(DelTime) Then Call GoBack("","����������������д��"):Exit Sub
		Call LoginTxt("���ڴ����ļ�")
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
			Call Suc("","����"&DelTime&"����ǰû�з��ʵ��ļ��Ѿ���ת����"&Del&"Ŀ¼�� !","?")
		Else
			Call Suc("","����"&DelTime&"����ǰû�з��ʵ��ļ��Ѿ�ɾ�� !","?")
		End If
	End If
End Sub

'ɾ����ѡ
Sub DelOptFile
	Dim FileName,FSO,Folder,Files,Upname,Temp,i
	FileName=Request("FileName")
	If FileName="" Then Call GoBack("","����ѡ����Ŀ��"):Exit Sub
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
	Call Suc("","�ɹ�ɾ������ѡ���ļ���","?")
End Sub

Sub NotFso
	If Session(YxBBs.CacheName&"fso")="no" Then
		Call GoBack("","�ռ䲻֧��FSO�ļ���д���޷�������һ����")
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
Response.Write"<center><DIV id=abc><br><br><table id=flashtable style='BORDER-RIGHT: white 2px solid; BORDER-TOP: white 2px solid; BORDER-LEFT: white 2px solid; BORDER-BOTTOM: white 2px solid'><tr><td>"&Txt&"�����Ժ򡣡���</td></tr></table></DIV></center>"
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