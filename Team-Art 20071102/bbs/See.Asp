<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="inc/ubb_Cls.Asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
td,tr,table,body{font-size: 9pt; margin:0}
</style>
<body bgcolor="#0072B">
<%Dim Action,ID,UserName,BbsID
Action=Lcase(Request.QueryString("Action"))
ID=YxBBs.Checknum(Request.QueryString("ID"))
Select Case Action
Case"vote"
	Vote
Case"placard"
	Placard()
Case"preview"
	Preview()
Case"checkname"
	CheckUserName()
Case"headpic"
	HeadPic()
End Select
Set YxBBs=Nothing
Sub Vote()
	Dim Rs,Arr_Rs,i,Temp,Caption,Content,Vote,VoteNum,AllvoteNum,VotePicW,ii,VoteShow,VoteType,voteopt
	Response.Write"<title>ͶƱ����</title>"
	If Not YxBBs.FoundUser Then Response.Write"�㻹û�е�½�����ܲ鿴ͶƱ��ϸ��Ϣ��":Response.End
	Set Rs=YxBBs.Execute("Select TopicID,Vote,VoteNum,VoteType,OutTime From [YX_TopicVote] where TopicID="&ID&"")
	If Not Rs.Eof then
		VoteType=Rs("VoteType")
		Vote=Split(Rs("Vote"),"|")
		VoteNum=split(Rs("VoteNum"),"|")
		For i=1 to ubound(Vote)
			AllvoteNum=Int(AllvoteNum+VoteNum(i))
		Next
		IF AllVoteNum=0 then AllvoteNum=1
		For i=1 To ubound(Vote)
			ii=ii+1
			VotePicW=VoteNum(i)/AllvoteNum*85
			IF ii>6 Then ii=1
			VoteShow=VoteShow&"<tr><td width='5%' height=25 >&nbsp;"&i&"</td><td width='40%'>&nbsp;"&YxBBs.Fun.HtmlCode(Vote(i))&"</td><td width='35%' >&nbsp;<img border=0 height=8 width=2 src=Images/line.gif><img border=0 height=8 width='"&VotePicW&"%' src='Images/hr"&ii&".gif'> <b>"&VoteNum(i)&"</b> Ʊ</td></tr>"
		next
	End if
	Caption="ͶƱѡ��"
	Content="<table frame=void border='1' cellpadding='3' cellspacing='0' bordercolor='#999999' style='border-collapse: collapse' width='100%'><tr>"&VoteShow&"<tr><td width='100%' height=25 colspan=4>&nbsp; ��Ͷ�ˣ�"&AllvoteNum&"Ʊ&nbsp;��ֹʱ�䣺"&Rs("OutTime")&" </td></tr></table>"
	Rs.Close
	Call YxBBs.ShowTable(Caption,Content)
	Set Rs=YxBBs.execute("select VoteNum,User From[YX_TopicVoteUser] where TopicID="&ID&"")
	Content=""
	If Not Rs.eof Then Arr_Rs=Rs.GetRows
	Rs.Close
	If IsArray(Arr_Rs) Then
		For i=0 To Ubound(Arr_Rs,2)
			If VoteType=1 Then
				Temp="ͶƱ��"&Arr_Rs(0,i)&"�"&YxBBs.Fun.HtmlCode(Vote(int(Arr_Rs(0,i))))
			ElseIf VoteType=2 Then
				VoteOpt=Split(Arr_Rs(0,i),",")
					Temp=""
					For II=0 to ubound(VoteOpt)
					If VoteOpt(ii)<>"" then
						Temp=Temp&"ͶƱ��"&VoteOpt(ii)&"�"&YxBBs.Fun.HtmlCode(Vote(int(VoteOpt(ii))))&"<br>"
						End if
					Next
			End If
			Content=Content&"<tr><td height='25'>&nbsp;"&Arr_Rs(1,i)&"</td><td>"&Temp&"</td></tr>"
		Next
		Caption="ͶƱ�û�"
		Content="<table frame=void border='1' cellpadding='3' cellspacing='0' bordercolor='#999999' style='border-collapse: collapse' width='100%'>"&Content&"</table>"
		Call YxBBs.ShowTable(Caption,Content)
	End If
End Sub
Sub HeadPic()
	Dim Temp,Caption,Content,I,tr_I
	Response.Write"<title>��̳ͷ��ѡ����</title>"
	Caption="��̳�Դ���ͷ�� ��"& YxBBs.BBSSetting(14) &"��"
	For I=1 To Int(YxBBs.BBSSetting(14))
		tr_i=tr_i+1
		Temp=Temp &"<td style='cursor:hand' title='���ѡ�� "& I &" ��ͷ��' onclick=instrPic("& I &")><img Src='Images/UserHead/"& i &".Gif'></td>"
		If tr_i=5 Then Temp=temp &"</tr><tr>":Tr_i=0
	Next
	Content="<table width='100%' barder=1>"& Temp &"</td></tr></table>"
	Call YxBBs.ShowTable(Caption,Content)
