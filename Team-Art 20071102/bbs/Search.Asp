<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="inc/Page_Cls.Asp"-->
<%
Dim Action,Key,strPageInfo
If Not YxBBs.Founduser Then YxBBs.Error("����û��ע����ߵ�½��")
If YxBBs.BoardID >0 Then YxBBs.CheckBoard()
Call YxBBs.Head("��̳����")
Key=GetKey("Key")
If len(Key)>20 Then YxBBs.Error("�����ؼ��ֳ��������ƣ�")
If Key<>"" Then
	SearchList()
Else
	Main()
End If
YxBBs.Footer()
Set YxBBs=Nothing

Sub ListTop()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("�����б�����")
	Temp=Replace(Temp,"{����}","�����ؼ��� <font color=red><u>"&Key&"</U></font>" )
	Response.Write Temp
End Sub

Sub ListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("�����б��ײ�")
	Temp=Replace(Temp,"{��ҳ}",strPageInfo)
	Response.Write Temp
End Sub

Function CheckKey(Keys)
	Keys=Replace(Keys,"#","")
	Keys=Replace(Keys,"  "," ")
	Keys=Replace(Keys,"]","")
	Keys=Replace(Keys,"[","[[]")
	Keys=Replace(Keys,"%","[%]")
	CheckKey=Replace(Keys,"_","[_]")
End Function

Function SplitKey(Col,Key)
	Dim KeyNum,Keys
	Keys=Split(Key," ")
	For KeyNum=0 To Ubound(Keys)
		SplitKey=SplitKey&Col&" like '%"&CheckKey(Keys(KeyNum))&"%' Or "
	Next
	SplitKey="("&Left(SplitKey,Len(SplitKey)-4)&")"
End Function

Sub SearchList()
	Dim intPageNow,arr_Rs,i,Pages,TopicImg,Conut,page
	Dim SType,STime,SQLwhere
	Dim Temp,TopicS,Caption,Content,Facepic,Moodpic,LastRe,RePageUrl,UploadType,RePage,leftn,ii,NoShow,IsSearchInfo
	SType=YxBBs.CheckNum(Request.QueryString("SType"))
	STime=YxBBs.CheckNum(Request.QueryString("STime"))
	If SType=1 Then
		Sqlwhere=SplitKey("Name",Key)
	ElseIf SType=3 Then
		Sqlwhere=SplitKey("Caption",Key)&" or "&SplitKey("Name",Key)
	Else
		Sqlwhere=SplitKey("Caption",Key)
	End If
	If STime<>0 Then Sqlwhere=Sqlwhere&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')<"&STime
	If YxBBs.BoardID >0 Then
		Sqlwhere=sqlwhere&" And (BoardID="&YxBBs.BoardID&" or TopType=5)"
	End If
	Sqlwhere=Sqlwhere&" and SqlTableID="&YxBBs.TB&" and IsDel=False"
	IsSearchInfo=False
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Topic]"
	Pages.strPageUrl = "?Action="&Action&"&Key="&Key&"&SType="&SType&"&TB="&YxBBs.TB&"&STime="&STime&"&BoardID="&YxBBs.BoardID
	Pages.strFieldsList = "TopicID,Face,Caption,Name,TopType,IsGood,AddTime,BoardID,LastTime,Hits,LastReply,UploadType,IsVote,ReplyNum,SqlTableID,IsLock"
	Pages.strCondiction = SqlWhere
	Pages.strOrderList = "TopicID desc"
	Pages.strPrimaryKey = "TopicID"
	Pages.intPageSize = Int(YxBBs.BBSSetting(26))
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "Search"&SType&STime&YxBBs.BoardID&YxBBs.TB
	Pages.Reloadtime=0
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
		TopicImg=Split(YxBBs.Template.ReadTemplate("����״̬ͼƬ"),"|")
		NoShow=YxBBs.NoShowTopic()
		For i = 0 to UBound(Arr_Rs, 2)
			If InStr(NoShow,","&Arr_Rs(7,I)&",")=0 Then
				IsSearchInfo=True
				Facepic="<img src='Images/face/"&Arr_Rs(1,i)&".gIf'>"
				Moodpic=TopicImg(6)
				If Arr_Rs(13,i) > Int(YxBBs.BBSSetting(24)) Then Moodpic=TopicImg(5)
				If Arr_Rs(5,i) Then Moodpic=TopicImg(3)
				If Arr_Rs(15,i) Then Moodpic=TopicImg(7)
				If Arr_Rs(12,i) Then Moodpic=TopicImg(4)
				If Arr_Rs(4,i)=5 Then Moodpic=TopicImg(0)
				If Arr_Rs(4,i)=4 Then Moodpic=TopicImg(1)
				If Arr_Rs(4,i)=3 Then Moodpic=TopicImg(2)
				UploadType=""
				If Arr_Rs(11,i)<>"" Then Uploadtype="<img src='Images/FileType/"&Arr_Rs(11,i)&".gif' border=0> "
				LastRe=split(Arr_Rs(10,i),"|")
				RePage=Arr_Rs(13,i)\10
				If RePage<Arr_Rs(13,i)/10 Then RePage=RePage+1
				RePageUrl="Show.Asp?ID="&Arr_Rs(0,i)
				leftn=40
				If RePage>1 Then leftn=36
				Caption=UploadType
				Caption=Caption&"<a href="&Repageurl&" title='����ʱ�䣺"&Arr_Rs(6,i)&"<br>���ظ���"&YxBBs.Fun.StrLeft(LastRe(1),20)&"'>"& Replace(YxBBs.Fun.StrLeft(Arr_Rs(2,i),leftn),Key,"<font color=red>"&Key&"</font>")&"</a>"
				If Repage>1 Then
					Caption=Caption&" <a href='"&RePageurl&"&page="&RePage&"'>[<font color=#FF0000>"&RePage&"</font>]</a>"
				End If
				If Datediff("n",Arr_Rs(8,i),YxBBs.NowbbsTime)<=180 Then Caption=Caption&TopicImg(8)
				Temp=YxBBs.Template.ReadTemplate("�����б�")
				Temp=Replace(Temp,"{״̬}",Moodpic)
				Temp=Replace(Temp,"{����}",Caption)
				Temp=Replace(Temp,"{����}",Facepic)
				Temp=Replace(Temp,"{�û�����}","<a href='Profile.Asp?name="&Arr_Rs(3,i)&"' title='�鿴 "&Arr_Rs(3,i)&" ������'>"&Replace(Arr_Rs(3,i),Key,"<font color=red>"&Key&"</font>")&"</a>")
				Temp=Replace(Temp,"{�ظ���}",Arr_Rs(13,i))
				Temp=Replace(Temp,"{�����}",Arr_Rs(9,i))
				Temp=Replace(Temp,"{���ʱ��}","<font title='ʱ�䣺"&FORMATDATETIME(Arr_Rs(8,i),3)&"'>"&Datepart("yyyy",Arr_Rs(8,i))&"-"&Right(00&Datepart("m",Arr_Rs(8,i)),2)&"-"&Right(00&Datepart("D",Arr_Rs(8,i)),2)&"</font>")
				Temp=Replace(Temp,"{�ظ��û�����}","<a href='Profile.Asp?name="&LastRe(0)&"' title='�鿴 "&LastRe(0)&" ������'>"&LastRe(0)&"</a>")
				TopicS=TopicS&Temp
			End If
		Next
	End If
	If IsSearchInfo Then
		ListTop()
		Response.Write(TopicS)
		ListBottom()
	Else
		Caption="��̳����"
		Content="<div style='margin: 10;line-height:150%'>�ؼ���<font color='red'> "&YxBBs.Fun.HtmlCode(key)&" </font>�Ҳ����κν����&nbsp;&nbsp;&nbsp;&nbsp;<li><a href=javascript:history.go(-1)>������һҳ</a><li><a href=Search.Asp>���¸߼�����</a><div>"
		Call YxBBs.ShowTable(Caption,Content)
	End If
