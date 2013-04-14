<%
Class Cls_Public
	Public Fun,Template,Position,MenuInfo,Menu,Stats,Board_Rs,HeadLoad,rssurl
	Public BBSName,BBSUrl,BBSClose,CloseInfo,BBSBanner,CopyRight,BBSSetting,BuildDate,BbsTable,RegAutoSms,UploadType,AllEssayNum,NewUser,TopicNum,TodayNum,YsterdayNum,MaxOnlineNum,MaxOnlineTime,MaxEssayNum,UserNum,NowDate,BadName,BadEssay
	Public CacheName,CookiesName,NowBBSTime,SkinID,UserOnlineNum,AllOnlineNum
	Public TB,BoardID,BoardName,BoardSetting,BoardIntroduce,BoardTopicNum,BoardEssayNum,BoardAdmin,BoardGrade,BoardLock,BoardType,BoardTodayNum,BoardDepth,BoardChild,BoardParentStr,BoardRootID,BoardRoots
	Public MyIp,MyName,MyPwd,MyID,MyHidden,MySessionID,FoundUser,CookiesDate,IsBoardAdmin
	Public MySex,MyEssayNum,MyGoodNum,MyCoin,MyMark,MyHome,MyQQ,MyIsQQpic,MyPic,MyPicw,MyPich,MyGradeNum,MyGradeName,MyGradePic,MyBirthday,MyRegTime,MyLastTime,MySmsSize,MyRegIp,MyLoginNum,MyLastIp,MyHonor,MyFaction,MyBankSave,ClassSetting,ClassID
	Private SQL,Rs,Temp,SysConfig,MyInfo
	
	Private Sub Class_Initialize()
		Set Fun = New Cls_Fun
		Set Template = New Cls_SkinTemplates
		MyIp=Userip()
		CacheName="YxBBs_"&Replace(Replace(Replace(Server.MapPath("Default.Asp"),"Default.Asp",""),":",""),"\","")
		CookiesName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(Request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(Request.ServerVariables("SCRIPT_NAME"),"/"))),""))
		MyName=Replace(Request.Cookies(CookiesName)("MyName"),"'","")
		MyPwd=Replace(Request.Cookies(CookiesName)("MyPwd"),"'","")
		MyID=Trim(Request.Cookies(CookiesName)("MyID"))
		MyHidden=Request.Cookies(CookiesName)("MyHidden")
		CookiesDate=Request.Cookies(CookiesName)("CookiesDate")
		TB = CheckNum(Request.querystring("TB"))
		BoardID = CheckNum(Request.querystring("BoardID"))
		SkinID=Request.Cookies(CookiesName&"SkinID")
		NowBBSTime=FormatDateTime(Now()+Timeset/24,0)'������ʱ��
		MySessionID=Session.SessionID
		FoundUser=False
	End Sub
	
	Private Sub Class_Terminate()
		Set Fun = Nothing
		Set Rs = Nothing
		Set Template = Nothing
		If IsObject(Conn) Then
			Conn.Close
			Set Conn = Nothing
		End If
	End Sub
	'�������ݱ�
	Private Function GetSqlTable(Str)
		Dim AllTable,i
		Temp=""
		AllTable=Split(BbsTable(0),",")
		For i=0 to uBound(AllTable)
		 If Str= Int(AllTable(i)) Then Temp=Str:Exit For
		Next
		If Temp="" Then Str=BbsTable(1)
		GetSqlTable=Str
	End Function
   '��ȡIP
	Private Function UserIP()
		Dim GetClientIP
		GetClientIP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
		If GetClientIP = "" or isnull(GetClientIP) or isempty(GetClientIP) Then
		GetClientIP = Request.ServerVariables("REMOTE_ADDR")
		End if
		If Instr(GetClientIP,"'")>0 Then GetClientIP="0.0.0.0"
		Userip = GetClientIP
	End function
	
	Private Sub MyDataInfo()
		Temp=Session(CacheName & "MyInfo")
		If LCase(MyName)<>LCase(Temp(1)) Then
			YxBBs.MakeCookiesEmpty()
			YxBBs.Error("��ȡ�û���������")
		End If
		MySex=Temp(3)
		MyEssayNum=Temp(4)
		MyGoodNum=Temp(5)
		MyCoin=Temp(6)
		MyMark=Temp(7)
		MyHome=Temp(8)
		MyQQ=Temp(9)
		MyIsQQpic=Temp(10)
		MyPic=Temp(11)
		MyPicw=Temp(12)
		MyPich=Temp(13)
		MyGradeNum=Temp(14)
		MyGradeName=Temp(15)
		MyGradePic=Temp(16)
		MyBirthday=Temp(17)
		MyRegTime=Temp(18)
		MyLastTime=Temp(19)
		MySmsSize=Temp(20)
		MyRegIp=Temp(21)
		MyLoginNum=Temp(22)
		MyLastIp=Temp(23)
		MyHonor=Temp(24)
		MyFaction=Temp(25)
		MyBankSave=Temp(26)
		ClassSetting=Split(Temp(27),",")
		ClassID=Temp(28)
		FoundUser=True
	End Sub
	
	Public Sub SystemConfig()
		If Not IsNumeric(MySessionID) Then Error("��ȡ��������")
		Fun.LockedIpCheck()
		Cache.Name="Config"
		If Cache.Valid then
			SysConfig=Split(Cache.Value,"<$><$>")
		Else
			Set Rs = Execute("Select Top 1 BBSName,BBSUrl,BBSClose,CloseInfo,BBSBanner,CopyRight,Info,BuildDate,RegAutoSms,UploadType,AllEssayNum,TopicNum,TodayNum,YsterdayNum,MaxOnlineNum,MaxOnlineTime,MaxEssayNum,NewUser,UserNum,NowDate,BadName,BadEssay,BbsTable,SkinID From[YX_Config]")
			SqlNum=SqlNum+1
			Temp = Rs.GetString(,1, "<$><$>","","")
			Rs.Close
			Cache.add Temp,dateadd("n",2000,NowBBSTime)
			SysConfig = Split(Temp,"<$><$>")
		End If
		BBSName=SysConfig(0)
		BBSUrl=SysConfig(1)
		BBSClose=SysConfig(2)
		CloseInfo=SysConfig(3)
		BBSBanner=SysConfig(4)
		CopyRight=SysConfig(5)
		BBSSetting=Split(SysConfig(6),"|")
		BuildDate=SysConfig(7)
		RegAutoSms=SysConfig(8)
		UploadType=Split(SysConfig(9),"@@")
		AllEssayNum=SysConfig(10)
		TopicNum=SysConfig(11)
		TodayNum=SysConfig(12)
		YsterdayNum=SysConfig(13)
		MaxOnlineNum=SysConfig(14)
		MaxOnlineTime=SysConfig(15)
		MaxEssayNum=SysConfig(16)
		NewUser=SysConfig(17)
		UserNum=SysConfig(18)
		NowDate=SysConfig(19)
		BadName=SysConfig(20)
		BadEssay=Split(SysConfig(21),"@@")
		BbsTable=Split(SysConfig(22),"|")
		If BBSClose then
			If Instr(Lcase(Request("url")),""&YxBBs.BBSSetting(2)&"/")=0 Then Response.Write CloseInfo:Response.End
		End If
		If Int(TB)<>Int(BbsTable(1)) Then TB=GetSqlTable(TB)
		If Datediff("d",FormatDateTime(NowBbsTime,2),NowDate)<>0 Then UpdateToday
		If  Not IsNumeric(SkinID) or SkinID="0"  Then
		SkinID=SysConfig(23)
		Response.Cookies(CookiesName&"SkinID")=SkinID
		End If
			Template.SkinID=SkinID
			Template.OpenFile()
		Position="<a href=Default.Asp onmouseover=""showmenu(event,'"&BoardList(1)&"')"">"&BBSName&"</a>"
	End Sub
	
	Private Sub UpdateToday()
		If Execute("Select NowDate From [YX_Config]")(0)<>FormatDateTime(NowBbsTime,2) then
			Cache.name="Config":Cache.clean()
			Cache.name="BoardInfo":Cache.clean()
			Temp=Execute("select Todaynum from [YX_Config]")(0)
			Execute("update [YX_config] set NowDate='"&FormatDateTime(NowBbsTime,2)&"',Todaynum=0,YsterdayNum="&Temp&"")
			Execute("update [YX_Board] set Todaynum=0")
		End if
	End Sub
	
	Public Sub CheckUser()
		If Not IsNumeric(MyID) Or MyID="" Or MyName="" Or MyPwd="" Then
			FoundUser=False
			UserLoginFalse()
		Else
			UserLoginTrue()
		End If
	End Sub
	'�û���Ϣ
	Public Sub UserLoginTrue()
		Dim MenuOnline,NewSmsNum,AddTime
		If Not IsArray(Session(CacheName & "MyInfo")) Then
			SQL="Select U.ID,U.Name,U.Password,U.Sex,U.EssayNum,U.GoodNum,U.Coin,U.Mark,U.Home,U.QQ,U.IsQQpic,U.Pic,U.Picw,U.Pich,U.GradeNum,U.GradeName,U.GradePic,U.Birthday,U.RegTime,U.LastTime,U.SmsSize,U.RegIp,U.LoginNum,U.LastIp,U.Honor,U.Faction,U.BankSave,C.ClassSetting,C.ClassID From YX_user As U inner join YX_UserClass As C on U.ClassID=C.ClassID where U.ID="&MyID&" And U.Name='"&MyName&"' And U.Password='"&MyPwd&"'"
			Set Rs=Execute(SQL)
			If Rs.Eof Or Rs.Bof Then
				MakeCookiesEmpty()
				FoundUser=False
			Else
				If lcase(MyName)<>lcase(Rs(1)) Or MyPwd<>Rs(2) Then
					FoundUser=False
				Else
					MyInfo=Rs.GetString(,1, "<$><$>","","")
					Rs.CLose
					Session(CacheName & "MyInfo")=Split(MyInfo,"<$><$>")
					MyDataInfo()
				End If
			End If
