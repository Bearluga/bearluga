<!--#include file="Conn.Asp"-->
<!--#include file="../inc/md5.Asp"-->
<style type="text/css">
BODY{
background-color:#0072BC;
font-family:Verdana, Tahoma, Arial;
FONT-SIZE: 9pt; 
SCROLLBAR-HIGHLIGHT-COLOR: buttonface;
SCROLLBAR-SHADOW-COLOR: buttonface;
SCROLLBAR-3DLIGHT-COLOR: buttonhighlight;
SCROLLBAR-TRACK-COLOR: #eeeeee;
SCROLLBAR-DARKSHADOW-COLOR: buttonshadow;
}

table{ WORD-BREAK: break-all;}
tr,td{
	font-family:Verdana;
	font-size:9pt;
}
a:link{text-decoration:none;color:#003399}
a:visited{text-decoration:none;color:#003399}
a:hover{text-decoration:none;color:#FF8040;position: relative; left: 1px; top: 1px; clip: rect()}
input,select{
	BORDER-RIGHT: #AAAAAA 1px solid; BORDER-TOP: #AAAAAA 1px solid; FONT-SIZE: 9pt; BACKGROUND: url(Images/Inputbg.gif) #ffffff; BORDER-LEFT: #AAAAAA 1px solid; COLOR: #333333; BORDER-BOTTOM: #AAAAAA 1px solid; FONT-FAMILY: verdana;
}
textarea{
	PADDING-RIGHT: 5px; PADDING-LEFT: 5px; FONT-WEIGHT: normal; FONT-SIZE: 12px; PADDING-BOTTOM: 5px; WIDTH: 98%; LINE-HEIGHT: normal; PADDING-TOP: 5px; border-width:1px;FONT-STYLE: normal;
}
.3d {
	font-size: 10pt;
	COLOR: #ffffff;
	FILTER: glow(color=000000,strength=2) dropshadow(color=#aaaaaa,offx=1, offy=1, positive=2);
	HEIGHT: 1px;
	MARGIN: 0px;
	font-weight: bold;
}
</STYLE>
<%Dim Action,MyName
Action=Request.QueryString("Action")

Select Case Action
Case"exit"
	ExitLogin()
Case"login"
	CheckLogin()
Case Else
	Main()
End select
Set YxBBs=Nothing

Sub Main()
	Response.Write"<title>论坛登陆</title>"&_
	"<br><br><form method=POST action='?action=login' style='margin:0'>"&_
	"<table width='500' border='0' cellspacing='1' cellpadding='4' align='center' bgcolor='#DDDDDD'>"&_
	"<tr bgcolor='#EFEFEF'><td height='25' align='center'>≡ 后台管理登陆 ≡</td></tr>"&_
	"<tr><td align='center' bgcolor='#FFFFFF'>"&_
	"<table width='100%' height='118'  border='0' cellpadding='0' cellspacing='0'>"&_
	"<tr><td width='40%' align='right'>管理账号：</td><td width='60%'><input name='AdminName' type=text size='22'></td></tr>"&_
	"<tr><td align='right'>管理密码：</td><td><input name='Password' type=password size='22'></td></tr>"&_
	"<tr><td align='right'>验 证 码：</td><td><input type=text name='PassCode' size=10> <img align='absmiddle' src=../Inc/Code.Asp ></td></tr></table> "&_
	"</td></tr><tr bgcolor='#EFEFEF'><td height='25' align='center'><input type=submit class=submit value=' 提  交 '>"&_
	"</td></tr></table></form>"
End Sub

Sub CheckLogin()
	Dim AdminName,AdminPassword,PassCode
	If YxBBs.GetCookiesInfo("AdminLogin",0)=>5 Then Call Alert("您已经超过三次错误的尝试，今天不能再登陆论坛后台了！","../Default.Asp")
	AdminName=YxBBs.Fun.GetStr("AdminName")
	AdminPassword=YxBBs.Fun.GetStr("Password")
	PassCode=YxBBs.Fun.GetStr("PassCode")
	If not YxBBs.Fun.CheckName(AdminName) Or PassCode="" then
		Call Alert("您输入的用户名不存在或随机验证码错误！\n错误操作 "&YxBBs.UpdateCookiesInfo("AdminLogin",1)&" 次！","login.Asp")
	End if
	If YxBBs.Execute("select name From [YX_admin] where name='"&AdminName&"' And Password='"&Md5(AdminPassword)&"'").eof Or Session("CheckCode")<>PassCode Then
		Session(YxBBs.CacheName&"AdminName")=""
		Session(YxBBs.CacheName&"AdminPassword")=""
		
		Session("CheckCode")=""
		Call Alert("您输入的用户名不存在或者密码错误！\n错误操作 "&YxBBs.UpdateCookiesInfo("AdminLogin",1) &" 次！","login.Asp")
	Else
		Session(YxBBs.CacheName&"AdminName")=AdminName
		Session(YxBBs.CacheName&"AdminPassword")=AdminPassword
		
		Session("CheckCode")=""
		Call YxBBs.UpdateCookiesInfo("AdminLogin",0)
		Conn.Execute("Update YX_Admin set LastLoginIP='"&replace(Request.ServerVariables("REMOTE_ADDR"),"'","")&"',LastLoginTime='"&Now()&"' where Name='"&AdminName&"'")
		Response.Redirect"Index.Asp"
		Response.End
	End if
End Sub

Sub Alert(message,url)
	message = replace(message,"'","\'")
	Url = replace(Url,"'","\'")
	Response.Write ("<script LANGUAGE='javascript'>alert('" & message & "');window.location.href='" & Url & "';</script>")
	Response.End
End Sub

Sub ExitLogin()
	Session(YxBBs.CacheName&"AdminName")=""
	Session(YxBBs.CacheName&"AdminPassword")=""
	Session("CheckCode")=""
	'Session.Abandon
	Response.redirect"../Default.Asp"
End Sub
%>