<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<%
Dim PageString,strPageInfo
YxBBs.CheckBoard()
YxBBs.Head("")
If YxBBs.BoardChild>0 Then PageString=ShowBoard()
If YxBBs.BoardDepth>0 Then
	PageString=PageString&ShowListTop()&ShowTopic()&ShowListBottom()
Else
	PageString=PageString&YxBBs.Template.ReadTemplate("��ҳͼ��")
End If
Response.Write(PageString)
YxBBs.Footer()
Set YxBBs=Nothing
'����¼���̳
Function ShowBoard()
	Dim Temp,i,BoardTop,BoardList,BoardBottom,BoardStr
	BoardTop=YxBBs.Template.ReadTemplate("��������")
	BoardList=YxBBs.Template.ReadTemplate("����б�")
	BoardBottom=YxBBs.Template.ReadTemplate("�����ײ�����")
	For i=0 To Ubound(YxBBs.Board_Rs,2)
		Temp=""
		If Int(YxBBs.Board_Rs(1,i))=YxBBs.BoardID Then
			Temp = Temp & Replace(BoardTop,"{��������}",YxBBs.Board_Rs(3,i))
		ElseIf YxBBs.Board_Rs(2,i)=YxBBs.BoardID Then
			Temp=BoardList
			Temp=YxBBs.GetBoardInfo(Temp,i)
		End If
		BoardStr=BoardStr & Temp
	Next
	ShowBoard = BoardStr& BoardBottom & VbCrlf
End Function