End Sub

Sub Main()
	Dim Caption,Content
	Content="<form method='get' style='margin:0'><tr><td width='30%' height=30 align='right'>�����ؼ��֣�</td><td width='70%'>&nbsp;<input type='text' name='Key' size=52 onkeyup=""ValidateTextboxAdd(this,'BtnSearch')"" onpropertychange=""ValidateTextboxAdd(this,'BtnSearch')""></td></tr>"&_
	"<tr><td height='30' align='right'>�������ͣ�</td><td width='61%'>&nbsp;<input type='radio' value='1'  name='SType'> ���������� <input type='radio' name='SType' value='2'> ���������� <input type='radio' checked name='SType' value='3'>���߾���</td></tr>"&_
	"<tr><td height='30' align='right'>�������ڷ�Χ��</td><td >&nbsp;<select size='1' name='STime'><option selected value='0'>��������</option><option value='1'>1������</option><option value='2'>2������</option><option value='7'>7������</option><option value='15'>15������</option><option value='30'>30������</option></select></td></tr>"&_
	"<tr><td height='30' align='right'>�������ݱ���Χ��</td><td>&nbsp;"&TBList&"</td></tr>"&_
	"<tr><td height='30' align='right'>��������̳��</td><td>&nbsp;<select name='BoardID'><option value='0'>����ȫ����̳...</option>"& YxBBs.BoardIDList(0,0)&"</select></td></tr>"&_
	"<tr><td height='30' align='center' colspan='2'><input type='submit' value=' �� ʼ �� �� ' ID='BtnSearch' disabled><input type='hidden' value='Topic' name='Action'></td></tr></form>"
	Caption="��̳����"
	Call YxBBs.ShowTable(Caption,Content)
End Sub

Function GetKey(str)
	Str=Request(str)
	Str=Replace(str,"'","")
	Str=Replace(str,chr(34)&chr(34),"")
	str=Replace(str,"[","[[]")
	GetKey=str
End Function

Function TBList()
	Dim AllTable,I,Temp
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		Temp=Temp&"<option value='"&AllTable(i)&"' " 
		If AllTable(i)=YxBBs.TB Then Temp=Temp&"selected"
		Temp=Temp&">���ݱ� "&AllTable(i)&"</option>"
	next
	TBList="<select name='TB'>"&Temp&"</select>"
End Function
%>