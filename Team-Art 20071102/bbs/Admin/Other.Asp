<!--#include file="Check.Asp"-->
<%
Dim Action,ID
ID=Request.QueryString("ID")
If ID="" Then ID=0

Action=Lcase(Request.QueryString("Action"))
Select case Action
Case"updatebbs"
	UpdateBbs
Case"passuser"
	PassUser
Case"delessay"
	DelEssay
Case"delsms"
	DelSms
Case"moveessay"
	MoveEssay
Case"allsms"
	AllSms
Case"updatebbsdate"
	UpdateBbsDate
Case"updatetopic"
	UpdateTopic
Case"updatealluser"
	UpdateAllUser
Case"delwuiong"
	DelWuiong
Case"exedelessay"
	ExeDelEssay
Case"exedelsms"
	ExeDelSms
Case"exemoveessay"
	ExeMoveEssay
Case"exeallsms"
	ExeAllSms
Case "clean"
	Clean
Case "execlean"
	ExeClean
End select
AdminFooter()

Sub UpdateBbs
%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="3"><b><font color="#FFFFFF">��̳�����޸�</font></b></td>
	</tr>
	<tr><td bgcolor="#D7DAEA" colspan="3" height="50"><b>ע�����</b>
	  ��̳�����еĸ������ж���Ҫ���ıȽ϶����Դ<br>
	  ��������ѡ����̳�����������ٵ�ʱ�����������
	  ���������������п�������ʱ��<a href=?Action=BbsInfo>�ر���̳</a>��</td>
	</tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>��̳ϵͳ����</b></td>
	  <td>���¼��������������������������������û�������ע���û���<br>
      ����ÿ��һ��ʱ������һ�Ρ�</td><td><input value="��ʼ����" type="button" onClick=window.location.href='Other.Asp?action=UpdateBbsdate'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="50"><b>��̳��������</b></td>
	<td>��������������������������������������������ظ���<br>
	  ����ÿ��һ��ʱ������һ�Ρ�<br>�����Ĺ������벻Ҫˢ�º͹رգ�</td><td><input value="��ʼ����" type="button" onClick=window.location.href='Board.Asp?Action=BoardUpdate'></td></tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>��̳��������</b></td>
	  <td>������Ч��������Ч���ӡ���Ч���⡢��Ч���ӡ���ЧͶƱ��ԪЧ���ԡ���Ч�û�����<br>
      ����ÿ��һ��ʱ������һ�Σ�����̳�������õ�֬�����Ǻ�<br>�����Ĺ������벻Ҫˢ�º͹رգ�</td><td><input value="��ʼ����" type="button" onClick=window.location.href='Other.Asp?Action=DelWuiong'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="50"><b>�޸���������</b></td>
	<td>������������ÿ���������Ļظ����������ظ���Ϣ��<br>
	  �����̳���ӷǳ��࣬�������̿��ܽ����Ĵ�����Դ��</td><td><input value="��ʼ����" type="button" onClick=window.location.href='Other.Asp?Action=UpdateTopic'></td></tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>�޸��û���Ϣ</b></td>
	  <td>������������ÿ���û��ĵȼ���������������������<br>
      ���ע���Ա�ǳ��࣬�������̿��ܽ����Ĵ�����Դ��</td><td><input value="��ʼ����" type="button" onClick=window.location.href='Other.Asp?action=UpdateAllUser'></td></tr>
</table>
<%
End Sub

