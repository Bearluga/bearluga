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
	<tr bgcolor="#CCCCCC"><td height="25" colspan="3"><b><font color="#FFFFFF">论坛整理修复</font></b></td>
	</tr>
	<tr><td bgcolor="#D7DAEA" colspan="3" height="50"><b>注意事项：</b>
	  论坛整理中的各项运行都需要消耗比较多的资源<br>
	  所以请你选择论坛访问人数较少的时候进行整理，
	  或者在整理过程中可以先暂时【<a href=?Action=BbsInfo>关闭论坛</a>】</td>
	</tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>论坛系统整理</b></td>
	  <td>重新计算总主题数、总帖数、今日帖数、用户数、新注册用户等<br>
      建议每隔一段时间运行一次。</td><td><input value="开始整理" type="button" onClick=window.location.href='Other.Asp?action=UpdateBbsdate'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="50"><b>论坛版面整理</b></td>
	<td>各版面总帖数、主题数、今日帖数、各版版主、最后回复等<br>
	  建议每隔一段时间运行一次。<br>清理的过程中请不要刷新和关闭！</td><td><input value="开始整理" type="button" onClick=window.location.href='Board.Asp?Action=BoardUpdate'></td></tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>论坛垃圾清理</b></td>
	  <td>清理无效版主、无效帖子、无效主题、无效帖子、无效投票、元效留言、无效用户帖等<br>
      建议每隔一段时间运行一次，给论坛减减无用的脂肪，呵呵<br>清理的过程中请不要刷新和关闭！</td><td><input value="开始清理" type="button" onClick=window.location.href='Other.Asp?Action=DelWuiong'></td></tr>
	<tr bgcolor="#DEDEDE"><td height="50"><b>修复主题帖数</b></td>
	<td>重新整理计算每个主题帖的回复帖数、最后回复信息等<br>
	  如果论坛帖子非常多，整理过程可能将消耗大量资源。</td><td><input value="开始整理" type="button" onClick=window.location.href='Other.Asp?Action=UpdateTopic'></td></tr>
	<tr bgcolor="#DEDEDE">
	  <td height="50"><b>修复用户信息</b></td>
	  <td>重新整理计算每个用户的等级、总帖数、精华帖数等<br>
      如果注册会员非常多，整理过程可能将消耗大量资源。</td><td><input value="开始整理" type="button" onClick=window.location.href='Other.Asp?action=UpdateAllUser'></td></tr>
</table>
<%
End Sub

Sub DelEssay
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除指定日期前的帖子</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">删除多少天前的帖子：</td>
<td width="70%"><input name="DateNum" type="text" value="365" size="5"> 天</td></tr>
<tr bgcolor="#DEDEDE"><td height="28">选择所在的论坛版面：</td>
<td height="28"><select name="BoardID"><option value="0">所有的论坛</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td height="28" colspan="2">说明：此操作将删除指定天数前发表的主题帖，同时也包括主题的回复帖(当然，该主题最新的回复帖也会被删除)。</td>
</tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=DateNoRe>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除指定日期前没有回复的主题</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">删除多少天前的帖子：</td>
<td width="70%"><input name="DateNum" type="text" value="100" size="5"> 天</td></tr>
<tr bgcolor="#DEDEDE"><td height="28">删除帖子所在的论坛：</td>
<td height="28"><select name="BoardID"><option value="0">所有的论坛</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td height="28" colspan="2">说明：此操作将删除指定天数前没有再回复主题帖，同时也包括主题的回复帖。</td>
</tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelEssay&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除指定用户的所有帖子</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">请输入用户的名称：</td>
<td width="70%"><input name="Name" type="text" value="" size="20"> </td></tr>
<tr bgcolor="#DEDEDE"><td height="28">删除帖子所在的论坛：</td>
<td height="28"><select name="BoardID"><option value="0">所有的论坛</option><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<%
End Sub

