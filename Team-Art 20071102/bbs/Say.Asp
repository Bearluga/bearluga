<!--#include file="Inc/SysConfig.Asp"-->
<SCRIPT src="Inc/Fun.js"></SCRIPT>
<%
Dim Caption,Action,Submiturl,bbsCaption,ThisFace,IsTitle,BbsContent,Quote,Page,bbsVote,ID,Rs
If Not YxBBs.Founduser then YxBBs.Error("您还没有注册或者登陆！")
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
		YxBBs.Stats="发表新帖"
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
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error("您没有查看投票的权限！")
	bbsVote="<tr><td valign=top><br><b>&nbsp;投票选项：<b></td><td>&nbsp;请选择投票项目数：<SELECT align=absmiddle name=VoteNum id=VoteNum onchange=SetNum(this)>"
	for i = 2 to int(Temp)
		bbsVote=bbsVote&"<option value='"&I&"'>"&I&"</option>"
	Next
	bbsVote=bbsVote&"</SELECT> 允许多选 <input type='checkbox' name='VoteType' value='2'> 过期时间：<select size='1' name='OutTime' ><option value='1'>一天</option><option value='3'>三天</option><option value='7'>一周</option><option value='15'>半个月</option><option value='31'>一个月</option><option value='93'>三个月</option><option value='365'>一年</option><option value='10000' selected>不过期</option></select><hr size=1 width='98%'><span id=optionid><table cellpadding=0 cellspacing=3 width='100%' border=0><tr><td>选项1：</td><td><input type='text' name='Votes1' style='width:300'></td></tr><tr><td>选项2：</td><td><input type='text' name='Votes2' style='width:300'><INPUT TYPE='hidden' name='AutoValue' value='2'></td></tr></table></span></td></tr>"
	YxBBs.Stats="发表新投票"
	Caption="发表新投票"
	bbsCaption="<input name='caption' type=text style='width:80%' maxlength=200>"
	Submiturl="Save.Asp?BoardID="&YxBBs.BoardID
End Sub