Sub DelEssay
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ��ָ������ǰ������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">ɾ��������ǰ�����ӣ�</td>
<td width="70%"><input name="DateNum" type="text" value="365" size="5"> ��</td></tr>
<tr bgcolor="#DEDEDE"><td height="28">ѡ�����ڵ���̳���棺</td>
<td height="28"><select name="BoardID"><option value="0">���е���̳</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td height="28" colspan="2">˵�����˲�����ɾ��ָ������ǰ��������������ͬʱҲ��������Ļظ���(��Ȼ�����������µĻظ���Ҳ�ᱻɾ��)��</td>
</tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=DateNoRe>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ��ָ������ǰû�лظ�������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">ɾ��������ǰ�����ӣ�</td>
<td width="70%"><input name="DateNum" type="text" value="100" size="5"> ��</td></tr>
<tr bgcolor="#DEDEDE"><td height="28">ɾ���������ڵ���̳��</td>
<td height="28"><select name="BoardID"><option value="0">���е���̳</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td height="28" colspan="2">˵�����˲�����ɾ��ָ������ǰû���ٻظ���������ͬʱҲ��������Ļظ�����</td>
</tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ��ָ���û�����������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">�������û������ƣ�</td>
<td width="70%"><input name="Name" type="text" value="" size="20"> </td></tr>
<tr bgcolor="#DEDEDE"><td height="28">ɾ���������ڵ���̳��</td>
<td height="28"><select name="BoardID"><option value="0">���е���̳</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<%
End Sub

Sub DelSms
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ��ָ������ǰ����������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">ɾ��������ǰ�����ԣ�</td>
<td width="70%"><input name="DateNum" type="text" value="60" size="5"> ��</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ��ָ���û�����������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">������ָ���û����ƣ�</td>
<td width="70%"><input name="Name" type="text" size="20"> </td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=Auto>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">ɾ���Զ����͵��ż�</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">ɾ��������ǰ�Զ����͵��ż���</td>
<td width="70%"><input name="DateNum" type="text" value="30" size="5">�� </td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('ע�⣺ɾ���󽫲��ָܻ�����ȷ��ɾ����')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<%
End Sub

Sub MoveEssay
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeMoveEssay&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">��ָ�������ƶ�����</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">�ƶ�������ǰ�����ӣ�</td>
<td width="70%"><input name="DateNum" type="text" value="100" size="5"> ��</td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">����ԭ�����ڵ���̳��</td>
<td width="70%"><select size="1" name="BoardID1"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">����Ҫ�ƶ�������̳��</td>
<td width="70%"><select size="1" name="BoardID2"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('��ȷ��Ҫ�ƶ�������')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeMoveEssay&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">�ƶ�ָ���û�������</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">������ָ�����û�����</td>
<td width="70%"><input name="Name" type="text"  size="20"></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">����ԭ�����ڵ���̳��</td>
<td width="70%"><select size="1" name="BoardID1"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">����Ҫ�ƶ�������̳��</td>
<td width="70%"><select size="1" name="BoardID2"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" �� �� " onclick=checkclick('��ȷ��Ҫ�ƶ�����û���������')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" �� �� "></td></tr></table>
</table></form><br>
<%End Sub

