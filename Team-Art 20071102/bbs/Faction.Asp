<!--#include file="Inc/SysConfig.Asp"-->
<!-- #include file="Inc/Page_Cls.asp" -->
<script>function checkclick(msg){if(confirm(msg)){event.returnValue=true;}else{event.returnValue=false;}}</script>
<%Dim Action,ID,Rs
If Not YxBBs.Founduser Then YxBBs.Error("您还没有注册或者登陆！")
YxBBs.Head("论坛帮派")
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
Content="<tr><td align='center' height=40 colspan=5><a href='?Action=Add'><img src='Images/tl.gif' border='0' align='absmiddle'> 创建帮派</a>&nbsp;&nbsp;<a onclick=checkclick('确定要退出您现在所加入的帮派？\n\n您的Y币将会减去1个') href='?Action=FactionOut'><img src='Images/tl.gif'  border='0' align='absmiddle'> 退出帮派</a></td></tr>"&_
"<tr bgcolor='#D6DFE4'><th width='15%' height='25'>派别</th><th width='40%'>宗旨</th><th width='15%'>创始人</th><th width='10%'>动作</th><th width='20%'>帮主管理</th></tr>"
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
	Pages.strCookiesName = "Faction"'客户端记录总数
	Pages.Reloadtime=3'每三分钟更新Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
		Content=Content & "<tr><td align='center' height='25'><a href=?Action=Look&ID="&Arr_Rs(0,i)&">"&Arr_Rs(1,i)&"</a></td><td>"&Arr_Rs(2,i)&"</td><td align='center' height='25'><a href=Profile.Asp?Name="&Arr_Rs(3,i)&">"&Arr_Rs(3,i)&"</a></td><td align='center'>"
		If YxBBs.MyFaction=Arr_Rs(1,i) then
			Content=Content & "<a onclick='checkclick(""您确定要退出该帮派？\n\n您的Y币将会减去 1个"")' href='?Action=FactionOut&ID="&Arr_Rs(0,i)&"'>退出此帮</a>"
		Else
			Content=Content & "<a onclick='checkclick(""您确定要加入该帮派？"")' href='?action=FactionAdd&ID="&Arr_Rs(0,i)&"'>加入此帮</a>"
		End if
		Content=Content & "<td align='center'><a href='?Action=Edit&ID="&Arr_Rs(0,i)&"'><img src='Images/edit.gif' border=0>修改</a> <a onclick='checkclick(""您确定要解散该帮派？"")' href='?Action=Del&ID="&Arr_Rs(0,i)&"'><img src='Images/Del.gif' border=0>解散</a></td></tr>"
	Next
	End If
	Content=Content & "<tr><td colspan=5>"&strPageInfo&"</td></tr>"
	Call YxBBs.ShowTable("论坛帮派",Content)
End Sub

Sub FactionAdd
	Dim Content,Rs
	YxBBs.Fun.CheckMake
	If YxBBs.MyFaction<>"" Then
		Call Alert("您已经加入["&YxBBs.MyFaction&"]了！请先退出["&YxBBs.MyFaction&"]才能加入新帮")
	Else
		Set Rs=YxBBs.Execute("select Name from [YX_Faction] where ID="&ID)
		IF Not Rs.Eof Then
			YxBBs.Execute("update [YX_user] Set Faction='"&rs(0)&"' where Name='"&YxBBs.MyName&"'")
			Session(YxBBs.CacheName & "MyInfo") = Empty
			Call Alert("成功的加入 ["&Rs(0)&"] 帮派！")
		Else
			Call Alert("不存在这个帮派！")
		End If
		Rs.Close
	End If
End Sub

Sub FactionOut
	YxBBs.Fun.CheckMake
	If YxBBs.MyFaction="" Then
		Call Alert("您目前还没有加入任何帮派！")
	Else
		If Not YxBBs.Execute("select ID from [YX_Faction] where user='"&YxBBs.MyName&"'").eof Then
			Call Alert("您是掌门人，不能退出帮派！退出必需先要解散帮派！")
		Else
			YxBBs.execute("Update [YX_user] Set Faction='',Mark=Mark-1 where name='"&YxBBs.MyName&"'")
			Session(YxBBs.CacheName & "MyInfo") = Empty
		End If
		Call Alert("退出帮派成功")
	End If
