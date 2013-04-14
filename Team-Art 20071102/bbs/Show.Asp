<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/ubb_Cls.Asp"-->
<!--#include file="Inc/page_Cls.Asp"-->
<%
Dim TopicCaption,TopicUserName,TopicTopType,TopicIsGood,TopicIsLock,TopicIsVote,TopicHits,TopicReplyNum
Dim YxBBs_ubb,Page,PageString,PageInfo,ID,UserName,BBSID
ID=YxBBs.CheckNum(Request.QueryString("ID"))
Call GetTopicInfo()
Call ShowListTop()
If TopicIsVote Then ShowVote()
Set YxBBs_ubb=New YxBBsubb_Cls
Call ShowBBS()
Set YxBBs_ubb=Nothing
ShowListBottom()
FastReply()
YxBBs.Footer()
YxBBs.Execute("UPDATE [YX_Topic] SET Hits=Hits+1 WHERE TopicID="&ID&"")
Set YxBBs=Nothing
	
Sub GetTopicInfo()
	Dim Rs,Arr_Rs
	Set Rs=YxBBs.Execute("Select TopicID,Caption,Name,TopType,IsGood,IsLock,isVote,Hits,ReplyNum,Face,AddTime,SqlTableID,BoardID From [YX_Topic] where TopicID="&ID&" and IsDel=False")
	IF Rs.eof then YxBBs.Error("该帖子不存在或已经删除！")
	Arr_Rs=Rs.GetRows(1)
	Rs.Close
	Set Rs=Nothing
	TopicCaption=YxBBs.Fun.HtmlCode(Arr_Rs(1,0))
	TopicUserName=Arr_Rs(2,0)
	TopicTopType=Arr_Rs(3,0)
	TopicIsGood=Arr_Rs(4,0)
	TopicIsLock=Arr_Rs(5,0)
	TopicIsVote=Arr_Rs(6,0)
	TopicHits=Arr_Rs(7,0)
	TopicReplyNum=Arr_Rs(8,0)
	YxBBs.TB=Arr_Rs(11,0)
	YxBBs.BoardID=Arr_Rs(12,0)
	YxBBs.CheckBoard()
	YxBBs.Head(Arr_Rs(1,0))
	Response.Write("<script src='Inc/Fun.js'></script>")
	If YxBBs.MyName<>TopicUserName Then
		If Cint(YxBBs.ClassSetting(1))=0 Then YxBBs.Error("您没有查看别人帖子的权限！")
		If TopicIsGood Then If Cint(YxBBs.ClassSetting(2))=0 Then YxBBs.Error("您没有浏览精华帖子的权限！")
	End If
	IF TopicIsGood Then If YxBBs.BBSSetting(34)="1" And Not YxBBs.FoundUser Then YxBBs.Error("您没有浏览精华帖子的权限！")
End Sub

Function TopicMood()
	Dim Temp,TopicImg
	TopicImg=Split(YxBBs.Template.ReadTemplate("帖子状态图片"),"|")
	IF TopicIsGood Then Temp="<td>"&TopicImg(3)&" <font color=red>精华帖子</font></td>"
	IF TopicIsVote then Temp=Temp&"<td>"&TopicImg(4)&" <font color=red>投票帖子</font></td>"
	IF TopicIsLock then Temp=Temp&"<td>"&TopicImg(7)&" <font color=red>此帖被锁</font></td>"
	IF TopicTopType=3 then Temp=Temp&"<td>"&TopicImg(2)&" <font color=red>置顶帖子</font></td>"
	IF TopicTopType=4 then Temp=Temp&"<td>"&TopicImg(1)&" <font color=red>区置顶帖子</font></td>"
	IF TopicTopType=5 then Temp=Temp&"<td>"&TopicImg(0)&" <font color=red>总置顶帖子</font></td>"
	IF Temp<>"" Then Temp="<Div  align='right'><table border=1 style='border-collapse: collapse' cellpadding='5' cellspacing='0' bordercolor=#DEDEDE bgcolor=ffffff><tr>"&Temp&"</tr></table></div>"
	TopicMood=Temp
End Function

Function ShowListTop()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("帖子顶部")
	Temp=Replace(Temp,"{发帖按钮}",SayBar())
	Temp=Replace(Temp,"{点击数}",TopicHits+1)
	Temp=Replace(Temp,"{标题}",TopicCaption)
        Temp=Replace(Temp,"{管理}",SetTopic())
	Response.Write(Temp)
End Function

Function ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("帖子底部")
	Temp=Replace(Temp,"{分页}",PageInfo)
	Response.Write(Temp)