Sub AllSms
%><SCRIPT src="Inc/Fun.js"></SCRIPT>
<form method=POST  name=yimxu style='margin:0' action=Other.Asp?Action=ExeAllSms  onSubmit="ok.disabled=true;ok.value='����Ⱥ���ż�-���Եȡ�����'">
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="3"><b><font color="#FFFFFF">Ⱥ���ż������û����ԣ�</font></b></td>
</tr>
<tr><td height="25" colspan="3" align="center" bgcolor="#D7DAEA">ע�⣺�˲������ܽ����Ĵ�����������Դ�������ã�</td></tr>
<tr bgcolor="#DEDEDE"><td align='right' >�����û���</td>
<td colspan='2'>
<select name='User' style='font-size: 9pt'>
<option value=0 selected>���������û�</option>
<option value=1>����ע���û�</option>
<option value=2>������̳����</option>
<option value=3>�����ܰ���</option>
<option value=4>���й���Ա</option>
<option value=5>�����Ŷ�(����Ա+�ܰ���+����)</option>
</select></td></tr><tr bgcolor="#DEDEDE"><td align='right' >��Ϣ���⣺</td>
<td colspan='2'><input name="Title" type="text" id="Title" size="40" maxlength="50"></td></tr><tr bgcolor="#DEDEDE"><td align='right' >���ܰ�ť��</td>
<td colspan='2'><img onClick=Cbold() src="../images/UbbPic/1.gif"  border=0 alt=������> <img src="../images/UbbPic/2.gif" onClick=Citalic() border=0 alt=б���� > <img src="../images/UbbPic/3.gif" onClick=Cunder() border=0 alt=�»���><img src="../images/UbbPic/4.gif" onClick=center() border='0' alt='����'> <img src="../images/UbbPic/5.gif" onClick=fly() border=0 alt=������> <img src="../images/UbbPic/6.gif" onClick=move() border=0 alt=�ƶ���> <img src="../images/UbbPic/7.gif" onClick=Insert("[light]����[/light]") border=0 alt=������> <img src="../images/UbbPic/8.gif" onClick=ying() border=0 alt=��Ӱ��> <img src="../images/UbbPic/9.gif" onClick=Curl() border='0' alt='������'> <img src="../images/UbbPic/10.gif" onClick=Cemail() border='0' alt='Email����'> <img src="../images/UbbPic/11.gif" onClick=showpic() border='0' alt='���������ͼƬ'> <img src="../images/UbbPic/12.gif" onClick=image() border=0 alt=ͼƬ> <img src="../images/UbbPic/13.gif" onClick=swf() border=0 alt=Flash���� > <img onClick=Cwmv()  src="../images/UbbPic/14.gif" border=0 alt='Media Player��Ƶ�ļ�'> <img src="../images/UbbPic/15.gif" onClick=Crm() border=0 alt=realplay��Ƶ�ļ�>  <img onClick=Csound() src="../images/UbbPic/16.gif" border='0' alt='���뱳������'>
</td>
</tr><tr bgcolor="#DEDEDE">
  <td align='right' valign='top'>��Ϣ���ݣ�</td>
  <td><TEXTAREA name=content  cols=90 rows='8' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();></textarea></td>
<td valign='top'><input type='button' style='BACKGROUND: url(../images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(../images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td></tr>
<tr bgcolor="#CCCCCC"><td colspan='3' align='center'><input  type='submit' value='ȷ���ͳ�' name="ok">&nbsp;<input type='reset' value='ȡ����д'>
</td></tr></table></form><div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div>
<%
End Sub

Sub Clean
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeClean>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#4D65A4"><td height="25" bgcolor="#CCCCCC"><b><font color="#FFFFFF">���¿ռ仺��</font></b></td>
</tr>
<tr><td bgcolor="#DEDEDE">��̳�����˷��������漼�������ݴ������ڴ��У�һЩ�Ķ���ʱ����������Ч����������Ҫ���¿ռ�Ļ�����ܿ���Ч����<br>
  ��վ��ʹ�û���<font color=red><%=Application.Contents.Count%></font>���� <input type="submit" value=" ����ȫ������ " ></td>
  </tr></table>
</table></form><br>
<%
End Sub

Sub UpdateBbsDate
	Dim EssayNum,TopicNum,NewUser,TodayNum,UserNum,AllTable,I
	UserNum=YxBBs.Execute("Select Count(ID) From[YX_User]")(0)
	NewUser=YxBBs.execute("select Top 1 Name from [YX_User] order by ID desc")(0)
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		EssayNum=EssayNum+YxBBs.Execute("Select Count(BbsID) From[YX_Bbs"&AllTable(i)&"] where IsDel=False")(0)
		TodayNum=TodayNum+YxBBs.Execute("Select Count(BbsID) From[YX_Bbs"&AllTable(i)&"] where IsDel=False And DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')<1")(0)
	Next
	TopicNum=YxBBs.Execute("Select Count(TopicID) From[YX_Topic]")(0)
	YxBBs.Execute("update [YX_Config] Set UserNum="&UserNum&",AllEssayNum="&EssayNum&",TopicNum="&TopicNum&",TodayNum="&TodayNum&",NewUser='"&NewUser&"'")
	Call Suc("��̳ϵͳ�����ɹ�","��̳ϵͳ�����ɹ���������<li>��������"&EssayNum&" | ��������"&TopicNum&" | ����������"&TodayNum&" | ע���û�����"&UserNum&" | ����ע���û���"&NewUser&"","Other.Asp?Action=UpdateBbs")
	Cache.name="Config"
	Cache.clean()
