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
	IF Rs.eof then YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ����")
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
		If Cint(YxBBs.ClassSetting(1))=0 Then YxBBs.Error("��û�в鿴�������ӵ�Ȩ�ޣ�")
		If TopicIsGood Then If Cint(YxBBs.ClassSetting(2))=0 Then YxBBs.Error("��û������������ӵ�Ȩ�ޣ�")
	End If
	IF TopicIsGood Then If YxBBs.BBSSetting(34)="1" And Not YxBBs.FoundUser Then YxBBs.Error("��û������������ӵ�Ȩ�ޣ�")
End Sub

Function TopicMood()
	Dim Temp,TopicImg
	TopicImg=Split(YxBBs.Template.ReadTemplate("����״̬ͼƬ"),"|")
	IF TopicIsGood Then Temp="<td>"&TopicImg(3)&" <font color=red>��������</font></td>"
	IF TopicIsVote then Temp=Temp&"<td>"&TopicImg(4)&" <font color=red>ͶƱ����</font></td>"
	IF TopicIsLock then Temp=Temp&"<td>"&TopicImg(7)&" <font color=red>��������</font></td>"
	IF TopicTopType=3 then Temp=Temp&"<td>"&TopicImg(2)&" <font color=red>�ö�����</font></td>"
	IF TopicTopType=4 then Temp=Temp&"<td>"&TopicImg(1)&" <font color=red>���ö�����</font></td>"
	IF TopicTopType=5 then Temp=Temp&"<td>"&TopicImg(0)&" <font color=red>���ö�����</font></td>"
	IF Temp<>"" Then Temp="<Div  align='right'><table border=1 style='border-collapse: collapse' cellpadding='5' cellspacing='0' bordercolor=#DEDEDE bgcolor=ffffff><tr>"&Temp&"</tr></table></div>"
	TopicMood=Temp
End Function

Function ShowListTop()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("���Ӷ���")
	Temp=Replace(Temp,"{������ť}",SayBar())
	Temp=Replace(Temp,"{�����}",TopicHits+1)
	Temp=Replace(Temp,"{����}",TopicCaption)
        Temp=Replace(Temp,"{����}",SetTopic())
	Response.Write(Temp)
End Function

Function ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("���ӵײ�")
	Temp=Replace(Temp,"{��ҳ}",PageInfo)
	Response.Write(Temp)
End Function

