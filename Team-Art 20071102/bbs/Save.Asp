<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Md5.Asp"-->
<%
Dim Action,Caption,Content,Face,Page,TmpUbbString
If Not YxBBs.Founduser then YxBBs.Error("����û��ע����ߵ�½��")
IF (Session(YxBBs.CacheName&"SayTime")+Int(YxBBs.BBSSetting(30))/86400)>Now() Then YxBBs.Error("����̳Ϊ�˷�ֹ��ˮ��������ͬһ�˷�����ʱ����Ϊ <Font color=red>"& YxBBs.BBSSetting(30)&"</Font> �룡")
YxBBs.Fun.CheckMake
YxBBs.CheckBoard()

Face=YxBBs.CheckNum(Request.form("face"))
Caption=YxBBs.Fun.GetStr("caption")
Content=YxBBs.Fun.checkbad(YxBBs.Fun.GetStr("content"))
If Caption="" Or Content="" then YxBBs.Error("���������û����д��")
Caption=Jncode(Caption)
Content=Jncode(Content)
Function Jncode(Istr)
Dim japArr,ArrNum
japArr=Array("��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��")
For ArrNum=0 to Ubound(japArr)
Istr=Replace(Istr,japArr(ArrNum),"&#"&AscW(japArr(ArrNum))&";")
Next
Jncode=Istr
End Function
IF Len(Caption)>YxBBs.BoardSetting(2) Then YxBBs.Error("���������ַ���������̳���ƣ�")
IF Len(Content)>YxBBs.BoardSetting(3) Then YxBBs.Error("�����ַ���������̳���ƣ�")
IF Session("CheckCode")<>Request.form("CheckCode") And Cint(YxBBs.BoardSetting(0))=1 then YxBBs.Error("������֤�����")
YxBBs.Head("")
Page=YxBBs.CheckNum(Request.QueryString("page"))
Action=lcase(Request.QueryString("action"))
IF Action="reply" Then
 	Reply()
ElseIf Action="edit" Then
	Edit()
Else
	Say()
End if
If Cint(YxBBs.BoardSetting(0))=1 then Session("CheckCode")=""
Content="<div style='margin:15;line-height: 150%'>"&Content&"</div>"
Call YxBBs.ShowTable(Caption,Content)
Session(YxBBs.CacheName & "SayTime")=Now()
YxBBs.Footer()
Set YxBBs=Nothing

Function CheckUploadType(byval Str)
	Dim pos
	Str=split(Str,"[UPLOAD=")
	If ubound(Str)>=1 then
		pos=instr(str(1),"[/UPLOAD]")
		If pos=0 then exit function
		CheckUploadType=left(str(1),3)
	End if
End function