End Sub

Sub UpdateTopic
	Dim Caption,Content,ID1,ID2,LastReply,Go,ReplyNum,AllTable,i,Temp,MaxID
	ID1=YxBBs.Fun.GetStr("id1")
	ID2=YxBBs.Fun.GetStr("id2")
	MaxID=YxBBs.execute("select max(TopicID)from [YX_Topic]")(0)
	IF ID1="" Then
		ID1=1:ID2=100
		Go= " ��ʼ���� "
	Else
		IF not isnumeric(ID1) or not isnumeric(ID2) then Call GoBack("","<li>����������д��"):Exit Sub
		Set Rs=YxBBs.execute("Select TopicId,SqlTableID From [YX_Topic] where TopicID>="&ID1&" And Topicid<="&ID2&"")
		IF Rs.eof then
			If Int(ID2) < Int(MaxID) Then
				Call GoBack("���ݾ���û������","��ID��<font color=red>"&ID1&"</font> �� <font color=red>"&ID2&"</font> ֮�䲻�������ӣ���ѽ���ID���������һЩ��")
			Else
				Call Suc("��������","ȫ�������ɹ�!","Other.Asp?Action=UpdateBbs")
			End If
			Exit Sub
		End If
		AllTable=Split(YxBBs.BBSTable(0),",")
		Do while not rs.eof
		For i=0 To uBound(AllTable)
			IF Int(Rs(1))=Int(AllTable(i)) Then
				ReplyNum=YxBBs.execute("select count(BbsID) from [YX_bbs"&Rs(1)&"] where IsDel=False and ReplyTopicID="&Rs(0)&"")(0)
				YxBBs.execute("update [YX_Topic] Set ReplyNum="&ReplyNum&" where TopicID="&Rs(0)&"")
				Exit For
			End If
		Next
		Rs.Movenext
		Loop
		Rs.Close
		Temp=ID1
		ID1=int(ID2)+1
		ID2=int(ID2)+int(ID2)-int(Temp)+1
		Go=" �������� "
	End IF
	Caption="������������"
	Content="<form method=POST action='?Action=UpdateTopic' onSubmit='ok.disabled=true;ok.value=""��������-���Ե�...""'>����д��Ҫ���������ӵĿ�ʼID�ͽ���ID��������֮�䲻Ҫ���̫��<br>�����̳�������� ID Ϊ��"&MaxID&"<br>��ʼID��<input type=text name='ID1' size=20 value="&ID1&"><BR>����ID��<input type=text name='ID2' size=20 value="&ID2&"><BR><input type=submit name='ok' value="&Go&"><input type=reset value=' �� �� '> </p></form>"
	Call ShowTable(caption,Content)
End Sub

