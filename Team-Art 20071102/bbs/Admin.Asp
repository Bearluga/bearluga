<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Caption,Content,Rs,ID,Url,Action,SetUserName,GoToUrl
YxBBs.Fun.CheckMake()
ID=YxBBs.Checknum(Request.QueryString("ID"))
Action=lcase(Request.QueryString("Action"))
If YxBBs.BoardID=0 or ID=0  Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数。")
If YxBBs.Execute("Select ID From[YX_user]where Name='"&YxBBs.MyName&"' And PassWord='"&YxBBs.MyPwd&"' And Isdel=False").Eof Then
	YxBBs.MakeCookiesEmpty()
	YxBBs.Error("该用户不存在或者已经被删除！")
End IF
YxBBs.CheckBoard()

Set Rs=YxBBs.Execute("Select Name,BoardID From[YX_topic] Where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	IF Not Rs.eof Then
		SetUserName=Rs("Name")
		YxBBs.BoardID=Rs("BoardID")
		Rs.Close
	Else
		YxBBs.Error("该帖子不存在或已经删除！")
	End IF
URl="Show.Asp?ID="&ID
GoToUrl=True
Call YxBBs.Head("管理帖子")
Select Case Action
Case"精华"
	If Cint(YxBBs.ClassSetting(19))=0 Then YxBBs.Error("您没有操作精华帖子权限！")
	Set Rs=YxBBs.Execute("Select IsGood,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0) Then
			YxBBs.Error("该主题帖子已经是精华帖子了！")
		ELse
			YxBBs.Execute("update [YX_Topic] set IsGood=True where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.Execute("update [YX_User] set Coin=Coin+"&YxBBs.BBSSetting(39)&",Mark=Mark+"&YxBBs.BBSSetting(40)&",GoodNum=GoodNum+1 where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为精华，主题ID："&ID,Rs(1),0
		End If
	End If
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">设定为精华帖子成功!3秒后返回主题!"
	Rs.Close
	Call Show()
Case"取消精华"
	If Cint(YxBBs.ClassSetting(19))=0 Then YxBBs.Error("您没有操作精华帖子权限！")
	Set Rs=YxBBs.Execute("Select IsGood,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Not Rs(0) Then
			YxBBs.Error("该主题帖子不是精华帖子！")
		ELse
			YxBBs.Execute("update [YX_Topic] set IsGood=False where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_User] set Coin=Coin-"&YxBBs.BBSSetting(41)&",Mark=Mark-"&YxBBs.BBSSetting(42)&",GoodNum=GoodNum-1 where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消精华，主题ID："&ID,Rs(1),0
		End If
	End If
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">取消帖子精华成功!3秒后返回主题!"
	Rs.Close
	Call Show()
Case"置顶"
	If Cint(YxBBs.ClassSetting(16))=0 Then YxBBs.Error("您没有置顶主题的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶帖！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶帖！")
		ElseIF Rs(0)=3 Then
			YxBBs.Error("该主题帖子已经被置顶了！")	
		Else
			YxBBs.Execute("update [YX_Topic] Set TopType=3 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_User] set Coin=Coin+"&YxBBs.BBSSetting(43)&",Mark=Mark+"&YxBBs.BBSSetting(44)&" Where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将主题设为置顶帖子!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"取消置顶"
	If Cint(YxBBs.ClassSetting(16))=0 Then YxBBs.Error("您没有操作置顶主题的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶帖！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶帖！")
		ElseIF Rs(0)<>3 Then
			YxBBs.Error("该主题已经不是置顶帖！")
		Else
			YxBBs.Execute("update [YX_Topic] Set TopType=0 where TopicId="&ID&" ")
			YxBBs.execute("update [YX_User] set Coin=Coin-"&YxBBs.BBSSetting(45)&",Mark=Mark-"&YxBBs.BBSSetting(46)&" Where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的置顶!3秒后返回主题!"
	End If
	Set Rs=Nothing
	Call Show()
Case"总置顶"
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理总置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] Set TopType=5 where TopicID="&id&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] Set Coin=Coin+"&YxBBs.BBSSetting(51)&",Mark=Mark+"&YxBBs.BBSSetting(52)&" where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为总置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将帖子设置为总置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"取消总置顶"
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理总置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=5)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)<>5 Then
			YxBBs.Error("该帖子不是总置顶主题！")
		Else
		YxBBs.execute("update [YX_Topic] set TopType=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
		YxBBs.execute("update [YX_user] set Coin=Coin-"&YxBBs.BBSSetting(53)&",Mark=Mark-"&YxBBs.BBSSetting(54)&" where name='"&SetUserName&"'")
		YxBBs.InLog "将主题《"&Rs(2)&"》取消总置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的总置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"区置顶"
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("您没有管理区置顶帖子的权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=4)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)=5 Then
			YxBBs.Error("该帖子已经是总置顶主题！")
		ElseIf Rs(0)=4 Then
			YxBBs.Error("该帖子已经是区置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] Set TopType=4 where TopicID="&id&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] Set Coin=Coin+"&YxBBs.BBSSetting(47)&",Mark=Mark+"&YxBBs.BBSSetting(48)&" where Name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》设为区置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功将帖子设置为区置顶!3秒后返回主题!"
	End If
	Rs.Close	
	Call Show()
Case"取消区置顶"
	If Cint(YxBBs.ClassSetting(17))=0 Then YxBBs.Error("对不起，您没有管理权限！")
	IF YxBBs.ClassID>2 Then YxBBs.Error("对不起，您没有管理权限！")
	Set Rs=YxBBs.execute("Select TopType,Name,Caption From[YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" or TopType=4)")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0)<>4 Then
			YxBBs.Error("该帖子不是区置顶主题！")
		Else
			YxBBs.execute("update [YX_Topic] set TopType=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_user] set Coin=Coin-"&YxBBs.BBSSetting(49)&",Mark=Mark-"&YxBBs.BBSSetting(50)&" where name='"&SetUserName&"'")
			YxBBs.InLog "将主题《"&Rs(2)&"》取消区置顶，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">成功的取消帖子的区置顶!3秒后返回主题!"
	End If
	Rs.Close
	Call Show()
Case"锁定"
	If Cint(YxBBs.ClassSetting(20))=0 Then YxBBs.Error("您没有锁定主题的权限！")
	Set Rs=YxBBs.execute("Select IsLock,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Rs(0) Then
			YxBBs.Error("该主题帖子已经被锁定！")
		Else
			YxBBs.execute("update [YX_Topic] set IsLock=True where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.InLog "将主题《"&Rs(2)&"》锁定，主题ID："&ID,Rs(1),0
		End If
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题已经锁定成功!3秒后返回主题!"
	End If
	Rs.Close			
	Call Show()
Case"解锁"
	If Cint(YxBBs.ClassSetting(20))=0 Then YxBBs.Error("您没有解除锁定的权限！")
	Set Rs=YxBBs.execute("Select Islock,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			YxBBs.Error("该帖子没有被锁定！")
		Else
			YxBBs.execute("update [YX_Topic] set IsLock=False where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.InLog "将主题《"&Rs(2)&"》解除锁定，主题ID："&ID,Rs(1),0
		End IF
		Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">解除主题锁定成功!3秒后返回主题!"
	End if
	Rs.Close	
	Call Show()

Case"删除主题"
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除主题的权限！")
Set Rs=YxBBs.execute("Select IsDel,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
End If
	Caption="删除主题"
	Content="<form method=POST name='move' action='?BoardID="&YxBBs.BoardID&"&ID="&ID&"&TB="&YxBBs.TB&"&Action=删除主题1'> <input type=submit value=' 确定删除 '> <br><br>是否用留言通知帖子的作者：<input name='issms' onclick='if(sms.disabled==true){sms.disabled=false;sms.value=""通知：您的帖子《"&Rs(2)&"》被管理员("&YxBBs.MyName&")删除，原因是：""}else{sms.disabled=true;sms.value="""";}' type='checkbox' value='yes'> <input name='sms' size='50' type='text' value='' disabled='true'></p></form>"
	YxBBs.ShowTable Caption,"<tr><td height=""100"">"&Content&"</td></tr>"
Case"删除主题1"
        IsSms=YxBBs.Fun.GetStr("issms")
	Sms=YxBBs.Fun.GetStr("sms")
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除主题的权限！")
	Set Rs=YxBBs.execute("Select IsDel,Name,Caption From[YX_Topic] where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			GoToUrl=False
			'得出要删除的帖数
			Temp=YxBBs.Execute("Select Count(BbsID) From[YX_bbs"&YxBBs.TB&"] where (TopicID="&ID&" Or  ReplyTopicID="&ID&") And BoardID="&YxBBs.BoardID)(0)
			YxBBs.Execute("update [YX_Topic] set IsDel=True,ReplyNum=0 where TopicID="&ID&" And BoardID="&YxBBs.BoardID)
			YxBBs.Execute("update [YX_Bbs"&YxBBs.TB&"] set IsDel=True where (TopicID="&ID&" Or  ReplyTopicID="&ID&") And BoardID="&YxBBs.BoardID) 
			YxBBs.Execute("update [YX_Config] set AllEssayNum=AllEssayNum-"&Temp&",TopicNum=TopicNum-1")
			YxBBs.Execute("update [YX_Board] set EssayNum=EssayNum-"&Temp&",TopicNum=TopicNum-1 where BoardID="&YxBBs.BoardID&"")
If IsSms="yes" Then
YxBBs.Execute("insert into [YX_Sms](name,MyName,Title,Content) values('系统消息','"&SetUserName&"','您的主题被删除通知','"&Sms&"')")
		YxBBs.Execute("update [YX_User] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Sms)&" Where Name='"&SetUserName&"'")
end if
			If YxBBs.BoardDepth>1 Then
				YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum-1,EssayNum=EssayNum-"&Temp&" where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
			End If
			BoardLastRaply()
			YxBBs.InLog "将主题《"&Rs(2)&"》删除，主题ID："&ID,Rs(1),0
		Else
			YxBBs.Error("该帖子不存在或已经删除")
		End IF
		Caption="<meta http-equiv=refresh content=3;url=List.Asp?BoardID="&YxBBs.BoardID&">成功删除主题帖子！"
	End if
	Rs.Close
	Call Show()
Case"删除回复"
	If Cint(YxBBs.ClassSetting(14))=0 Then YxBBs.Error("您没有删除回复的权限！")
	GoToUrl=False
	Dim BbsID,Temp
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	Set Rs=YxBBs.execute("Select IsDel,Name,Caption From [YX_bbs"&YxBBs.TB&"] where ReplyTopicID="&ID&" And BbsID="&BbsID&" And BoardID="&YxBBs.BoardID&"")
	IF Rs.eof Then
		YxBBs.Error("该帖子不存在或已经删除")
	Else
		IF Not Rs(0) Then
			YxBBs.execute("update [YX_bbs"&YxBBs.TB&"] set IsDel=True where ReplyTopicID="&ID&" And BbsID="&BbsID&" And BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_Config] Set AllEssayNum=AllEssayNum-1")
			YxBBs.execute("update [YX_Board] Set EssayNum=EssayNum-1 where BoardID="&YxBBs.BoardID&"")
			YxBBs.execute("update [YX_Topic] set ReplyNum=ReplyNum-1 where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
			If YxBBs.BoardDepth>1 Then
				YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum-1,,EssayNum=EssayNum-1 where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
			End If
			BoardLastRaply()
			YxBBs.InLog "删除回复《"&Rs(2)&"》，主题ID："&ID,Rs(1),0
		Else
			YxBBs.Error("该帖子不存在或已经删除")
		End IF
		Caption="成功删除回复帖子！"
	End if
	Rs.Close
	Call Show()
Case"移动"
	If Cint(YxBBs.ClassSetting(15))=0 Then YxBBs.Error("您没有移动主题的权限！")
	GoToUrl=False
	Caption="移动帖子"
	Content="<form method=POST name='move' action='?action=move&TB="&YxBBs.TB&"&ID="&ID&"&BoardID="&YxBBs.BoardID&"'><p style='margin: 15'>请选择帖子要移动到的论坛："&GetBoardList()&" <input type=submit value=' 移 动 '> <br><br>是否用留言通知帖子的作者：<input name='issms' onclick='if(sms.disabled==true){sms.disabled=false;sms.value=""通知：您的帖子被管理员("&YxBBs.MyName&")移动到这里：""}else{sms.disabled=true;sms.value="""";}' type='checkbox' value='yes'> <input name='sms' size='50' type='text' value='' disabled='true'></p></form>"
	YxBBs.ShowTable Caption,"<tr><td height=""100"">"&Content&"</td></tr>"
Case"move"
	If Cint(YxBBs.ClassSetting(15))=0 Then YxBBs.Error("您没有移动主题的权限！")
	Dim IsSms,Sms,TmpBoardID
	GoToUrl=False
	IsSms=YxBBs.Fun.GetStr("issms")
	Sms=YxBBs.Fun.GetStr("sms")
	TmpBoardID=YxBBs.Checknum(Request.form("BoardID"))
	Set Rs=YxBBs.Execute("Select BoardID,Name,Caption From[YX_Topic] where TopicID="&ID&" and BoardID="&YxBBs.BoardID&"")
	YxBBs.execute("update [YX_Topic] Set BoardID="&TmpBoardID&" where TopicID="&ID&"")
	YxBBs.execute("update [YX_bbs"&YxBBs.TB&"] Set BoardID="&TmpBoardID&" where TopicId="&ID&" or ReplyTopicid="&ID&"")
	YxBBs.InLog "将主题《"&Rs(2)&"》从ID为"&Rs(0)&"的版面移动到版面ID为"&TmpBoardID&"的版面，主题ID："&ID,Rs(1),0
	If IsSms="yes" Then
		Sms=Sms&vbcrlf&"[url=Show.Asp?ID="&ID&"]请点击这里您的帖子[/url]"
		YxBBs.Execute("insert into [YX_Sms](name,MyName,Title,Content) values('系统消息','"&SetUserName&"','您的主题被移动通知','"&Sms&"')")
		YxBBs.Execute("update [YX_User] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(Sms)&" Where Name='"&SetUserName&"'")
	End If
	Rs.Close
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题移动成功!3秒后返回主题!"
	Call Show()
Case"提升"
       If Cint(YxBBs.ClassSetting(21))=0 Then YxBBs.Error("您没有提升主题的权限！")
	YxBBs.Execute("update [YX_Topic] set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	YxBBs.Execute("update [YX_bbs"&YxBBs.TB&"] set LastTime='"&YxBBs.NowBbsTime&"' where TopicID="&ID&" And BoardID="&YxBBs.BoardID&"")
	Set Rs=YxBBs.Execute("Select BoardID,Name,Caption From[YX_Topic] where TopicID="&ID&" and BoardID="&YxBBs.BoardID&"")
	YxBBs.InLog "成功提升主题《"&Rs(2)&"》，主题ID："&ID,Rs(1),0
	Rs.Close
	Caption="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&ID&">主题提升成功!3秒后返回主题!"
	Call Show()
Case Else
	YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Sub Show()
	Dim Temp
	IF GoToUrl Then Temp="<li><a href="&Url&">回到帖子</a></li>"
	Content=Content&Temp&"<li><a href=List.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.BoardName&"</a></li><li><a href=Default.Asp>返回首页</a>"
	YxBBs.Success Caption,Content
End Sub

Function GetBoardList()
	Dim Temp,I,II,po
	Temp="<select Style='font-size: 9pt' name='BoardID' >"
	If IsArray(YxBBs.Board_Rs) Then
		For i=0 To Ubound(YxBBs.Board_Rs,2)
			Po=""
			If YxBBs.Board_Rs(0,i)=0 Then
				Temp=Temp&"<option value='"&YxBBs.Board_Rs(1,i)&"'>≡"&YxBBs.Board_Rs(3,i)&"≡</option>"
			Else
				For II=2 to YxBBs.Board_Rs(0,i)
					po=Po&"∣"
				Next
				Temp=Temp&"<option value='"&YxBBs.Board_Rs(1,i)&"'>"&po&"├ "&YxBBs.Board_Rs(3,i)&"</option>"
			End IF
		Next
	End If
	GetBoardList=Temp&"</select>"
End Function

Sub BoardLastRaply()
	Dim Rs,Temp,TempID,TempContent
	Set Rs=YxBBs.execute("select top 1 ReplyTopicID,Name,Caption,Content,TopicID,LastTime,Face,BoardID from [YX_bbs"&YxBBs.TB&"] where BoardID="&YxBBs.BoardID&" And IsDel=False order by BbsID desc")
	if Rs.eof then
		Temp=""
	Else
		if Rs("ReplyTopicID")=0 then
			TempContent=YxBBs.Fun.StrLeft(Rs("Caption"),20)
			TempID=Rs("Topicid")
		Else
			TempContent=YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Rs("Caption")),20)
			TempID=Rs("ReplyTopicID")
			'更新主题
			Dim ReRs,TopicLastReply
			Set ReRs=YxBBs.execute("select top 1 Name,Content from [YX_bbs"&YxBBs.TB&"] where BoardID="&YxBBs.BoardID&" And ReplyTopicID="&TempID&" And IsDel=False order by BbsID desc")
			If Not ReRs.Eof Then
				TopicLastReply=""&ReRs(0)&"|"&YxBBs.Fun.StrLeft(ReRs(1),40)
				YxBBs.execute("Update [YX_Topic] set LastReply='"&TopicLastReply&"' where TopicId="&TempID&"")
			End If
			ReRs.CLose:Set ReRs=Nothing
		End if
	Temp=""&Rs("name")&"|"&TempContent&"|"&Rs("LastTime")&"|"&Rs("Face")&"|"&TempID&"|"&Rs("BoardID")&"|"&YxBBs.TB&""
	end if
	Rs.Close
	IF Temp<>"" Then 
		YxBBs.execute("update [YX_Board] set LastReply='"&Temp&"' where BoardID="&YxBBs.BoardID&" and ParentID<>0")
		If YxBBs.BoardDepth>1 Then
			YxBBs.Execute("Update [YX_Board] set LastReply='"&Temp&"' where BoardID In ("&YxBBs.BoardParentStr&") And ParentID<>0")
		End If
	End IF
	Cache.name="Config"
	Cache.clean()
	Cache.Name="BoardInfo"
	Cache.clean()
End Sub
%>