Sub Say()
	Dim Temp,I,ISvote,TitleType,VoteType,VoteAutoValue,Votes,VoteNum,Outtime,UploadType,TopicLastReply,BoardLastReply,MaxID
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error("��û�з��������Ȩ�ޣ�")
	TmpUbbString=YxBBs.Fun.UbbString(Content)
	IsVote=false
	If instr(","&Join(Split(YxBBs.BoardSetting(1),"|"),",")&",",","&CheckUploadType(Content)&",")>0 then
		UploadType=CheckUploadType(Content)
	Else
		UploadType=""
	End if
	TitleType=YxBBs.CheckNum(request.Form("topicximoo"))
	VoteType=YxBBs.CheckNum(Request.Form("VoteType"))
	VoteAutoValue=YxBBs.CheckNum(Request.Form("AutoValue"))
	If Int(TitleType)<>0 Then
		If Int(YxBBs.MyCoin)<Int(YxBBs.BBSSetting(13)) Then YxBBs.Error("���Ľ�Ǯ������ <font color=#FF0000>"&Int(YxBBs.BBSSetting(13))&"</font> ��!����ʹ����Ŀ����!")
		YxBBs.Execute("Update [YX_user] Set Coin=Coin-"&Int(YxBBs.BBSSetting(13))&" WHERE Name='"&YxBBs.MyName&"'")
	End If
	If VoteType<>2 Then VoteType=1
	For i=1 to VoteAutoValue
	Temp=Left(YxBBs.Fun.Checkbad(Trim(YxBBs.Fun.GetStr("Votes"&I))),250)
	IF not Temp="" Then
		votes=Votes&"|"&Temp
		VoteNum=VoteNum&"|0"
	End If
	Next
	Outtime=cDate(YxBBs.NowBbsTime)+int(Request.form("OutTime"))
	If Votes<>"" Then
		IsVote=True
		'ͶƱȨ��
		If Cint(YxBBs.ClassSetting(7))=0 Then YxBBs.Error("��û�з���ͶƱ��Ȩ�ޣ�")
	End If
	If Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content) Then YxBBs.Error("���������Ѿ������ɹ����벻Ҫ�ظ��ύ��")
	'���������
	TopicLastReply=YxBBs.Myname&"|"&YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Content),40)
	YxBBs.Execute("Insert into [YX_Topic](Caption,Name,Face,IsVote,AddTime,LastTime,Lastreply,UploadType,BoardID,SqlTableID,TitleType)Values('"&Caption&"','"&YxBBs.Myname&"',"&Face&","&IsVote&",'"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"','"&TopicLastReply&"','"&UploadType&"',"&YxBBs.BoardID&","&YxBBs.TB&","&TitleType&")")
	'�õ��·��������ID
	MaxID=YxBBs.Execute("select Max(TopicID) from [YX_Topic]")(0)
	'����ͶƱ
	IF IsVote Then YxBBs.Execute("insert into[YX_TopicVote](TopicID,Vote,VoteNum,VoteType,OutTime)values("&MaxID&",'"&votes&"','"&VoteNum&"',"&votetype&",'"&Outtime&"')")
	'��������
	YxBBs.Execute("Insert into [YX_bbs"&YxBBs.TB&"](TopicID,Caption,name,Content,AddTime,LastTime,Face,BoardID,UbbString,IP)VALUES("&MaxID&",'"&Caption&"','"&YxBBs.MyName&"','"&Content&"','"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"',"&Face&","&YxBBs.BoardID&",'"&TmpUbbString&"','"&YxBBs.MyIP&"')")
	'�����û���Ϣ
	Dim UG
	Set UG = YxBBs.Execute("Select Top 1 GradeNum,GradeName,GradePic,UserMinPostNum from YX_UserGrade Where ClassID="&YxBBs.ClassID&" And UserMinPostNum<="&YxBBs.MyEssayNum&" Order By UserMinPostNum Desc")
	If Not UG.Eof Then
		YxBBs.Execute("Update [YX_User] Set Coin=Coin+"&YxBBs.BBSSetting(37)&",EssayNum=EssayNum+1,GradeNum="&UG(0)&",GradeName='"&UG(1)&"',GradePic='"&UG(2)&"' Where ID="&YxBBs.MyID)
	Else
		YxBBs.Execute("Update [YX_user] set Coin=Coin+"& YxBBs.BBSSetting(37)&",EssayNum=EssayNum+1 WHERE ID="&YxBBs.MyID)
	End If
	UG.Close
	Set UG=nothing
	'���°��
	BoardLastReply=YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(Caption,20)&"|"&YxBBs.NowBbsTime&"|"&Face&"|"&MaxID&"|"&YxBBs.BoardID&"|"&YxBBs.TB
	YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID="&YxBBs.BoardID&" And Depth>0")
	'�����ϼ����
	If YxBBs.BoardDepth>1 Then
		YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
	End If
	'����ϵͳ
	YxBBs.Execute("Update [YX_config] set Topicnum=Topicnum+1,allEssayNum=AllEssayNum+1,TodayNum=TodayNum+1")
	UpdateCache()
	Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content)
	Caption="�����ɹ�"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?ID="&MaxId&"><b>��ҳ�潫��3����Զ����������������ӣ�������ѡ�����²�����</b><br><ul><li><a href=Default.Asp>������ҳ</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?ID="&MaxId&">�ص��㷢������</a></li></ul>"
End Sub

