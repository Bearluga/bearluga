<!--#include file="Inc/SysConfig.Asp"-->
<SCRIPT src="Inc/Fun.js"></SCRIPT>
<%
Dim Caption,Action,Submiturl,bbsCaption,ThisFace,IsTitle,BbsContent,Quote,Page,bbsVote,ID,Rs
If Not YxBBs.Founduser then YxBBs.Error("����û��ע����ߵ�½��")
YxBBs.CheckBoard()
ID=YxBBs.CheckNum(Request.QueryString("ID"))
Page=YxBBs.CheckNum(Request.QueryString("page"))
IsTitle=True
Action=lcase(Request.QueryString("action"))
Select Case Action
	Case"vote"
		Vote()
	Case"reply"
		Reply()
	Case"edit"
		Edit()
	Case Else
		YxBBs.Stats="��������"
		Caption=YxBBs.Stats
		bbsCaption="<input name='caption' type='text' style='width:80%' maxlength=200>"
		Submiturl="Save.Asp?BoardID="&YxBBs.BoardID&""
End Select
YxBBs.Head(YxBBs.Stats)
Set Rs=YxBBs.Execute("Select Name,GradeNum From [YX_user]where Name='"&YxBBs.MyName&"' And PassWord='"&YxBBs.MyPwd&"' And ID="&YxBBs.MyID&"")
ShowMain()
YxBBs.Footer()
Set YxBBs=Nothing

Sub Vote()
	Dim Temp,i
	Temp=YxBBs.BoardSetting(4)
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error("��û�в鿴ͶƱ��Ȩ�ޣ�")
	bbsVote="<tr><td valign=top><br><b>&nbsp;ͶƱѡ�<b></td><td>&nbsp;��ѡ��ͶƱ��Ŀ����<SELECT align=absmiddle name=VoteNum id=VoteNum onchange=SetNum(this)>"
	for i = 2 to int(Temp)
		bbsVote=bbsVote&"<option value='"&I&"'>"&I&"</option>"
	Next
	bbsVote=bbsVote&"</SELECT> ������ѡ <input type='checkbox' name='VoteType' value='2'> ����ʱ�䣺<select size='1' name='OutTime' ><option value='1'>һ��</option><option value='3'>����</option><option value='7'>һ��</option><option value='15'>�����</option><option value='31'>һ����</option><option value='93'>������</option><option value='365'>һ��</option><option value='10000' selected>������</option></select><hr size=1 width='98%'><span id=optionid><table cellpadding=0 cellspacing=3 width='100%' border=0><tr><td>ѡ��1��</td><td><input type='text' name='Votes1' style='width:300'></td></tr><tr><td>ѡ��2��</td><td><input type='text' name='Votes2' style='width:300'><INPUT TYPE='hidden' name='AutoValue' value='2'></td></tr></table></span></td></tr>"
	YxBBs.Stats="������ͶƱ"
	Caption="������ͶƱ"
	bbsCaption="<input name='caption' type=text style='width:80%' maxlength=200>"
	Submiturl="Save.Asp?BoardID="&YxBBs.BoardID
End Sub

Sub Reply()
	Dim Rs,BbsID,TopicCaption
	if Id=0 Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error(12)
	YxBBs.Stats="�ظ�����"
	IsTitle=False
	Set Rs=YxBBs.Execute("Select Caption,SqlTableID,IsLock From [YX_Topic] where TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ����")
	ElseIf Rs(2) Then
		YxBBs.Error("�������Ѿ���������")
	Else
		TopicCaption=Rs(0)
		YxBBs.TB=Rs(1)
	End If
	Set Rs=Nothing
	bbsCaption=" <input type=hidden name='caption' value='Re:"&TopicCaption&"'>"
	Caption="�ظ����⣺"&TopicCaption
	Submiturl="Save.Asp?Action=Reply&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&ID="&ID&"&page="&page&""
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	If BbsID<>"" Then
		Set Rs=YxBBs.Execute("select top 1 B.ReplyTopicID,B.TopicID,B.Name,B.AddTime,B.Content,B.BoardID,U.IsShow from [YX_Bbs"&YxBBs.TB&"] As B inner join [YX_User] As U on B.Name=U.Name where B.BbsID="&BbsID&" And B.IsDel=False")
			If Not Rs.Eof Then
				If Rs(1)<>ID And Rs(0)<> Id Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
				If Rs(6) Then
					BbsCaption=BbsCaption &"<Font Color=Red>�������ݲ�������</Font>"
				Else
					BbsCaption=BbsCaption &" <Font Color=Red>���� "&Rs(2)&" �ķ���</Font>"
					Quote="<tr><td>&nbsp;<b>���õ����ݣ�<input name='QuoteName' type='hidden' value='[quote]���������á�[color=0000FF][B]"&Rs(2)&"[/B][/color]����([i]"&Rs(3)&"[/i])[B]�ķ��ԣ�[/B]"&chr(10)&chr(10)&"'></b><br>&nbsp;���Ա༭Ҫ���õ�����</td><td width='76%'>&nbsp;<TEXTAREA name='Quote'  cols=90 rows='5' style='WIDTH: 95%;'>"&YxBBs.Fun.StrLeft(QuoteCode(Rs(4)),500)&"</textarea></td>"
				End If
			End if
		Set Rs=Nothing
	End If
