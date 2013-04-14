<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<%
Dim Action,ID
Action=Lcase(Request.QueryString("Action"))
ID=YxBBs.Checknum(Request.QueryString("ID"))
Select Case Action
Case"edit"
	EditPlacard()	
Case"del"
	IF YxBBs.ClassID>3 Then YxBBs.Error("您没有管理公告的权限！")
	IF YxBBs.ClassID=3 Then
		YxBBs.execute("Delete From [YX_Placard] where ID="&ID&" and Name='"&YxBBs.MyName&"'")
	Else
		YxBBs.execute("Delete From [YX_Placard] where ID="&ID&"")
	End IF
	Cache.Name="Placard"
	Cache.clean()
	Response.redirect Request.ServerVariables("HTTP_REFERER")
Case Else
	SayPlacard()
End Select
YxBBs.Footer()
Set YxBBs=Nothing
Sub DelMyPlacard()
	Dim Caption,Content,rs
	Set Rs=YxBBs.execute("select ID,Caption,Content,AddTime,Name,hits from [YX_Placard] where Name='"&YxBBs.MyName&"'")
	IF Not rs.eof Then
		Caption="我发布的公告"
		Do while not Rs.eof
		Content=Content&"<tr><td><a href=javascript: onclick=javascript:window.open('See.Asp?Id="&Rs("ID")&"','open','width=500,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes')>"&YxBBs.Fun.HtmlCode(Rs("caption"))&"</td><td>发表于："&Rs("Addtime")&"<br></td><td><a href='?Action=Edit&ID="&Rs("ID")&"'><img src='Images/Edit.gif' border='0'>修改</a> <a onclick=checkclick('删除这条公告！！\n\n您确定要删除吗？') href='?Action=del&ID="&Rs("ID")&"'><img src='Images/del.gif' border='0'>删除</a></td></tr>"
		Rs.movenext
		Loop
		Call YxBBs.ShowTable(Caption,Content)
	End IF
	Rs.Close
End Sub

