<!--#include file="Inc/SysConfig.Asp"-->
<!-- #include file="Inc/Page_Cls.asp" -->
<script>function checkclick(msg){if(confirm(msg)){event.returnValue=true;}else{event.returnValue=false;}}</script>
<%Dim Action,ID,Rs
If Not YxBBs.Founduser Then YxBBs.Error("����û��ע����ߵ�½��")
YxBBs.Head("��̳����")
ID = YxBBs.CheckNum(Request.QueryString("ID"))
Action=Request("action")
Select Case Action
Case"Add"
	Add
Case"Edit"
	Edit
Case"FactionAdd"
	FactionAdd
Case"FactionOut"
	FactionOut
Case"Look"
	Look
Case"Del"
	Del
Case Else
	Main()
End Select
YxBBs.Footer
Set YxBBs=Nothing

Sub Alert(message)
	message = replace(message,"'","\'")
	Response.Write ("<script LANGUAGE='javascript'>alert('" & message & "');window.location.href='Faction.Asp';</script>")
	Response.End
End Sub

Sub Main()
Dim intPageNow,strPageInfo,arr_Rs,i,Pages,page
Dim Content
Content="<tr><td align='center' height=40 colspan=5><a href='?Action=Add'><img src='Images/tl.gif' border='0' align='absmiddle'> ��������</a>&nbsp;&nbsp;<a onclick=checkclick('ȷ��Ҫ�˳�������������İ��ɣ�\n\n����Y�ҽ����ȥ1��') href='?Action=FactionOut'><img src='Images/tl.gif'  border='0' align='absmiddle'> �˳�����</a></td></tr>"&_
"<tr bgcolor='#D6DFE4'><th width='15%' height='25'>�ɱ�</th><th width='40%'>��ּ</th><th width='15%'>��ʼ��</th><th width='10%'>����</th><th width='20%'>��������</th></tr>"
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Faction]"
	Pages.strPageUrl = "?"
	Pages.strFieldsList = "ID,Name,Note,User,BuildDate"
	Pages.strCondiction = ""
	Pages.strOrderList = "ID desc"
	Pages.strPrimaryKey = "ID"
	Pages.intPageSize = 10
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "Faction"'�ͻ��˼�¼����
	Pages.Reloadtime=3'ÿ�����Ӹ���Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
		Content=Content & "<tr><td align='center' height='25'><a href=?Action=Look&ID="&Arr_Rs(0,i)&">"&Arr_Rs(1,i)&"</a></td><td>"&Arr_Rs(2,i)&"</td><td align='center' height='25'><a href=Profile.Asp?Name="&Arr_Rs(3,i)&">"&Arr_Rs(3,i)&"</a></td><td align='center'>"
		If YxBBs.MyFaction=Arr_Rs(1,i) then
			Content=Content & "<a onclick='checkclick(""��ȷ��Ҫ�˳��ð��ɣ�\n\n����Y�ҽ����ȥ 1��"")' href='?Action=FactionOut&ID="&Arr_Rs(0,i)&"'>�˳��˰�</a>"
		Else
			Content=Content & "<a onclick='checkclick(""��ȷ��Ҫ����ð��ɣ�"")' href='?action=FactionAdd&ID="&Arr_Rs(0,i)&"'>����˰�</a>"
		End if
		Content=Content & "<td align='center'><a href='?Action=Edit&ID="&Arr_Rs(0,i)&"'><img src='Images/edit.gif' border=0>�޸�</a> <a onclick='checkclick(""��ȷ��Ҫ��ɢ�ð��ɣ�"")' href='?Action=Del&ID="&Arr_Rs(0,i)&"'><img src='Images/Del.gif' border=0>��ɢ</a></td></tr>"
	Next
	End If
	Content=Content & "<tr><td colspan=5>"&strPageInfo&"</td></tr>"
	Call YxBBs.ShowTable("��̳����",Content)
End Sub

Sub FactionAdd
	Dim Content,Rs
	YxBBs.Fun.CheckMake
	If YxBBs.MyFaction<>"" Then
		Call Alert("���Ѿ�����["&YxBBs.MyFaction&"]�ˣ������˳�["&YxBBs.MyFaction&"]���ܼ����°�")
	Else
		Set Rs=YxBBs.Execute("select Name from [YX_Faction] where ID="&ID)
		IF Not Rs.Eof Then
			YxBBs.Execute("update [YX_user] Set Faction='"&rs(0)&"' where Name='"&YxBBs.MyName&"'")
			Session(YxBBs.CacheName & "MyInfo") = Empty
			Call Alert("�ɹ��ļ��� ["&Rs(0)&"] ���ɣ�")
		Else
			Call Alert("������������ɣ�")
		End If
		Rs.Close
	End If