If Int(MyID)<>Int(Session(CacheName & "MyInfo")(0)) or LCase(MyName)<>LCase(Session(CacheName & "MyInfo")(1)) Or MyPwd<>Session(CacheName & "MyInfo")(2) Then
			MakeCookiesEmpty()
				Error("�Ƿ�α��Cookie����̳���й���")
                         end if
		Else
			MyDataInfo()
		End If
		If Request.Cookies(CookiesName)("onlinetime")=Empty Then
			Response.Cookies(CookiesName)("onlinetime")=NowBbsTime
		ElseIf DateDiff("s",Request.Cookies(CookiesName)("onlinetime"),NowBbsTime)>30 then
			AddTime=DateDiff("s",Request.Cookies(CookiesName)("onlinetime"),NowBbsTime)
			Execute("update [YX_User] Set lasttime='"&NowBbsTime&"',TimeSum=TimeSum+"&AddTime&" where Name='"&MyName&"'")
			Response.Cookies(CookiesName)("onlinetime")=NowBbsTime
		End If
               rssurl="?BoardID="&BoardID&""
if rssurl="?BoardID=0" then
                rssurl=""
                end if   
                
		If MyHidden="" then MyHidden=1
		If MyHidden=1 then MenuOnline="<a href=cookies.Asp?Action=Online>�� ��</a>"
		If MyHidden=2 then MenuOnline="<a href=cookies.Asp?Action=Online>�� ��</a>"
		MenuInfo="<b>&raquo; <a onmouseover=""showmenu(event,'<div class=menuitems><a href=Sms.Asp>�ҵ���̳����</a></div><div class=menuitems><a href=MyList.Asp?Action=MySay>�ҷ���������</a></div><div class=menuitems><a href=Mylist.Asp?action=MyReply>�Ҳ��������</a></div><div class=menuitems><a href=MyList.Asp?Action=MyGood>�ҵľ�������</a></div><div class=menuitems><a href=UserSetup.Asp?Action=MyInfo>�޸��ҵ�����</a></div><div class=menuitems><a href=usersetup.Asp?action=mypassword>�޸��ҵ�����</a></div>')"" style='CURSOR: hand;'>"&MyName&"</b></a> �� "&MenuOnline
		MenuInfo=MenuInfo&" �� <a onmouseover=""showmenu(event,'<div class=menuitems><a href=showList.Asp?Action=new>��̳����</a></div><div class=menuitems><a href=Search.Asp>��̳����</a></div><div class=menuitems><a href=Members.Asp>�û��б�</a></div><div class=menuitems><a href=Members.Asp?Action=admin>�����Ŷ�</a></div><div class=menuitems><a href=Online.Asp>�������</a></div>')"">�� ��</a> "
		MenuInfo=MenuInfo&PlusMenu()&" �� <a href=help.Asp>�� ��</a>"
	
		If Session(CacheName & "LastTime")="" Then
			Session(CacheName & "LastTime")=MyLastTime
			Execute("Update [YX_user] set Lasttime='"&NowBbsTime&"' where Name='"&MyName&"'")
		End If
		If Session(CacheName & "MyReNewTime")="" Or DateDiff("n",Session(CacheName & "MyRenewTime"),NowBbsTime) > 2 Then'3����
			Set Rs=Execute("select NewSmsNum from [YX_user] where IsDel=False And Name='"&MyName&"' And Password='"&MyPwd&"'")
			If Rs.Eof Then
				MakeCookiesEmpty()
				Error("�����¼��̳����ܽ��в�����")
			Else
				NewSmsNum=Rs(0)
			End If
			Rs.Close
			If Instr(Lcase(Request("url")),"sms.asp")=0 Then
				If NewSmsNum>0 then
						If  YxBBs.BBSSetting(11)=1 Then
						Dim NewMailNum
                                                MenuInfo=MenuInfo&" <script language='JavaScript'>if(confirm('������̳�����������ԣ��Ƿ�Ҫ�鿴��')){window.location.href='Sms.Asp';}else{event.returnValue=false;};window.location.href='Sms.Asp';</SCRIPT>"
                                             else
						MenuInfo=MenuInfo&" �� <a href='Sms.Asp' target='_blank'><font color=#FF0000>�� �� �� ("&NewSmsNum&")</font></a>"
