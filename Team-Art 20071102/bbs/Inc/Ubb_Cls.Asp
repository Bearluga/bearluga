<%Const MaxLoopcount=100%>
<script language=vbscript runat=server>
Class YxBBsubb_Cls
	Public UbbString,Re
	Private Sub Class_Initialize()
	End Sub
	Rem 入口(内容，1=帖子|2=留言公告等)
	Public Function Ubb(Str,PostType)
		If isNull(Str) or Str="" then
			Ubb=""
			Exit function
		End if
		If UbbString="" Or IsNull(UbbString) Then
			UbbString=YxBBs.Fun.UbbString(Str)
		End If
		If instr(UbbString,",41,")>0 And PostType=1 Then
			Str=YxBBs_Code(Str,PostType)
		Else
			Str=YxBBs_UBB(str,postType)
		End If
		UBB=Str
	End Function
	
	Private Function YxBBs_UBB(Str,PostType)
		If isNull(Str) or Str="" then
			YxBBs_UBB=""
			Exit function
		End if
		Str=Html_Code(Str)
		Set re=new RegExp
		re.IgnoreCase =True
		re.Global=True
		If InStr(UbbString,",0,")>0 Then
			re.pattern="((javascript:)|(jscript:)|(object)|(js:)|(location.)|(vbscript:)|(vbs:)|(\.value)|(about:)|(file:)|(document.cookie)|(on(mouse|exit|error|click|key|load)))"
			str=re.replace(str,"<font color=#000000>$1</font>")
		End If
		If InStr(UbbString,",7,")>0 Then Str=YxBBs_Ubb1(Str,"\[b\]","\[\/b\]","<b>$1</b>")
		If InStr(UbbString,",8,")>0 Then Str=YxBBs_Ubb1(Str,"\[i\]","\[\/i\]","<i>$1</i>")
		If InStr(UbbString,",9,")>0 Then Str=YxBBs_Ubb1(Str,"\[u\]","\[\/u\]","<u>$1</u>")
		If InStr(UbbString,",10,")>0 Then Str=YxBBs_Ubb1(Str,"\[sup\]","\[\/sup\]","<sup>$1</sup>")
		If InStr(UbbString,",11,")>0 Then Str=YxBBs_Ubb1(Str,"\[sub\]","\[\/sub\]","<sub>$1</sub>")
		If InStr(UbbString,",12,")>0 Then Str=YxBBs_Ubb1(Str,"\[color=((#.{6})|.{3,6})\]","\[\/color\]","<font color=$1>$3</font>") 
		If InStr(UbbString,",13,")>0 Then Str=YxBBs_Ubb1(Str,"\[url=(.{5,}?)\]","\[\/url\]","<a href=""$1"" target='_blank'>$2</a>") 
		If InStr(UbbString,",14,")>0 Then Str=YxBBs_Ubb1(Str,"\[right\]","\[\/right\]","<div align=right>$1</div>")	
		If InStr(UbbString,",15,")>0 Then Str=YxBBs_Ubb1(Str,"\[light\]","\[\/light\]","<span style=""behavior:url(Inc/font.htc)"">$1</span>") 
		If InStr(UbbString,",16,")>0 Then re.pattern="\[em*([0-9]*)]":str=re.replace(str,"<img src=Images/Emotions/em$1.gif>")
		If InStr(UbbString,",17,")>0 Then Str=YxBBs_Ubb1(Str,"\[size=([1-5])\]","\[\/size\]","<font size=$1>$2</font>") 
		If InStr(UbbString,",18,")>0 Then Str=YxBBs_Ubb1(Str,"\[dir=([0-9]{1,3}),([0-9]{1,3})\]","\[\/dir\]","<object classid=clsid:166B1BCA-3F9C-11CF-8075-444553540000 codebase=http://download.macromedia.com/pub/shockwave/cabs/director/sw.cab#version=7,0,2,0 width=$1 height=$2><param name=src value=$3><embed src=$3 pluginspage=http://www.macromedia.com/shockwave/download/ width=$1 height=$2></embed></object>") 
		If InStr(UbbString,",19,")>0 Then Str=YxBBs_Ubb1(Str,"\[fly\]","\[\/fly\]","<marquee width=90% behavior=alternate scrollamount=3>$1</marquee>") 
		If InStr(UbbString,",20,")>0 Then Str=YxBBs_Ubb1(Str,"\[move\]","\[\/move\]","<MARQUEE scrollamount=3>$1</marquee>") 
		If InStr(UbbString,",21,")>0 Then Str=YxBBs_Ubb1(Str,"\[align=(center|left|right)\]","\[\/align\]","<div align=$1>$2</div>") 
		If InStr(UbbString,",22,")>0 Then Str=YxBBs_Ubb1(Str,"\[shadow=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\]","\[\/shadow\]","<table width=$1 ><tr><td style=""filter:shadow(color=$2, stregExngth=$3)"">$4</td></tr></table>") 
		If InStr(UbbString,",23,")>0 Then Str=YxBBs_Ubb1(Str,"\[sound\]","\[\/sound\]","<a href=""$1"" target=_blank><IMG SRC=Images/FileType/mid.gif border=0 alt='背景音乐'></a><bgsound src=""$1"" loop=""-1"">") 
		If InStr(UbbString,",24,")>0 Then Str=YxBBs_Ubb2(Str,"\[img\]","\[\/img\]","<img onmousewheel=""return bbimg(this)"" onload=""javascript:if(this.width>screen.width-500)this.style.width=screen.width-500;"" src=$1 border=0 onclick=""javascript:window.open(this.src);"" style=""CURSOR: pointer"">","<a href=$1 target=_blank>$1</a>",YxBBs.BBSSetting(22)) 
		If InStr(UbbString,",25,")>0 Then
			If Not YxBBs.FoundUser and YxBBs.BBSSetting(55)="0" Then 
			Str=YxBBs_Ubb3(Str,"\[upload=(txt|zip|rar|mdb|swf),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的附件</legend><br>&nbsp;&nbsp;<font color=gray>抱歉,您所在的组无权下载附件,请<a href=register.asp>注册</a>或<a href=login.asp>登陆</a>.</font><br><br></fieldset>")
			
			Str=YxBBs_Ubb2(Str,"\[upload=(gif|jpg|jpeg|bmp|png),*(#*[0-9\.]*),([0-9]{1,3}),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的图片</legend><br>&nbsp;&nbsp;<font color=gray>抱歉,您所在的组无权下载附件,请<a href=register.asp>注册</a>或<a href=login.asp>登陆</a></font>","",YxBBs.BBSSetting(22))

		Else
		
	Str=YxBBs_Ubb3(Str,"\[upload=(txt|zip|rar|mdb|swf),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的附件</legend><br>&nbsp;&nbsp;<IMG SRC=Images/FileType/$1.gif align=absmiddle> <a href=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a> [ <font color=blue>$2</font> KB ]<br><br></fieldset>")
			Str=YxBBs_Ubb2(Str,"\[upload=(gif|jpg|jpeg|bmp|png),*(#*[0-9\.]*),([0-9]{1,3}),*(#*[0-9\.]*),*(#*[0-9\.]*)\]","\[\/upload\]","<fieldset><legend>上传的图片</legend><br>&nbsp;&nbsp;<img src=Images/FileType/$1.gif align=absmiddle> <A HREF=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a> [ <font color=blue>$2</font> KB <font color=blue>$4</font>×<font color=blue>$5</font> ] <font color=#999999>(缩略时请点击查看原图)</font><br><br>&nbsp;&nbsp;<IMG  onload=""javascript:if(this.width>screen.width-500)this.style.width=screen.width-500;"" SRC=""ViewFile.Asp?FileName=$6"" border=0><br><br></fieldset>","<A HREF=""ViewFile.Asp?FileName=$6"" TARGET=_blank>$6</a>",YxBBs.BBSSetting(22)) 

		End If
		End If
		If InStr(UbbString,",26,")>0 Then
			re.pattern="\[EMAIL\]([^\s@]+@[^\.]+\..+?)\[\/EMAIL\]"
			str=re.replace(str,"<a href=""mailto:$1"" target='_blank'>$1</a>")
			re.pattern="\[EMAIL=([^\s@]+@[^\.]+?\..+?)\](.+?)\[\/EMAIL\]"
			str=re.replace(str,"<a href=""mailto:$1"" target='_blank'>$2</a>")
		End If
		If InStr(UbbString,",27,")>0 Then Str=YxBBs_Ubb2(Str,"\[flash=*([0-9]*),*([0-9]*)\]","\[\/flash\]","<a href=""$3"" TARGET=_blank><IMG SRC=Images/FileType/swf.gif border=0 alt='点击开新窗口欣赏该FLASH动画!'>[全屏欣赏]</a><br><OBJECT codeBase=http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 width=$1 height=$2><PARAM NAME=movie VALUE=""$3""><PARAM NAME=quality VALUE=high><embed src=""$3"" quality=high pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width=$1 height=$2>$4</embed></OBJECT>","<A HREF=""$3"" TARGET=_blank>[此处含有一FLASH动画,点击观看]</A>",YxBBs.BBSSetting(20)) 
		If InStr(UbbString,",28,")>0 Then Str=YxBBs_Ubb1(Str,"\[mp=*([0-9]{1,3}),([0-9]{1,3})\]","\[\/mp\]","<br><b>此主题相关媒体如下：<a href=""$3"" TARGET=_blank>(点这里下载)</a></b><br><object align=middle classid=CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95 class=OBJECT id=MediaPlayer width=$1 height=$2 >" & vbcrlf & "<PARAM NAME=AUTOSTART VALUE=false><param name=ShowStatusBar value=-1>" & vbcrlf & "<param name=Filename value=$3>" & vbcrlf & "<embed type=application/x-oleobject codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701 flename=mp src=$3 width=$1 height=$2>" & vbcrlf & "</embed>" & vbcrlf & "</object>") 
		If InStr(UbbString,",29,")>0 Then Str=YxBBs_Ubb1(Str,"\[rm=([0-9]{1,3}),([0-9]{1,3})\]","\[\/rm\]","<b>此主题相关媒体如下：<a href=""$3"" TARGET=_blank>(点这里下载)</a></b><br><OBJECT classid=clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA class=OBJECT id=RAOCX width=$1 height=$2>" & vbcrlf & "<PARAM NAME=SRC VALUE=$3>" & vbcrlf & "<PARAM NAME=CONSOLE VALUE=Clip1>" & vbcrlf & "<PARAM NAME=CONTROLS VALUE=imagewindow>" & vbcrlf & "<PARAM NAME=AUTOSTART VALUE=false>" & vbcrlf & "</OBJECT>" & vbcrlf & "<br>" & vbcrlf & "<OBJECT classid=CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA height=32 id=video2 width=$1>" & vbcrlf & "<PARAM NAME=SRC VALUE=$3>" & vbcrlf & "<PARAM NAME=AUTOSTART VALUE=0>" & vbcrlf & "<PARAM NAME=CONTROLS VALUE=controlpanel>" & vbcrlf & "<PARAM NAME=CONSOLE VALUE=Clip1>" & vbcrlf & "</OBJECT>") 
		If InStr(UbbString,",30,")>0 Then Str=YxBBs_Ubb1(Str,"\[ra\]","\[\/ra\]","<b>这个是 RealPlayer 音乐：</b><br><object classid=clsid:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA class=OBJECT id=RAOCX width=280 height=70><param name=_ExtentX value=7938><param name=_ExtentY value=2646><param name=AUTOSTART value=0><param name=SHUFFLE value=0><param name=PREFETCH value=0><param name=NOLABELS value=0><param name=LOOP value=0><param name=NUMLOOP value=0><param name=CENTER value=0><param name=MAINTAINASPECT value=0><param name=BACKGROUNDCOLOR value=#000000><PARAM NAME=SRC VALUE=$1></object>") 
		If InStr(UbbString,",31,")>0 Then Str=UbbCode_Q(Str)
		If InStr(UbbString,",32,")>0 Then Str=YxBBs_GetUBB(Str,"\[coin=*([0-9]*)\]","\[\/coin\]","$1<hr noshade size=1><font color=gray>以下内容需要金钱数达到<B>$3</B>才可以浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要金钱数达到<B>$3</B>才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyCoin)
		If InStr(UbbString,",33,")>0 Then Str=YxBBs_GetUBB(Str,"\[mark=*([0-9]*)\]","\[\/mark\]","$1<hr noshade size=1><font color=gray>以下内容需要积分数达到<B>$3</B>才可以浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要积分数达到<B>$3</B>才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyMark)
		If InStr(UbbString,",34,")>0 Then Str=YxBBs_GetUBB(Str,"\[grade=*([0-9]*)\]","\[\/grade\]","$1<hr noshade size=1><font color=gray>以下内容需要等级为 <b>$3</b> 或更高的等级以及作者才能浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要等级为<B>$3</B>或更高的等级以及作者才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyGradeNum)
		If InStr(UbbString,",35,")>0 Then Str=YxBBs_Ubb_Login(Str,PostType)
		If InStr(UbbString,",36,")>0 Then Str=YxBBs_Ubb_Sex(Str,PostType)
		If InStr(UbbString,",37,")>0 Then Str=YxBBs_Ubb_Name(Str,PostType)
		If InStr(UbbString,",38,")>0 Then Str=YxBBs_Ubb_Date(Str,PostType)
		If InStr(UbbString,",39,")>0 Then Str=YxBBs_Ubb_Reply(Str,PostType)
		If InStr(UbbString,",40,")>0 Then Str=YxBBs_Ubb_Buy(Str,PostType)
		If YxBBs.BBSSetting(9)="0" Then
			If  InStr(UbbString,",2,")>0 Or InStr(UbbString,",3,")>0 Or InStr(UbbString,",4,")>0 Or InStr(UbbString,",5,")>0 Or InStr(UbbString,",6,")>0 Then
				re.Pattern = "^((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]:+!]+([^<>""|'])+)"
				str = re.Replace(str,"<a target=_blank href=$1>$1</a>")
				re.Pattern = "((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]:+!]+([^<>""])+)$([^\[|']*)"
				str = re.Replace(str,"<a target=_blank href=$1>$1</a>")
				re.Pattern = "([^>=""])((http|https|ftp|rtsp|mms):(\/\/|\\\\)[A-Za-z0-9\./=\?%\-&_~`@[\]:+!]+([^<>""|'])+)"
				str = re.Replace(str,"$1<a target=_blank href=$2>$2</a>")
			End If
			If InStr(UbbString,",1,")>0  Then
				re.Pattern = "([\s])((www|cn)[.](\w)+[.]{1,}(net|com|cn|org|cc)(((\/[\~]*|\\[\~]*)(\w)+)|[.](\w)+)*(((([?](\w)+){1}[=]*))*((\w)+){1}([\&](\w)+[\=](\w)+)*)*)"
				str = re.Replace(str,"<a target=_blank href=""http://$2"">$2</a>")
			End If
		End If
		Set re=Nothing
		YxBBs_UBB=Str
	End function
	
	Private Function Html_Code(byval Str)
		If IsNull(Str) then
			 Html_code=""
		Else
			Str=replace(Str,chr(32),"&nbsp;")
			Str=replace(Str,chr(39),"&#39;")
			Str=replace(Str,chr(36),"&#36;")
			Str=replace(Str,chr(34),"&quot;")
			Str=replace(Str,"<","&lt;")
			Str=replace(Str,">","&gt;")
			Str = Replace(Str, chr(13), "")
			Str = Replace(Str, chr(10) &chr(10), "<br><br> ")
			Html_Code = Replace(Str, chr(10), "<br> ")
		End if
	End Function

	Public Function Sign_Code(byval Str)
		If IsNull(Str) or Str="" Then
			Sign_Code=""
			Exit Function
		End If
		Str=Html_Code(Str)
		Set re=new regExp
		re.IgnoreCase=true
		re.Global=true	
		re.pattern="((javascript:)|(jscript:)|(object)|(js:)|(location.)|(vbscript:)|(vbs:)|(\.value)|(about:)|(file:)|(document.cookie)|(on(mouse|exit|error|click|key|load)))"
		str=re.replace(str,"<font color=#000000>$1</font>")
		If InStr(Lcase(Str),"[/b]")>0 Then Str=YxBBs_Ubb1(Str,"\[b\]","\[\/b\]","<b>$1</b>")
		If InStr(Lcase(Str),"[/i]")>0 Then Str=YxBBs_Ubb1(Str,"\[i\]","\[\/i\]","<i>$1</i>")
		If InStr(Lcase(Str),"[/u]")>0 Then Str=YxBBs_Ubb1(Str,"\[u\]","\[\/u\]","<u>$1</u>")
		If InStr(Lcase(Str),"[/color]")>0 Then Str=YxBBs_Ubb1(Str,"\[color=((#.{6})|.{3,6})\]","\[\/color\]","<font color=#$1>$3</font>") 
		If InStr(Lcase(Str),"[/url]")>0 Then Str=YxBBs_Ubb1(Str,"\[url=(.{5,}?)\]","\[\/url\]","<a href=""$1"" target='_blank'>$2</a>") 
		If InStr(Lcase(Str),"[/right]")>0 Then Str=YxBBs_Ubb1(Str,"\[right\]","\[\/right\]","<div align=right>$1</div>")	
		If InStr(Lcase(Str),"[/light]")>0 Then Str=YxBBs_Ubb1(Str,"\[light\]","\[\/light\]","<span style=""behavior:url(Inc/font.htc)"">$1</span>") 
		If InStr(Lcase(Str),"[em")>0 Then re.pattern="\[em*([0-9]*)]":str=re.replace(str,"<img src=Images/Emotions/em$1.gif>")
		If InStr(Lcase(Str),"[/size]")>0 Then Str=YxBBs_Ubb1(Str,"\[size=([1-7])\]","\[\/size\]","<font size=$1>$2</font>") 
		If InStr(Lcase(Str),"[/fly]")>0 Then Str=YxBBs_Ubb1(Str,"\[fly\]","\[\/fly\]","<marquee width=90% behavior=alternate scrollamount=3>$1</marquee>") 
		If InStr(Lcase(Str),"[/move]")>0 Then Str=YxBBs_Ubb1(Str,"\[move\]","\[\/move\]","<MARQUEE scrollamount=3>$1</marquee>") 
		If InStr(Lcase(Str),"[/aling]")>0 Then Str=YxBBs_Ubb1(Str,"\[align=(center|left|right)\]","\[\/align\]","<div align=$1>$2</div>") 
		If InStr(Lcase(Str),"[/shadow]")>0 Then Str=YxBBs_Ubb1(Str,"\[shadow=*([0-9]*),*(#*[a-z0-9]*),*([0-9]*)\]","\[\/shadow\]","<table width=$1 ><tr><td style=""filter:shadow(color=$2, stregExngth=$3)"">$4</td></tr></table>") 
		If InStr(Lcase(Str),"[/sound]")>0 Then Str=YxBBs_Ubb1(Str,"\[sound\]","\[\/sound\]","<a href=""$2"" target=_blank><IMG SRC=Images/FileType/mid.gif border=0 alt='背景音乐'></a><bgsound src=""$2"" loop=""-1"">") 
		If InStr(Lcase(Str),"[/img]")>0 Then Str=YxBBs_Ubb2(Str,"\[img\]","\[\/img\]","<img src=$1 border=0 style='cursor:hand' onload=""javascript:if(this.width>screen.width-333)this.width=screen.width-333"" onclick=""window.open(this.src,null,'')"">","<a href=$1 target=_blank>$1</a>",YxBBs.BBSSetting(22)) 
		If InStr(Lcase(Str),"[/email]")>0 Then
			re.pattern="\[EMAIL\]([^\s@]+@[^\.]+\..+?)\[\/EMAIL\]"
			str=re.replace(str,"<a href=""mailto:$1"" target='_blank'>$1</a>")
			re.pattern="\[EMAIL=([^\s@]+@[^\.]+?\..+?)\](.+?)\[\/EMAIL\]"
			str=re.replace(str,"<a href=""mailto:$1"" target='_blank'>$2</a>")
		End If
		Set re=nothing
		Sign_Code=Str
	End Function
	
	Private Function UbbCode_Q(strText)
		Dim s
		Dim Test
		Dim LoopCount
		LoopCount=0
		s=strText
		re.Pattern="\[QUOTE\]"
		Test=re.Test(s)
		If Test Then
			re.Pattern="\[\/QUOTE\]"
			Test=re.Test(s)
			If Test Then
				re.Pattern="\[QUOTE\]"
				s=re.replace(s, chr(1) & "QUOTE" & chr(2))
				re.Pattern="\[\/QUOTE\]"
				s=re.replace(s, chr(1) & "/QUOTE" & chr(2))
				Do
					re.Pattern="\x01QUOTE\x02\x01\/QUOTE\x02"
					s=re.Replace(s,"")
					re.Pattern="\x01QUOTE\x02(.[^\x01]*)\x01\/QUOTE\x02"
					s=re.Replace(s,"<table cellpadding=0 cellspacing=0 border=1 WIDTH='90%' style='border-collapse: collapse' bordercolor=red align=center><tr><td bgcolor='#f2f8ff'><p style='margin:15'>$1</p></td></tr></table><br>")
					Test=re.Test(s)
					LoopCount=LoopCount+1
					If LoopCount>MaxLoopCount Then Exit Do
				Loop While(Test)
				re.Pattern="\x02"
				s=re.replace(s, "]")
				re.Pattern="\x01"
				s=re.replace(s, "[")
			End If 
		End If
		UbbCode_Q=s
	End Function

	Private Function text_encode(byval str)
		If isnull(str) then
			text_encode=""
		Else
			str=replace(Str,"&#124;","|")
			str=replace(Str,"&#39;",chr(39))
			str=replace(str,"&","&amp;")
			str=replace(str,"<","&lt;")
			text_encode=replace(str,">","&gt;")
		End if
	End function

	Private Function YxBBs_Ubb1(Str,uCodeL,uCodeR,tCode)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		s=re.Replace(s,tCode)
		re.Pattern=uCodeL
		s=re.Replace(s,"")
		re.Pattern=uCodeR
		s=re.Replace(s,"")
		YxBBs_Ubb1=s
	End Function

	Private Function YxBBs_Ubb3(Str,uCodeL,uCodeR,tCode)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		s=re.Replace(s,tCode)
		YxBBs_Ubb3=s
	End Function
	
	Private Function YxBBs_Ubb2(Str,uCodeL,uCodeR,tCode1,tCode2,BBSCheck)
		Dim s
		s=str
		re.Pattern=uCodeL&uCodeR
		s=re.Replace(s,"")
		re.Pattern=uCodeL&"(.+?)"&uCodeR
		If BBScheck="0" Then
		s=re.Replace(s,tCode1)
		Else
		s=re.Replace(s,tCode2)
		End If
		re.Pattern=uCodeL
		s=re.Replace(s,"")
		re.Pattern=uCodeR
		s=re.Replace(s,"")
		YxBBs_Ubb2=s
	End Function

	Private Function YxBBs_Code(Str,PostType)
		dim ary_String,i,n,n_pos
		ary_String=split(Str,"[code]")
		n=ubound(ary_String)
		If n<1 then
			YxBBs_Code=YxBBs_UBB(Str,PostType)
			Exit function
		End If
		ary_String(0)=YxBBs_UBB(ary_String(0),postType)
		for i=1 to n
			n_pos=inStr(ary_String(i),"[/code]")
			If n_pos>0 then
				ary_String(i)="<b>以下为程序代码：</b><br><form><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td width='95%'><textarea style='border:solid 1px #EEAF71;width:100%' name='dbg' rows='10'>" & text_encode(left(ary_String(i),n_pos-1)) & "</textarea><br><input type='button' class='button' value='运行此代码' style='width:80px' onclick='runit(this.form.dbg)'> <input type='button' class='button' value='复制到剪贴板' style='width:90px' onclick='copyit(this.form.dbg)'> <input type='button' class='button' value='代码另存为' style='width:80px' onclick='saveAs(this.form.dbg)'> </td><td width='5%' valign='top'><input type='button' style='BACKGROUND: url(Images/plus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(5,this.form.dbg)' ><br><br><input type='button' style='BACKGROUND: url(Images/minus.gif); width:20;height:20;border:0;cursor:hand' onclick='textarea_Size(-5,this.form.dbg)'></td></tr></table></form>" & YXBBS_UBB(right(ary_String(i),len(ary_String(i))-n_pos-6),PostType)
			Else
				ary_String(i)="[code]" & YxBBs_UBB(ary_String(i),PostType)
			End if
		next
		YxBBs_Code=join(ary_String,"")
	End Function

	Rem 入口（内容,开始的UBB，结束的UBB，显示允许，显示不允许，标记：1=帖子/2=留言公告，用户的信息）
	Rem (Str,"\[grade=*([0-9]*)\]","\[\/grade\]","$1<hr noshade size=1><font color=gray>以下内容需要等级为 <b>$3</b> 或更高的等级以及作者才能浏览</font><BR>$4<hr noshade size=1>$6","$1<hr noshade size=1><font color=Red>以下内容需要等级为<B>$3</B>或更高的等级以及作者才可以浏览</font><hr noshade size=1>$6",PostType,YxBBs.MyGrade)
	Private Function YxBBs_GetUBB(Str,uCodeL,uCodeR,tCode1,tCode2,postType,MyInfo)
		Dim Test
		Dim po,ii
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern=uCodeL
			Test=re.Test(Str)
			If Test Then
				re.Pattern=uCodeR
				Test=re.Test(Str)
				If Test Then
					If PostType=1 Then
						re.Pattern="(^.*)("&uCodeL&")(.+?)("&uCodeR&")(.*)"
						po=re.Replace(Str,"$3")
						If  IsNumeric(po) Then
							ii=int(po) 
						Else
							ii=0
						End If 
						If YxBBs.Founduser and (Lcase(YxBBs.MyName)=Lcase(UserName) or int(MyInfo)>=int(ii) or YxBBs.ClassID<=2 or YxBBs.IsBoardAdmin) Then
							Str=re.Replace(str,tCode1)
						Else
							Str=re.Replace(str,tCode2)
						End If
					Else
						re.Pattern="("&uCodeL&")(.+?)("&uCodeR&")"
						s=re.Replace(s,"$3")
					End If 
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_GetUBB=Str
	End Function

	Private Function YxBBs_Ubb_Login(Str,PostType)
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[login\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/login\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[login\])(.+?)(\[\/login\])(.*)"
					If YxBBs.FoundUser Then
						Str=re.Replace(str,"$1<hr height=1><font color=#A2A2A2>此帖内容<b>必须登陆</b>后才能浏览</font><BR>$3</font><hr size=1>$5")
					Else
						Str=re.Replace(str,"$1<hr height=1><font color=Red>此帖内容<b>必须<a href=login.Asp>登陆</a></b>后才能浏览<BR></font><hr size=1>$5")
					End if
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Login=Str
	End Function

	Private Function YxBBs_Ubb_Sex(Str,PostType)
		Dim Test
		Dim LoopCount
		Dim Tmp_Str,po
		LoopCount=0
		Do While True
			re.Pattern="\[sex=*([0-1]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/sex\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[sex=*([0-1]*)\])(.+?)(\[\/sex\])(.*)"
					If PostType=1 Then
						po=re.replace(str,"$3")
						If isnumeric(po) then
							If int(po)=0 then Tmp_Str="女"
							If int(po)=1 then Tmp_Str="男"
							If Not YxBBs.FoundUser Then
								str=re.Replace(str,"$1<hr size=1><font color=Red>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR><hr size=1>$6")
							Else
							If (YxBBs.MySex And int(po)=1) or (Not YxBBs.MySex And int(po)=0) or Lcase(YxBBs.MyName)=Lcase(UserName) Then
								str=re.Replace(str,"$1<hr size=1><font color=#A2A2A2>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR>$4<hr size=1>$6")
							Else
								str=re.Replace(str,"$1<hr size=1><font color=Red>此内容需要性别为<font color=red> <b>"&Tmp_Str&"</b></font> 和作者才能浏览：</font><BR><hr size=1>$6")
							End If
							End If
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Sex=Str
	End Function

	Private Function YxBBs_Ubb_Name(Str,PostType)
		Dim Test
		Dim LoopCount
		Dim Tmp_My,tmp_str,I
		LoopCount=0
		Do While True
			re.Pattern="\[username=(.[^\[]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/username\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[username=(.[^\[]*)\])(.+?)(\[\/username\])(.*)"
					If PostType=1 Then
						Tmp_Str=re.replace(str,"$3")
						Tmp_Str=split(Tmp_Str,",")
						Tmp_My=False
						For i=0 to ubound(Tmp_Str)
							If lcase(YxBBs.MyName)=lcase(Tmp_Str(i)) then Tmp_My=True:Exit For
						Next
						If Tmp_My or Lcase(YxBBs.MyName)=Lcase(UserName) Then
							Str=re.Replace(str,"$1<hr size=1><font color=#A2A2A2>此内容只有作者和 <b>$3</b> 能浏览：</font><BR>$4<hr size=1>$6")
						Else
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和 <b>$3</b> 能浏览：</font><BR><hr size=1>$6")
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Name=Str
	End Function
	
	Private Function YxBBs_Ubb_Reply(Str,PostType)
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[reply\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/reply\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[reply\])((.|\n)+?)(\[\/reply\])(.*)"
					IF PostType=1 Then
						If YxBBs.ClassID=1 or Not(YxBBs.execute("select BbsID From[YX_bbs"&YxBBs.TB&"] where ReplyTopicID="&ID&" and name='"&YxBBs.MyName&"'").eof) or Lcase(YxBBs.MyName)=Lcase(UserName) then
							str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和已经回复此帖的浏览者能浏览：</font><BR>$3<hr size=1>$6")
						Else
							str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有作者和已经回复此帖的浏览者能浏览：</font><BR><hr size=1>$6")
						End if
					Else
						str=re.Replace(str,"$3")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Reply=Str
	End Function

	Private Function YxBBs_Ubb_Date(Str,PostType)
		Dim Tmp_int,Tmp_My,tmp_str
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[date=(.[^\[]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/date\]"
				Test=re.Test(Str)
				If Test Then	
					re.Pattern="(^.*)(\[date=(.[^\[]*)\])(.[^\[]*)(\[\/date\])(.*)"
					IF PostType=1 Then
						Tmp_Str=re.replace(str,"$3")
						If IsDate(Tmp_Str) Then Tmp_Int=Datediff("d",cdate(Tmp_Str),cdate(YxBBs.NowBbsTime)) Else Tmp_Int=-1
						If int(Tmp_Int)>0 Then
							Str=re.Replace(Str,"$1<hr size=1><font color=Red>此内容只有：<b>"&Tmp_Str&"</b>这天以后才能浏览：</font><BR>$4<hr size=1>$6")
						Else
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容只有：<b>"&Tmp_Str&"</b>这天以后才能浏览：</font><BR><hr size=1>$6")
						End If
					Else
						Str=re.Replace(str,"$1")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Date=Str					
	End Function

	Private Function YxBBs_Ubb_Buy(Str,PostType)
		Dim Tmp_int,Tmp_My,tmp_str,i
		Dim Test
		Dim LoopCount
		LoopCount=0
		Do While True
			re.Pattern="\[buypost=*([0-9]*)\]"
			Test=re.Test(Str)
			If Test Then
				re.Pattern="\[\/buypost\]"
				Test=re.Test(Str)
				If Test Then
					re.Pattern="(^.*)(\[buypost=*([0-9]*)\])(.+?)(\[\/buypost\])(.*)"
					If PostType=1 Then
						If Not YxBBs.FoundUser Then
							Str=re.Replace(str,"$1<hr size=1><font color=Red>此内容要求金钱数达到$3以上才可以购买并浏览</font><hr noshade size=1>$6")
						Else
							Tmp_My="<Form action='VoteSubmit.Asp?Action=buy' method='Get'><input type=hidden value="&BbsID&" name='ID'><input type=hidden value="&YxBBs.TB&" name='TB'><input type=submit  value='好黑啊…我…我买了！'></form>"
							Tmp_Int=re.Replace(str,"$3")
							If isnumeric(Tmp_Int) Then Tmp_Int=int(Tmp_Int) Else Tmp_Int=0
							If BBSID=0 Then
							Tmp_Str=""
							Else
							Tmp_Str=YxBBs.execute("select Buyer From[YX_bbs"&YxBBs.TB&"] where BbsID="&BbsID&"")(0)
							End If
							If Lcase(YxBBs.MyName)=Lcase(UserName) or YxBBs.ClassID<=2 Or YxBBs.IsBoardAdmin Then
								Dim PostBuyUser
								If (not isnull(Tmp_Str)) and Tmp_Str<>"" then
									Tmp_Str=split(Tmp_Str,"|")
									PostBuyUser=""
									For i=0 to ubound(Tmp_Str)
									PostBuyUser=PostBuyUser & "<option value="&i&">"&Tmp_Str(i)&"</option>"
									Next
									PostBuyUser="<select name=buyuser size=1><option value=0>共有"&ubound(Tmp_Str)&"位用户购买</option>"&PostBuyUser & "</select>"
								Else
									PostBuyUser="<select name=buyuser size=1><option value=0>还没有用户购买</option></select>"
								End if
								If YxBBs.MyName<>UserName Then PostBuyUser=Tmp_My&PostBuyUser
								Str=re.Replace(str,"$1<hr size=1><font color=Red>以下为需要金钱数达到<B>$3</B>才能浏览的内容</font>&nbsp;&nbsp;"&PostBuyUser&"<BR>$4<hr size=1>$6")
							Else
								If instr("|"&Tmp_Str&"|","|"&YxBBs.MyName&"|")>0 then
									Str=re.Replace(str,"$1<hr noshade size=1>以下为需要花 <del><B>$3</B></del> 金钱才能购买并浏览的内容，您已经购买本帖<BR>$4<hr noshade size=1>$6")
								Else
									If Int(YxBBs.MyCoin)>Tmp_Int then
										str=re.Replace(str,"$1<hr size=1><font color=Red>此帖子内容需要您花 <B>$3</B> 金钱来购买浏览&nbsp;&nbsp;"&Tmp_My&"</font><hr size=1>$6")
									Else
										str=re.Replace(str,"$1<hr size=1><font color=Red>此内容要求金钱数达到 <B>$3</B> 以上才可以购买并浏览</font><hr size=1>$6")
									end if
								End if
							End if
						End if
					Else
						Str=re.Replace(str,"$4")
					End If
				Else
					Exit Do
				End If 
			Else
				Exit Do
			End If
			LoopCount=LoopCount + 1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		YxBBs_Ubb_Buy=Str
	End Function

	Function UBBCode_HighLight(Str)
		Dim HighLight
		Set HighLight = New YxBBs_CodeHighLight_Cls
		HighLight.VBCode=Str
		UBBCode_HighLight=HighLight.MakeLi()
		Set HighLight = NoThing
	End Function
End Class

Class YxBBs_CodeHighLight_Cls
	Private RegEx
	Public Keyword,ObjectCommand,Strings,VBCode
	Public KeyWordColor,ObjectCommandColor,StringsColor,Comment,CodeColor

	Private Sub Class_Initialize()
		Set RegEx = New RegExp
		RegEx.IgnoreCase = True
		RegEx.Global = True
		KeyWordColor="#0000FF"
		ObjectCommandColor="#FF0000"
		StringsColor="#FF00FF"
		Comment="#008000"
		CodeColor="#993300"
		Keyword="Set|Private|If|Then|Sub|End|Function|For|Next|Do|While|Wend|True|False|Nothing|Class|Request|Response|Dim|Call|Const|Rnd|To|SELECT|CASE"
		ObjectCommand="Left|Mid|Right|Int|Cint|Clng|String|Join|Array|IsNumeric|Trim|Session|Write|close|open|Server|ubound|split"
		VBCode=""
	End Sub

	Private Sub Class_Terminate()
		Set RegEx = Nothing
	End Sub

	Private Function M_Replace(Str,Pattern,Color)
		RegEx.Pattern = Pattern
		M_Replace=RegEx.Replace(Str,"<font color="&Color&">$1</font>")
	End Function

	Private Function String_Replace(Str,Pattern,Pattern1,Color,IsString)
		Dim Temp,RetStr,Matches,Match
		RegEx.Pattern =Pattern1
		Set Matches = RegEx.Execute(Str)
		For Each Match In Matches
			Temp=Re(Match.value)
			Str = Replace(Str,Match.value,Temp)
		Next
		RegEx.Pattern = Pattern
		If IsString=1 Then
			String_Replace=RegEx.Replace(Str,"<font color="&Color&">&quot;$1&quot;</font>")
		Else
			String_Replace=RegEx.Replace(Str,"<font color="&Color&">$1</font>")
		End If
	End Function


	Private Function Re(Str)
		Dim TRegEx,Temp
		Set TRegEx = New RegExp
		TRegEx.IgnoreCase = True
		TRegEx.Global = True
		TRegEx.Pattern="<.*?>"
		Temp=TRegEx.Replace(Str,"")
		Temp=Replace(Temp,"<","")
		Temp=Replace(Temp,">","")
		Re=Temp
		Set TRegEx=Nothing
	End Function

	Public Function MakeLi()
		Dim Temp
		If VBCode="" Then
			MakeLi=""
			Exit Function
		End If
		VBCode=HTMLEncode(VBCode)
		Temp=M_Replace(VBCode,"\b("&Keyword&")\b",KeyWordColor)
		Temp=M_Replace(Temp,"\b("&ObjEctCommand&")\b",ObjectCommandColor)
		Temp=String_Replace(Temp,"""(.*?)""","""(.*)(<.+?>)("&KeyWord&ObjectCommand&")+(<.+?>)(.*)""",StringsColor,1)
		Temp=String_Replace(Temp,"(('|rem).*)","'(.*)(<.+?>)("&KeyWord&ObjectCommand&")+(<.+?>)(.*)",Comment,0)
		MakeLi="<FONT  COLOR="&CodeColor&">"&RepVbCrlf(Temp)&"</FONT>"
	End Function

	Public Function RepVbCrlf(fString)
		RepVbCrlf = Replace(fString, CHR(10), "<BR> ")
	End Function

	Public Function HTMLEncode(fString)
		If IsNull(fString) Or fString="" Then
			HTMLEncode=""
			Exit Function
		End If
		fString = replace(fString, ">", "&gt;")
		fString = replace(fString, "<", "&lt;")
		'fString = Replace(fString, CHR(32), "&nbsp;")
		'fString = Replace(fString, CHR(9), "&nbsp;")
		'fString = Replace(fString, CHR(34), "&quot;")
		'fString = Replace(fString, CHR(39), "&#39;")
		'fString = Replace(fString, CHR(13), "")
		'fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
		'fString = Replace(fString, CHR(10), "<BR> ")
		HTMLEncode = fString
	End Function
End Class
</script>