End Sub

Sub Edit()
	Dim Rs,BbsID,TopicIsLock,TopicRs,IsTop
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	IF BbsID=0 Or ID=0 Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
	Set Rs=YxBBs.Execute("Select BoardID,TopType,SqlTableID,IsLock,TitleType From [YX_Topic] where IsDel=False And TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ����")
	Else
		TopicRs=Rs.GetRows(-1)
	End If
	Rs.Close
	'������ܶ���
	Set Rs=YxBBs.Execute("select BoardID,Name,AddTime,TopicID,face,Caption,Content,IsDel From [YX_Bbs"&TopicRs(2,0)&"] where IsDel=False And BbsID="&BbsID&"")
	If Rs.eof  Then
		YxBBs.Error("�����Ӳ����ڻ��Ѿ�ɾ����")
	Else
		If Not(TopicRs(1,0)=5 or TopicRs(1,0)=4) and TopicRs(0,0)<>YxBBs.BoardID Then YxBBs.Error("����ĵ�ַ���������벻Ҫ�ֶ�ȥ���ĵ�ַ��������")
		If lcase(YxBBs.MyName)<>lcase(rs("name")) Then
			If Cint(YxBBs.ClassSetting(18))=0 Then YxBBs.Error("��û�б༭�������ӵ�Ȩ�ޣ�")
		Else
			'�༭�Լ����ӵ�Ȩ��
			If Cint(YxBBs.ClassSetting(9))=0 Then YxBBs.Error("��û�б༭�Լ����ӵ�Ȩ�ޣ�")
		End If
		If YxBBs.ClassID>2 And Not YxBBs.IsBoardAdmin Then
			If YxBBs.BBSSetting(31)<>0 Then If lcase(YxBBs.MyName)=lcase(rs("name")) And DateDiff("s",Rs("AddTime")+YxBBs.BBSSetting(31)/1440,YxBBs.NowBbsTime)>0 Then YxBBs.Error("�㳬����������ͨ�û��༭�Լ����ӵ�ʱ�� (������<Font color=red>"&YxBBs.BBSSetting(31)&"</Font>������)")
			If lcase(YxBBs.MyName)=lcase(rs("name")) And TopicRs(3,0) Then YxBBs.Error("�������Ѿ���������")
		End If
		BbsCaption=rs("Caption")
		IF BbsCaption<>"" Then Hell(BbsCaption)
		IF Rs("TopicID")=0 Then
			IsTitle=False
			bbsCaption="<input type=hidden name='caption' value='"&BbsCaption&"'>�༭�ظ���"
		Else 
			bbsCaption="<input name='caption' type=text value='"&bbsCaption&"' size=70 maxlength=200><input type=hidden name=OldTitleType value='"&TopicRs(4,0)&"'>"
		End If
		ThisFace=Rs("Face")
		BbsContent=hell(rs("Content"))
	End if
	Rs.Close
	YxBBs.Stats="�༭����"
	Caption=YxBBs.Stats
	Submiturl="Save.Asp?Action=Edit&ID="&ID&"&BbsID="&BbsID&"&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&page="&page&""
End Sub

Function Hell(str)
		dim re
		Set re=new RegExp
		re.IgnoreCase=true
		re.Global=True
		re.Pattern=vbcrlf&vbcrlf&vbcrlf&"(\[right\])(\[color=(.[^\[]*)\])(.[^\[]*)(\[\/color\])(\[\/right\])"
		str=re.Replace(str," ")
		str = replace(str, ">", "&gt;")
		str = replace(str, "<", "&lt;")
		set re=Nothing
		Hell=str
End function