End If 
					Else
						Session(CacheName & "MyReNewTime")=NowBbsTime
					End If
			End If
		End If
		If ClassID=1 Then MenuInfo=MenuInfo&" ��  <a href="&YxBBs.BBSSetting(2)&"/ onmouseover=""showmenu(event,'<div class=menuitems><a href=Members.Asp?Action=log&BoardID="&BoardID&">��̳��־</a></div><div class=menuitems><a href=Placard.Asp>��������</a></div>')""><font color=""#FF0000"">�� ��</font></a>"
		MenuInfo=MenuInfo&" �� <a href=Login.Asp?Action=Exit>�� ��</a> "
	End Sub
	
	Private Sub UserLoginFalse()
		Dim NotFoundUserClassSetting
		Cache.Name = "NotFoundUserClassSetting"
 rssurl="?BoardID="&BoardID&""
if rssurl="?BoardID=0" then
                rssurl=""
                end if   
		If Cache.valid then
			ClassSetting=Split(Cache.Value,",")
			ClassID=6
		Else
			Temp = Execute("Select ClassSetting from YX_UserClass where ClassID=6")(0)
			SqlNum=SqlNum+1
			Cache.add NotFoundUserClassSetting,dateadd("n",2000,now)
			ClassSetting=Split(Temp,",")
			ClassID=6
		End if