End Sub

Sub FactionOut
	YxBBs.Fun.CheckMake
	If YxBBs.MyFaction="" Then
		Call Alert("��Ŀǰ��û�м����κΰ��ɣ�")
	Else
		If Not YxBBs.Execute("select ID from [YX_Faction] where user='"&YxBBs.MyName&"'").eof Then
			Call Alert("���������ˣ������˳����ɣ��˳�������Ҫ��ɢ���ɣ�")
		Else
			YxBBs.execute("Update [YX_user] Set Faction='',Mark=Mark-1 where name='"&YxBBs.MyName&"'")
			Session(YxBBs.CacheName & "MyInfo") = Empty
		End If
		Call Alert("�˳����ɳɹ�")
	End If
End Sub

Sub Del
YxBBs.Fun.CheckMake
	Set Rs=YxBBs.Execute("Select Name,User From[YX_Faction] where ID="&ID)
	If Rs.Eof Then
		Call Alert("������������ɣ�")
	ElseIf YxBBs.MyName<>Rs(1) Then
		Call Alert("�����Ǹð�İ����޷���ɢ�ð")
	Else
		YxBBs.Execute("Update [YX_user] set Faction='' where Faction='"&rs(0)&"'")
		YxBBs.Execute("Delete from [YX_Faction] where ID="&ID)
		Session(YxBBs.CacheName & "MyInfo") = Empty
		Call Alert("��ɢ���ɳɹ���")
	End if
	Rs.Close
End Sub

Sub Look
Dim Content
Set Rs=YxBBs.Execute("Select Name,FullName,Note,User,BuildDate from [YX_Faction] where ID="&ID)
If Rs.eof Then
	Call Alert("�����ڴ˰��ɣ�")
Else
	Content="<tr><td width='24%' align='right' height=25><b>�������ƣ�</b></td><td width='74%'>&nbsp;"&YxBBs.Fun.HtmlCode(rs(0))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>����ȫ�ƣ�</b></td><td>&nbsp;"&YxBBs.Fun.HtmlCode(rs(1))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>������ּ��</b></td><td>&nbsp;"&YxBBs.Fun.HtmlCode(rs(2))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>����ʱ�䣺</b></td><td>&nbsp;"&Rs(4)&"</td></tr>"&_
	"<tr><td align='right' height=25><b>�������ƣ�</b></td><td>&nbsp;"&Rs(3)&"</td></tr>"&_
	"<tr><td align='right' height=25><b>���е��ӣ�</b></td><td>"&Desciple(Rs(0))&"</td></tr>"&_
	"<tr><td colspan=2 align='center' height=25><a href='?'>�����ء�</a></td></tr>"
	Call YxBBs.ShowTable("������Ϣ",Content)
End If
Rs.Close
End Sub

Function Desciple(name)
	Dim dRs,I
	I=0
	Set dRs=YxBBs.Execute("Select Name From [YX_user] where Faction='"&Name&"'")
	Do while not dRs.eof
	I=I+1
	Desciple=Desciple & "<a target='_blank' href='Profile.Asp?Name="&dRs(0)&"'>"&dRs(0)&"</a>&nbsp;&nbsp;&nbsp;"
	dRs.movenext
	Loop
	dRs.close:Set dRs=NoThing
	Desciple="<table width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td>&nbsp;"&I&" ��</td><td width='90%'><marquee onmouseover='this.stop()' onmouseout='this.start()' scrollAmount='3' direction='left' width='100%' height='15'>"&Desciple&"</marquee></td></tr></table>"
End Function

Sub Add
Dim Name,FullName,Note,Content
YxBBs.Fun.CheckMake
Name=YxBBs.Fun.GetStr("Name")
FullName=YxBBs.Fun.GetStr("FullName")
Note=YxBBs.Fun.GetStr("Note")
IF Name="" And FullName="" And Note="" Then
	Content="<form  method='post' style='margin:0'>"&_
	"<tr><td colspan=2 height=30 align='center'><font color=red>�������ɵı�Ҫ������ 1.���Ļ���ֵ���� 10 ���ϣ� 2.��Ҫ�۳��� 3000 ���ֽ���Ϊ���ɻ��� </font></td></tr>"&_
	"<tr><td align='right' height=25><b>�������ƣ�</b></td><td>&nbsp;<input Maxlength=10 Name='Name' size='10'>*���ֻ��5������</td></tr>"&_
	"<tr><td align='right' height=25><b>����ȫ�ƣ�</b></td><td>&nbsp;<input size=30 name='FullName'> * </td></tr>"&_
	"<tr><td align='right' height=25><b>������ּ��</b></td><td>&nbsp;<input size=70 name='Note'> * </td></tr>"&_
	"<tr><td colspan=2 height=30 align='center'><input type=submit value=' �� �� '>&nbsp;&nbsp;&nbsp; <input type=reset value=' �� �� '></td></tr></form>"
	Call YxBBs.ShowTable("��������",Content)