Sub EditPlacard()
	Dim Caption,Content,Temp,Rs,TmpBoardID
	IF YxBBs.ClassID>3 Then YxBBs.Error("您没有管理公告的权限！")
	If YxBBs.BoardID>0 Then
		YxBBs.CheckBoard()
	End If
	Call YxBBs.Head("管理公告")
	Caption=YxBBs.Fun.Checkbad(YxBBs.Fun.GetStr("caption"))
	Content=YxBBs.Fun.Checkbad(YxBBs.Fun.GetStr("Content"))
	IF Caption="" And Content="" Then
		Set Rs=YxBBs.execute("select ID,BoardID,Caption,Content,AddTime,Name,hits from [YX_Placard] where ID="&ID&"")
		IF Not rs.eof Then
			Caption="编辑公告"
			Content="<form style='margin: 0' method=POST name=yimxu><tr><td height='30' width='80'>&nbsp;公告标题：</td><td>&nbsp;<input name='ID' type='hidden' value='"&Rs("ID")&"'><input name='Caption' type='text' id='Caption' size='60' Value='"&Rs("Caption")&"'></td></tr>"&_
				"<tr><td height='30'>&nbsp;所在版块：</td><td>&nbsp;"
			Content=Content & "<select name='BoardID'><option value='0'>论坛首页</option>"&YxBBs.BoardIDList(Rs("BoardID"),0)&"</select>"
			Content=Content&"</td></tr><tr><td>&nbsp;公告内容：</td><td><table width='100%'><tr><td><img onClick=Cbold() <img src=""Images/UbbPic/1.gif""  border=0 alt=粗体字> <img src=""Images/UbbPic/2.gif"" onClick=Citalic() border=0 alt=斜体字 > <img src=""Images/UbbPic/3.gif"" onClick=Cunder() border=0 alt=下划线> <img src=""Images/UbbPic/4.gif"" onClick=center() border='0' alt='居中'> <img src=""Images/UbbPic/5.gif"" onClick=fly() border=0 alt=飞行字> <img src=""Images/UbbPic/6.gif"" onClick=move() border=0 alt=移动字> <img src=""Images/UbbPic/7.gif"" onClick=Especial(""[light]"",""[/light]"") border=0 alt=发光字> <img src=""Images/UbbPic/8.gif"" onClick=ying() border=0 alt=阴影字> "&_
			"<img src=""Images/UbbPic/9.gif"" onClick=Curl() border='0' alt='超连接'> <img src=""Images/UbbPic/10.gif"" onClick=Cemail() border='0' alt='Email连接'> <img src=""Images/UbbPic/11.gif"" onClick=showpic() border='0' alt='更多的心情图片'> <img src=""Images/UbbPic/12.gif"" onClick=image() border=0 alt=图片> <img src=""Images/UbbPic/13.gif"" onClick=swf() border=0 alt=Flash动画 > <img onClick=Cwmv()  src=""Images/UbbPic/14.gif"" border=0 alt='Media Player视频文件'> <img src=""Images/UbbPic/15.gif"" onClick=Crm() border=0 alt=realplay视频文件>  <img onClick=Csound() src=""Images/UbbPic/16.gif"" border='0' alt='插入背景音乐'>"&_
			"<TEXTAREA name=content cols=90 rows='8' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();>"&Rs("content")&"</textarea></td></tr></Table></td></tr>"
			Content=Content&"<tr><td height='30' colspan=2 align='center'> <input type='submit' value='确定修改'>&nbsp;<input type='reset' value='取消重置'><div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div></form>"
		Else
			Caption="错误信息":Content="不存在公告记录！"
		End If
	Else
		ID=YxBBs.Fun.GetStr("ID")
		TmpBoardID=YxBBs.Fun.GetStr("BoardID")
		If Caption="" or Content="" Then YxBBs.Error("公告标题和内容都不能为空！")
		IF len(Content)>30720 or Len(Caption)>250 Then YxBBs.Error("公告标题或内容超过了字数限制！")
		Temp=YxBBs.Fun.UbbString(Content)
		YxBBs.execute("update [YX_Placard] Set Caption='"&Caption&"',Content='"&Content&"',AddTime='"&YxBBs.NowBBSTime&"',ubbString='"&Temp&"',BoardID="&TmpBoardID&" where ID="&ID&"")
		Caption="编辑公告"
		Content="<li>公告修改成功！<li><a href=placard.Asp>继续管理公告</a> <li><a href=Default.Asp>返回论坛首页</a> "
		IF YxBBs.BoardID>0 Then Content=Content&"<li><a href=List.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.BoardName&"</a>"
		Content="<div style='margin:15;line-height: 150%'>"&Content&"</div>"
	End If
	Cache.Name="Placard"
	Cache.clean()
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub SayPlacard()
	Dim Caption,Content,Temp,TmpBoardID
	IF YxBBs.ClassID>3 Then YxBBs.Error("您没有管理公告的权限！")
	If YxBBs.BoardID>0 Then YxBBs.CheckBoard()
	IF YxBBs.ClassID=3 And YxBBs.IsBoardAdmin=False Then YxBBs.Error("您没有管理公告的权限！")
	Call YxBBs.Head("发布公告")
	Caption=YxBBs.Fun.Checkbad(YxBBs.Fun.GetStr("caption"))
	Content=YxBBs.Fun.Checkbad(YxBBs.Fun.GetStr("Content"))
	IF Caption="" And Content="" Then
		Caption="发布公告"
		Content="<form style='margin: 0' method=POST name=yimxu><tr><td height='30'>&nbsp;&nbsp;公告标题：</td><td>&nbsp;<input name='Caption' type='text' id='Caption' size='60'></td></tr>"&_
		"<tr><td height='30'>&nbsp;&nbsp;所在版块：</td><td>&nbsp;"
		IF YxBBs.ClassID=3 Then
			Content=Content&YxBBs.BoardName&"<input name='BoardID' value='"&YxBBs.BoardID&"' type='hidden'>"
		Else
			Content=Content & "<select name='BoardID'><option value='0'>论坛首页</option>"&YxBBs.BoardIDList(YxBBs.BoardID,0)&"</select>"
		End If
		Content=Content&"</td></tr><tr><td >&nbsp;&nbsp;公告内容：</td><td><table width='100%'><tr><td><img onClick=Cbold() <img src=""Images/UbbPic/1.gif""  border=0 alt=粗体字> <img src=""Images/UbbPic/2.gif"" onClick=Citalic() border=0 alt=斜体字 > <img src=""Images/UbbPic/3.gif"" onClick=Cunder() border=0 alt=下划线> <img src=""Images/UbbPic/4.gif"" onClick=center() border='0' alt='居中'> <img src=""Images/UbbPic/5.gif"" onClick=fly() border=0 alt=飞行字> <img src=""Images/UbbPic/6.gif"" onClick=move() border=0 alt=移动字> <img src=""Images/UbbPic/7.gif"" onClick=Especial(""[light]"",""[/light]"") border=0 alt=发光字> <img src=""Images/UbbPic/8.gif"" onClick=ying() border=0 alt=阴影字> "&_
		"<img src=""Images/UbbPic/9.gif"" onClick=Curl() border='0' alt='超连接'> <img src=""Images/UbbPic/10.gif"" onClick=Cemail() border='0' alt='Email连接'> <img src=""Images/UbbPic/11.gif"" onClick=showpic() border='0' alt='更多的心情图片'> <img src=""Images/UbbPic/12.gif"" onClick=image() border=0 alt=图片> <img src=""Images/UbbPic/13.gif"" onClick=swf() border=0 alt=Flash动画 > <img onClick=Cwmv()  src=""Images/UbbPic/14.gif"" border=0 alt='Media Player视频文件'> <img src=""Images/UbbPic/15.gif"" onClick=Crm() border=0 alt=realplay视频文件>  <img onClick=Csound() src=""Images/UbbPic/16.gif"" border='0' alt='插入背景音乐'>"&_
		"<TEXTAREA name=content  cols=90 rows='8' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();></textarea></td></tr></Table></td></tr>"
		Content=Content&"<tr><td  height='30' colspan=2 align='center'> <input type='submit' value='确定发布'>&nbsp;<input type='reset' value='取消重写'><div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div></form>"
		Call YxBBs.ShowTable(Caption,Content)
		If YxBBs.ClassID<=2 Then AdminPlacard() Else DelmyPlacard()
	Else
		If Caption="" or Content="" Then YxBBs.Error("公告标题和内容都不能为空！")
		TmpBoardID=YxBBs.Fun.GetStr("BoardID")
		IF len(Content)>30720 or Len(Caption)>250 Then YxBBs.Error("公告标题或内容都不能为空！")
		Temp=YxBBs.Fun.UbbString(Content)
		YxBBs.execute("insert into[YX_Placard](Caption,Content,AddTime,Name,BoardID,UbbString)values('"&Caption&"','"&Content&"','"&YxBBs.NowBbsTime&"','"&YxBBs.MyName&"',"&TmpBoardID&",'"&Temp&"')")
		Caption="发布公告"
		Content="<li>公告发布成功！ <li><a href=Default.Asp>返回首页</a>"
		IF YxBBs.BoardID>0 Then Content=Content&"<li><a href=List.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.BoardName&"</a>"
		Content="<div style='margin:15;line-height: 150%'>"&Content&"</div>"
		Cache.Name="Placard"
		Cache.clean()
		Call YxBBs.ShowTable(Caption,Content)
	End If