Sub UpdateAllUser
	Dim Caption,Content,ID1,ID2,GradeNum,GradeName,GradePic,GoodNum,EssayNum,UG,Go,AllTable,I,Temp,MaxID
	ID1=YxBBs.Fun.GetStr("id1"):ID2=YxBBs.Fun.GetStr("id2")
	MaxID=YxBBs.Execute("select max(id)from [YX_User]")(0)
	IF ID1="" Then
		ID1=1:ID2=100
		Go= " ��ʼ���� "
	Else
		IF not isnumeric(ID1) or not isnumeric(ID2) then Call GoBack("","<li>����������д��"):Exit Sub
		Set Rs=YxBBs.Execute("Select Name,ClassID From [YX_User] where Id>="&ID1&" and id<="&ID2&"")
		IF Rs.eof then
			If Int(ID2) < Int(MaxID) Then
				Call GoBack("���ݾ���û������","��ID��<font color=red>"&ID1&"</font> �� <font color=red>"&ID2&"</font> ֮�䲻�����û�����ѽ���ID���������һЩ��")
			Else
				Call Suc("��������","ȫ�������ɹ�!","Other.Asp?Action=UpdateBbs")
			End If		
			Exit Sub
		End if
		AllTable=Split(YxBBs.BBSTable(0),",")
		Do while not rs.eof
			EssayNum=0
			GoodNum=0
			For i=0 To uBound(AllTable)
				EssayNum=EssayNum+YxBBs.Execute("select Count(BbsID) from [YX_bbs"&AllTable(i)&"] where Name='"&Rs(0)&"'")(0)
			Next
				GoodNum=YxBBs.execute("select count(TopicID) from [YX_Topic] where Name='"&Rs(0)&"' And IsGood=True")(0)
			Set UG=YxBBs.execute("Select Top 1 GradeNum,GradeName,GradePic from YX_UserGrade Where ClassID="&Rs(1)&" And UserMinPostNum<="&EssayNum&" Order By UserMinPostNum Desc")
			If Not UG.Eof Then
				GradeNum=UG(0)
				GradeName=UG(1)
				GradePic=UG(2)
			End If
			UG.Close
			Set UG=Nothing
			YxBBs.Execute("update [YX_User] set EssayNum="&EssayNum&",GoodNum="&GoodNum&",GradeNum="&GradeNum&",GradeName='"&GradeName&"',GradePic='"&GradePic&"' where Name='"&Rs(0)&"'")
		Rs.Movenext
		Loop
		rs.close
		Temp=ID1
		ID1=int(ID2)+1
		ID2=int(ID2)+int(ID2)-int(Temp)+1
		Go=" �������� "
	End IF
	Caption="�û������޸�"
	Content="<form method=POST action='?Action=UpdateAllUser' onSubmit='ok.disabled=true;ok.value=""��������-���Ե�...""'>����д��Ҫ�����û��Ŀ�ʼID�ͽ���ID��������֮�䲻Ҫ���̫��<br>��̳ע���û����� ID Ϊ��"&MaxID&"<br>��ʼID��<input type=text name='id1' size=20 value="&ID1&"><BR>����ID��<input type=text name='id2' size=20 value="&ID2&"><BR><input name='ok'  type=submit value="&Go&" ><input type=reset value=' �� �� '> </p></form>"
	Call ShowTable(caption,Content)
End Sub