Sub Reply()
	Dim Rs,BbsID,TopicCaption
	if Id=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	If Cint(YxBBs.ClassSetting(3))=0 Then YxBBs.Error(12)
	YxBBs.Stats="回复帖子"
	IsTitle=False
	Set Rs=YxBBs.Execute("Select Caption,SqlTableID,IsLock From [YX_Topic] where TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	ElseIf Rs(2) Then
		YxBBs.Error("该帖子已经被锁定！")
	Else
		TopicCaption=Rs(0)
		YxBBs.TB=Rs(1)
	End If
	Set Rs=Nothing
	bbsCaption=" <input type=hidden name='caption' value='Re:"&TopicCaption&"'>"
	Caption="回复主题："&TopicCaption
	Submiturl="Save.Asp?Action=Reply&BoardID="&YxBBs.BoardID&"&TB="&YxBBs.TB&"&ID="&ID&"&page="&page&""
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	If BbsID<>"" Then
		Set Rs=YxBBs.Execute("select top 1 B.ReplyTopicID,B.TopicID,B.Name,B.AddTime,B.Content,B.BoardID,U.IsShow from [YX_Bbs"&YxBBs.TB&"] As B inner join [YX_User] As U on B.Name=U.Name where B.BbsID="&BbsID&" And B.IsDel=False")
			If Not Rs.Eof Then
				If Rs(1)<>ID And Rs(0)<> Id Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
				If Rs(6) Then
					BbsCaption=BbsCaption &"<Font Color=Red>屏蔽内容不能引用</Font>"
				Else
					BbsCaption=BbsCaption &" <Font Color=Red>引用 "&Rs(2)&" 的发言</Font>"
					Quote="<tr><td>&nbsp;<b>引用的内容：<input name='QuoteName' type='hidden' value='[quote]以下是引用　[color=0000FF][B]"&Rs(2)&"[/B][/color]　在([i]"&Rs(3)&"[/i])[B]的发言：[/B]"&chr(10)&chr(10)&"'></b><br>&nbsp;可以编辑要引用的内容</td><td width='76%'>&nbsp;<TEXTAREA name='Quote'  cols=90 rows='5' style='WIDTH: 95%;'>"&YxBBs.Fun.StrLeft(QuoteCode(Rs(4)),500)&"</textarea></td>"
				End If
			End if
		Set Rs=Nothing
	End If
End Sub

Sub Edit()
	Dim Rs,BbsID,TopicIsLock,TopicRs,IsTop
	BbsID=YxBBs.CheckNum(Request.QueryString("BbsID"))
	IF BbsID=0 Or ID=0 Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
	Set Rs=YxBBs.Execute("Select BoardID,TopType,SqlTableID,IsLock,TitleType From [YX_Topic] where IsDel=False And TopicID="&ID)
	If Rs.Eof Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		TopicRs=Rs.GetRows(-1)
	End If
	Rs.Close
	'如果是总顶或顶
	Set Rs=YxBBs.Execute("select BoardID,Name,AddTime,TopicID,face,Caption,Content,IsDel From [YX_Bbs"&TopicRs(2,0)&"] where IsDel=False And BbsID="&BbsID&"")
	If Rs.eof  Then
		YxBBs.Error("该帖子不存在或已经删除！")
	Else
		If Not(TopicRs(1,0)=5 or TopicRs(1,0)=4) and TopicRs(0,0)<>YxBBs.BoardID Then YxBBs.Error("错误的地址栏参数，请不要手动去更改地址栏参数！")
		If lcase(YxBBs.MyName)<>lcase(rs("name")) Then
			If Cint(YxBBs.ClassSetting(18))=0 Then YxBBs.Error("您没有编辑别人帖子的权限！")
		Else
			'编辑自己帖子的权限
			If Cint(YxBBs.ClassSetting(9))=0 Then YxBBs.Error("您没有编辑自己帖子的权限！")
		End If
		If YxBBs.ClassID>2 And Not YxBBs.IsBoardAdmin Then
			If YxBBs.BBSSetting(31)<>0 Then If lcase(YxBBs.MyName)=lcase(rs("name")) And DateDiff("s",Rs("AddTime")+YxBBs.BBSSetting(31)/1440,YxBBs.NowBbsTime)>0 Then YxBBs.Error("你超过了允许普通用户编辑自己帖子的时限 (发帖后<Font color=red>"&YxBBs.BBSSetting(31)&"</Font>分钟内)")
			If lcase(YxBBs.MyName)=lcase(rs("name")) And TopicRs(3,0) Then YxBBs.Error("该帖子已经被锁定！")
		End If
		BbsCaption=rs("Caption")
		IF BbsCaption<>"" Then Hell(BbsCaption)
		IF Rs("TopicID")=0 Then
			IsTitle=False
			bbsCaption="<input type=hidden name='caption' value='"&BbsCaption&"'>编辑回复帖"
		Else 
			bbsCaption="<input name='caption' type=text value='"&bbsCaption&"' size=70 maxlength=200><input type=hidden name=OldTitleType value='"&TopicRs(4,0)&"'>"
		End If
		ThisFace=Rs("Face")
		BbsContent=hell(rs("Content"))
	End if
	Rs.Close
	YxBBs.Stats="编辑帖子"
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
	restr="[COLOR=RED]…… 加密内容不能引用 ……[/COLOR]"
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
	Temp="<form style='margin:0;' method=POST name='yimxu' onsubmit='if(caption.value==""""){alert(""您忘记了填写标题！"");caption.focus();return (false);};if(content.value==""""){alert(""您还没有填写帖子内容!"");content.focus();return (false);};"
	If Cint(YxBBs.BoardSetting(0))=1 then Temp=Temp&"if(CheckCode.value==""""){alert(""请填写验证码！"");CheckCode.focus();return (false);};"
	Temp=Temp&"BtnPost.disabled = true;' action='"&Submiturl&"' >"
	If IsTitle Then
		Temp=Temp&"<tr><td width='24%' height='30'><b>&nbsp;帖子主题：</b><select name=Title onChange=DoTitle(this.options[this.selectedIndex].value) style='font-size: 9pt'><option selected value="""">话题</option><option value=[原创]>[原创]</option><option value=[转帖]>[转帖]</option><option value=[灌水]>[灌水]</option><option value=[讨论]>[讨论]</option><option value=[求助]>[求助]</option><option value=[推荐]>[推荐]</option><option value=[公告]>[公告]</option><option value=[注意]>[注意]</option><option value=[贴图]>[贴图]</option><option value=[建议]>[建议]</option><option value=[下载]>[下载]</option><option value=[分享]>[分享]</option></select></td><td>"
	Else
		Temp=Temp&"<tr><td colspan=2 height='30'>"
	End If
	If Action="reply" Then
		Temp=Temp&"&nbsp;"&bbsCaption&"</td></tr>"
	Else
		Temp=Temp&"&nbsp;"&bbsCaption&" <select name=""topicximoo""><option value=0>标题醒目</option><option value=1>红色醒目</option><option value=2>蓝色醒目</option><option value=3>绿色醒目</option></select></td></tr>"
	End If
	'If Quote<>"" Then Temp=Temp&Quote
	Temp=Temp&Quote&"<tr><td width='24%'>&nbsp;<b>你的表情：</b><br>&nbsp;在帖子前面</td><td>"
	Face="&nbsp;<script>var mytface = Math.floor(Math.random()*17+1);for(i=1;i<=18;i=i+1) {if (i==10){document.write(""<br>&nbsp;"")}if (i==mytface){document.write(""<input type=radio value=""+i+"" name=face checked><img border=0 src=images/face/""+i+"".gif>"")}else {document.write(""<input type=radio value=""+i+"" name=face><img border=0 src=images/face/""+i+"".gif>"")}}</script>"
	Temp=Temp&Face&"</td></tr>"&bbsVote&"<tr><td>&nbsp;<b>附件上传类型：</b><br>&nbsp;"&Join(Split(YxBBs.BoardSetting(1),"|"),",")&"</td><td>"
	
        If Int(Rs("GradeNum"))>Int(YxBBs.BBSSetting(36)) then
		Temp=Temp&"<table border=0 cellpadding=0 cellspacing=0><tr><td>&nbsp;<iframe Src='ViewFile.Asp?Action=Upload&BoardID="&YxBBs.BoardID&"' scrolling='no' frameborder='0' height='20' width='260'></iframe></td><td>[每日您可以上传 <font color=blue>"&YxBBs.ClassSetting(11)&"</font> 个 小于 <font color=blue>"&YxBBs.ClassSetting(12)&"</font> KB / 每个]</td></tr></table>"
        Else

               Temp=Temp&"您的等级未达到 <B><font Color=red>"&YxBBs.BBSSetting(36)&"级</font></B> 不能上传文件！<br>"
        End if
	
	Temp=Temp&"</td></tr><tr><td valign='top'><table width='100%'  border='0' cellpadding='0' cellspacing='4'><tr><td colspan='2'><b>帖子内容：</b></td></tr>"
	Temp=Temp&"<tr><td rowspan='5' width=10 ></td></tr><tr><td>UBB标签： <font color=red>√</font></td></tr><tr><td>表情符转换：<font color=red>√</font></td></tr><tr><td>内容最多：<font color=red>"&YxBBs.BoardSetting(3)/1024&"KB</font></td></tr><tr><td>上传文件：<font color=red>√</font></td> </tr><tr><td rowspan='4' width='10'></td><td>发帖请遵守国家法律 </td></tr><tr> <td>禁止发表政治及色情内容</td></tr><tr><td>禁止发灌水的“付费帖子”</td></tr><tr><td>以上发现将删除帐号ID</td></tr></table></td>"
	Temp=Temp&"<td width='76%' valign='top'><table border='0' cellpadding='0' cellspacing='3'  width='100%'><tr><td colspan='2'><select onChange=""if(this.options[this.selectedIndex].value!=''){ybbsize(this.options[this.selectedIndex].value);this.options[0].selected=true;}"" name=a>"
	Temp=Temp&"<option selected>文字大小</option><option value=1>1号字</option><option value=2>2号字</option><option value=3>3号字</option><option value=4>4号字</option><option value=5>5号字</option></select> "
	Temp=Temp&"<select onChange=""if(this.options[this.selectedIndex].value!=''){COLOR(this.options[this.selectedIndex].value);this.options[0].selected=true;}""><option>文字颜色</option><option style='COLOR:000000;BACKGROUND-COLOR:000000' value=000000>黑色</option><option style='COLOR:FFFFFF;BACKGROUND-COLOR:FFFFFF' value=FFFFFF>白色</option><option style='COLOR:008000;BACKGROUND-COLOR:008000' value=008000>绿色</option><option style='COLOR:800000;BACKGROUND-COLOR:800000' value=800000>褐色</option><option style='COLOR:808000;BACKGROUND-COLOR:808000' value=808000>橄榄色</option><option style='COLOR:000080;BACKGROUND-COLOR:000080' value=000080>深蓝色</option><option style='COLOR:800080;BACKGROUND-COLOR:800080' value=800080>紫色</option>"&_
			"<option style='COLOR:808080;BACKGROUND-COLOR:808080' value=808080>灰色</option><option style='COLOR:FFFF00;BACKGROUND-COLOR:FFFF00' value=FFFF00>黄色</option><option style='COLOR:00FF00;BACKGROUND-COLOR:00FF00' value=00FF00>浅绿色</option><option style='COLOR:00FFFF;BACKGROUND-COLOR:00FFFF' value=00FFFF>浅蓝色</option><option style='COLOR:FF00FF;BACKGROUND-COLOR:FF00FF' value=FF00FF>粉红色</option><option style='COLOR:C0C0C0;BACKGROUND-COLOR:C0C0C0' value=C0C0C0>银白色</option><option style='COLOR:FF0000;BACKGROUND-COLOR:FF0000' value=FF0000>红色</option><option style='COLOR:0000FF;BACKGROUND-COLOR:0000FF' value=0000FF>蓝色</option><option style='COLOR:008080;BACKGROUND-COLOR:008080' value=008080>蓝绿色</option></select> "
	Temp=Temp&"<select style='BACKGROUND-COLOR: #ffffff' onChange=""if(this.options[this.selectedIndex].value!=''){location=this.options[this.selectedIndex].value;this.options[0].selected=true;}"" name=sptie>"
	Temp=Temp&"<option selected>特殊贴↓</option><option value=javascript:Grade()>等级可见</option>+<option value=javascript:Especial('[REPLY]','[/REPLY]')>回复可见</option><option value=javascript:Name()>指定读者</option><option value=javascript:Coin()>金钱可见</option><option value=javascript:Mark()>积分可见</option><option value=javascript:Buypost()>付费可见</option><option value=javascript:Showdate()>日期可见</option><option value=javascript:Sex()>性别可见</option><option value=javascript:Especial('[LOGIN]','[/LOGIN]')>登陆可见</option></select> <input type=button value=插入代码 Class=Butt onClick=Especial('[code]','[/code]')> <input type=button value=上标 Class=Butt onClick=Especial('[sup]','[/sup]')> <input type=button value=下标 Class=Butt onClick=Especial('[sub]','[/sub]')>"
	Temp=Temp&"</td></tr><tr><td colspan='2'><img onClick=Cbold() <img src=""Images/UbbPic/1.gif""  border=0 alt=粗体字> <img src=""Images/UbbPic/2.gif"" onClick=Citalic() border=0 alt=斜体字 > <img src=""Images/UbbPic/3.gif"" onClick=Cunder() border=0 alt=下划线> "&_
			"<img src=""Images/UbbPic/4.gif"" onClick=center() border='0' alt='居中'> <img src=""Images/UbbPic/5.gif"" onClick=fly() border=0 alt=飞行字> <img src=""Images/UbbPic/6.gif"" onClick=move() border=0 alt=移动字> <img src=""Images/UbbPic/7.gif"" onClick=Especial(""[light]"",""[/light]"") border=0 alt=发光字> <img src=""Images/UbbPic/8.gif"" onClick=ying() border=0 alt=阴影字> <img src=""Images/UbbPic/9.gif"" onClick=Curl() border='0' alt='超连接'> <img src=""Images/UbbPic/10.gif"" onClick=Cemail() border='0' alt='Email连接'> <img src=""Images/UbbPic/11.gif"" onClick=showpic() border='0' alt='更多的心情图片'> <img src=""Images/UbbPic/12.gif"" onClick=image() border=0 alt=图片> <img src=""Images/UbbPic/13.gif"" onClick=swf() border=0 alt=Flash动画 > <img onClick=Cwmv()  src=""Images/UbbPic/14.gif"" border=0 alt='Media Player视频文件'> <img src=""Images/UbbPic/15.gif"" onClick=Crm() border=0 alt=realplay视频文件>  <img onClick=Csound() src=""Images/UbbPic/16.gif"" border='0' alt='插入背景音乐'> </td></tr>"
	Temp=Temp&"<tr><td width='95%'><TEXTAREA name='content'  cols=90 rows='11' style='PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px;WIDTH: 100%;' onkeydown=presskey();>"&BbsContent&"</textarea></td>"&_
	"<td width='5%' valign='top'><input type='button' style='BACKGROUND: url(Images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(3,this.form.content)' ><br><br><input type='button' style='BACKGROUND: url(Images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-3,this.form.content)'></td>"&_
	"</tr></table></td></tr><tr><td height='40' colspan='2' align='center'>"
        If Action="edit" And (YxBBs.ClassID<=3) Then Temp= Temp & "<input name='EditChalk' type='checkbox' value='No'>不留下编辑标记 "
	If Cint(YxBBs.BoardSetting(0))=1 Then Temp=Temp&"验证码：<input  type=text name='CheckCode' size=8><img align='absmiddle' Src=Inc/code.Asp> "
	Temp=Temp&"&nbsp;<input type=submit value=' 发 表！' ID='BtnPost'> <input type=button value=' 预 览 ' onclick=openwin()> <input type=reset value=' 重 写 '> <input type=button value='剪贴板内容转UBB' onclick=""window.open('inc/Html2UBB.htM',null,'Height=450,Width=640,resizable=0,status=0,scrollbar=0')"">" 
	Temp=Temp&"<font color=#D8D8D8></font></td></tr></form>"
	Call YxBBs.ShowTable(Caption,Temp)
	Response.Write"<div id='MaoDiv' style='position: absolute; width:570px; height:160px; display:none;'><iframe id='MView' name='MView' src='about:blank' frameborder='0' scrolling='no' valign='top' width='100%' height='100%'></iframe></div><form  style='margin:0;' name=preview action=See.Asp?Action=preview method=post target=preview><input type=hidden name=caption value=><input type=hidden name=content value=></form>"
End Function
%>