End Sub

Sub Del
YxBBs.Fun.CheckMake
	Set Rs=YxBBs.Execute("Select Name,User From[YX_Faction] where ID="&ID)
	If Rs.Eof Then
		Call Alert("不存在这个帮派！")
	ElseIf YxBBs.MyName<>Rs(1) Then
		Call Alert("您不是该帮的帮主无法解散该帮！")
	Else
		YxBBs.Execute("Update [YX_user] set Faction='' where Faction='"&rs(0)&"'")
		YxBBs.Execute("Delete from [YX_Faction] where ID="&ID)
		Session(YxBBs.CacheName & "MyInfo") = Empty
		Call Alert("解散帮派成功！")
	End if
	Rs.Close
End Sub

Sub Look
Dim Content
Set Rs=YxBBs.Execute("Select Name,FullName,Note,User,BuildDate from [YX_Faction] where ID="&ID)
If Rs.eof Then
	Call Alert("不存在此帮派！")
Else
	Content="<tr><td width='24%' align='right' height=25><b>帮派名称：</b></td><td width='74%'>&nbsp;"&YxBBs.Fun.HtmlCode(rs(0))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>帮派全称：</b></td><td>&nbsp;"&YxBBs.Fun.HtmlCode(rs(1))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>帮派宗旨：</b></td><td>&nbsp;"&YxBBs.Fun.HtmlCode(rs(2))&"</td></tr>"&_
	"<tr><td align='right' height=25><b>创建时间：</b></td><td>&nbsp;"&Rs(4)&"</td></tr>"&_
	"<tr><td align='right' height=25><b>帮主名称：</b></td><td>&nbsp;"&Rs(3)&"</td></tr>"&_
	"<tr><td align='right' height=25><b>现有弟子：</b></td><td>"&Desciple(Rs(0))&"</td></tr>"&_
	"<tr><td colspan=2 align='center' height=25><a href='?'>【返回】</a></td></tr>"
	Call YxBBs.ShowTable("帮派信息",Content)
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
	Desciple="<table width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td>&nbsp;"&I&" 名</td><td width='90%'><marquee onmouseover='this.stop()' onmouseout='this.start()' scrollAmount='3' direction='left' width='100%' height='15'>"&Desciple&"</marquee></td></tr></table>"
End Function

Sub Add
Dim Name,FullName,Note,Content
YxBBs.Fun.CheckMake
Name=YxBBs.Fun.GetStr("Name")
FullName=YxBBs.Fun.GetStr("FullName")
Note=YxBBs.Fun.GetStr("Note")
IF Name="" And FullName="" And Note="" Then
	Content="<form  method='post' style='margin:0'>"&_
	"<tr><td colspan=2 height=30 align='center'><font color=red>创建门派的必要条件： 1.您的积分值必须 10 以上！ 2.需要扣除您 3000 的现金作为门派基金！ </font></td></tr>"&_
	"<tr><td align='right' height=25><b>帮派名称：</b></td><td>&nbsp;<input Maxlength=10 Name='Name' size='10'>*最多只能5个汉字</td></tr>"&_
	"<tr><td align='right' height=25><b>帮派全称：</b></td><td>&nbsp;<input size=30 name='FullName'> * </td></tr>"&_
	"<tr><td align='right' height=25><b>帮派宗旨：</b></td><td>&nbsp;<input size=70 name='Note'> * </td></tr>"&_
	"<tr><td colspan=2 height=30 align='center'><input type=submit value=' 创 建 '>&nbsp;&nbsp;&nbsp; <input type=reset value=' 重 填 '></td></tr></form>"
	Call YxBBs.ShowTable("创建帮派",Content)