Function QuoteCode(str)
	Dim re,restr
	Set re=new RegExp
	re.IgnoreCase=true
	re.Global=True
	restr="[COLOR=RED]���� �������ݲ������� ����[/COLOR]"
	re.Pattern="(\[DATE=(.[^\[]*)\])(.[^\[]*)(\[\/DATE\])"
	str=re.Replace(str,restr)
	re.Pattern="(\[SEX=*([0-1]*)\])(.[^\[]*)(\[\/SEX\])"
	str=re.Replace(str,restr)
	re.Pattern="(\[COIN=*([0-9]*)\])(.[^\[]*)(\[\/COIN\])"
	str=re.Replace(str,restr)		
	re.Pattern="(\[USERNAME=(.[^\[]*)\])(.[^\[]*)(\[\/USERNAME\])"
	str=re.Replace(str,restr)	
	re.Pattern="(\[GRADE=*([0-9]*)\])(.[^\[]*)(\[\/GRADE\])"
	str=re.Replace(str,restr)	
	re.Pattern="(\[MARK=*([0-9]*)\])(.[^\[]*)(\[\/MARK\])"		
	str=re.Replace(str,restr)
	re.Pattern="(\[BUYPOST=*([0-9]*)\])(.[^\[]*)(\[\/BUYPOST\])"
	str=re.Replace(str,restr)
	re.Pattern=vbcrlf&vbcrlf&vbcrlf&"(\[RIGHT\])(\[COLOR=(.[^\[]*)\])(.[^\[]*)(\[\/COLOR\])(\[\/RIGHT\])"
	str=re.Replace(str,"")
	Str = Replace(Str, chr(10), "")
	re.Pattern="(\[reply\])(.+?)(\[\/reply\])"
	str=re.Replace(str,restr)	
	set re=Nothing
	QuoteCode=str
End Function