End Function

Function SayBar()
	Dim Temp,PostPic
	PostPic=Split(YxBBs.Template.ReadTemplate("发帖图片"),"||")
	Temp="<a href='Say.Asp?BoardID="&YxBBs.BoardID&"'>"&PostPic(0)&"</a> <a href='Say.Asp?action=vote&BoardID="&YxBBs.BoardID&"'>"&PostPic(1)&"</a>"
	If Not TopicIsLock or YxBBs.ClassID=1 Then
		Temp=Temp&" <a href='Say.Asp?Action=Reply&BoardID="&YxBBs.BoardID&"&ID="&ID&"'>"&PostPic(2)&"</a>"
	End If
	SayBar=Temp
End Function

Function ShowVote()
	Dim Temp,Rs,Arr_Rs,Vote,VoteNum,AllvoteNum,VotePicW,Opt,ClueTxt,CanVote,ii,VoteShow,i
	Set Rs=YxBBs.Execute("Select TopicID,Vote,VoteNum,VoteType,OutTime From [YX_TopicVote] where TopicID="&ID&"")
	If Rs.Eof then Exit Function
	Arr_Rs=Rs.GetRows(1)
	Rs.Close:Set Rs=Nothing
	Vote=Split(Arr_Rs(1,0),"|")
	VoteNum=split(Arr_Rs(2,0),"|")
	CanVote=True
	If Not YxBBs.FoundUser Then
		ClueTxt="你还没有登陆，不能进行投票。"
		CanVote=False
	Else
		IF not YxBBs.Execute("Select User From [YX_TopicVoteUser] where User='"&YxBBs.MyName&"' and TopicID="&ID&"").eof then
			ClueTxt="你已经投过票了，不能再投票了。[<a style='cursor:hand;color:red;' onclick=javascript:window.open('See.Asp?Action=Vote&Id="&Arr_Rs(0,0)&"','open','width=550,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes')>详情</a>]"
			CanVote=False
		End If
	End If
	For i=1 to ubound(Vote)
		AllvoteNum=Int(AllvoteNum+VoteNum(i))
	Next
	IF AllVoteNum=0 then AllvoteNum=1
	For i=1 To ubound(Vote)
		ii=ii+1
		VotePicW=VoteNum(i)/AllvoteNum*85
		If CanVote Then
			IF Int(Arr_Rs(3,0))=1 then Opt="<input type=radio value='"&i&"' name='opt'>" Else Opt="<input type=checkbox name='opt"&i&"' value='"&i&"'>"
		End If
		IF ii>6 Then ii=1
		VoteShow=VoteShow&"<tr><td width='5%' height=25 >&nbsp;"&i&"</td><td width='40%'>&nbsp;"&Opt&""&YxBBs.Fun.HtmlCode(Vote(i))&"</td><td width='35%' >&nbsp;<img border=0 height=8 width=2 src=Images/line.gif><img border=0 height=8 width='"&VotePicW&"%' src='Images/hr"&ii&".gif'> <b>"&VoteNum(i)&"</b> 票</td></tr>"
	Next
	If DateDiff("s",YxBBs.NowBbsTime,Arr_Rs(4,0))<0 then
		ClueTxt="该投票已经过期，不能进行投票。"
		CanVote=False
	End If
	IF CanVote then
		ClueTxt="<input type='submit' value='投 票 (投票后方能看详尽结果)'>"
	End IF
	ClueTxt=ClueTxt&" [ 截止时间："&Arr_Rs(4,0)&" ]"
	Temp=YxBBs.Template.ReadTemplate("显示投票")
	Temp=Replace(Temp,"{投票选项}","<form style='margin:0' method=POST action=VoteSubmit.Asp?Action=Vote&id="&ID&"&type="&Arr_Rs(3,0)&">"&VoteShow)
	Temp=Replace(Temp,"{投票信息}",ClueTxt&"</form>")
	Response.Write(Temp)
End Function