End Sub

Function GetBoardName(Ast)
	Dim i
	If IsArray(YxBBs.Board_Rs) Then
		For i=0 To Ubound(YxBBs.Board_Rs,2)
		IF YxBBs.Board_Rs(1,i)=Ast Then
			GetBoardName=YxBBs.Board_Rs(3,i)
			Exit For
		End IF
		Next
	End If
	If GetBoardName="" Then GetBoardName="首页"
End Function

Sub AdminPlacard()
	Dim Pages,Page,arr_Rs,i,Temp,Content,PageInfo
	Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	Temp=Replace(Temp,"{标题}","公告列表" )
	Response.Write Temp
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_Placard]"
	pages.strPageUrl = "?Action="&Action
	pages.strFieldsList = "ID,Caption,BoardID,Name,AddTime,hits"
	'pages.strCondiction = ""
	pages.strPrimaryKey ="ID"
	pages.strOrderList = "BoardID,ID desc"
	pages.intPageSize = 30
	pages.intPageNow = Page
	pages.strCookiesName = "Placard_List"'客户端记录总数
	pages.Reloadtime=3'每三分钟更新Cookies
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Content="<tr bgcolor='#E4E4E4'><td width='35%' align='center' height=25 bgcolor='#E4E4E4'><b>公告标题</b></td><td width='15%' align='center'><b>所在版块</b></td><td width='10%' align='center'><b>作者</b></td><td width='20%' align='center'><b>时间</b></td><td width='20%' align='center'><b>管理</b></td></tr>"
	If IsArray(Arr_Rs) Then
		For i = 0 to UBound(Arr_Rs, 2)
		Content=Content&"<tr><td height=25>&nbsp;<a href=javascript: onclick=javascript:window.open('See.Asp?Action=placard&ID="&Arr_Rs(0,i)&"','','width=500,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes')>"&YxBBs.Fun.HtmlCode(Arr_Rs(1,i))&"</td><td align='center'>"&GetBoardName(Arr_Rs(2,i))&"</td><td align='center'>"&Arr_Rs(3,i)&"</td><td align='center'>"&Arr_Rs(4,i)&"</td><td align='center'><a href='?Action=Edit&ID="&Arr_Rs(0,i)&"'><img src='Images/Edit.gif' border='0'>修改</a> <a onclick=checkclick('删除这条公告！！\n\n您确定要删除吗？') href='?Action=del&ID="&Arr_Rs(0,i)&"'><img src='Images/del.gif' border='0'>删除</a></td></tr>"
		Next
	End If
	Response.Write Content
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}",PageInfo)
	Response.Write Temp
End Sub
%>
<SCRIPT src="inc/Fun.js"></SCRIPT>