Function SayBar()
	Dim Temp,PostPic
	PostPic=Split(YxBBs.Template.ReadTemplate("����ͼƬ"),"||")
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
		ClueTxt="�㻹û�е�½�����ܽ���ͶƱ��"
		CanVote=False
	Else
		IF not YxBBs.Execute("Select User From [YX_TopicVoteUser] where User='"&YxBBs.MyName&"' and TopicID="&ID&"").eof then
			ClueTxt="���Ѿ�Ͷ��Ʊ�ˣ�������ͶƱ�ˡ�[<a style='cursor:hand;color:red;' onclick=javascript:window.open('See.Asp?Action=Vote&Id="&Arr_Rs(0,0)&"','open','width=550,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes')>����</a>]"
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
		VoteShow=VoteShow&"<tr><td width='5%' height=25 >&nbsp;"&i&"</td><td width='40%'>&nbsp;"&Opt&""&YxBBs.Fun.HtmlCode(Vote(i))&"</td><td width='35%' >&nbsp;<img border=0 height=8 width=2 src=Images/line.gif><img border=0 height=8 width='"&VotePicW&"%' src='Images/hr"&ii&".gif'> <b>"&VoteNum(i)&"</b> Ʊ</td></tr>"
	Next
	If DateDiff("s",YxBBs.NowBbsTime,Arr_Rs(4,0))<0 then
		ClueTxt="��ͶƱ�Ѿ����ڣ����ܽ���ͶƱ��"
		CanVote=False
	End If
	IF CanVote then
		ClueTxt="<input type='submit' value='Ͷ Ʊ (ͶƱ���ܿ��꾡���)'>"
	End IF
	ClueTxt=ClueTxt&" [ ��ֹʱ�䣺"&Arr_Rs(4,0)&" ]"
	Temp=YxBBs.Template.ReadTemplate("��ʾͶƱ")
	Temp=Replace(Temp,"{ͶƱѡ��}","<form style='margin:0' method=POST action=VoteSubmit.Asp?Action=Vote&id="&ID&"&type="&Arr_Rs(3,0)&">"&VoteShow)
	Temp=Replace(Temp,"{ͶƱ��Ϣ}",ClueTxt&"</form>")
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
	Template=YxBBs.Template.ReadTemplate("������Ϣ")
	TempLink=Split(YxBBs.Template.ReadTemplate("������Ϣ����"),"||")
	
	If IsArray(Arr_Rs) Then
		Lou = (Page-1)*10
		For i = 0 to UBound(Arr_Rs,2)
			UserName=Arr_Rs(11,i)
			BBSID=Arr_Rs(0,i)
			YxBBs_ubb.UbbString=Arr_Rs(8,i)
			Temp=Replace(Template,"{��Ϣ}",TempLink(0))
			Temp=Replace(Temp,"{����}",TempLink(1))
			If YxBBs.Fun.GetSqlStr(Arr_Rs(13,i))<>"" Then
				Temp=Replace(Temp,"{QQ}",Replace(TempLink(2),"{QQ}",YxBBs.Fun.GetSqlStr(Arr_Rs(13,i))))
			Else
				Temp=Replace(Temp,"{QQ}","")
			End If
			
			If YxBBs.Fun.GetSqlStr(Arr_Rs(21,i))<>"" Then
				Temp=Replace(Temp,"{����}",Replace(TempLink(3),"{����}",YxBBs.Fun.GetSqlStr(Arr_Rs(21,i))))
			Else
				Temp=Replace(Temp,"{����}","")
			End If
			If YxBBs.Fun.GetSqlStr(Arr_Rs(22,i))<>"" Then
				Temp=Replace(Temp,"{��ҳ}",Replace(TempLink(4),"{��ҳ}",YxBBs.Fun.GetSqlStr(Arr_Rs(22,i))))
			Else
				Temp=Replace(Temp,"{��ҳ}","")
			End If
			Temp=Replace(Temp,"{�༭}",TempLink(5))
			Temp=Replace(Temp,"{����}",TempLink(6))
			If Arr_Rs(1,i)=ID Then
				Temp=Replace(Temp,"{ɾ��}","")
				Temp=Replace(Temp,"{¥��}","¥ ��")
				ShowCaption=TopicCaption
				ShowMood=TopicMood()
			Else
				ShowCaption="":ShowMood=""
				Temp=Replace(Temp,"{¥��}","�� <font color=#FF0000>"&Lou+i&"</font> ¥")
				Temp=Replace(Temp,"{ɾ��}",TempLink(7))
			End If
			Temp=Replace(Temp,"{���ݱ�ID}",YxBBs.TB)
			Temp=Replace(Temp,"{���ID}",YxBBs.BoardID)
			Temp=Replace(Temp,"{����ID}",ID)
			Temp=Replace(Temp,"{ҳ��}",page)
			Temp=Replace(Temp,"{����ID}",Arr_Rs(0,i))
			Temp=Replace(Temp,"{�û�����}",Arr_Rs(11,i))
			Temp=Replace(Temp,"{����ʱ��}",Arr_Rs(6,i))
			IF YxBBs.ClassID>2 then
				Temp=Replace(Temp,"{�û�IP}",YxBBs.Fun.GetIp(Arr_Rs(9,i),2))
			Else
				Temp=Replace(Temp,"{�û�IP}",YxBBs.Fun.GetSqlStr(Arr_Rs(9,i)))
			End If
			Temp=Replace(Temp,"{������}",YxBBs.Fun.GetSqlStr(Arr_Rs(24,i)))
			Temp=Replace(Temp,"{��Ǯ��}",YxBBs.Fun.GetSqlStr(Arr_Rs(25,i)))
			Temp=Replace(Temp,"{�ȼ�ͼƬ}","<img src='"&Arr_Rs(19,i)&"' alt="&Arr_Rs(18,i)&" Align=center>")
			Temp=Replace(Temp,"{�ȼ�����}","<b>"&Arr_Rs(18,i)&"</b>")
			If Arr_Rs(33,i)<>"" Then
				Temp=Replace(Temp,"{ͷ��}","ͷ�Σ�"&YxBBs.Fun.GetSqlStr(Arr_Rs(33,i))&"<br>")
			Else
				Temp=Replace(Temp,"{ͷ��}","ͷ�Σ�δ����<br>")
			End If
			If Arr_Rs(34,i)<>"" Then
				Temp=Replace(Temp,"{����}","���ɣ�"&YxBBs.Fun.GetSqlStr(Arr_Rs(34,i))&"<br>")
			Else
				Temp=Replace(Temp,"{����}","���ɣ�δ����<br>")
			End If
			If IsOnline(Arr_Rs(11,i)) Then
				If Arr_Rs(23,i) Then
					Temp=Replace(Temp,"{�Ա�}","<img src='Images/11.gif' alt='�Ա���<br>״̬������<br>��ʱ��" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				Else
					Temp=Replace(Temp,"{�Ա�}","<img src='Images/01.gif' alt='�Ա�Ů<br>״̬������<br>��ʱ��" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				End If
			Else
				If Arr_Rs(23,i) Then
					Temp=Replace(Temp,"{�Ա�}","<img src='Images/10.gif' alt='�Ա���<br>״̬������<br>��ʱ��" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				Else
					Temp=Replace(Temp,"{�Ա�}","<img src='Images/00.gif' alt='�Ա�Ů<br>״̬������<br>��ʱ��" &YxBBs.Fun.DateToSting(Arr_Rs(35,i))&"' align='absmiddle'>")
				End If
			End If
			Temp=Replace(Temp,"{����}",Arr_Rs(20,i))
			Temp=Replace(Temp,"{ע��ʱ��}",formatdatetime(Arr_Rs(27,i),2))
			IF Arr_Rs(12,i) then
				Temp=Replace(Temp,"{�û�ͷ��}","<img src='http://qqshow-user.tencent.com/"&Arr_Rs(13,i)&"/10/'>")
			else
				Temp=Replace(Temp,"{�û�ͷ��}","<img border='0' src='"&Arr_Rs(14,i)&"' width="&Arr_Rs(15,i)&" height="&Arr_Rs(16,i)&">")
			End If
			Sign=Arr_Rs(26,i)
			IF Arr_Rs(28,i) then
				Temp=Replace(Temp,"{��������}","<Hr Size=1><Font Color=red>���û������ѱ�����Ա���Σ���͹���Ա��ϵ</Font><Hr Size=1>")
				Temp=Replace(Temp,"{ǩ��}","��ǩ�������ѹ���Ա���Ρ�")
			Else
				IF YxBBs.BBSSetting(12)="1" then Sign="" 
				IF Arr_Rs(30,i) Then Sign="��ǩ�����ѱ�����Ա���Ρ�"
				IF isNull(sign) or sign="" then
					Temp=Replace(Temp,"{ǩ��}",YxBBs.BBSName&"��ӭ����")
				Else
					Temp=Replace(Temp,"{ǩ��}",YxBBs_ubb.Sign_Code(Sign))
				End IF
				Temp=Replace(Temp,"{��������}",ShowMood&"<SPAN style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all;width:100%'><img src='Images/face/"&Arr_rs(2,i)&".gif'> <b>"&ShowCaption&"</b><br><br>"&YxBBs_ubb.UBB(Arr_Rs(4,i),1)&"</SPAN>")
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
		Cache.add Temp,dateadd("n",5,YxBBs.NowBBSTime)'5����
	End If
	If InStr(Lcase(Temp),","&Lcase(TUserName)&",")>0 Then IsOnline=true
End Function

Function SetTopic()
	Dim Temp,Url
	If Not YxBBs.FoundUser Then Exit Function
	Url="admin.Asp?BoardID="&YxBBs.BoardID&"&ID="&ID&"&TB="&YxBBs.TB&"&Action="
        
	IF TopicTopType=5 then Temp="<div class=menuitems><a href="&Url&"ȡ�����ö�>ȡ�����ö�</a></div>" Else Temp="<div class=menuitems><a href="&Url&"���ö�>��Ϊ���ö�</a></div>"
	IF TopicTopType=4 Then Temp=Temp&"<div class=menuitems><a href="&Url&"ȡ�����ö�>ȡ�����ö�</a></div>" ELse Temp=Temp&"<div class=menuitems><a href="&Url&"���ö�>��Ϊ���ö�</a></div>"
	IF TopicTopType=3 Then Temp=Temp&"<div class=menuitems><a href="&Url&"ȡ���ö�>ȡ���ö�</a></div>" ELse Temp=Temp&"<div class=menuitems><a href="&Url&"�ö�>��Ϊ�ö�</a></div>"
	IF TopicIsGood Then Temp=Temp&"<div class=menuitems><a href="&Url&"ȡ������>ȡ������</a></div>" Else Temp=Temp&"<div class=menuitems><a href="&Url&"����>��Ϊ����</a></div>"
	IF TopicIsLock Then Temp=Temp&"<div class=menuitems><a href="&Url&"����>�������</a></div>" Else Temp=Temp&"<div class=menuitems><a href="&Url&"����>��������</a></div>"
	Temp=Temp&"<div class=menuitems><a href="&Url&"ɾ������>ɾ������</a></div><div class=menuitems><a href="&Url&"�ƶ�>�ƶ�����</a></div><div class=menuitems><a href="&Url&"����>��������</a></div>"
       Temp="<a onmouseover=""showmenu(event,'"&Temp&"')""><font color=blue>�������</font></a>"
	SetTopic=Temp
End Function

Function FastReply()
	If Not YxBBs.FoundUser Then Exit Function
	IF Not TopicIsLock Or YxBBs.ClassID=1 then
		Dim Caption,Content
		Caption="���ٻظ���<a href='Say.Asp?action=reply&BoardID="&YxBBs.BoardID&"&id="&ID&"'>�߼��ظ�</a>��"
		Content="<div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div>"&_
		"<form style='margin: 8;' method='POST' name='yimxu' onsubmit='if(content.value==""""){alert(""����û����д��������!"");content.focus();return (false);};"
		If Cint(YxBBs.BoardSetting(0))=1 then Content=Content&"if(CheckCode.value==""""){alert(""����д��֤�룡"");CheckCode.focus();return (false);};"
		Content=Content&"BtnPost.disabled = true;' action='Save.Asp?action=Reply&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&ID="&ID&"&page="&Page&"'><table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' width='100%'></td></tr><tr><td width='24%' valign='top'><table width='100%' border='0' cellpadding='5' cellspacing='0'><tr><td align='center'><img onClick=Cbold() src='Images/UbbPic/1.gif' border=0 alt=������> <img onClick=Cwmv() src=Images/UbbPic/14.gif border=0 alt='Media Player��Ƶ�ļ�'> <img onClick=swf() src=Images/UbbPic/13.gif border=0 alt=Flash���� > <img onClick=image() src='Images/UbbPic/12.gif' border=0 alt=ͼƬ> <img onClick=showpic() src='Images/UbbPic/11.gif' border='0' alt='����ͼƬ'></td>"&_
		"</tr><tr><td align='center'><img src='Images/butreply.gif' onClick=Especial('[reply]','[/reply]')> <img src='Images/butlogin.gif' onClick=Especial('[LOGIN]','[/LOGIN]')></td></tr>"&_
		"<tr><td align='center'><img src='Images/butgrade.gif' width='60' height='22' onClick=Grade()> <img src='Images/butcode.gif' onClick=Code()></td></tr></table>"&_
		"</td><td width='71%' valign='top'><input type=hidden name='caption' value='Re:"&TopicCaption&"'><textarea onkeydown=presskey(); rows=6 name=content Style='width:100%'></textarea><p style='margin-top: 10; margin-bottom: 0'>"
		IF Cint(YxBBs.BoardSetting(0))=1 then Content=Content&"��֤�룺<input type=text name='CheckCode' size=8><img align='absmiddle' src=Inc/code.Asp> "
		Content=Content&"<input type=submit value='�ظ�����' ID='BtnPost'> <input type=button value='Ԥ ��' onclick=openwin()> <input type='reset' value='�� д'> ��ݼ� Ctrl+Enter </p></td><td width='5%' valign='top'><input type='button' style='BACKGROUND: url(Images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(Images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td></tr></table></form><form  style='margin:0;' name=preview action=See.Asp?Action=preview method=post target=preview><input type=hidden name=caption value=><input type=hidden name=content value=''></form>"
	Call YxBBs.ShowTable(Caption,Content)
	END IF
End Function
%>