Function ShowBBS()
	Dim arr_Rs,i,pages
	Dim Template,TempLink,TempUserL,Temp,TempStr,Lou,Sign,ShowCaption,ShowMood,Arr_Ip
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_Bbs"&YxBBs.TB&"] As B inner join [YX_User] As U on B.Name=U.Name"
	pages.strPageUrl = "?BoardID="&YxBBs.BoardID&"&ID="&ID&"&TB="&YxBBs.TB
	pages.strFieldsList = "B.BbsID,B.TopicID,B.Face,B.Caption,B.Content,B.Name,B.AddTime,B.BoardID,B.UbbString,B.IP,U.Id,U.Name,U.IsQQpic,U.QQ,U.Pic,U.Picw,U.Pich,U.GradeNum,U.GradeName,U.GradePic,U.EssayNum,U.Mail,U.Home,U.Sex,U.Mark,U.Coin,U.Sign,U.Regtime,U.IsShow,U.IsDel,U.IsSign,U.RegIp,U.LoginNum,U.Honor,U.Faction,U.TimeSum"
	pages.strCondiction = "B.isDel=False and (B.TopicID="&ID&" or B.ReplyTopicID="&ID&")"
	pages.strOrderList = "B.BbsID"
	pages.strPrimaryKey = "BbsID"
	Pages.CountSQL=TopicReplyNum+1
	'Pages.CountSQL=YxBBs.Execute("SELECT Count(ID) FROM [YX_Bbs"&YxBBs.TB&"] where (TopicID="&ID&" or ReplyTopicID="&ID&") and isDel=False")(0)
	pages.intPageSize = 10
	pages.intPageNow = Page
	pages.strCookiesName = "Show_"&ID
	pages.Reloadtime=0
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Template=YxBBs.Template.ReadTemplate("帖子信息")
	TempLink=Split(YxBBs.Template.ReadTemplate("帖子信息链接"),"||")
	
	If IsArray(Arr_Rs) Then
		Lou = (Page-1)*10
		For i = 0 to UBound(Arr_Rs,2)
			UserName=Arr_Rs(11,i)
			BBSID=Arr_Rs(0,i)
			YxBBs_ubb.UbbString=Arr_Rs(8,i)
			Temp=Replace(Template,"{信息}",TempLink(0))
			Temp=Replace(Temp,"{短信}",TempLink(1))
			If YxBBs.Fun.GetSqlStr(Arr_Rs(13,i))<>"" Then
				Temp=Replace(Temp,"{QQ}",Replace(TempLink(2),"{QQ}",YxBBs.Fun.GetSqlStr(Arr_Rs(13,i))))
			Else
				Temp=Replace(Temp,"{QQ}","")
			End If
			
			If YxBBs.Fun.GetSqlStr(Arr_Rs(21,i))<>"" Then
				Temp=Replace(Temp,"{邮箱}",Replace(TempLink(3),"{邮箱}",YxBBs.Fun.GetSqlStr(Arr_Rs(21,i))))
			Else
				Temp=Replace(Temp,"{邮箱}","")
			End If
			If YxBBs.Fun.GetSqlStr(Arr_Rs(22,i))<>"" Then
				Temp=Replace(Temp,"{主页}",Replace(TempLink(4),"{主页}",YxBBs.Fun.GetSqlStr(Arr_Rs(22,i))))
			Else
				Temp=Replace(Temp,"{主页}","")
			End If
			Temp=Replace(Temp,"{编辑}",TempLink(5))
			Temp=Replace(Temp,"{引用}",TempLink(6))
			If Arr_Rs(1,i)=ID Then
				Temp=Replace(Temp,"{删除}","")
				Temp=Replace(Temp,"{楼号}","楼 主")
				ShowCaption=TopicCaption
				ShowMood=TopicMood()
			Else
				ShowCaption="":ShowMood=""
				Temp=Replace(Temp,"{楼号}","第 <font color=#FF0000>"&Lou+i&"</font> 楼")
				Temp=Replace(Temp,"{删除}",TempLink(7))
			End If
			Temp=Replace(Temp,"{数据表ID}",YxBBs.TB)
			Temp=Replace(Temp,"{版块ID}",YxBBs.BoardID)
			Temp=Replace(Temp,"{主题ID}",ID)
			Temp=Replace(Temp,"{页次}",page)
			Temp=Replace(Temp,"{帖子ID}",Arr_Rs(0,i))
			Temp=Replace(Temp,"{用户名称}",Arr_Rs(11,i))
			Temp=Replace(Temp,"{发帖时间}",Arr_Rs(6,i))
			IF YxBBs.ClassID>2 then
				Temp=Replace(Temp,"{用户IP}",YxBBs.Fun.GetIp(Arr_Rs(9,i),2))
			Else
				Temp=Replace(Temp,"{用户IP}",YxBBs.Fun.GetSqlStr(Arr_Rs(9,i)))
			End If
			Temp=Replace(Temp,"{积分数}",YxBBs.Fun.GetSqlStr(Arr_Rs(24,i)))
			Temp=Replace(Temp,"{金钱数}",YxBBs.Fun.GetSqlStr(Arr_Rs(25,i)))
			Temp=Replace(Temp,"{等级图片}","<img src='"&Arr_Rs(19,i)&"' alt="&Arr_Rs(18,i)&" Align=center>")
			Temp=Replace(Temp,"{等级名称}","<b>"&Arr_Rs(18,i)&"</b>")
			If Arr_Rs(33,i)<>"" Then
				Temp=Replace(Temp,"{头衔}","头衔："&YxBBs.Fun.GetSqlStr(Arr_Rs(33,i))&"<br>")
			Else
				Temp=Replace(Temp,"{头衔}","头衔：未定义<br>")
			End If
			If Arr_Rs(34,i)<>"" Then
				Temp=Replace(Temp,"{帮派}","帮派："&YxBBs.Fun.GetSqlStr(Arr_Rs(34,i))&"<br>")
			Else
				Temp=Replace(Temp,"{帮派}","帮派：未定义<br>")
			End If
			If IsOnline(Arr_Rs(11,i)) Then
				If Arr_Rs(23,i) Then
					Temp=Replace(Temp,"{性别}","<img src='Images/11.gif' alt='性别：男<br>状态：在线<br>积时：" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				Else
					Temp=Replace(Temp,"{性别}","<img src='Images/01.gif' alt='性别：女<br>状态：在线<br>积时：" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				End If
			Else
				If Arr_Rs(23,i) Then
					Temp=Replace(Temp,"{性别}","<img src='Images/10.gif' alt='性别：男<br>状态：离线<br>积时：" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				Else
					Temp=Replace(Temp,"{性别}","<img src='Images/00.gif' alt='性别：女<br>状态：离线<br>积时：" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				End If
			End If
			Temp=Replace(Temp,"{帖数}",Arr_Rs(20,i))
			Temp=Replace(Temp,"{注册时间}",formatdatetime(Arr_Rs(27,i),2))
			IF Arr_Rs(12,i) then
				Temp=Replace(Temp,"{用户头像}","<img src='http://qqshow-user.tencent.com/"&Arr_Rs(13,i)&"/10/'>")
			else
				Temp=Replace(Temp,"{用户头像}","<img border='0' src='"&Arr_Rs(14,i)&"' width="&Arr_Rs(15,i)&" height="&Arr_Rs(16,i)&">")
			End If
			Sign=Arr_Rs(26,i)
			IF Arr_Rs(28,i) then
				Temp=Replace(Temp,"{帖子内容}","<Hr Size=1><Font Color=red>该用户帖子已被管理员屏蔽，请和管理员联系</Font><Hr Size=1>")
				Temp=Replace(Temp,"{签名}","【签名档被已管理员屏蔽】")
			Else
				IF YxBBs.BBSSetting(12)="1" then Sign="" 
				IF Arr_Rs(30,i) Then Sign="【签名档已被管理员屏蔽】"
				IF isNull(sign) or sign="" then
					Temp=Replace(Temp,"{签名}",YxBBs.BBSName&"欢迎您！")
				Else
					Temp=Replace(Temp,"{签名}",YxBBs_ubb.Sign_Code(Sign))
				End IF
				Temp=Replace(Temp,"{帖子内容}",ShowMood&"<SPAN style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all;width:100%'><img src='Images/face/"&Arr_rs(2,i)&".gif'> <b>"&ShowCaption&"</b><br><br>"&YxBBs_ubb.UBB(Arr_Rs(4,i),1)&"</SPAN>")
			End IF
			TempStr=TempStr&Temp
		Next
		Response.Write(TempStr)
	End If
End Function

Function IsOnline(TUserName)
	Dim Temp,Rs,Ary_Rs,i
	IsOnline=false
 		Cache.Name="UserOnline"
	If Cache.valid Then
	   Temp=Cache.Value
	Else
		Set Rs=YxBBs.Execute("Select Name From [YX_online] where ClassID<>6")
		If Rs.Eof Or Rs.Bof Then Exit Function
		Ary_Rs=Rs.GetRows(-1)
		Rs.Close
		For i=0 To Ubound(Ary_Rs,2)
			Temp=Temp & Ary_Rs(0,i)&","
		Next
		Temp=","&Temp
		Cache.add Temp,dateadd("n",5,YxBBs.NowBBSTime)'5分钟
	End If
	If InStr(Lcase(Temp),","&Lcase(TUserName)&",")>0 Then IsOnline=true
End Function

Function SetTopic()
	Dim Temp,Url
	If Not YxBBs.FoundUser Then Exit Function
	Url="admin.Asp?BoardID="&YxBBs.BoardID&"&ID="&ID&"&TB="&YxBBs.TB&"&Action="
        
	IF TopicTopType=5 then Temp="<div class=menuitems><a href="&Url&"取消总置顶>取消总置顶</a></div>" Else Temp="<div class=menuitems><a href="&Url&"总置顶>设为总置顶</a></div>"
	IF TopicTopType=4 Then Temp=Temp&"<div class=menuitems><a href="&Url&"取消区置顶>取消区置顶</a></div>" ELse Temp=Temp&"<div class=menuitems><a href="&Url&"区置顶>设为区置顶</a></div>"
	IF TopicTopType=3 Then Temp=Temp&"<div class=menuitems><a href="&Url&"取消置顶>取消置顶</a></div>" ELse Temp=Temp&"<div class=menuitems><a href="&Url&"置顶>设为置顶</a></div>"
	IF TopicIsGood Then Temp=Temp&"<div class=menuitems><a href="&Url&"取消精华>取消精华</a></div>" Else Temp=Temp&"<div class=menuitems><a href="&Url&"精华>设为精华</a></div>"
	IF TopicIsLock Then Temp=Temp&"<div class=menuitems><a href="&Url&"解锁>解除锁定</a></div>" Else Temp=Temp&"<div class=menuitems><a href="&Url&"锁定>锁定主题</a></div>"
	Temp=Temp&"<div class=menuitems><a href="&Url&"删除主题>删除主题</a></div><div class=menuitems><a href="&Url&"移动>移动主题</a></div><div class=menuitems><a href="&Url&"提升>提升主题</a></div>"
       Temp="<a onmouseover=""showmenu(event,'"&Temp&"')""><font color=blue>主题管理</font></a>"
	SetTopic=Temp
End Function

Function FastReply()
	If Not YxBBs.FoundUser Then Exit Function
	IF Not TopicIsLock Or YxBBs.ClassID=1 then
		Dim Caption,Content
		Caption="快速回复【<a href='Say.Asp?action=reply&BoardID="&YxBBs.BoardID&"&id="&ID&"'>高级回复</a>】"
		Content="<div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div>"&_
		"<form style='margin: 8;' method='POST' name='yimxu' onsubmit='if(content.value==""""){alert(""您还没有填写帖子内容!"");content.focus();return (false);};"
		If Cint(YxBBs.BoardSetting(0))=1 then Content=Content&"if(CheckCode.value==""""){alert(""请填写验证码！"");CheckCode.focus();return (false);};"
		Content=Content&"BtnPost.disabled = true;' action='Save.Asp?action=Reply&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&ID="&ID&"&page="&Page&"'><table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' width='100%'></td></tr><tr><td width='24%' valign='top'><table width='100%' border='0' cellpadding='5' cellspacing='0'><tr><td align='center'><img onClick=Cbold() src='Images/UbbPic/1.gif' border=0 alt=粗体字> <img onClick=Cwmv() src=Images/UbbPic/14.gif border=0 alt='Media Player视频文件'> <img onClick=swf() src=Images/UbbPic/13.gif border=0 alt=Flash动画 > <img onClick=image() src='Images/UbbPic/12.gif' border=0 alt=图片> <img onClick=showpic() src='Images/UbbPic/11.gif' border='0' alt='心情图片'></td>"&_
		"</tr><tr><td align='center'><img src='Images/butreply.gif' onClick=Especial('[reply]','[/reply]')> <img src='Images/butlogin.gif' onClick=Especial('[LOGIN]','[/LOGIN]')></td></tr>"&_
		"<tr><td align='center'><img src='Images/butgrade.gif' width='60' height='22' onClick=Grade()> <img src='Images/butcode.gif' onClick=Code()></td></tr></table>"&_
		"</td><td width='71%' valign='top'><input type=hidden name='caption' value='Re:"&TopicCaption&"'><textarea onkeydown=presskey(); rows=6 name=content Style='width:100%'></textarea><p style='margin-top: 10; margin-bottom: 0'>"
		IF Cint(YxBBs.BoardSetting(0))=1 then Content=Content&"验证码：<input type=text name='CheckCode' size=8><img align='absmiddle' src=Inc/code.Asp> "
		Content=Content&"<input type=submit value='回复帖子' ID='BtnPost'> <input type=button value='预 览' onclick=openwin()> <input type='reset' value='重 写'> 快捷键 Ctrl+Enter </p></td><td width='5%' valign='top'><input type='button' style='BACKGROUND: url(Images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(Images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td></tr></table></form><form  style='margin:0;' name=preview action=See.Asp?Action=preview method=post target=preview><input type=hidden name=caption value=><input type=hidden name=content value=''></form>"
	Call YxBBs.ShowTable(Caption,Content)
	END IF
End Function
%>