Sub DelWuiong
	Dim ii,i,AllTable%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bordercolor="#999999" bordercolordark="#FFFFFF" bgcolor="#FFFFFF">
	  <tbody>
	<tr><td bgcolor="#CCCCCC" height="25" colspan="2" ><b><font color="#FFFFFF">��̳�������� </font></b></td>
	</tr>
	<tr><td bgcolor="#DEDEDE"><div align="center"><b><span id=YxBBsT name=YxBBsT>����������Ч���⣡���Ե�...</span></b></div>
	    <table width="400" border="0" align="center" cellpadding="1" cellspacing="1">
	<tr><td bgcolor=#d7d7d7>
	<table width="400" border="0" cellspacing="0" cellpadding="1">
	<tr> 
	<td bgcolor=ffffff height=9><img src="../images/hr1.gif" width=0 height=16 id=YxBBsimg name=YxBBsimg align=absmiddle></td>
	</tr></table>
	</td></tr></table>
	<div align="center"><span id=YxBBstxt name=YxBBstxt style="font-size:9pt">0</span><span style="font-size:9pt">%</span></div></td></tr>
	</tbody></table><br>
	<%Response.Flush
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		YxBBs.execute("delete * from [YX_bbs"&AllTable(i)&"] where TopicID<>0 and not exists (select name from [YX_topic] where [YX_bbs"&AllTable(i)&"].TopicId=[YX_Topic].TopicID)")
		YxBBs.execute("delete * from [YX_Topic] where SqlTableID="&AllTable(i)&" and not exists (select name from [YX_bbs"&AllTable(i)&"] where [YX_Topic].TopicID=[YX_bbs"&AllTable(i)&"].TopicId)")
	Next
	Call Table("��Ч����������ϣ�","")
	
	Call PicPro(1,6,"����������Ч�ظ����ӣ����Ե�...;")
	For i=0 To uBound(AllTable)
		Set Rs=YxBBs.Execute("select ReplyTopicID from [YX_bbs"&AllTable(i)&"] where ReplyTopicID<>0")
		Do While Not Rs.eof
			If YxBBs.execute("select TopicID from [YX_bbs"&AllTable(i)&"] where TopicID="&Rs(0)&"").eof Then
			YxBBs.Execute("Delete from [YX_bbs"&AllTable(i)&"] where ReplyTopicID="&Rs(0)&"")
			End IF
		Rs.MoveNext
		Loop
		Rs.Close
	Next
	Call Table("��Ч�ظ�������ϣ�","")
	
	Call PicPro(2,6,"����������ЧͶƱ�����Ե�...")
		YxBBs.execute("delete * from [YX_TopicVote] where  not exists (select name from [YX_Topic] where [YX_TopicVote].TopicID=[YX_Topic].TopicId)")
		YxBBs.execute("delete * from [YX_TopicVoteUser] where  not exists (select name from [YX_Topic] where [YX_TopicVoteUser].TopicID=[YX_Topic].TopicId)")
	Call Table("��ЧͶƱ������ϣ�","")
	
	Call PicPro(3,6,"����������Ч���ԣ����Ե�...")
		YxBBs.execute("delete * from [YX_Sms] where not exists (select name from [YX_User] where [YX_Sms].MyName=[YX_User].Name)")
	Call Table("��Ч����������ϣ�","")
	
	Call PicPro(4,6,"����������Ч���棡���Ե�...;")
		YxBBs.execute("delete * from [YX_Placard] where not exists (select name from [YX_User] where [YX_Placard].Name=[YX_User].Name)")
		If Not IsArray(YxBBs.Board_Rs) Then YxBBs.CacheBoard()
		If IsArray(YxBBs.Board_Rs) Then
			For i=0 To Ubound(YxBBs.Board_Rs,2)
			'����ǰ��Ϊ��
			If YxBBs.Board_Rs(0,i)=0 Then
				YxBBs.execute("delete * from [YX_Placard] where BoardID<0 or BoardID="&YxBBs.Board_Rs(1,i))
			End If
			Next
		End If
	Call Table("��Ч����������ϣ�","")
	
	Call PicPro(5,6,"��������ɾ���û������ӣ����Ե�...")
		For i=0 To uBound(AllTable)
		YxBBs.execute("delete * from [YX_bbs"&AllTable(i)&"] where not exists (select name from [YX_User] where [YX_bbs"&AllTable(i)&"].Name=[YX_User].Name)")
		Next
		YxBBs.execute("delete * from [YX_Topic] where not exists (select name from [YX_User] where [YX_Topic].Name=[YX_User].Name)")
	Call Table("��Ч�û�������������ϣ�","")
	Response.Write "<script>YxBBsimg.width=400;YxBBstxt.innerHTML=""100"";YxBBsT.innerHTML=""<font color=red>�ɹ����������</font>"";</script>"
End Sub

Sub Table(Str1,Str2)
	Response.Write("<table width='98%' border='1' align='center' cellpadding='3' cellspacing='2' bordercolor='#999999' bordercolordark='#FFFFFF' bgcolor='#DEF0FE'><tr><td><Div style='margin:5;line-height: 150%'>"&Str1&"<br>"&Str2&"</Div></td></tr></table>")