Function ShowMain()
	Dim Temp,Face,I,J
	Temp="<form style='margin:0;' method=POST name='yimxu' onsubmit='if(caption.value==""""){alert(""����������д���⣡"");caption.focus();return (false);};if(content.value==""""){alert(""����û����д��������!"");content.focus();return (false);};"
	If Cint(YxBBs.BoardSetting(0))=1 then Temp=Temp&"if(CheckCode.value==""""){alert(""����д��֤�룡"");CheckCode.focus();return (false);};"
	Temp=Temp&"BtnPost.disabled = true;' action='"&Submiturl&"' >"
	If IsTitle Then
		Temp=Temp&"<tr><td width='24%' height='30'><b>&nbsp;�������⣺</b><select name=Title onChange=DoTitle(this.options[this.selectedIndex].value) style='font-size: 9pt'><option selected value="""">����</option><option value=[ԭ��]>[ԭ��]</option><option value=[ת��]>[ת��]</option><option value=[��ˮ]>[��ˮ]</option><option value=[����]>[����]</option><option value=[����]>[����]</option><option value=[�Ƽ�]>[�Ƽ�]</option><option value=[����]>[����]</option><option value=[ע��]>[ע��]</option><option value=[��ͼ]>[��ͼ]</option><option value=[����]>[����]</option><option value=[����]>[����]</option><option value=[����]>[����]</option></select></td><td>"
	Else
		Temp=Temp&"<tr><td colspan=2 height='30'>"
	End If
	If Action="reply" Then
		Temp=Temp&"&nbsp;"&bbsCaption&"</td></tr>"
	Else
		Temp=Temp&"&nbsp;"&bbsCaption&" <select name=""topicximoo""><option value=0>������Ŀ</option><option value=1>��ɫ��Ŀ</option><option value=2>��ɫ��Ŀ</option><option value=3>��ɫ��Ŀ</option></select></td></tr>"
	End If
	'If Quote<>"" Then Temp=Temp&Quote
	Temp=Temp&Quote&"<tr><td width='24%'>&nbsp;<b>��ı��飺</b><br>&nbsp;������ǰ��</td><td>"
	Face="&nbsp;<script>var mytface = Math.floor(Math.random()*17+1);for(i=1;i<=18;i=i+1) {if (i==10){document.write(""<br>&nbsp;"")}if (i==mytface){document.write(""<input type=radio value=""+i+"" name=face checked><img border=0 src=images/face/""+i+"".gif>"")}else {document.write(""<input type=radio value=""+i+"" name=face><img border=0 src=images/face/""+i+"".gif>"")}}</script>"
	Temp=Temp&Face&"</td></tr>"&bbsVote&"<tr><td>&nbsp;<b>�����ϴ����ͣ�</b><br>&nbsp;"&Join(Split(YxBBs.BoardSetting(1),"|"),",")&"</td><td>"
	
        If Int(Rs("GradeNum"))>Int(YxBBs.BBSSetting(36)) then
		Temp=Temp&"<table border=0 cellpadding=0 cellspacing=0><tr><td>&nbsp;<iframe Src='ViewFile.Asp?Action=Upload&BoardID="&YxBBs.BoardID&"' scrolling='no' frameborder='0' height='20' width='260'></iframe></td><td>[ÿ���������ϴ� <font color=blue>"&YxBBs.ClassSetting(11)&"</font> �� С�� <font color=blue>"&YxBBs.ClassSetting(12)&"</font> KB / ÿ��]</td></tr></table>"
        Else

               Temp=Temp&"���ĵȼ�δ�ﵽ <B><font Color=red>"&YxBBs.BBSSetting(36)&"��</font></B> �����ϴ��ļ���<br>"
        End if
	
	Temp=Temp&"</td></tr><tr><td valign='top'><table width='100%'  border='0' cellpadding='0' cellspacing='4'><tr><td colspan='2'><b>�������ݣ�</b></td></tr>"
	Temp=Temp&"<tr><td rowspan='5' width=10 ></td></tr><tr><td>UBB��ǩ�� <font color=red>��</font></td></tr><tr><td>�����ת����<font color=red>��</font></td></tr><tr><td>������ࣺ<font color=red>"&YxBBs.BoardSetting(3)/1024&"KB</font></td></tr><tr><td>�ϴ��ļ���<font color=red>��</font></td> </tr><tr><td rowspan='4' width='10'></td><td>���������ع��ҷ��� </td></tr><tr> <td>��ֹ�������μ�ɫ������</td></tr><tr><td>��ֹ����ˮ�ġ��������ӡ�</td></tr><tr><td>���Ϸ��ֽ�ɾ���ʺ�ID</td></tr></table></td>"
	Temp=Temp&"<td width='76%' valign='top'><table border='0' cellpadding='0' cellspacing='3'  width='100%'><tr><td colspan='2'><select onChange=""if(this.options[this.selectedIndex].value!=''){ybbsize(this.options[this.selectedIndex].value);this.options[0].selected=true;}"" name=a>"
	Temp=Temp&"<option selected>���ִ�С</option><option value=1>1����</option><option value=2>2����</option><option value=3>3����</option><option value=4>4����</option><option value=5>5����</option></select> "
	Temp=Temp&"<select onChange=""if(this.options[this.selectedIndex].value!=''){COLOR(this.options[this.selectedIndex].value);this.options[0].selected=true;}""><option>������ɫ</option><option style='COLOR:000000;BACKGROUND-COLOR:000000' value=000000>��ɫ</option><option style='COLOR:FFFFFF;BACKGROUND-COLOR:FFFFFF' value=FFFFFF>��ɫ</option><option style='COLOR:008000;BACKGROUND-COLOR:008000' value=008000>��ɫ</option><option style='COLOR:800000;BACKGROUND-COLOR:800000' value=800000>��ɫ</option><option style='COLOR:808000;BACKGROUND-COLOR:808000' value=808000>���ɫ</option><option style='COLOR:000080;BACKGROUND-COLOR:000080' value=000080>����ɫ</option><option style='COLOR:800080;BACKGROUND-COLOR:800080' value=800080>��ɫ</option>"&_
			"<option style='COLOR:808080;BACKGROUND-COLOR:808080' value=808080>��ɫ</option><option style='COLOR:FFFF00;BACKGROUND-COLOR:FFFF00' value=FFFF00>��ɫ</option><option style='COLOR:00FF00;BACKGROUND-COLOR:00FF00' value=00FF00>ǳ��ɫ</option><option style='COLOR:00FFFF;BACKGROUND-COLOR:00FFFF' value=00FFFF>ǳ��ɫ</option><option style='COLOR:FF00FF;BACKGROUND-COLOR:FF00FF' value=FF00FF>�ۺ�ɫ</option><option style='COLOR:C0C0C0;BACKGROUND-COLOR:C0C0C0' value=C0C0C0>����ɫ</option><option style='COLOR:FF0000;BACKGROUND-COLOR:FF0000' value=FF0000>��ɫ</option><option style='COLOR:0000FF;BACKGROUND-COLOR:0000FF' value=0000FF>��ɫ</option><option style='COLOR:008080;BACKGROUND-COLOR:008080' value=008080>����ɫ</option></select> "
	Temp=Temp&"<select style='BACKGROUND-COLOR: #ffffff' onChange=""if(this.options[this.selectedIndex].value!=''){location=this.options[this.selectedIndex].value;this.options[0].selected=true;}"" name=sptie>"
	Temp=Temp&"<option selected>��������</option><option value=javascript:Grade()>�ȼ��ɼ�</option>+<option value=javascript:Especial('[REPLY]','[/REPLY]')>�ظ��ɼ�</option><option value=javascript:Name()>ָ������</option><option value=javascript:Coin()>��Ǯ�ɼ�</option><option value=javascript:Mark()>���ֿɼ�</option><option value=javascript:Buypost()>���ѿɼ�</option><option value=javascript:Showdate()>���ڿɼ�</option><option value=javascript:Sex()>�Ա�ɼ�</option><option value=javascript:Especial('[LOGIN]','[/LOGIN]')>��½�ɼ�</option></select> <input type=button value=������� Class=Butt onClick=Especial('[code]','[/code]')> <input type=button value=�ϱ� Class=Butt onClick=Especial('[sup]','[/sup]')> <input type=button value=�±� Class=Butt onClick=Especial('[sub]','[/sub]')>"
	Temp=Temp&"</td></tr><tr><td colspan='2'><img onClick=Cbold() <img src=""Images/UbbPic/1.gif""  border=0 alt=������> <img src=""Images/UbbPic/2.gif"" onClick=Citalic() border=0 alt=б���� > <img src=""Images/UbbPic/3.gif"" onClick=Cunder() border=0 alt=�»���> "&_
			"<img src=""Images/UbbPic/4.gif"" onClick=center() border='0' alt='����'> <img src=""Images/UbbPic/5.gif"" onClick=fly() border=0 alt=������> <img src=""Images/UbbPic/6.gif"" onClick=move() border=0 alt=�ƶ���> <img src=""Images/UbbPic/7.gif"" onClick=Especial(""[light]"",""[/light]"") border=0 alt=������> <img src=""Images/UbbPic/8.gif"" onClick=ying() border=0 alt=��Ӱ��> <img src=""Images/UbbPic/9.gif"" onClick=Curl() border='0' alt='������'> <img src=""Images/UbbPic/10.gif"" onClick=Cemail() border='0' alt='Email����'> <img src=""Images/UbbPic/11.gif"" onClick=showpic() border='0' alt='���������ͼƬ'> <img src=""Images/UbbPic/12.gif"" onClick=image() border=0 alt=ͼƬ> <img src=""Images/UbbPic/13.gif"" onClick=swf() border=0 alt=Flash���� > <img onClick=Cwmv()  src=""Images/UbbPic/14.gif"" border=0 alt='Media Player��Ƶ�ļ�'> <img src=""Images/UbbPic/15.gif"" onClick=Crm() border=0 alt=realplay��Ƶ�ļ�>  <img onClick=Csound() src=""Images/UbbPic/16.gif"" border='0' alt='���뱳������'> </td></tr>"
	Temp=Temp&"<tr><td width='95%'><TEXTAREA name='content'  cols=90 rows='11' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();>"&BbsContent&"</textarea></td>"&_
	"<td width='5%' valign='top'><input type='button' style='BACKGROUND: url(Images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(Images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td>"&_
	"</tr></table></td></tr><tr><td height='40' colspan='2' align='center'>"
        If Action="edit" And (YxBBs.ClassID<=3) Then Temp= Temp & "<input name='EditChalk' type='checkbox' value='No'>�����±༭��� "
	If Cint(YxBBs.BoardSetting(0))=1 Then Temp=Temp&"��֤�룺<input  type=text name='CheckCode' size=8><img align='absmiddle' Src=Inc/code.Asp> "
	Temp=Temp&"&nbsp;<input type=submit value=' �� ����' ID='BtnPost'> <input type=button value=' Ԥ �� ' onclick=openwin()> <input type=reset value=' �� д '> <input type=button value='����������תUBB' onclick=""window.open('inc/Html2UBB.htM',null,'Height=450,Width=640,resizable=0,status=0,scrollbar=0')"">" 
	Temp=Temp&"<font color=#D8D8D8></font></td></tr></form>"
	Call YxBBs.ShowTable(Caption,Temp)
	Response.Write"<div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div><form  style='margin:0;' name=preview action=See.Asp?Action=preview method=post target=preview><input type=hidden name=caption value=><input type=hidden name=content value=></form>"
End Function
%>