Sub Reply()
	Dim Rs,ID,TopicUserName,TopicLastReply,BoardLastReply,Temp,Quote,QuoteName,Coins
	ID=YxBBs.Checknum(Request.QueryString("Id"))
	Quote=YxBBs.Fun.GetStr("Quote")
	If Trim(Quote)<>"" Then Content=YxBBs.Fun.GetStr("QuoteName") & Quote & "[/quote]" & Content
	If Id=0 or YxBBs.BoardID=0 Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
	TmpUbbString=YxBBs.Fun.UbbString(content)
	Set Rs=YxBBs.Execute("Select Name,IsLock,SqlTableID,BoardID From [YX_Topic] where TopicID="&ID&" And (BoardID="&YxBBs.BoardID&" Or TopType=4 or TopType=5) And SqlTableID="&YxBBs.TB&" And IsDel=False")
	IF Rs.Eof Then YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ��")
	IF YxBBs.MyName=Rs(0) Then
		IF Rs(1) Then YxBBs.Error("�������Ѿ���������")
	End If
	'�ظ�Ȩ��
	If Rs(0)=YxBBs.MyName Then
		If Cint(YxBBs.ClassSetting(4))=0 Then YxBBs.Error("��û�лظ��Լ����ӵ�Ȩ�ޣ�")
	Else
		If Cint(YxBBs.ClassSetting(5))=0 Then YxBBs.Error("��û�лظ��������ӵ�Ȩ�ޣ�")
	End If
	TopicUserName=Rs(0)
	YxBBs.TB=Rs(2)
	YxBBs.BoardID=Rs(3)
	Set RS=Nothing
	If Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content) Then YxBBs.Error("���Ļظ������ɹ����벻Ҫ�ظ��ύ��")
	'��������
	YxBBs.Execute("insert into [YX_bbs"&YxBBs.TB&"](ReplyTopicID,name,Caption,Content,AddTime,LastTime,Face,Boardid,UbbString,ip)VALUES("&ID&",'"&YxBBs.MyName&"','"&Caption&"','"&Content&"','"&YxBBs.NowBbsTime&"','"&YxBBs.NowBbsTime&"',"&face&","&YxBBs.BoardID&",'"&TmpUbbString&"','"&YxBBs.MyIp&"')")
	'������������
	YxBBs.Execute("Update [YX_bbs"&YxBBs.TB&"] Set LastTime='"&YxBBs.NowBbsTime&"' where TopicId="&ID&"")
	'��������
	TopicLastReply=""&YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(YxBBs.Fun.FixReply(Content),40)
	YxBBs.Execute("Update [YX_Topic] set ReplyNum=ReplyNum+1,LastTime='"&YxBBs.NowBbsTime&"',LastReply='"&TopicLastReply&"' where TopicId="&ID&"")
	'���°��
	BoardLastReply=""&YxBBs.MyName&"|"&YxBBs.Fun.StrLeft(Caption,20)&"|"&YxBBs.NowBbsTime&"|"&Face&"|"&ID&"|"&YxBBs.BoardID&"|"&YxBBs.TB
	YxBBs.Execute("Update [YX_Board] set lastReply='"&BoardLastReply&"',TodayNum=TodayNum+1,EssayNum=EssayNum+1 where BoardID="&YxBBs.BoardID&" and Depth<>0")
	If YxBBs.BoardDepth>1 Then
		YxBBs.Execute("Update [YX_Board] set TopicNum=TopicNum+1,TodayNum=TodayNum+1,EssayNum=EssayNum+1,LastReply='"&BoardLastReply&"' where BoardID In ("&YxBBs.BoardParentStr&") And Depth>0")
	End If
	'�����û�
	If Len(Content)<10 Then Coins=0 Else 
	YxBBs.Execute("Update [YX_user] set Coin=Coin+"&YxBBs.BBSSetting(38)&",EssayNum=EssayNum+1 WHERE Name='"&YxBBs.Myname&"'")
	'����¥��
	If Lcase(YxBBs.MyName)<>Lcase(TopicUserName) Then
		YxBBs.Execute("Update [YX_user] set Coin=Coin+"&YxBBs.BBSSetting(38)&" WHERE Name='"&TopicUserName&"'")
	End If
	'����ϵͳ
	YxBBs.Execute("Update [YX_Config] set TodayNum=TodayNum+1,AllEssayNum=AllEssayNum+1")
	UpdateCache()
	Session(YxBBs.CacheName&"SayContent")=Md5(Caption&Content)
	Caption="�ظ��ɹ�"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?id="&ID&"&page="&page&"><b>��ҳ�潫��3����Զ��������ظ�����ҳ�棡������ѡ�����²�����</b><br><ul><li><a href=Default.Asp>������ҳ</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?id="&ID&"&page="&page&">�ص���ظ�������</a></li></ul>"
