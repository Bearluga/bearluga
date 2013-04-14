<!--#include file="Conn.Asp"-->
<!--#include file="../inc/md5.Asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
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
<script language="JavaScript">
function checkclick(msg){if(confirm(msg)){event.returnValue=true;}else{event.returnValue=false;}}
</SCRIPT>
<%
Dim AdminName,AdminPassword,CheckName,Rs
AdminName=Session(YxBBs.CacheName&"AdminName")
AdminPassword=Session(YxBBs.CacheName&"AdminPassword")
CheckName=Session(YxBBs.CacheName&"CheckName")
IF AdminName="" or AdminPassword="" Then
	If  instr(Lcase(Request("Url")),"index.asp")>0 Then
		Response.redirect"Login.Asp"
	Else
	Call ShowTable("论坛安全时间","系统安全管理超时，请重新 【<a href=Login.Asp target='_parent'>登陆</a>】")
	Response.End
	End If
End If

If not YxBBs.Fun.CheckName(AdminName) or CheckName<>YxBBs.MyName then Response.redirect"login.Asp"
If YxBBs.Execute("Select name from [YX_admin] where Name='"&AdminName&"' and Password='"&Md5(AdminPassword)&"'").eof  Then
	Response.Redirect"Login.Asp"
	Response.End
End if

Sub GoBack(Str1,Str2)
	If Str1="" Then Str1="错误信息"
	If Str2="" Then Str2="请填写完整必填项目"
	Str2="<li>"&Str2&"<li><a href=javascript:history.go(-1)>返回重填</a>"
	Response.Write("<table width='98%' border='0' align='center' cellpadding='4' cellspacing='1' bgcolor='#FFFFFF'><tr bgcolor='#CCCCCC'><td height='25' colspan='3'><b>"&Str1&"</b></td></tr><tr bgcolor='#DEDEDE'><td><table width='100%'><tr><td><font color=red size=15><b>×</b></font></td><td width='98%'><Div style='margin:10;line-height: 150%'>"&str2&"</Div></td></tr></table></td></tr></table>")
	Response.End()
End Sub

Sub ShowTable(Str1,Str2)
	Response.Write("<table width='98%' border='0' align='center' cellpadding='4' cellspacing='1' bgcolor='#FFFFFF'><tr bgcolor='#CCCCCC'><td height='25' colspan='3'><b>"&Str1&"</b></td></tr><tr bgcolor='#DEDEDE'><td><table width='100%'><tr><td><Div style='margin:10;line-height: 150%'>"&str2&"</Div></td></tr></table></td></tr></table>")
End Sub

Sub Suc(Str1,Str2,url)
	If Str1="" Then Str1="操作成功"
	If Str2="" Then Str2="成功的完成这次操作！"
	Str2="<li>"&Str2&"<li><a href="&Url&">返回继续管理</a>"
	Response.Write("<table width='98%' border='0' align='center' cellpadding='4' cellspacing='1' bgcolor='#FFFFFF'><tr bgcolor='#CCCCCC'><td height='25' colspan='3'><b>"&Str1&"</b></td></tr><tr bgcolor='#DEDEDE'><td><table width='100%'><tr><td><font color=red size=15><b>√</b></font></td><td width='98%'><Div style='margin:10;line-height: 150%'>"&Str2&"</Div></td></tr></table></td></tr></table>")
End Sub
Sub AdminFooter()
	Set YxBBs=Nothing
End Sub
%>