Sub DelSms
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除指定日期前的所有留言</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">删除多少天前的留言：</td>
<td width="70%"><input name="DateNum" type="text" value="60" size="5"> 天</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除指定用户的所有留言</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">请输入指定用户名称：</td>
<td width="70%"><input name="Name" type="text" size="20"> </td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeDelSms&Go=Auto>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">删除自动发送的信件</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">删除多少天前自动发送的信件：</td>
<td width="70%"><input name="DateNum" type="text" value="30" size="5">天 </td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('注意：删除后将不能恢复！您确定删除吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<%
End Sub

Sub MoveEssay
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeMoveEssay&Go=Date>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">按指定天数移动帖子</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">移动多少天前的帖子：</td>
<td width="70%"><input name="DateNum" type="text" value="100" size="5"> 天</td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">帖子原来所在的论坛：</td>
<td width="70%"><select size="1" name="BoardID1"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">帖子要移动到的论坛：</td>
<td width="70%"><select size="1" name="BoardID2"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('您确定要移动帖子吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeMoveEssay&Go=User>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">移动指定用户的帖子</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">请输入指定的用户名：</td>
<td width="70%"><input name="Name" type="text"  size="20"></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">帖子原来所在的论坛：</td>
<td width="70%"><select size="1" name="BoardID1"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#DEDEDE"><td width="30%" height="28">帖子要移动到的论坛：</td>
<td width="70%"><select size="1" name="BoardID2"><%=YxBBs.BoardIDList(0,0)%></select></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 " onclick=checkclick('您确定要移动这个用户的帖子吗？')> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></table>
</table></form><br>
<%End Sub

Sub AllSms
%><SCRIPT src="Inc/Fun.js"></SCRIPT>
<form method=POST  name=yimxu style='margin:0' action=Other.Asp?Action=ExeAllSms  onSubmit="ok.disabled=true;ok.value='正在群发信件-请稍等。。。'">
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="3"><b><font color="#FFFFFF">群发信件（给用户留言）</font></b></td>
</tr>
<tr><td height="25" colspan="3" align="center" bgcolor="#D7DAEA">注意：此操作可能将消耗大量服务器资源。请慎用！</td></tr>
<tr bgcolor="#DEDEDE"><td align='right' >接收用户：</td>
<td colspan='2'>
<select name='User' style='font-size: 9pt'>
<option value=0 selected>所有在线用户</option>
<option value=1>所有注册用户</option>
<option value=2>所有论坛版主</option>
<option value=3>所有总版主</option>
<option value=4>所有管理员</option>
<option value=5>管理团队(管理员+总版主+版主)</option>
</select></td></tr><tr bgcolor="#DEDEDE"><td align='right' >消息标题：</td>
<td colspan='2'><input name="Title" type="text" id="Title" size="40" maxlength="50"></td></tr><tr bgcolor="#DEDEDE"><td align='right' >功能按钮：</td>
<td colspan='2'><img onClick=Cbold() src="../images/UbbPic/1.gif"  border=0 alt=粗体字> <img src="../images/UbbPic/2.gif" onClick=Citalic() border=0 alt=斜体字 > <img src="../images/UbbPic/3.gif" onClick=Cunder() border=0 alt=下划线><img src="../images/UbbPic/4.gif" onClick=center() border='0' alt='居中'> <img src="../images/UbbPic/5.gif" onClick=fly() border=0 alt=飞行字> <img src="../images/UbbPic/6.gif" onClick=move() border=0 alt=移动字> <img src="../images/UbbPic/7.gif" onClick=Insert("[light]内容[/light]") border=0 alt=发光字> <img src="../images/UbbPic/8.gif" onClick=ying() border=0 alt=阴影字> <img src="../images/UbbPic/9.gif" onClick=Curl() border='0' alt='超连接'> <img src="../images/UbbPic/10.gif" onClick=Cemail() border='0' alt='Email连接'> <img src="../images/UbbPic/11.gif" onClick=showpic() border='0' alt='更多的心情图片'> <img src="../images/UbbPic/12.gif" onClick=image() border=0 alt=图片> <img src="../images/UbbPic/13.gif" onClick=swf() border=0 alt=Flash动画 > <img onClick=Cwmv()  src="../images/UbbPic/14.gif" border=0 alt='Media Player视频文件'> <img src="../images/UbbPic/15.gif" onClick=Crm() border=0 alt=realplay视频文件>  <img onClick=Csound() src="../images/UbbPic/16.gif" border='0' alt='插入背景音乐'>
</td>
</tr><tr bgcolor="#DEDEDE">
  <td align='right' valign='top'>消息内容：</td>
  <td><TEXTAREA name=content  cols=90 rows='8' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();></textarea></td>
<td valign='top'><input type='button' style='BACKGROUND: url(../images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(../images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td></tr>
<tr bgcolor="#CCCCCC"><td colspan='3' align='center'><input  type='submit' value='确定送出' name="ok">&nbsp;<input type='reset' value='取消重写'>
</td></tr></table></form><div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div>
<%
End Sub

Sub Clean
%>
<form method=POST name=form style='margin:0' action=Other.Asp?Action=ExeClean>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#4D65A4"><td height="25" bgcolor="#CCCCCC"><b><font color="#FFFFFF">更新空间缓存</font></b></td>
</tr>
<tr><td bgcolor="#DEDEDE">论坛采用了服务器缓存技术，数据储存在内存中，一些改动有时不会马上生效，所以您需要更新空间的缓存才能看到效果！<br>
  本站现使用缓存<font color=red><%=Application.Contents.Count%></font>个　 <input type="submit" value=" 更新全部缓存 " ></td>
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
	Call Suc("论坛系统整理成功","论坛系统整理成功，整理后：<li>总帖数："&EssayNum&" | 主题数："&TopicNum&" | 今日帖数："&TodayNum&" | 注册用户数："&UserNum&" | 最新注册用户："&NewUser&"","Other.Asp?Action=UpdateBbs")
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
		Go= " 开始整理 "
	Else
		IF not isnumeric(ID1) or not isnumeric(ID2) then Call GoBack("","<li>请用数字填写！"):Exit Sub
		Set Rs=YxBBs.execute("Select TopicId,SqlTableID From [YX_Topic] where TopicID>="&ID1&" And Topicid<="&ID2&"")
		IF Rs.eof then
			If Int(ID2) < Int(MaxID) Then
				Call GoBack("数据据中没有数据","在ID：<font color=red>"&ID1&"</font> 至 <font color=red>"&ID2&"</font> 之间不存在帖子，请把结束ID的数字填大一些。")
			Else
				Call Suc("整理结束","全部整理成功!","Other.Asp?Action=UpdateBbs")
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
		Go=" 继续整理 "
	End IF
	Caption="主题帖子整理"
	Content="<form method=POST action='?Action=UpdateTopic' onSubmit='ok.disabled=true;ok.value=""正在整理-请稍等...""'>请填写你要整理的帖子的开始ID和结束ID：（两者之间不要相差太大）<br>你的论坛帖子最大的 ID 为："&MaxID&"<br>初始ID：<input type=text name='ID1' size=20 value="&ID1&"><BR>结束ID：<input type=text name='ID2' size=20 value="&ID2&"><BR><input type=submit name='ok' value="&Go&"><input type=reset value=' 重 置 '> </p></form>"
	Call ShowTable(caption,Content)
End Sub

Sub UpdateAllUser
	Dim Caption,Content,ID1,ID2,GradeNum,GradeName,GradePic,GoodNum,EssayNum,UG,Go,AllTable,I,Temp,MaxID
	ID1=YxBBs.Fun.GetStr("id1"):ID2=YxBBs.Fun.GetStr("id2")
	MaxID=YxBBs.Execute("select max(id)from [YX_User]")(0)
	IF ID1="" Then
		ID1=1:ID2=100
		Go= " 开始整理 "
	Else
		IF not isnumeric(ID1) or not isnumeric(ID2) then Call GoBack("","<li>请用数字填写！"):Exit Sub
		Set Rs=YxBBs.Execute("Select Name,ClassID From [YX_User] where Id>="&ID1&" and id<="&ID2&"")
		IF Rs.eof then
			If Int(ID2) < Int(MaxID) Then
				Call GoBack("数据据中没有数据","在ID：<font color=red>"&ID1&"</font> 至 <font color=red>"&ID2&"</font> 之间不存在用户，请把结束ID的数字填大一些。")
			Else
				Call Suc("整理结束","全部整理成功!","Other.Asp?Action=UpdateBbs")
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
		Go=" 继续整理 "
	End IF
	Caption="用户整理修复"
	Content="<form method=POST action='?Action=UpdateAllUser' onSubmit='ok.disabled=true;ok.value=""正在整理-请稍等...""'>请填写你要整理用户的开始ID和结束ID：（两者之间不要相差太大）<br>论坛注册用户最大的 ID 为："&MaxID&"<br>初始ID：<input type=text name='id1' size=20 value="&ID1&"><BR>结束ID：<input type=text name='id2' size=20 value="&ID2&"><BR><input name='ok'  type=submit value="&Go&" ><input type=reset value=' 重 置 '> </p></form>"
	Call ShowTable(caption,Content)
End Sub

Sub DelWuiong
	Dim ii,i,AllTable%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bordercolor="#999999" bordercolordark="#FFFFFF" bgcolor="#FFFFFF">
	  <tbody>
	<tr><td bgcolor="#CCCCCC" height="25" colspan="2" ><b><font color="#FFFFFF">论坛垃圾清理 </font></b></td>
	</tr>
	<tr><td bgcolor="#DEDEDE"><div align="center"><b><span id=YxBBsT name=YxBBsT>正在清理无效主题！请稍等...</span></b></div>
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
	Call Table("无效主题清理完毕！","")
	
	Call PicPro(1,6,"正在清理无效回复帖子！请稍等...;")
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
	Call Table("无效回复清理完毕！","")
	
	Call PicPro(2,6,"正在清理无效投票！请稍等...")
		YxBBs.execute("delete * from [YX_TopicVote] where  not exists (select name from [YX_Topic] where [YX_TopicVote].TopicID=[YX_Topic].TopicId)")
		YxBBs.execute("delete * from [YX_TopicVoteUser] where  not exists (select name from [YX_Topic] where [YX_TopicVoteUser].TopicID=[YX_Topic].TopicId)")
	Call Table("无效投票清理完毕！","")
	
	Call PicPro(3,6,"正在清理无效留言！请稍等...")
		YxBBs.execute("delete * from [YX_Sms] where not exists (select name from [YX_User] where [YX_Sms].MyName=[YX_User].Name)")
	Call Table("无效留言清理完毕！","")
	
	Call PicPro(4,6,"正在清理无效公告！请稍等...;")
		YxBBs.execute("delete * from [YX_Placard] where not exists (select name from [YX_User] where [YX_Placard].Name=[YX_User].Name)")
		If Not IsArray(YxBBs.Board_Rs) Then YxBBs.CacheBoard()
		If IsArray(YxBBs.Board_Rs) Then
			For i=0 To Ubound(YxBBs.Board_Rs,2)
			'如果是版块为类
			If YxBBs.Board_Rs(0,i)=0 Then
				YxBBs.execute("delete * from [YX_Placard] where BoardID<0 or BoardID="&YxBBs.Board_Rs(1,i))
			End If
			Next
		End If
	Call Table("无效公告清理完毕！","")
	
	Call PicPro(5,6,"正在清理删除用户的帖子！请稍等...")
		For i=0 To uBound(AllTable)
		YxBBs.execute("delete * from [YX_bbs"&AllTable(i)&"] where not exists (select name from [YX_User] where [YX_bbs"&AllTable(i)&"].Name=[YX_User].Name)")
		Next
		YxBBs.execute("delete * from [YX_Topic] where not exists (select name from [YX_User] where [YX_Topic].Name=[YX_User].Name)")
	Call Table("无效用户的帖子清理完毕！","")
	Response.Write "<script>YxBBsimg.width=400;YxBBstxt.innerHTML=""100"";YxBBsT.innerHTML=""<font color=red>成功完成整理！</font>"";</script>"
End Sub

Sub Table(Str1,Str2)
	Response.Write("<table width='98%' border='1' align='center' cellpadding='3' cellspacing='2' bordercolor='#999999' bordercolordark='#FFFFFF' bgcolor='#DEF0FE'><tr><td><Div style='margin:5;line-height: 150%'>"&Str1&"<br>"&Str2&"</Div></td></tr></table>")
End Sub
'进度条
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
		If not isnumeric(DateNum) Then Call GoBack("","天数必需用数字填写！"):Exit Sub
		If BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where  DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功删除所有论坛在"&DateNum&"天前发表的主题帖（包括其回复帖）！<li>删除后建议对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where BoardID="&BoardID&" And (TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"))")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功删除在 "&YxBBs.Execute("Select BoardName From[YX_Board]where BoardID="&BoardID&"")(0)&" 上 "&DateNum&" 天前发表的主题帖（包括其回复帖）！<li>删除后建议对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		End IF
	Case"DateNoRe"
		If not isnumeric(DateNum) Then Call GoBack("","天数必需用数字填写！"):Exit Sub
		If BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where  DATEDIFF('d',LastTime,'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功删除所有论坛在"&DateNum&"天前没有回复的所有主题帖（包括其回复）！<li>建议删除后对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where TopicID in (Select TopicID From [YX_Topic] where BoardID="&BoardID&" and DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&") or ReplyTopicID in (Select TopicID From [YX_Topic] where BoardID="&BoardID&" and DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&")")
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功删除在 "&YxBBs.Execute("Select BoardName From[YX_Board]where BoardID="&BoardID&"")(0)&" 上 "&DateNum&" 天前没回复的主题帖(包括其回复帖)！<li>删除后建议对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		End IF
	Case"User"
		If UserName="" Then Call GoBack("",""):Exit Sub
		IF YxBBs.Execute("select name From[YX_User] where Name='"&UserName&"'").eof Then
			Call GoBack("","这个用户根本不存在！"):Exit Sub
		ElseIf BoardID=0 Then
			For i=0 To uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where Name='"&UserName&"'")
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&UserName&"')")	
			Next
			YxBBs.Execute("Delete From[YX_Topic] where Name='"&UserName&"'")
			Call Suc("","已经成功删除在所有论坛 "&UserName&" 的所有帖子！<li>建议删除后对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		Else
			For i=0 to uBound(AllTable)
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where BoardID="&BoardID&" and Name='"&UserName&"'")
			YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&UserName&"' And BoardID="&BoardID&")")	
			Next
			YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And Name='"&UserName&"'")
			Call Suc("","已经成功删除 "&UserName&" 的帖子！<li>删除后建议对论坛做一次<a href=Other.Asp?Action=UpdateBbs>整理</a>","Other.Asp?Action=DelEssay")
		End IF
	Case Else
		Call GoBack("","提交的路径不正确")
	End Select
End Sub

Sub ExeDelSms
	Dim UserName,DateNum,BoardID
	DateNum=YxBBs.Fun.GetStr("DateNum")
	Select Case Request("Go")
	Case"Date"
		If not isnumeric(DateNum) Then 
			Call GoBack("","天数必需用数字填写！")
		Else
			YxBBs.Execute("Delete From[YX_Sms] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功删除在"&DateNum&"天前的所有留言信件！","Other.Asp?Action=DelSms")
		End If
	Case"User"
		UserName=YxBBs.Fun.GetStr("Name")
		IF YxBBs.Execute("select name From[YX_User] where lcase(Name)='"&lcase(UserName)&"'").eof Then
			Call GoBack("","这个用户根本不存在！")
		Else
		YxBBs.Execute("Delete From[YX_Sms] where MyName='"&UserName&"'")
		Call Suc("","已经成功删除了 "&UserName&" 的所有留言信件！","Other.Asp?Action=DelSms")
		End If
	Case"Auto"
		If not isnumeric(DateNum) Then 
			Call GoBack("","天数必需用数字填写！")
		Else
			YxBBs.Execute("Delete From[YX_Sms] where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" And Name='系统消息'")
			Call Suc("","已经成功删除在"&DateNum&"天前的所有论坛自动送信的留言信件！","Other.Asp?Action=DelSms")
		End If
	End Select
End Sub

Sub ExeMoveEssay
	Dim BoardID1,BoardID2,DateNum,UserName,AllTable,I
	BoardID1=YxBBs.Fun.GetStr("BoardID1")
	BoardID2=YxBBs.Fun.GetStr("BoardID2")
	IF BoardID1=BoardID2 Then Call GoBack("","您还没有选择目标论坛！"):Exit Sub
	AllTable=Split(YxBBs.BBSTable(0),",")
	DateNum=YxBBs.Fun.GetStr("DateNum")
	UserName=YxBBs.Fun.GetStr("Name")
	Select Case Request("Go")
		Case"Date"
			If not isnumeric(DateNum) Then Call GoBack("","天数必需用数字填写！"):Exit Sub
			For i=0 to uBound(AllTable)
				YxBBs.Execute("update [YX_Bbs"&AllTable(i)&"] Set BoardID="&BoardID2&" where TopicID in (Select TopicID from[YX_Topic] Where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" and BoardID="&BoardID1&") or ReplyTopicID in (Select TopicID from[YX_Topic] Where DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&" and BoardID="&BoardID1&")")
			Next
			YxBBs.Execute("update [YX_Topic] Set BoardID="&BoardID2&" where BoardID="&BoardID1&" And DATEDIFF('d',[AddTime],'"&YxBBs.NowBbsTime&"')>"&DateNum&"")
			Call Suc("","已经成功的把"&DateNum&"天前的帖子从 "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID1&"")(0)&" 移动到 "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID2&"")(0)&"！","Other.Asp?Action=MoveEssay")
		Case"User"
			If UserName="" Then Call GoBack("",""):Exit Sub
			IF YxBBs.Execute("select name From[YX_User] where Name='"&UserName&"'").eof Then
				Call GoBack("","这个用户根本不存在！"):Exit Sub
			Else
			For i=0 to uBound(AllTable)
				YxBBs.Execute("update [YX_Bbs"&AllTable(i)&"] Set BoardID="&BoardID2&" where TopicID in(Select TopicID from[YX_Topic] Where BoardID="&BoardID1&" and Name='"&UserName&"') or ReplyTopicID in (Select TopicID from[YX_Topic] Where BoardID="&BoardID1&" and Name='"&UserName&"')")
			Next
				YxBBs.Execute("update [YX_Topic] Set BoardID="&BoardID2&"  Where BoardID="&BoardID1&" and Name='"&UserName&"'")
				Call Suc("","已经成功的把"&UserName&"的帖子从 "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID1&"")(0)&" 移动到 "&YxBBs.Execute("select BoardName From[YX_Board] where BoardID="&BoardID2&"")(0)&"！","Other.Asp?Action=MoveEssay")
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
			Call GoBack("","非法操作"):Exit Sub
	end select
	Set Rs=YxBBs.Execute(Sql)
	If Not Rs.Eof Then
	MRs=Rs.GetRows(-1)
	rs.close
	For I=0 to Ubound(MRs,2)
	YxBBs.Execute("insert into [YX_sms](name,MyName,Title,Content) values('系统消息','"&MRs(0,i)&"','"&SmsTitle&"','"&SmsContent&"')")
	YxBBs.Execute("update [YX_user] set NewSmsNum=NewSmsNum+1,SmsSize=SmsSize+"&Len(SmsContent)&" where Name='"&MRs(0,i)&"'")
	Next
	End If
	Call Suc("","成功的群发了信件!","Other.Asp?Action=AllSms")
End Sub

Sub ExeClean
Application.Contents.RemoveAll
Call Suc("","更新缓存成功","Other.Asp?Action=Clean")
End Sub
%>