End Sub

Sub Edit()
	Dim Rs,ID,BbsID,IsTopic,TopicID,TitleType,OldTitleType,EditChalk
	EditChalk=YxBBs.Fun.GetStr("EditChalk")
	ID=YxBBs.CheckNum(Request.QueryString("ID"))
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	If BbsID=0 Or ID=0 Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
	IsTopic=False
	If EditChalk<>"No" Then
	Content=""&Content&vbcrlf&vbcrlf&vbcrlf&"[right][color=#0080FF]�������ӱ� "&YxBBs.MyName&" �� "&YxBBs.NowBbsTime&" �༭����[/color][/right]"
	End If
	TmpUbbString=YxBBs.Fun.UbbString(content)
	Set Rs=YxBBs.Execute("select Name,TopicID,ReplyTopicID from [YX_bbs"&YxBBs.TB&"] where BbsID="&BbsID&"")
	If Not Rs.eof  Then
		If Lcase(YxBBs.MyName)<>Lcase(rs("name")) Then
			If Cint(YxBBs.ClassSetting(18))=0 Then YxBBs.Error("��û�б༭�������ӵ�Ȩ�ޣ�")
		Else
			'�༭�Լ����ӵ�Ȩ��
			If Cint(YxBBs.ClassSetting(9))=0 Then YxBBs.Error("��û�б༭�Լ����ӵ�Ȩ�ޣ�")
		End If
		IF Rs("ReplyTopicID")=0 Then
			TopicID=Rs("TopicID")
			IsTopic=True
		End IF
		Rs.Close
	Else
		YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ����")
	End if
	YxBBs.Execute("Update [YX_bbs"&YxBBs.TB&"] set Caption='"&Caption&"',Content='"&Content&"',Face="&Face&",LastTime='"&YxBBs.NowBbsTime&"',UbbString='"&TmpUbbString&"' where BbsID="&BbsID&"")
	If IsTopic then
		TitleType=YxBBs.CheckNum(Request.Form("topicximoo"))
		OldTitleType=YxBBs.CheckNum(Request.Form("OldTitleType"))
		If Cint(TitleType)<>0 and Cint(OldTitleType)=0 Then
			If Cint(YxBBs.MyCoin)<Cint(YxBBs.BBSSetting(13)) Then YxBBs.Error("���Ľ�Ǯ������ <font color=#FF0000>"&Cint(YxBBs.BBSSetting(13))&"</font> ��!����ʹ����Ŀ����!")
			YxBBs.Execute("Update [YX_User] Set Coin=Coin-"&Cint(YxBBs.BBSSetting(13))&" WHERE Name='"&YxBBs.MyName&"'")
		End If
		YxBBs.Execute("Update [YX_Topic] set Caption='"&Caption&"',Face="&Face&",LastTime='"&YxBBs.NowBbsTime&"',TitleType="&TitleType&" where TopicID="&TopicID&"")
	End if
	Caption="�޸ĳɹ�"
	Content="<meta http-equiv=refresh content=3;url=Show.Asp?id="&ID&"&page="&page&">��ҳ�潫��3����Զ��������༭�����ӣ�<b>������ѡ�����²�����</b><br><ul><li><a href=Default.Asp>������ҳ</a><li></li><a href=list.Asp?BoardID="&YxBBs.BoardID&">"&YxBBs.Boardname&"</a></li><li><a href=Show.Asp?id="&ID&"&page="&page&">�ص���༭������</a></li></ul>"
End Sub

Sub UpdateCache()
	Dim Temp
	Temp=YxBBs.TodayNum+1
	If Int(Temp)>Int(YxBBs.MaxEssayNum) Then
		YxBBs.Execute("Update [YX_Config] set MaxEssayNum="&Temp&"")
	End If
	Session(YxBBs.CacheName & "MyInfo") = Empty
	'����ϵͳ
	Cache.Name="Config"
	Cache.clean()
	'���°��
	Cache.Name="BoardInfo"
	Cache.clean()
End Sub
%>