Else
	IF Name="" or FullName="" or Note="" Then
		Call Alert("帮派要填写的信息你没有填写完整。")
	ElseIF Len(Name)>10 or Len(FullName)>50 Or Len(Note)>200 Then
		Call Alert("字符太多，超过了论坛的限制。")
	ElseIf int(YxBBs.MyMark)<10 then
		Call Alert("您的积分小于 10 ！")
	ElseIf int(YxBBs.MyCoin)<5000 then
		Call Alert("您的现金少于 3000 ！")
	ElseIf Not YxBBs.Execute("Select ID From[YX_Faction] where User='"&YxBBs.MyName&"'").Eof Then
		Call Alert("您已经贵为帮主了，不能再创立帮派！")
	Else
	YxBBs.execute("Insert into[YX_Faction](Name,FullName,[Note],BuildDate,[User])Values('"&Name&"','"&FullName&"','"&Note&"','"&YxBBs.NowBbsTime&"','"&YxBBs.MyName&"')")
	YxBBs.execute("Update [YX_User] Set Coin=Coin-3000,Faction='"&Name&"' where Name='"&YxBBs.MyName&"'")
	Session(YxBBs.CacheName & "MyInfo") = Empty
	Call Alert("您成功的创建了帮派["&Name&"]，您现在是该帮派的掌门人！恭喜您！")
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
	Call Alert("不存在此帮派！")
ElseIf YxBBs.MyName<>Rs(3) Then
	Call Alert("您不是["&Rs(0)&"]的帮主无法修改信息！")
Else
	IF Name="" And FullName="" And Note="" Then
		Set Rs=YxBBs.Execute("Select Name,FullName,Note,User from [YX_Faction] where ID="&ID)
		If Rs.eof Then
			Call Alert("不存在此帮派！")
		ElseIf YxBBs.MyName<>Rs(3) Then
			Call Alert("您不是["&Rs(0)&"]的帮主无法修改信息！")
		Else
			Content="<form  method='post' style='margin:0'>"&_
			"<tr><td colspan=2 height=30 align='center'><font color=red>注意：每次修改帮派信息将扣除您 100 的现金！ </font></td></tr>"&_
			"<tr><td align='right' height=25><b>帮派名称：</b></td><td>&nbsp;<input Maxlength=10 Name='Name' size='10' value='"&Rs(0)&"'>*不要超过5个汉字</td></tr>"&_
			"<tr><td align='right' height=25><b>帮派全称：</b></td><td>&nbsp;<input size=30 name='FullName' value='"&Rs(1)&"'> * </td></tr>"&_
			"<tr><td align='right' height=25><b>帮派宗旨：</b></td><td>&nbsp;<input size=70 name='Note' value='"&Rs(2)&"'> * </td></tr>"&_
			"<tr><td colspan=2 height=30 align='center'><input type=submit value=' 修 改 '>&nbsp;&nbsp;&nbsp; <input type=reset value=' 重 填 '></td></tr></form>"
			Call YxBBs.ShowTable("创建帮派",Content)
		End If
	Else
		IF Name="" or FullName="" or Note="" Then
			Call Alert("帮派要填写的信息你没有填写完整。")
		ElseIf int(YxBBs.MyCoin)<100 then
			Call Alert("对不起，你的现金少于100元，不能整顿帮派。")
		ElseIF Len(Name)>10 or Len(FullName)>50 Or Len(Note)>200 Then
			Call Alert("字符太多，超过了论坛的限制。")
		Else
		YxBBs.execute("Update [YX_Faction]Set Name='"&Name&"',FullName='"&FullName&"',[Note]='"&Note&"' where ID="&ID)
		YxBBs.execute("Update [YX_User] Set Faction='"&Name&"' where Faction='"&Rs(0)&"'")
		YxBBs.execute("Update [YX_User] Set Coin=Coin-100 where Name='"&YxBBs.MyName&"'")
		Session(YxBBs.CacheName & "MyInfo") = Empty
		Call Alert("成功的修改了帮派！")
		End if
	End if
End If
Rs.Close
End Sub
%>