End Sub
Sub Placard()
	Dim Rs,Caption,Content,YxBBs_ubb
	Response.Write "<title>��̳����</title>"
	Set YxBBs_ubb=New YxBBsubb_Cls
	Set Rs=YxBBs.execute("select Caption,Content,AddTime,Name,hits,ubbString from [YX_Placard] where Id="&ID&"")
	If Rs.eof then
	Caption="������Ϣ"
	Content="û�й������ݡ�"
	Else
	YxBBs_ubb.UbbString=Rs("ubbString")
	Caption=YxBBs.Fun.HtmlCode(Rs("Caption"))
	Content="<tr><td><blockquote><span style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all; width:100%'><br><div align='center'><font style='font:bold 18px;'>"&YxBBs.Fun.HtmlCode(Rs("Caption"))&"</font></div><hr size=1>"&YxBBs_ubb.UBB(Rs("Content"),2)&"<hr size=1><div align='right'>�����ˣ�"&Rs("name")&"&nbsp;|&nbsp; �����ڣ�"&Rs("AddTime")&"&nbsp;|&nbsp;�Ķ�������"&Rs("hits")&" </div></Span></blockquote></td></tr>"
	YxBBs.execute("Update [YX_Placard] set Hits=Hits+1 where Id="&ID&"")
	End If
	Set YxBBs_ubb=Nothing
	Rs.close
	Call YxBBs.ShowTable(Caption,Content)
	Response.Write"<div align='center'><input type='button' onclick='window.close();'  value='�رմ���'></div>"
End Sub
Sub Preview()
	Dim Caption,Content,YxBBs_ubb
	Response.Write "<title>����Ԥ��</title><SCRIPT src=""inc/Fun.js""></SCRIPT>"
	Set YxBBs_ubb=New YxBBsubb_Cls
	Caption=YxBBs.Fun.HtmlCode(trim(Request.form("Caption")))
	Content=trim(Request.form("Content"))
	YxBBs_ubb.UbbString=YxBBs.Fun.UbbString(Content)
	Content="<tr><td><blockquote><span style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all; width:100%'><br>"&YxBBs_ubb.UBB(Content,1)&"</Span></blockquote></td></tr>"
	Set YxBBs_ubb=Nothing
Call YxBBs.ShowTable(Caption,Content)
End Sub

Sub CheckUserName()
	Dim Caption,Content,Temp,Name,can,I
	Response.Write"<title>����û���</title>"
	Name=trim(Request("name"))
	Caption="���û�ע��"
	If Name="" or Name=NULL Then
		Temp= "�Բ���!<br>����д�û���!"
	Else
		If not YxBBs.Fun.CheckName(Name) or YxBBs.Fun.strLength(Name)>14 or YxBBs.Fun.strLength(Name)<3  Then
			Temp="�Բ���!<br>�û��� <font color=red><b>"&YxBBs.Fun.HtmlCode(Name)&"</b></font> <br>���зǷ��ַ����ַ�����������Ҫ��."
		Else
			If Not YxBBs.execute("select name from [YX_User] where name='"&Name&"'").eof Then
				Temp="�Բ���!<br>�û��� <font color=red><b>"&YxBBs.Fun.HtmlCode(Name)&"</font></b> �ѱ���ע����!"
			Else
				If instr("@@"&lcase(YxBBs.BadName)&"@@","@@"& lcase(Name) &"@@")>0 Then
					Can=true
				End If
				If Can Then
					Temp="�Ƿ��û���������ע��!"
				Else
					Temp="��ϲ�㣬<font color=red><b>"&Name&"</b></font> ����ע�ᡣ"
				End If
			End If
		End If
	End If
	Response.Write "<table border=0 cellpadding=4 cellspacing=1 width='100%' height='100%' bgcolor='#DDDDDD'><tr bgcolor='#EFEFEF'><td height=22 align=center>���û�ע��</td></tr><tr bgcolor='#FFFFFF'><td align=center>"&Temp&"</td></tr></table>"
End Sub%>
<script type="text/javascript">
function instrPic(id){
self.opener.document.images.Pic.src="Images/UserHead/"+id+".gif";
self.opener.form.PicUrl.value="Images/UserHead/"+id+".gif";
window.close();
}
</script>