Function Showonline()
	Dim Temp,BoardOnline,BoardUserOnline
	Temp=YxBBs.Template.ReadTemplate("�������")
	Temp=Replace(Temp,"{�����б�}","<span id=showon></span>")
	BoardOnline=YxBBs.Execute("select count(ID) from [YX_online] where BoardID="&YxBBs.BoardID&"")(0)
	Temp=Replace(Temp,"{������Ϣ}","��̳�����ߣ�<b>"&YxBBs.AllOnlineNum&"</b>�ˣ��������ߣ�<b>"&BoardOnline&"</b>�ˣ�������<b> "&YxBBs.UserOnlineNum&"</b> ��Ա�� <b>"&BoardOnline-YxBBs.UserOnlineNum&"</b> �ο����ߡ������������<Font color=red>"&YxBBs.BoardTodayNum&"</Font>ƪ ")
	If Session(YxBBs.CacheName&"online")="1" then
		Temp=Replace(Temp,"{�����б�����}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"' onClick='ShowOnline();' ><span id='Showtxt' >�ر���ϸ�б�</span></a>")
		Temp=Temp&"<iframe name='hiddenframe' frameborder='0'  height='0' src='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"&id=1' id='hiddenframe'></iframe>"
	Else
		Temp=Replace(Temp,"{�����б�����}","<a target='hiddenframe' href='Online.Asp?Action=LoadIng&BoardID="&YxBBs.BoardID&"' onClick='ShowOnline();' ><span id='Showtxt' >��ʾ��ϸ�б�</span></a>")
		Temp=Temp&"<iframe name='hiddenframe' frameborder='0' height='0' id='hiddenframe'></iframe>"	
	End If
	ShowOnline=Temp
End Function

Function ShowListTop()
	Dim Temp,Button,PostPic
	PostPic=Split(YxBBs.Template.ReadTemplate("����ͼƬ"),"||")
	Button="<a href='Say.Asp?BoardID="&YxBBs.BoardID&"'>"&PostPic(0)&"</a> <a href='Say.Asp?action=vote&BoardID="&YxBBs.BoardID&"'>"&PostPic(1)&"</a>"
	Temp=YxBBs.Template.ReadTemplate("�����б�����")
	Temp=Replace(Temp,"{������ť}",Button)
	Temp=Replace(Temp,"{����}",YxBBs.BoardAdmin)
	Temp=Replace(Temp,"{���ID}",YxBBs.BoardID)
	Temp=Replace(Temp,"{���ݱ�ID}",YxBBs.TB)
	Temp=Replace(Temp,"{����}",YxBBs.Placard(YxBBs.BoardID))
	If YxBBs.BBSSetting(10)="0" then Temp=Replace(Temp,"{��ʾ����}",ShowOnline()) Else Temp=Replace(Temp,"{��ʾ����}","")
	ShowListTop=Temp
End Function

Function ShowListBottom()
	Dim Temp,StrSearch
	StrSearch="<form name=search method=""post"" style=""margin:0"" action=""Search.Asp?SType=2&STime=0&tb="&YxBBs.TB&"&BoardID="&YxBBs.BoardID&""">���������� <input name=""Key"" size=20 onkeyup=""ValidateTextboxAdd(this,'BtnSearch')"" onpropertychange=""ValidateTextboxAdd(this,'BtnSearch')""> <input name=""BtnSearch"" type=submit  value=' �� �� ' disabled></form>"
	Temp=YxBBs.Template.ReadTemplate("�����б��ײ�")
	Temp=Replace(Temp,"{��ҳ}",strPageInfo)
	Temp=Replace(Temp,"{��������}",StrSearch)
	Temp=Replace(Temp,"{��������б�}",YxBBs.BoardList(2))
	ShowListBottom=Temp
End Function

Function ShowTopic()
	Dim intPageNow,arr_Rs,i,Pages,TopicImg,Conut,page
	Dim Temp,TopicS,Caption,Facepic,Moodpic,LastRe,RePageUrl,UploadType,RePage,leftn,ii
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Topic]"
	Pages.strPageUrl = "?BoardID="&YxBBs.BoardID
	Pages.strFieldsList = "TopicID,Face,Caption,Name,TopType,IsGood,AddTime,BoardID,LastTime,Hits,LastReply,UploadType,IsVote,ReplyNum,SqlTableID,IsLock,TitleType"
	Pages.strCondiction = "(BoardID="&YxBBs.BoardID&" or TopType=4 or TopType=5) And IsDel=False "
	Pages.strOrderList = "TopType desc,LastTime desc"
	Pages.strPrimaryKey = "TopicID"
	Pages.intPageSize = Int(YxBBs.BBSSetting(26))
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "BBSList"&YxBBs.BoardID'�ͻ��˼�¼����
	Pages.Reloadtime=3'ÿ�����Ӹ���Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
		TopicImg=Split(YxBBs.Template.ReadTemplate("����״̬ͼƬ"),"|")
		For i = 0 to UBound(Arr_Rs, 2)
			Moodpic=TopicImg(6)
			If Arr_Rs(13,i) > Int(YxBBs.BBSSetting(24)) Then Moodpic=TopicImg(5)
			If Arr_Rs(5,i) Then Moodpic=TopicImg(3)'����
			If Arr_Rs(15,i) Then Moodpic=TopicImg(7)'����
			If Arr_Rs(12,i) Then Moodpic=TopicImg(4)'ͶƱ
			If Arr_Rs(4,i)=5 Then Moodpic=TopicImg(0)'�ܶ�
			If Arr_Rs(4,i)=4 Then Moodpic=TopicImg(1)'����
			If Arr_Rs(4,i)=3 Then Moodpic=TopicImg(2)'��
			If Arr_Rs(4,i)<>4 or (Arr_Rs(4,i)=4 And InStr(YxBBs.BoardRoots,"|"&Arr_Rs(7,i)&"|"))>0 Then
				Facepic="<img src='Images/face/"&Arr_Rs(1,i)&".gIf'>"
				UploadType=""
				If Arr_Rs(11,i)<>"" Then Uploadtype="<img src='Images/FileType/"&Arr_Rs(11,i)&".gif' border=0> "
				LastRe=split(Arr_Rs(10,i),"|")
				RePage=(Arr_Rs(13,i)+1)\10
				If RePage<(Arr_Rs(13,i)+1)/10 Then RePage=RePage+1
				RePageUrl="Show.Asp?ID="&Arr_Rs(0,i)
				leftn=40
				If RePage>1 Then leftn=36
				Caption=UploadType
				Caption=Caption&"<a href="&Repageurl&">"&YxBBs.Cvt("<span title='����ʱ�䣺"&Arr_Rs(6,i)&"<br>���ظ���"&YxBBs.Fun.StrLeft(LastRe(1),20)&"'>"&YxBBs.Fun.StrLeft(Arr_Rs(2,i),leftn)&"</span>",Arr_Rs(16,i))&"</a>"
				If Repage>1 Then
					Caption=Caption&" <a href='"&RePageurl&"&page="&RePage&"'>[<font color=#FF0000>"&RePage&"</font>]</a>"
				End If
				If Datediff("n",Arr_Rs(8,i),YxBBs.NowbbsTime)<=180 Then Caption=Caption&" "&TopicImg(8)
				Temp=YxBBs.Template.ReadTemplate("�����б�")
				Temp=Replace(Temp,"{״̬}",Moodpic)
				
				Temp=Replace(Temp,"{����}",Facepic)
				Temp=Replace(Temp,"{�û�����}","<a href='Profile.Asp?name="&Arr_Rs(3,i)&"' title='�鿴 "&Arr_Rs(3,i)&" ������'>"&Arr_Rs(3,i)&"</a>")
				Temp=Replace(Temp,"{�ظ���}",Arr_Rs(13,i))
				Temp=Replace(Temp,"{�����}",Arr_Rs(9,i))
				Temp=Replace(Temp,"{���ʱ��}","<font title='ʱ�䣺"&FORMATDATETIME(Arr_Rs(8,i),3)&"'>"&Datepart("yyyy",Arr_Rs(8,i))&"-"&Right(00&Datepart("m",Arr_Rs(8,i)),2)&"-"&Right(00&Datepart("D",Arr_Rs(8,i)),2)&"</font>")
				Temp=Replace(Temp,"{�ظ��û�����}","<a href='Profile.Asp?name="&LastRe(0)&"' title='�鿴 "&LastRe(0)&" ������'>"&LastRe(0)&"</a>")
                                Temp=Replace(Temp,"{����}",Caption)
				TopicS=TopicS&Temp
			End If
		Next
	End If
	ShowTopic=TopicS
End Function
%>