End Sub
'������
Sub PicPro(i,sum,strtxt)
	Response.Write "<script>YxBBsimg.width=" & Fix((i/sum) * 400) & ";" & VbCrLf
	Response.Write "YxBBstxt.innerHTML=""" & FormatNumber(i/sum*100,4,-1) & """;" & VbCrLf
	Response.Write "YxBBsT.innerHTML="""& StrTxt & """;"& VbCrLf
	Response.Write "</script>" & VbCrLf
	Response.Flush
End Sub

Sub ExeDelEssay
	Dim UserName,DateNum,BoardID,AllTable,I
	DateNum=YxBBs.Fun.GetStr("DateNum")
	BoardID=YxBBs.Fun.GetStr("BoardID")
	UserName=YxBBs.Fun.GetStr("Name")
	AllTable=Split(YxBBs.BBSTable(0),",")
	Select Case Request("Go")
	Case"Date"
		If not isnumeric(DateNum) Then Call GoBack("","����������������д��"):Exit Sub
		If BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where  DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ�ɾ��������̳��"&DateNum&"��ǰ��������������������ظ�������<li>ɾ���������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where BoardID="&BoardID&" And (TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"))")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ�ɾ���� "&YxBBs.Execute("Select BoardName From[YX_Board]where BoardID="&BoardID&"")(0)&" �� "&DateNum&" ��ǰ��������������������ظ�������<li>ɾ���������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		End IF
	Case"DateNoRe"
		If not isnumeric(DateNum) Then Call GoBack("","����������������д��"):Exit Sub
		If BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where  DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ�ɾ��������̳��"&DateNum&"��ǰû�лظ���������������������ظ�����<li>����ɾ�������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where BoardID="&BoardID&" and DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where BoardID="&BoardID&" and DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ�ɾ���� "&YxBBs.Execute("Select BoardName From[YX_Board]where BoardID="&BoardID&"")(0)&" �� "&DateNum&" ��ǰû�ظ���������(������ظ���)��<li>ɾ���������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		End IF
	Case"User"
		If UserName="" Then Call GoBack("",""):Exit Sub
		IF YxBBs.Execute("select name From[YX_User] where Name='"&UserName&"'").eof Then
			Call GoBack("","����û����������ڣ�"):Exit Sub
		ElseIf BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where Name='"&UserName&"'")
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&UserName&"')")	
			Next
			YxBBs.Execute("Delete From[YX_Topic] where Name='"&UserName&"'")
			Call Suc("","�Ѿ��ɹ�ɾ����������̳ "&UserName&" ���������ӣ�<li>����ɾ�������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 to uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where BoardID="&BoardID&" and Name='"&UserName&"'")
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&UserName&"' And BoardID="&BoardID&")")	
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And Name='"&UserName&"'")
			Call Suc("","�Ѿ��ɹ�ɾ�� "&UserName&" �����ӣ�<li>ɾ���������̳��һ��<a href=Other.Asp?Action=UpdateBbs>����</a>","Other.Asp?Action=DelEssay")
		End IF
	Case Else
		Call GoBack("","�ύ��·������ȷ")
	End Select
End Sub

Sub ExeDelSms
	Dim UserName,DateNum,BoardID
	DateNum=YxBBs.Fun.GetStr("DateNum")
	Select Case Request("Go")
	Case"Date"
		If not isnumeric(DateNum) Then 
			Call GoBack("","����������������д��")
		Else
			YxBBs.Execute("Delete From[YX_Sms] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ�ɾ����"&DateNum&"��ǰ�����������ż���","Other.Asp?Action=DelSms")
		End If
	Case"User"
		UserName=YxBBs.Fun.GetStr("Name")
		IF YxBBs.Execute("select name From[YX_User] where lcase(Name)='"&lcase(UserName)&"'").eof Then
			Call GoBack("","����û����������ڣ�")
		Else
		YxBBs.Execute("Delete From[YX_Sms] where MyName='"&UserName&"'")
		Call Suc("","�Ѿ��ɹ�ɾ���� "&UserName&" �����������ż���","Other.Asp?Action=DelSms")
		End If
	Case"Auto"
		If not isnumeric(DateNum) Then 
			Call GoBack("","����������������д��")
		Else
			YxBBs.Execute("Delete From[YX_Sms] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" And Name='ϵͳ��Ϣ'")
			Call Suc("","�Ѿ��ɹ�ɾ����"&DateNum&"��ǰ��������̳�Զ����ŵ������ż���","Other.Asp?Action=DelSms")
		End If
	End Select
End Sub

Sub ExeMoveEssay
	Dim BoardID1,BoardID2,DateNum,UserName,AllTable,I
	BoardID1=YxBBs.Fun.GetStr("BoardID1")
	BoardID2=YxBBs.Fun.GetStr("BoardID2")
	IF BoardID1=BoardID2 Then Call GoBack("","����û��ѡ��Ŀ����̳��"):Exit Sub
	AllTable=Split(YxBBs.BBSTable(0),",")
	DateNum=YxBBs.Fun.GetStr("DateNum")
	UserName=YxBBs.Fun.GetStr("Name")
	Select Case Request("Go")
		Case"Date"
			If not isnumeric(DateNum) Then Call GoBack("","����������������д��"):Exit Sub
			For i=0 to uBound(AllTable)
				YxBBs.Execute("update [YX_Bbs"&AllTable(i)&"] Set BoardID="&BoardID2&" where TopicID in (Select TopicID from[YX_Topic] Where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" and BoardID="&BoardID1&") or ReplyTopicID in (Select TopicID from[YX_Topic] Where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" and BoardID="&BoardID1&")")
			Next
			YxBBs.Execute("update [YX_Topic] Set BoardID="&BoardID2&" where BoardID="&BoardID1&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","�Ѿ��ɹ��İ�"&DateNum&"��ǰ�����Ӵ� "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID1&"")(0)&" �ƶ��� "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID2&"")(0)&"��","Other.Asp?Action=MoveEssay")
		Case"User"
			If UserName="" Then Call GoBack("",""):Exit Sub
			IF YxBBs.Execute("select name From[YX_User] where Name='"&UserName&"'").eof Then
				Call GoBack("","����û����������ڣ�"):Exit Sub
			Else
			For i=0 to uBound(AllTable)
				YxBBs.Execute("update [YX_Bbs"&AllTable(i)&"] Set BoardID="&BoardID2&" where TopicID in(Select TopicID from[YX_Topic] Where BoardID="&BoardID1&" and Name='"&UserName&"') or ReplyTopicID in (Select TopicID from[YX_Topic] Where BoardID="&BoardID1&" and Name='"&UserName&"')")
			Next
				YxBBs.Execute("update [YX_Topic] Set BoardID="&BoardID2&"  Where BoardID="&BoardID1&" and Name='"&UserName&"'")
				Call Suc("","�Ѿ��ɹ��İ�"&UserName&"�����Ӵ� "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID1&"")(0)&" �ƶ��� "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID2&"")(0)&"��","Other.Asp?Action=MoveEssay")
			End If
	End Select
End Sub

Sub ExeAllSms
	Dim SmsTitle,SmsContent,UserType,Sql,Mrs,I
	SmsTitle=YxBBs.Fun.GetStr("title")
	SmsContent=YxBBs.Fun.GetStr("content")
	UserType=YxBBs.Fun.GetStr("User")
	If SmsTitle="" or SmsContent="" Then Call GoBack("",""):Exit Sub
	Select case UserType
		case"0"
			Sql="select name From [YX_online] where ClassID<>6"
		case"1"
			sql="select name from [YX_user] where not isdel"
		case"2"
			Sql="select name From [YX_user] where ClassID=3"
		case"3"
			Sql="select name From [YX_user] where ClassID=2"
		case"4"
			Sql="select name From [YX_user] where ClassID=1"
		case"5"
			Sql="select name From [YX_user] where ClassID>=3"
		case else
			Call GoBack("","�Ƿ�����"):Exit Sub
	end select
	Set Rs=YxBBs.Execute(Sql)
	If Not Rs.Eof Then
	MRs=Rs.GetRows(-1)
	rs.close
	For I=0 to Ubound(MRs,2)
	YxBBs.Execute("insert into [YX_sms](name,MyName,Title,Content) values('ϵͳ��Ϣ','"&MRs(0,i)&"','"&SmsTitle&"','"&SmsContent&"')")
	YxBBs.Execute("update [YX_user] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(SmsContent)&" where Name='"&MRs(0,i)&"'")
	Next
	End If
	Call Suc("","�ɹ���Ⱥ�����ż�!","Other.Asp?Action=AllSms")
End Sub

Sub ExeClean
Application.Contents.RemoveAll
Call Suc("","���»���ɹ�","Other.Asp?Action=Clean")
End Sub
%>