MenuInfo="<b>&raquo; �� ��</b> �� <a href=login.Asp>�� ¼</a> �� <a href=register.Asp>ע ��</a> �� <a href=UserSetup.Asp?Action=ForgetPassword>�� �� �� ��</a>"
		MenuInfo=MenuInfo&" �� <a onmouseover=""showmenu(event,'<div class=menuitems><a href=Search.Asp>��̳����</a></div><div class=menuitems><a href=Members.Asp>�û��б�</a></div><div class=menuitems><a href=Members.Asp?Action=admin>�����Ŷ�</a></div><div class=menuitems><a href=Online.Asp>�������</a></div>')"">�� ��</a>"
		MenuInfo=MenuInfo&PlusMenu()&" �� <a href=help.Asp>�� ��</a> "
	End Sub
	
	Public function CheckNum(str)
		If isnull(str) or str=""  then
		Str=0
		End If
		if not isnumeric(str) then Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
		CheckNum=int(str)
	End function
	
	Public Sub GetOnline()
		Dim PicMood
		If Session(CacheName & "Stats") = Stats Then
			AllOnlineNum=Session(CacheName & "AllonlineNum")
			UserOnlineNum=Session(CacheName & "UserOnlineNum")
		Else
			Session(CacheName & "Stats")=Stats
			Dim UserSessionID
			UserSessionID=Request.Cookies("SessionID")("SID")
			If IsNumeric(UserSessionID)=0 or UserSessionID="" Then
				UserSessionID=Ccur(MySessionID)
				Response.Cookies("SessionID").Expires=date+1
				Response.Cookies("SessionID")("SID")=Ccur(MySessionID)
			Else
				UserSessionID=Ccur(UserSessionID)
			End If
			If FoundUser Then
				SQL = "Select Count(ID) From[YX_Online]Where Name='" & MyName & "' or ID=" & UserSessionID &" "
			Else
				SQL = "Select Count(ID) From[YX_Online]Where ID=" & UserSessionID &""
			End if
			Temp=Execute(SQL)(0)
			IF FoundUser Then
				If MyHidden=2 Then PicMood=0
				IF Temp >1 Then Execute("Delete * From[YX_online] where name='"&MyName&"'")
			End If
			If Temp < 1 Then
				SQL="Insert into [YX_Online](ID,ClassID,Name,OldTime,LastTime,Locate,Ip,BoardID,BoardUrl) values("&UserSessionID&","&ClassID&",'"& Myname &"','"& NowBbsTime &"','"&NowBbsTime&"','"& Stats &"','"& MyIp &"',"& BoardID &",'"&GetUrl()&"')"
			Else
				SQL="Update [YX_Online] set Name='"& Myname &"',ClassID='"&ClassID&"',LastTime='"&NowBbsTime&"',Locate='"&Stats&"',BoardID="&BoardID&",BoardUrl='"&GetUrl()&"',Ip='"& MyIp &"' where ID="&UserSessionID&""
			End If
			Execute(Sql)
			'ȫ�������û�
			AllOnlineNum=Execute("Select Count(ID) From[YX_online]")(0)
			'ͳ�����߻�Ա
			If BoardID=0 Then
				UserOnlineNum=Execute("Select Count(ID) From[YX_online] where ClassID<>6")(0)
			Else
				UserOnlineNum=Execute("Select Count(ID) From[YX_online] where ClassID<>6 And BoardID="&BoardID&"")(0)
			End If
			Session(CacheName & "AllOnlineNum")=AllOnlineNum
			Session(CacheName & "UserOnlineNum")=UserOnlineNum
			If Int(AllOnlineNum)>Int(MaxOnlineNum) then
				Execute ("update [YX_Config] Set MaxOnlineNum="&AllOnlineNum&",MaxOnlineTime='"&NowBbsTime&"'")
				Cache.name="Config"
				Cache.clean()
			End If
			Execute( "Delete FROM [YX_Online] WHERE DATEDIFF('s', LastTime,'"&NowBbsTime&"') > "&BBSSetting(27)*60&"") '����
		End If
	End Sub
	
	Public Sub MakeCookiesEmpty()
		Session(CacheName & "MyInfo") = Empty
		Response.Cookies(CookiesName)("MyID")=""
		Response.Cookies(CookiesName)("MyName")=""
		Response.Cookies(CookiesName)("MyPwd")=""
		Response.Cookies(CookiesName)("MyHidden")=""
		Response.Cookies(CookiesName)("CookiesData")=""
		Cache.Name="UserOnline"
		Cache.Clean()
	End Sub
	
	Public Function PageStats()
		Temp=Template.ReadTemplate("���λ��")
		Temp=Replace(Temp,"{λ��}",Position)
		PageStats=Temp
	End Function
	
	Public Sub Head(Str)
		Dim i
		Temp = Template.ReadTemplate("ҳ������")
		IF Str<>"" Then
			Position=Position&"&nbsp;<FONT face=Webdings>8</FONT>&nbsp;"& Str
