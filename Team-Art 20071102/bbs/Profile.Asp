<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim UserName,NoShow
UserName=Request.QueryString("name")
If YxBBs.FoundUser Then
	If Trim(UserName)="" Then UserName=YxBBs.MyName
	If Lcase(UserName)<>lCase(YxBBs.MyName) Then If Cint(YxBBs.ClassSetting(0))=0 Then YxBBs.Error("您没有权限查看其他人资料！")
Else
	If Trim(UserName)="" Then YxBBs.Error("缺少用户参数！")
	If Cint(YxBBs.ClassSetting(0))=0 Then YxBBs.Error("您没有权限查看其他人资料！")
End If

If Not YxBBs.Fun.CheckName(UserName) then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
If Lcase(UserName)=lCase(YxBBs.MyName) Then
	YxBBs.Position=YxBBs.Position&" <FONT face=Webdings>8</FONT> <a href=Profile.Asp>控制面版<a>"
	Call YxBBs.Head("查看本人资料")
	
Else
	Call YxBBs.Head("查看『 "&UserName&" 』的资料")
End If
NoShow=YxBBs.NoShowTopic()
ShowUserInfo()
ShowUserBBS()
YxBBs.Footer()
Set YxBBs=Nothing



Sub ShowUserInfo()
	Dim Caption,Content
	Dim Rs,Grade,UserPic,UserSex,RegIP,LastIP
	SET Rs=YxBBs.Execute("Select Name,Sex,Birthday,Mail,Home,TimeSum,IsQQpic,QQ,Pic,Pich,Picw,RegIp,LastIp,EssayNum,GoodNum,Mark,GradeName,Coin,BankSave,RegTime,LastTime,IsShow,IsDel,IsVip,LoginNum,Honor,Sign,Faction From[YX_user]where Name='"&UserName&"' And Isdel=False")
	If Rs.eof then YxBBs.Error("该用户不存在或者已经被删除！")
	If Rs("IsQQpic") Then
		UserPic="<img src='http://qqshow-user.tencent.com/"&Rs("QQ")&"/10/'>"
	Else
		UserPic="<img src="&YxBBs.Fun.GetSqlStr(Rs("pic"))&" width="&Rs("picw")&" height="&Rs("pich")&" >"
	End If
	IF Rs("Sex") Then UserSex="男" Else UserSex="女"
	IF YxBBs.ClassID<=2 or Lcase(YxBBs.MyName)=Lcase(UserName) Then
		RegIP=YxBBs.Fun.GetSqlStr(Rs("RegIp"))
		LastIP=YxBBs.Fun.GetSqlStr(Rs("LastIp"))
	Else 
		RegIP=YxBBs.Fun.GetIp(Rs("RegIp"),2)
		LastIP=YxBBs.Fun.GetIp(Rs("LastIp"),2)
	End If
	Caption="用户信息"
	Content="<table border=0 cellpadding=8 cellspacing=0 style='border-collapse: collapse' width='100%'><tr><td width='20%'>"&_
	"<table width='100%'  border='0' cellspacing='0' cellpadding='0'><tr><td align='center'>"&UserPIc&"</td></tr><tr><td align='center' height='40'><a href='Sms.Asp?Action=write&Name="&UserName&"'><img src='Images/sms.gif' border='0'> 发送留言</a></td></tr></table>"&_
	"</td><td width='40%' valign=top>"&_
	"<table width='98%' border='0' cellpadding='2' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #D4D4D4 2px solid; border-bottom: #D4D4D4 2px solid;border-top: #e8e8e8 1px solid;border-left: #e8e8e8 1px solid;'><tr><td align='left' height='25' bgcolor='#D6DAD7'><img src='Images/inn.gif' align='absmiddle'> <b>基本信息</b></td></tr>"&_
	"<tr><td height='190' bgcolor='#F7F7F7'><li>昵称："&UserName&"<li>性别："&UserSex&"<li>生日："&Rs("Birthday")&"<li>邮箱："&YxBBs.Fun.GetSqlStr(Rs("Mail"))&"<li> ＱＱ："&YxBBs.Fun.GetSqlStr(Rs("QQ"))&"<li>网站：<a href="&YxBBs.Fun.GetSqlStr(Rs("Home"))&">"&YxBBs.Fun.GetSqlStr(Rs("Home"))&"</a><li>论坛等级：<b>"&Rs("GradeName")&"</b><li>在线时长："&YxBBs.Fun.DateToSting(Rs("TimeSum"))&"<li>注册时IP："&RegIP&"<li>最后访问IP："&LastIP&"</td></tr></table></td><td width='40%' valign=top>"&_
	"<table width='95%' border='0' cellpadding='2' cellspacing='5' bgcolor='#FFFFFF' style='border-right: #D4D4D4 2px solid; border-bottom: #D4D4D4 2px solid;border-top: #e8e8e8 1px solid;border-left: #e8e8e8 1px solid;'><tr><td align='left' height='25' bgcolor='#D6DAD7'><img src='Images/inn.gif' align='absmiddle'> <b>论坛信息</b></td></tr>"&_
	"<tr><td height='190'bgcolor='#F7F7F7'><li>用户等级："&rs("GradeName")&"<li>头街称号："&YxBBs.Fun.GetSqlStr(Rs("Honor"))&"<li>论坛帮派："&YxBBs.Fun.GetSqlStr(Rs("Faction"))&"<li>发帖总数："&Rs("EssayNum")&"<li>精华帖数："&Rs("GoodNum")&"<li>用户金钱："&Rs("Coin")&"<li>用户存款："&Rs("BankSave")&"<li>用户积分："&Rs("Mark")&"<li>登陆次数："&Rs("LoginNum")&"<li>注册时间："&Rs("RegTime")&"<li>最后访问："&Rs("LastTime")&"</td></tr></table>"&_
	"</td></tr></table>"
	Rs.Close
	Call YxBBs.ShowTable(Caption,Content)