Else
	IF Name="" or FullName="" or Note="" Then
		Call Alert("����Ҫ��д����Ϣ��û����д������")
	ElseIF Len(Name)>10 or Len(FullName)>50 Or Len(Note)>200 Then
		Call Alert("�ַ�̫�࣬��������̳�����ơ�")
	ElseIf int(YxBBs.MyMark)<10 then
		Call Alert("���Ļ���С�� 10 ��")
	ElseIf int(YxBBs.MyCoin)<5000 then
		Call Alert("�����ֽ����� 3000 ��")
	ElseIf Not YxBBs.Execute("Select ID From[YX_Faction] where User='"&YxBBs.MyName&"'").Eof Then
		Call Alert("���Ѿ���Ϊ�����ˣ������ٴ������ɣ�")
	Else
	YxBBs.execute("Insert into[YX_Faction](Name,FullName,[Note],BuildDate,[User])Values('"&Name&"','"&FullName&"','"&Note&"','"&YxBBs.NowBbsTime&"','"&YxBBs.MyName&"')")
	YxBBs.execute("Update [YX_User] Set Coin=Coin-3000,Faction='"&Name&"' where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("���ɹ��Ĵ����˰���["&Name&"]���������Ǹð��ɵ������ˣ���ϲ����")
	End if
End if
End Sub

Sub Edit
Dim Name,FullName,Note,Content
Name=YxBBs.Fun.GetStr("Name")
FullName=YxBBs.Fun.GetStr("FullName")
Note=YxBBs.Fun.GetStr("Note")
Set Rs=YxBBs.Execute("Select Name,FullName,Note,User from [YX_Faction] where ID="&ID)
If Rs.eof Then
	Call Alert("�����ڴ˰��ɣ�")
ElseIf YxBBs.MyName<>Rs(3) Then
	Call Alert("������["&Rs(0)&"]�İ����޷��޸���Ϣ��")
Else
	IF Name="" And FullName="" And Note="" Then
		Set Rs=YxBBs.Execute("Select Name,FullName,Note,User from [YX_Faction] where ID="&ID)
		If Rs.eof Then
			Call Alert("�����ڴ˰��ɣ�")
		ElseIf YxBBs.MyName<>Rs(3) Then
			Call Alert("������["&Rs(0)&"]�İ����޷��޸���Ϣ��")
		Else
			Content="<form  method='post' style='margin:0'>"&_
			"<tr><td colspan=2 height=30 align='center'><font color=red>ע�⣺ÿ���޸İ�����Ϣ���۳��� 100 ���ֽ� </font></td></tr>"&_
			"<tr><td align='right' height=25><b>�������ƣ�</b></td><td>&nbsp;<input Maxlength=10 Name='Name' size='10' value='"&Rs(0)&"'>*��Ҫ����5������</td></tr>"&_
			"<tr><td align='right' height=25><b>����ȫ�ƣ�</b></td><td>&nbsp;<input size=30 name='FullName' value='"&Rs(1)&"'> * </td></tr>"&_
			"<tr><td align='right' height=25><b>������ּ��</b></td><td>&nbsp;<input size=70 name='Note' value='"&Rs(2)&"'> * </td></tr>"&_
			"<tr><td colspan=2 height=30 align='center'><input type=submit value=' �� �� '>&nbsp;&nbsp;&nbsp; <input type=reset value=' �� �� '></td></tr></form>"
			Call YxBBs.ShowTable("��������",Content)
		End If
	Else
		IF Name="" or FullName="" or Note="" Then
			Call Alert("����Ҫ��д����Ϣ��û����д������")
		ElseIf int(YxBBs.MyCoin)<100 then
			Call Alert("�Բ�������ֽ�����100Ԫ���������ٰ��ɡ�")
		ElseIF Len(Name)>10 or Len(FullName)>50 Or Len(Note)>200 Then
			Call Alert("�ַ�̫�࣬��������̳�����ơ�")
		Else
		YxBBs.execute("Update [YX_Faction]Set Name='"&Name&"',FullName='"&FullName&"',[Note]='"&Note&"' where ID="&ID)
		YxBBs.execute("Update [YX_User] Set Faction='"&Name&"' where Faction='"&Rs(0)&"'")
		YxBBs.execute("Update [YX_User] Set Coin=Coin-100 where Name='"&YxBBs.MyName&"'")
		Session(YxBBs.CacheName & "MyInfo") = Empty
		Call Alert("�ɹ����޸��˰��ɣ�")
		End if
	End if
End If
Rs.Close
End Sub
%>