Stats=Str
		End if
		Temp = Replace(Temp,"{ҳ�����}",BBSName&" --- "&Stats)
		Temp= Temp & Template.ReadTemplate("�˵�����")& vbNewLine &"<SCRIPT Src=Inc/Menu.js></SCRIPT>"
		Temp = Temp & vbNewLine & Template.ReadTemplate("ҳ��ͷ��")
		Temp = Replace(Temp,"{�˵�}",MenuInfo)
		Temp = Replace(Temp,"{���}",BBSBanner)
		Response.Write Temp&vbNewLine &PageStats()
		GetOnline()
		HeadLoad=True
	End Sub
	'��̳����
	Public Function Placard(Ast)
		Dim Temp,Rs,Arr_Rs,i
		Cache.Name="Placard"'��������
		If Cache.valid then
			Arr_Rs=Cache.Value
		Else
			Set Rs=Execute("Select Id,Caption,AddTime,BoardID From [YX_Placard] order by Id desc")
			If Rs.Eof Or Rs.Bof Then
				Temp="��̳��������,Ŀǰû�й��棡"
				Placard=Temp
				Exit Function
			Else
				Arr_Rs=Rs.GetRows(-1)
				Rs.Close
				Cache.add Arr_Rs,dateadd("n",5000,now)'5000���Ӹ���
			End if
		End if
		For i=0 To Ubound(Arr_Rs,2)
		If Arr_Rs(3,i)=Ast Then
			Temp=Temp&" ��<a href=javascript: onclick=javascript:window.open('See.Asp?Action=Placard&ID="&Arr_Rs(0,i)&"','','width=600,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes')>"&Fun.HtmlCode(Arr_Rs(1,i))&" [ "&Arr_Rs(2,i)&" ]</a> "
		End If
		Next
		If Temp="" Then Temp="��̳��������,Ŀǰû�й��棡"
		Placard=Temp
	End Function
	
	Public Sub Footer()
		Temp=Template.ReadTemplate("ҳ��ײ�")
		Temp=Replace(Temp,"{��Ȩ}","Designed By <a href=""http://www.YimXu.Com/""target=""_blank"">YxBBs</a><br> "&getTimeOver(BBSSetting(33))&" ���ݲ�ѯ��"&SqlNum&"��<br>"&CopyRight&"")
		Response.Write Temp
	End Sub
	'����˵�
	Public Function PlusMenu()
		Cache.Name="PlusMenu"
		If Cache.Valid then
			PlusMenu=Cache.Value
		Else
			Set Rs=YxBBs.Execute("Select Name,Url,Flag From [YX_Plus]")
			SqlNum=SqlNum+1
			Do while not Rs.eof
				PlusMenu=PlusMenu & "<div class=menuitems><a href="&Rs(1)&">"&Rs(0)&"</a></div>"
				Rs.MoveNext
			Loop
			PlusMenu=" �� <a onmouseover=""showmenu(event,'"&PlusMenu&"')"">�� ʩ</a>"
			Rs.Close
			Cache.add PlusMenu,dateadd("n",2000,NowBBSTime)
		End If
	End Function
	'���˵�
	Public Function SkinList()
		Dim Temp,Arr_Rs,i
 		Cache.Name="SkinList"
		If Cache.valid Then
			Arr_Rs=Cache.Value
		Else
			Set Rs=Execute("Select SkinID,SkinName From[YX_SkinStyle]")
			If Rs.Eof Or Rs.Bof Then
			Exit Function
			Else
			Arr_Rs=Rs.GetRows
			Rs.Close
			Cache.add Arr_Rs,dateadd("n",2000,now)
			End If
		End if
			For i=0 To Ubound(Arr_Rs,2)
				If int(SkinID)=Int(Arr_Rs(0,i)) Then
					Temp=Temp&"<div class=menuitems><a href=Cookies.Asp?Action=Style&SkinID="&Arr_Rs(0,i)&"><font color=red>"&Arr_Rs(1,i)&"</font></a></div>"
				Else
					Temp=Temp&"<div class=menuitems><a href=Cookies.Asp?Action=Style&SkinID="&Arr_Rs(0,i)&">"&Arr_Rs(1,i)&"</a></div>"
				End if
			Next
		SkinList=Temp
	End Function
	'������
	Public Function CacheBoard()
		Cache.Name="BoardInfo"
		If Cache.valid then
			Board_Rs=Cache.Value
		Else
			Set Rs=Execute("Select Depth,BoardID,ParentID,Boardname,BoardSetting,BoardImg,Introduce,BoardAdmin,TopicNum,EssayNum,TodayNum,LastReply,PassUser,Child,ParentStr,RootID,BoardLock,BoardType,BoardGrade From[YX_Board] order by RootID,Orders")
			If Rs.Eof Or Rs.Bof Then
				Exit Function
			Else
				Board_Rs=Rs.GetRows(-1)
				Rs.Close
				Cache.add Board_Rs,dateadd("n",1000,now)'1000���Ӹ���
			End If
		End If
	End Function
	'�����Ϣ
	Public Function GetBoardInfo(Str,Ast)
		Dim I,BoardtypePic,BoardtypepicTemp,BoardAdmin,BoardAdmin1,LastStr
		Temp= Replace(Trim(Template.ReadTemplate("�������ͼƬ")), CHR(10),"")
		Temp= Replace(temp,CHR(13),"")
		If Temp="" Then Response.Write("ģ�������𻵣�<br><A HREF=Cookies.Asp?Action=Style&SkinID=0>�������������Cookies</A><br>�����Ȼ�������⣬�����Cookies,�����������������"):Response.end
		BoardtypepicTemp=split(Temp,"|")
		If Board_Rs(16,Ast) Then
			Boardtypepic=BoardtypepicTemp(2)
		Else
			If board_Rs(11,Ast)<>"" Then
				If Datediff("h",Split(board_Rs(11,Ast),"|")(2),NowbbsTime)<=24 Then
					Boardtypepic=BoardtypepicTemp(1)
				Else
					Boardtypepic=BoardtypepicTemp(0)
				End If
			Else
				Boardtypepic=BoardTypePicTemp(0)
			End If
		End If
		If board_Rs(5,Ast)="" or IsNull(board_Rs(5,Ast)) Then
			Temp=""
		Else
			Temp="<img src="&board_Rs(5,Ast)&">"
		End if
		Str = Replace(Str,"{�������ͼƬ}",BoardTypePic)
		Str = Replace(Str,"{���ͼƬ}",Temp)
		If board_Rs(13,Ast)>0 Then Temp=" ["&board_Rs(13,Ast)&"]" Else Temp=""
		Str = Replace(Str,"{���ID}",board_Rs(1,Ast))
		Str = Replace(Str,"{�������}","<a href=List.Asp?BoardID="&board_Rs(1,Ast)&">"&board_Rs(3,Ast)&Temp&"</a>")
		Str = Replace(Str,"{������}",board_Rs(6,Ast))
		If Board_Rs(7,Ast) = "" Or IsNull(board_Rs(7,Ast)) Then
			BoardAdmin="����":BoardAdmin1="����"
		Else
			Temp=split(board_Rs(7,Ast),"@@")
			BoardAdmin=""
			For I=0 to ubound(Temp)
				BoardAdmin=BoardAdmin&"<a href='Profile.Asp?Name="&Temp(I)&"' title='����鿴������"&Temp(I)&" ����Ϣ'>"&Temp(I)&"</a> "
			Next
			BoardAdmin1=Replace(BoardAdmin,"&nbsp;","<br>")
		End If
		Str=Replace(Str,"{��������}",BoardAdmin1)
		Str = Replace(Str,"{����}",BoardAdmin)
		Str = Replace(Str,"{������}",board_Rs(8,Ast))
		Str = Replace(Str,"{������}",board_Rs(9,Ast))
		Str = Replace(Str,"{��������}",board_Rs(10,Ast))
		If isnull(board_Rs(11,Ast)) or board_Rs(11,Ast)="" Then
			Str=Replace(Str,"{���ظ�}","")
		Elseif Cint(Board_Rs(17,Ast)) Then
			Str=Replace(Str,"{���ظ�}","<div align=center><font color=#999999>��֤����</font></div>")
		Else
			LastStr=Template.ReadTemplate("������ظ�")
			Temp=Split(board_Rs(11,Ast),"|")
			LastStr = Replace(LastStr,"{�û�����}",Temp(0))
			LastStr = Replace(LastStr,"{������Ϣ}",Temp(1))
			LastStr = Replace(LastStr,"{�ظ�ʱ��}",Temp(2))
			LastStr = Replace(LastStr,"{����}",Temp(3))
			LastStr = Replace(LastStr,"{����ID}",Temp(4))
			LastStr = Replace(LastStr,"{���ID}",Temp(5))
			LastStr = Replace(LastStr,"{���ݱ�ID}",Temp(6))
			Str = Replace(Str,"{���ظ�}",LastStr)
		End if
		GetBoardInfo=Str
	End Function
	'������ʾ�����⣬���ݣ�
	Public Sub ShowTable(Str1,Str2)
		Dim Temp
		Temp=Template.ReadTemplate("���ݱ���")
		Temp=Replace(Temp,"{����}",Str1)
		Temp=Replace(Temp,"{����}",Str2)
		Response.Write(Temp)
	End Sub
	'������
	Public Sub CheckBoard()
		If Not IsArray(Board_Rs) Then CacheBoard()
		If Not IsArray(Board_Rs) Then Error("�������ʵİ��治���ڣ�")
		Dim Temp,PassUser,i
                rssurl="?BoardID="&BoardID&""
		If BoardID=0 Then Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
                For i=0 To Ubound(Board_Rs,2)
			If Int(Board_Rs(1,i))=Int(BoardID) Then
				BoardDepth=Board_Rs(0,i)
				BoardName=Board_Rs(3,i)
				Stats=Boardname
				BoardSetting=split(Board_Rs(4,i),",")
				BoardIntroduce=Board_Rs(6,i)
				BoardAdmin=Board_Rs(7,i)
				BoardEssayNum=Board_Rs(9,i)
				BoardTopicNum=Board_Rs(8,i)
				BoardTodayNum=Board_Rs(10,i)
				PassUser=Board_Rs(12,i)
				BoardChild=Board_Rs(13,i)
				BoardParentStr=Board_Rs(14,i)
				BoardRootID=Board_Rs(15,i)
				BoardLock=Board_Rs(16,i)
				BoardType=Board_Rs(17,i)
				BoardGrade=Board_Rs(18,i)
			End If
		Next
		IsBoardAdmin=False
		BoardRoots="|"
		If InStr("|"&Lcase(BoardAdmin)&"|","|"&Lcase(MyName)&"|")>0  And FoundUser And BoardAdmin<>"" Then IsBoardAdmin=True
		For i=0 To Ubound(Board_Rs,2)
			'��¼���ö���Ϣ
			If Board_Rs(15,i)=BoardRootID And Board_Rs(0,i)<>0 Then BoardRoots=BoardRoots&Board_Rs(1,i)&"|"
			If Int(BoardDepth)>0 Then
				If InStr(","&BoardParentStr&",",","&Board_Rs(1,i)&",")>0 Then
					'����ϼ���̳Ϊ��Ա����
					'If Board_Rs(4,i)=1 Then If Not Founduser then Error("�ð���Ϊֻ��ע���Ա���Խ���")
					'�ϼ������̳й���
					If BBSSetting(1)="0" And FoundUser Then
						If InStr("|"&Board_Rs(7,i)&"|","|"&MyName&"|")>0 And FoundUser And BoardAdmin<>"" Then IsBoardAdmin=True
					End If
					Temp=Temp &" <FONT face=Webdings>8</FONT> <a href='List.Asp?BoardID="&Board_Rs(1,i)&"'>"&Board_Rs(3,i)&"</a>"
				End If
			End If
		Next
		If ClassID=3 And Not IsBoardAdmin Then ClassSetting=Split(Execute("Select ClassSetting from YX_UserClass where ClassID=5")(0),",")
		Position=Position & Temp &" <FONT face=Webdings>8</FONT> <a href='List.Asp?BoardID="&BoardID&"'>"&Stats&"</a>"
		If BoardName="" or IsNull(BoardName) Then Error("�������ʵİ��治���ڣ�")
		If  Instr(Lcase(Request("Url")),"list.asp")>0 Then
			If  isnull(Boardadmin) or Trim(BoardAdmin)="" then
				BoardAdmin="����"
			Else
				Temp=split(BoardAdmin,"|")
				BoardAdmin=""
				For i=0 to ubound(Temp)
					Boardadmin=Boardadmin&"<a href='Profile.Asp?name="&Temp(i)&"'>"&Temp(i)&"</a>&nbsp;"
				Next
			End If
		End If
		If ClassID<=2 Then Exit Sub
		If Cint(MyGradeNum)<BoardGrade Then Error("���ĵȼ���û�дﵽ <font color=#FF0000>"&BoardGrade&"</font> �������ܽ�������棡��ǰ���ĵȼ��� <font color=#FF0000>"&CInt(MyGradeNum)&"</font> ����")
		If BoardLock Then
			If  ClassID>2 or Not IsBoardAdmin then
				If (Instr(Lcase(Request("url")),"say.asp")>0 and Instr(Lcase(Request("url")),"show.asp")<1) or Instr(Lcase(Request("url")),"save.asp")>0 then Error("�ð����Ѿ���������û��Ȩ���ڱ��淢�����ӣ�") 
			End If
		End If
		If BoardType Then
			Dim IsPassUser
			ISpassUser=False
			If ClassID>2 Then
				If Not IsBoardAdmin Then
					If Not FoundUser or isnull(PassUser) or PassUser="" then
						Error("�ð���Ϊ��֤��̳���㻹û�о�������Ա����֤��")
					Else
						PassUser=Split(PassUser,"|")
						for i = 0 to ubound(PassUser)
							If MyName=trim(PassUser(i)) And MyName<>"" Then
								IsPassuser=True
								Exit for
							End If
						Next
						If Not IsPassUser Then Error("�ð���Ϊ��֤��̳���㻹û�о�������Ա����֤��")
					End If
				End If
			End if
		End If
		
		If Cint(MyEssayNum)<Cint(BoardSetting(5)) Then Error("��������û�дﵽ "&Cint(BoardSetting(5))&" ���ܽ��뱾���棡")
		If Cint(MyMark)<Cint(BoardSetting(6)) Then Error("���Ļ���û�дﵽ "&Cint(BoardSetting(6))&" ���ܽ��뱾���棡")
		If Cint(MyCoin)<Cint(BoardSetting(7)) Then Error("���Ľ��û�дﵽ "&Cint(BoardSetting(7))&" ���ܽ��뱾���棡")
		If Cint(MyLoginNum)<Cint(BoardSetting(8)) Then Error("���ĵ�½����û�дﵽ "&Cint(BoardSetting(8))&" ���ܽ��뱾���棡")
		If Cint(MyGoodNum)<Cint(BoardSetting(9)) Then Error("���ľ�������û�дﵽ "&Cint(BoardSetting(9))&" ���ܽ��뱾���棡")
		If DateDIff("n",MyRegTime,NowBBSTime)<Cint(BoardSetting(10)) Then Error("����ע��ʱ��û�г��� "&Cint(BoardSetting(10))&" ���ܽ��뱾���棡")
	End Sub
	'��������б�(��ǰID������ʾ�����)
	Public Function BoardIDList(Ast,Depth)
		Dim Temp,I,II,po
		If Not IsArray(Board_Rs) Then YxBBs.CacheBoard()
		If IsArray(Board_Rs) Then
			For i=0 To Ubound(Board_Rs,2)
				Po=""
				If Board_Rs(0,i)=0 Then
					Temp=Temp&"<option value='"&Board_Rs(1,i)&"'"
					If Board_Rs(1,i)=Ast Then Temp=Temp&" selected"
					Temp=Temp&">��"&Board_Rs(3,i)&"��</option>"
				Else
					For II=2 to Board_Rs(0,i)
						po=Po&"�O"
					Next
					Temp=Temp&"<option value='"&Board_Rs(1,i)&"'"
					If Board_Rs(1,i)=Ast Then Temp=Temp&" selected"
					Temp=Temp&">"&po&"�� "&Board_Rs(3,i)&"</option>"
				End IF
			Next
			BoardIDList=Temp
		End If
	End Function
	'��¼��֤���ı��
	Public Function NoShowTopic()
		Dim Temp,i
		If Not IsArrAy(Board_Rs) Then CacheBoard()
		If IsArray(Board_Rs) Then
			Temp=""
			For i=0 To Ubound(Board_Rs,2)
				If Board_Rs(17,I)=3 Then
					Temp=Temp&Board_Rs(1,I)&","
				End If
			Next
			If Temp<>"" Then Temp=left(temp,len(temp)-1)
			NoShowTopic=Temp
		End If
	End Function
	Public Function Execute(T_Sql)
		If Not IsObject(Conn) Then ConnectionDatabase
		Set Execute = Conn.Execute(T_Sql)
		SqlNum=SqlNum+1
	End Function
	Public Sub InToDataBase(DataBaseName,TableName,ColumnName,ColumnValue)
		On Error Resume Next
		
		YxBBs.Execute("insert into ["&TableName&"] ("&ColumnName&") values ("&Replace(Replace(ColumnValue,"True","1"),"False","0")&")")
		
		If Err Then
			Response.Write "��LOG���ݿ��"&TableName&"�����Ӽ�¼ʧ�ܣ�ԭ��<font color=red>" & Err.Description
			Err.Clear
		End If
	End Sub
	PubLic Sub InLog(LogInfo,ToName,LogType)
		If LogType = 1 Then
			InToDataBase db,"YX_Logs","UserName,UserIP,LogContent,LogTime","'"&YxBBs.MyName&"','"&YxBBs.MyIp&"','"&LogInfo&"','"&Now()&"'"
		Else
			InToDataBase db,"YX_Logs","ToName,UserName,UserIP,LogContent,LogTime","'"&ToName&"','"&YxBBs.MyName&"','"&YxBBs.MyIp&"','"&LogInfo&"','"&Now()&"'"
		End If
	End Sub
	'����JS������Ϣ
	Sub ErrMsg(Message)
		Response.Write("<script>alert('"&message&"');history.back();</script>")
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'������Ϣ��ʾ
	Public Sub Error(Message)
		If Not HeadLoad Then Call Head("������Ϣ")
		Call ShowTable("������Ϣ","<tr><td height=""100""><b>�������ɹ��Ŀ���ԭ��</b><ul>"&Message&"</ul></td></tr>")
		YxBBs.Footer()
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'�����ɹ�����
	Public Sub Success(Info,Message)
		If Not HeadLoad Then Call Head("�����ɹ�")
		Call ShowTable("�����ɹ�","<tr><td height=""100""><div style='margin:15;line-height: 150%'><b>"&Info&"�����Խ������²�����</b><br><ul>"&Message&"</ul></div></td></tr>")
		YxBBs.Footer()
		Set Cache = Nothing
		Set YxBBs = Nothing
		Response.End()
	End Sub
	'��ȡCookies��¼(cookies���ƣ���Դ)
	Public Function GetCookiesInfo(CkStr,From)
		GetCookiesInfo=Session(CacheName & CkStr)
		If GetCookiesInfo="" Then GetCookiesInfo=Request.Cookies(CookiesName&CkStr)(CkStr)
		If GetCookiesInfo="" Then
			GetCookiesInfo=From
			Session(CacheName & CkStr)=From
			Response.Cookies(CookiesName&CkStr)(CkStr)=From
			Response.Cookies(CookiesName&CkStr).Expires=Date+1
		Else
			Session(CacheName & CkStr)=GetCookiesInfo
			Response.Cookies(CookiesName&CkStr)(CkStr)=GetCookiesInfo
		End If
	End Function
	'��ȡ��ǰURL��ַ
	Public Function GetUrl()
		On Error Resume Next
		Dim Temp
		If LCase(Request.ServerVariables("HTTPS")) = "off" Then
			Temp = "http://"
		Else
			Temp = "https://"
		End If
		Temp = Temp & Request.ServerVariables("SERVER_NAME")
		If Request.ServerVariables("SERVER_PORT") <> 80 Then Temp = Temp & ":" & Request.ServerVariables("SERVER_PORT")
		Temp = Temp & Request.ServerVariables("URL")
		If Trim(Request.QueryString) <> "" Then Temp = Temp & "?" & Request.QueryString
		GetUrl = Temp
	End Function

	Public Function UpdateCookiesInfo(CkStr,Ast)
		If Ast=0 Then
			Session(CacheName & CkStr)=""
			Response.Cookies(CookiesName&CkStr)(CkStr)=""
		Else
			Dim Temp
			Temp=Session(CacheName & CkStr)
			If Temp="" Then Temp=Request.Cookies(CookiesName&CkStr)(CkStr)
			If Temp="" Then Exit Function
			Temp=Temp+Ast
			Session(CacheName & CkStr)=Temp
			Response.Cookies(CookiesName&CkStr)(CkStr)=Temp
			UpdateCookiesInfo=Temp
		End If
	End Function

	'1�˵��б�2�����б�
	Public Function BoardList(Ast)
	   If Ast<1 or Ast>2 Then Exit Function
		Dim Temp,BoardNenu,BoardSelect,i,II,Po
 		Cache.Name="BoardList"&Ast
		If Cache.valid Then
			Temp=Cache.Value
			BoardList=Temp
			Exit Function
		Else
			If Not IsArray(Board_Rs) Then CacheBoard()
			If Not IsArray(Board_Rs) Then Exit Function
			Cache.Name="BoardList"&Ast
			For i=0 To Ubound(Board_Rs,2)
			Po=""
			If Board_Rs(0,i)=0 Then'��
				BoardNenu=BoardNenu&"<div class=menuitems><A Href=List.Asp?BoardID="&Board_Rs(1,i)&">�� "&Board_Rs(3,i)&" ��</a></div>"
				BoardSelect=BoardSelect&"<option value='"&Board_Rs(1,i)&"'>����"&Board_Rs(3,i)&"��</option>"
			Else
				For II=2 to Board_Rs(0,i)
				po=Po&"�O"
				Next
				BoardNenu=BoardNenu&"<div class=menuitems><A Href=List.Asp?BoardID="&Board_Rs(1,i)&">"&po&"�� "&Board_Rs(3,i)&"</a></div>"
				BoardSelect=BoardSelect&"<option value='"&Board_Rs(1,i)&"'>&nbsp;&nbsp;"&po&"�� "&Board_Rs(3,i)&"</option>"
			End IF
			Next
			BoardSelect="<select onchange=if(this.options[this.selectedIndex].value!=''){location='list.Asp?boardID='+this.options[this.selectedIndex].value;} style='font-size: 9pt'><option selected>��ת��̳��...</option>"&BoardSelect&"</select>"
			If Ast = 1 Then
			Cache.add BoardNenu,dateadd("n",5000,now)'5000���Ӹ���
			BoardList=BoardNenu
			Else
			Cache.add BoardSelect,dateadd("n",5000,now)
			BoardList=BoardSelect
			End If
		End If
	End Function

	Function Cvt(Tstr,Iflag)
		Select Case Iflag
			Case"1"
				Tstr="<font color=""red""><b>"&Tstr&"</b></font>"
			Case"2"
				Tstr="<font color=""blue""><b>"&Tstr&"</b></font>"
			Case"3"    
				Tstr="<font color=""green""><b>"&Tstr&"</b></font>"
                    
			Case Else
				Tstr=Tstr
		End Select
	Cvt=Tstr
	End Function

	Function GetTimeOver(iflag)
		If iflag=0 Then Exit Function
		Dim tTimeOver
		If iflag = 1 Then
			tTimeOver = FormatNumber((Timer() - StartTime) * 1000, 3, true)
			getTimeOver = " ִ��ʱ�䣺" & tTimeOver & " Ms."
		Else
			tTimeOver = FormatNumber(Timer() - StartTime, 6, true)
			getTimeOver = " ִ��ʱ�䣺" & tTimeOver & " ��"
		End If
	End Function
End Class


Dim YimXu,CookiesName
'��ȡCookies 
CookiesName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(request.ServerVariables("SCRIPT_NAME"),"/"))),""))
YimXu=Request.Cookies(CookiesName)("CookiesDate")
If YimXu>0 Then Response.Cookies(CookiesName).Expires=date+YimXu
%>