End Sub 

Sub ShowUserBBS()
	Dim Rs,I,SysInfo,ReplyInfo
	Set Rs=YxBBs.Execute("select Face,BoardID,Caption,AddTime,TopicID,Name,SqlTableID from  [YX_Topic] where name='"&UserName&"' And IsDel=False order by AddTime desc")
	 Do While not Rs.Eof
		If InStr(","&NoShow&",",","&Rs("BoardID")&",")=0 or (Lcase(UserName)=Lcase(YxBBs.MyName) or YxBBs.ClassID=1) Then
			i=i+1
			SysInfo=SysInfo& "<tr height='24' onmouseover=javascript:this.bgColor='#FFFDE6' onmouseout=javascript:this.bgColor=''><td background='Images/line_bg.gif' width='65%'><img src='Images/face/"&Rs("Face")&".gif' align='absmiddle'><a href=Show.Asp?ID="&Rs("TopicID")&">"&YxBBs.Fun.StrLeft(Rs("Caption"),50)&"</a></td><td  background=Images/line_bg.gif width='15%'>"&Rs("name")&"<td width='20%' background='Images/line_bg.gif'> "&Rs("AddTime")&"</td></tr>"
		End If
		IF i=5 Then Exit Do
		Rs.MoveNext
	 Loop
	Rs.Close
	SysInfo="<br><table align='center' width='96%' border='0' cellpadding='0' cellspacing='3' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'><tr><td height='25' bgcolor='#E8E8E8' colspan=3 align='left'>&nbsp;<img src='Images/inn.gif' align='absmiddle'> <b>最近发表的主题</b></td></tr><tr><td><table width=98% align='center' cellpadding='0' cellspacing='0' board=0 >"&SysInfo&"</table><br></td></tr></table>"
	i=0
	Set Rs=YxBBs.Execute("select Face,BoardID,Caption,LastTime,TopicID,Name,SqlTableID from [YX_Topic] where Name<>'"&UserName&"' And IsDel=False and TopicID in (Select ReplyTopicID from [YX_Bbs"&YxBBs.TB&"] where name='"&UserName&"') order by LastTime desc")
	 Do While not Rs.Eof
		If InStr(","&NoShow&",",","&Rs("BoardID")&",")=0 or (Lcase(UserName)=Lcase(YxBBs.MyName) or YxBBs.ClassID=1) Then
			i=i+1
			ReplyInfo=ReplyInfo& "<tr height='24' onmouseover=javascript:this.bgColor='#FFFDE6' onmouseout=javascript:this.bgColor=''><td background='Images/line_bg.gif' width='65%'><img src='Images/face/"&Rs("Face")&".gif' align='absmiddle'><a href=Show.Asp?ID="&Rs("TopicID")&">"&YxBBs.Fun.StrLeft(Rs("Caption"),50)&"</a></td><td  background=Images/line_bg.gif width='15%'>"&Rs("name")&"<td width='20%' background='Images/line_bg.gif'> "&Rs("LastTime")&"</td></tr>"
		End If
		IF i=5 Then Exit Do
		Rs.MoveNext
	 Loop
	Rs.Close
	ReplyInfo="<br><table align='center' width='96%' border='0' cellpadding='0' cellspacing='3' bgcolor='#FFFFFF' style='border-right: #BCBCBC 2px solid; border-bottom: #BCBCBC 2px solid;border-top: #e8e8e8 1px solid; border-left: #e8e8e8 1px solid;'><tr><td height='25' bgcolor='#E8E8E8'  align='left' colspan=3>&nbsp;<img src='Images/inn.gif' align='absmiddle'> <b>最近参与的主题</b></td></tr><tr><td><table width=98% align='center' cellpadding='0' cellspacing='0' board=0 >"&ReplyInfo&"</table><br></td></tr></table><br>"
	Call YxBBs.ShowTable(UserName&" 帖子信息",SysInfo&ReplyInfo)
End Sub
%>