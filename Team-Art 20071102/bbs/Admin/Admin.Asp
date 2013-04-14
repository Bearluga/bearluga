<!--#include file="Check.Asp"-->
<!--#include file="../Inc/Page_Cls.Asp"-->
<!--#include file="../inc/Ubb_Cls.Asp"-->
<script>
function okdel()
{
	if(!confirm("你是否确认删除？"))
		return false
	else
		return true
}
</script>

<%
if Request("action")="del" and isNumeric(Request("ID")) then
        if conn.execute("Select count(*) from YX_Admin")(0)<=1 Then 
        Call GoBack("","目前只有一个管理员，不能删除！")
        Else
        Conn.Execute("Delete From YX_Admin where id="&Request("ID")&"")
        Call Suc("","管理员删除成功！","Admin.Asp")
End if
End if
%>
<%if Request("action")="" then%>
<table cellpadding=6 cellspacing=1 border=0 width=95% bgcolor="#FFFFFF" align="center">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=4 align=center>
	<font color="#800000"><b>管 理 员 信 息</b></font></td></tr>
 		<tr>
		<td bgcolor=#d7d7d7 width="25%" align="center"><b><font color="#000077">用户名</font></b></td>		
		<td bgcolor=#d7d7d7 width="25%" align="center"><b><font color="#000077">
		上次登录时间</font></b></td>
		<td bgcolor=#d7d7d7 width="25%" align="center"><b><font color="#000077">
		上次登录IP</font></b></td>
		<td bgcolor=#d7d7d7 width="25%" align="center"><b><font color="#000077">操作</font></b></td>		
		</tr>
		<%
		Set Rs=Conn.execute("select ID,Name,LastLoginTime,LastLoginIP from YX_Admin")
		while not rs.eof
		%>
 		<tr>
		<td bgcolor=#d7d7d7 width="25%"><A HREF="?action=editadmin1&ID=<%=rs("ID")%>"><%=rs("Name")%></A></td>		
		<td bgcolor=#d7d7d7 width="25%"><%=rs("LastLoginTime")%></td>		
		<td bgcolor=#d7d7d7 width="25%"><%=rs("LastLoginIP")%></td>		
		<td bgcolor=#d7d7d7 width="25%" align="center"><A HREF="?action=editadmin1&ID=<%=rs("ID")%>">编辑</A> <A HREF="?Action=del&ID=<%=rs("ID")%>" onclick="return okdel()">删除</a></td>		
		</tr>
		<%
		rs.movenext
		wend
		set rs=nothing
		%>
		<tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=4 align=center>
	</td></tr>
</table>
<%end if%>
<%if Request("action")="Right" then%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
    <tr align="center" bgcolor="#CCCCCC">
    <td height="28" colspan="2"><b>论坛系统信息</b></td>
    </tr>
  <tr bgcolor="#DEDEDE">
	<td width="50%">总帖数：<font color=blue><%=YxBBs.AllEssayNum%></font></td>
	<td width="50%">主题数：<font color=blue><%=YxBBs.TopicNum%></font></td>
  </tr>
  <tr bgcolor="#DEDEDE">
	<td>注册人数：<font color=blue><%=YxBBs.userNum%></font></td>
	<td>最新加入：<font color=blue><%=YxBBs.NewUser%></font></td>
  </tr>
  <tr bgcolor="#DEDEDE">
	<td>创建时间：<font color=blue><%=YxBBs.BuildDate%></font></td>
	<td>今日新帖：<font color=blue><%=YxBBs.TodayNum%></font></td>
  </tr>
  <tr bgcolor="#DEDEDE">
	<td>目前在线人数：<font color=blue><%=YxBBs.Execute("Select Count(ID) From[YX_online]")(0)%></font></td>
	<td>最大在线人数：<font color=blue><%=YxBBs.MaxOnlineNum%></font> (<%=YxBBs.MaxOnlineTime%>)</td>
  </tr>
  <tr bgcolor="#DEDEDE">
  </tr>
</table>
<br>
<script language="javascript" type="text/javascript" SRC="http://www.yimxu.com/js/ver.js"></script>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr bgcolor="#CCCCCC">
    <td height="28" colspan="3">服务器的有关参数</td>
  </tr>
  <tr bgcolor="#dedede">
    <td width="17%">&nbsp;服务器名：</td>
    <td width="32%" bgcolor="#dedede">&nbsp;
        <%response.write Request.ServerVariables("SERVER_NAME")%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器IP：</td>
    <td>&nbsp;
        <%response.write Request.ServerVariables("LOCAL_ADDR")%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器端口：</td>
    <td>&nbsp;
        <%response.write Request.ServerVariables("SERVER_PORT")%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器时间：</td>
    <td>&nbsp;
        <%response.write now%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器IIS版本：</td>
    <td>&nbsp;
        <%response.write Request.ServerVariables("SERVER_SOFTWARE")%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器操作系统：</td>
    <td>&nbsp;
        <%if Request.ServerVariables("OS")="" then
	response.write "Windows 2003"
	else
	response.write Request.ServerVariables("OS")
	end if%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;脚本超时时间：</td>
    <td>&nbsp;
        <%response.write Server.ScriptTimeout%>
    秒</td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;站点物理路径：</td>
    <td>&nbsp;
        <%response.write Request.ServerVariables("APPL_PHYSICAL_PATH")%></td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器CPU数量：</td>
    <td>&nbsp;
        <%response.write Request.ServerVariables("NUMBER_OF_PROCESSORS")%>
    个</td>
  </tr>
  <tr bgcolor="#dedede">
    <td>&nbsp;服务器解译引擎：</td>
    <td>&nbsp;
        <%response.write ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></td>
  </tr>
  <tr bgcolor="#CCCCCC"><td  width='50%' height="26" colspan=2>组件支持有关参数</td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td width="25%">数据库(ADO)支持：</td>
    <td width="25%">&nbsp;
        <%if object_install("adodb.connection")=false then%>
        <font color=red><b>×</b></font> （不支持）
        <% else %>
        <b>√</b> （支持）
    <% end if %></td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td>&nbsp;FSO文本读写：</td>
    <td>&nbsp;
        <%if object_install("scripting.filesystemobject")=false then
	Session(YxBBs.CacheName&"fso")="no"%>
        <font color=red><b>×</b></font> （不支持）
        <% else
	Session(YxBBs.CacheName&"fso")="" %>
        <b>√</b> （支持）
    <% end if %></td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td>&nbsp;Stream文件流：</td>
    <td>&nbsp;
        <%if object_install("Adodb.Stream")=false then%>
        <font color=red><b>×</b></font> （不支持）
        <% else %>
        <b>√</b> （支持）
    <% end if %></td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td>&nbsp;Jmail组件支持：</td>
    <td>&nbsp;
        <%If object_install("JMail.SMTPMail")=false Then%>
        <font color=red><b>×</b></font> （不支持）
        <% else %>
        <b>√</b> （支持）
    <% end if %></td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td>&nbsp;CDONTS组件支持：</td>
    <td>&nbsp;
        <%If object_install("CDONTS.NewMail")=false Then%>
        <font Color=red><b>×</b></font> （不支持）
        <% else %>
        <b>√</b> （支持）
    <% end if %></td>
  </tr>
</table>
<%
function object_install(strclassstring)
  on error resume next
  object_install=false
  dim xtestobj
  err=0
  set xtestobj=server.createobject(strclassstring)
  if err=0 then object_install=true
  set xtestobj=nothing
  err=0
End function
%>
<%end if%>

<%if Request("action")="setadv" then%> 

<form method=POST action=?action=setadvok>
<div align="center">
<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#FFFFFF" width="98%">
  <tr class=td2>
    <td width="40%" bgcolor="#CCCCCC" valign="top">
    <p style="line-height: 150%; margin: 4"><font color="#000000">
	<span style="font-weight: 400">论坛已有广告的显示效果：</span></font></td>
    <td width="60%" bgcolor="#CCCCCC">
    <p style="line-height: 150%; margin: 4"><font color="#000000">
	<span style="font-weight: 400">论坛已有广告的代码：<br>清空代码即删除广告。</span></font></td>
  </tr>

<%
dim fso1,openfile,tmpstr,tmp,ad_num,ad_i,ad_tmp
set fso1 = server.createobject("scripting.filesystemobject")
Set openfile=fso1.OpenTextFile(Server.MapPath("../inc/ads.js"))
tmpstr=openfile.readall
tmp=split(tmpstr,chr(13)&chr(10))
ad_num=replace(tmp(1),"a = ","")
ad_num=int(replace(ad_num,";if(a==0){a=1}",""))
for ad_i=1 to ad_num
ad_tmp=replace(tmp(ad_i+8),"b["&ad_i&"].under =","")
ad_tmp=replace(ad_tmp,"'","")
response.write"<tr><td bgcolor=#DEDEDE valign=top><p style='line-height: 150%; margin: 4'>"&ad_tmp&"</td><td bgcolor=#DEDEDE><p style='line-height: 150%; margin: 4'><textarea  rows=5 cols=60 name=ad_v"&ad_i&" style='font-family: 宋体; font-size: 9pt'>"&ad_tmp&"</textarea></td></tr>"
next
openfile.close
set fso1=nothing
%>  
  <tr>
    <td width="100%" bgcolor="#d7d7d7" colspan="2" height="28">
    　</td>
  </tr>
  <tr>
    <td width="40%" bgcolor="#DEDEDE" valign="top" class=td2>
    <p style="line-height: 150%; margin: 4"><span style="font-weight: 400">
	<font color="#000000">增加广告：</font></span></td>
    <td width="60%" bgcolor="#DEDEDE">
    <p style="line-height: 150%; margin: 4">
    <textarea row=3 cols=60 name=ad_v<%=ad_num+1%> rows="5" style="font-family: 宋体; font-size: 9pt"></textarea></td>
  </tr>  <tr>
    <td width="100%" bgcolor="#CCCCCC" colspan="2" height="35" align="center">
    <input type="submit" value="     确  认  修  改     " name="B1"></td>
  </tr>
</table></div>
</form>
<%end if%> 

<%if Request("action")="setadvok" then
dim adv_num,ad_msg
set fso1 = server.createobject("scripting.filesystemobject")
Set openfile=fso1.OpenTextFile(Server.MapPath("../inc/ads.js"))
tmpstr=openfile.readall
tmp=split(tmpstr,chr(13)&chr(10))
ad_num=replace(tmp(1),"a = ","")
ad_num=int(replace(ad_num,";if(a==0){a=1}",""))
openfile.close
set fso1=nothing
adv_num=0
for ad_i=1 to ad_num+1
ad_tmp=replace(request.form("ad_v"&ad_i&""),"'","")
if trim(ad_tmp)<>"" or isnull(ad_tmp)then
adv_num=adv_num+1
ad_msg=ad_msg&"b["&adv_num&"].under ='"&ad_tmp&"'"&vbcrlf
end if
next
dim objFSO,objname
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
Set objname=objFSO.CreateTextFile(Server.MapPath("../inc/ads.js"),True)
objname.Write"<!--"&vbcrlf&"a = "&adv_num&";if(a==0){a=1}"&vbcrlf&"var slump = Math.random();"&vbcrlf&"var talet = Math.round(slump * (a-1))+1;"&vbcrlf&"function create() { "&vbcrlf&"this.under = '' "&vbcrlf&"}"&vbcrlf&"b = new Array() "&vbcrlf&"for(var i=1; i<=a; i++) { b[i] = new create() } "&vbcrlf&ad_msg&"var visa = """";"&vbcrlf&"document.write(b[talet].under); "&vbcrlf&"//-->"
objname.close
set objfso=nothing
response.redirect"Admin.Asp?Action=setadv"
end if%>

<%
if Request("action")="addadmin" then
Dim Password,UserName,UserID
AdminName=Request.form("AdminName")
Password=Request.form("Password")
UserName=Request.form("UserName")

if AdminName="" then
	Call GoBack("","请输入后台登陆名称！")	

end if

if Password="" then
	Call GoBack("","请输入后台密码！")	

else
 Password=Md5(Password)
end if

if UserName="" then
	Call GoBack("","请输入前台用户名称！")	

end if

set rs=Conn.execute("Select ID from YX_User where Name='"&UserName&"'")
if rs.eof or rs.bof then
	Call GoBack("","您输入的用户名不是一个有效的注册用户！")	

else
	UserID=rs(0)
end if
set Rs=Conn.execute("select Name from YX_Admin where Name='"&AdminName&"'")
if not (rs.eof and rs.bof) then
	Call GoBack("","您输入的用户名已经在管理用户中存在！请使用其他名称！")

end if
dim GradeNum,GradeName,GradePic
set Rs=Conn.Execute("select GradeNum,GradeName,GradePic from YX_UserGrade where GradeID=1")
GradeNum=Rs(0)
GradeName=rs(1)
GradePic=rs(2)
set rs=nothing

Conn.execute("Update YX_User set ClassID=1,GradeNum="&GradeNum&",GradeName='"&GradeName&"',GradePic='"&GradePic&"' where ID="&UserID)
Conn.execute("Insert into YX_Admin (Name,[Password],UserName) values('"&AdminName&"','"&Password&"','"&UserName&"')")
Call Suc("","添加成功，请记住新管理员后台登陆信息，如需修改请返回管理员管理！","Admin.Asp")
end if
%>
<%
if Request("action")="addadmin1" then%>
 <form action="?action=addadmin" method=post>
	<table cellpadding=6 cellspacing=1 border=0 width=95% bgcolor="#FFFFFF" align="center">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	<font color="#800000"><b>管 理 员 添 加</b></font></td></tr> 
 		<tr>
		<td bgcolor=#d7d7d7 width=40%><b><font color="#000077">后台登陆名称 </font></b></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="AdminName" size="30">　</td>
		</tr><tr>
		<td bgcolor=#d7d7d7><b><font color="#000077">后台登陆密码</font></b></td>		
		<td bgcolor=#d7d7d7>
		<input type=password name="Password" size="30"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7><b><font color="#000077">前台用户名称</font></b></td>		
		<td bgcolor=#d7d7d7>
		<input type="text" name="UserName" size="30"></td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="添 加" name="B1"></td></tr>
	</table>
</form>
<%end if%>

<%
if Request("action")="editadmin" then
Dim ID,Sql
AdminName=Request.form("AdminName")
Password=Request.form("Password")
ID=Request.form("ID")

if ID="" or not isNumeric(ID) then
	Call GoBack("","参数错误！")
	
end if

if AdminName="" then
	Call GoBack("","请输入后台登录名称！")
	
end if

set rs=server.createobject("adodb.recordset")
sql="Select * from YX_Admin where ID="&ID
rs.open sql,conn,1,3
if rs.eof or rs.bof then
	Call GoBack("","没有此用户！")
	
else
	rs("Name")=AdminName
	If PassWord <> "" Then Rs("Password")=MD5(Password)
	Rs.update
End if
rs.close
set rs=nothing
Call Suc("","管理员修改成功！","Admin.Asp")
end if	
%>
<%
if Request("action")="editadmin1" then
id=Request("id")
if ID="" or not isNumeric(ID) then
	Call GoBack("","错误参数！")	
end if

set rs=Conn.Execute("Select Name,UserName from YX_Admin where ID="&ID)
if rs.eof or rs.bof then
	Call GoBack("","没有此管理员！")
else

%>
 <form action="?action=editadmin" method=post>
	<table cellpadding=6 cellspacing=1 border=0 width=95% bgcolor="#FFFFFF" align="center">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	<font color="#800000"><b>管 理 员 编 辑</b></font></td></tr> 
 		<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077">后台登陆名称 </font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<INPUT TYPE="hidden" name="ID" value="<%=ID%>">
		<input name="AdminName" size="30" value="<%=rs(0)%>"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7><font color="#000077">后台登陆密码</font></td>		
		<td bgcolor=#d7d7d7>
		<input type=password name="Password" size="30"> <font color="#999999">如不更改请留空！</font></td>
		</tr>
		<tr>
		<td bgcolor=#d7d7d7><font color="#000077">前台用户名称</font></td>		
		<td bgcolor=#d7d7d7>
		<B><%=rs(1)%></B></td>
		</tr>
		<tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="编 辑" name="B1"></td></tr>
	</table>
</form>
<%
end if
end if
set rs=nothing
%>
<%Dim Action,bbsID
username=AdminName
Server.ScriptTimeOut=999999
Action=Request.QueryString("Action")
Select Case Action
Case "Submit"
	Submit()
Case "SeeRecycle"
	SeeRecycle()
Case "DelRecycle"
	DelRecycle()
Case "TBInfo"
	TBInfo()
Case "Giveback"
	Giveback()
Case "DelAll"
	DelAll()
Case "Recycle"
	Recycle()
End Select
AdminFooter()
Set YxBBs=Nothing

Sub Recycle()
Response.Write"<form name='yimxu'  style='margin:0' method='POST' action='?Action=Submit'>"
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="4"><b><font color="#FFFFFF">回收站</font></b></td>
	</tr>	
	<tr bgcolor="#DEDEDE">
	  <td height="25" colspan="4"><table width="100%%"  border="0" cellspacing="5" cellpadding="0">
          <tr>
            <td width="84%">【<a href="?Action=Recycle"><font color="red">列出全部主题</font></a>】<%=TBList(0)%> </td>
            <td width="16%">【<a onclick=checkclick('您确定要清空回收站的全部帖子吗？') href="?Action=DelAll"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle">清空回收站</a>】</td>
          </tr>
      </table></td>
    </tr>
	<tr bgcolor="#CCCCCC">
	  <td width="5%" height="25" align="center"><b>选择</b></td>
	  <td width="55%" align="center"><b>帖子</b></td>
	  <td width="18%" align="center"><b>作者</b></td>
	  <td width="22%" align="center"><b>最后时间</b></td>
	</tr>
<%
	Dim intPageNow,arr_Rs,i,Pages,Conut,page,strPageInfo
	Dim Temp,BbsID
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_Topic]"
	Pages.strPageUrl = "?Action=Recycle"
	Pages.strFieldsList = "TopicID,SqlTableID,Face,Caption,Name,LastTime,BoardID"
	Pages.strCondiction = "IsDel=True"
	Pages.strOrderList = "TopicID desc"
	Pages.strPrimaryKey = "TopicID"
	Pages.intPageSize = 25
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "Recycle"&YxBBs.TB'客户端记录总数
	Pages.Reloadtime=3'每三分钟更新Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
	Set Rs=YxBBs.Execute("Select BbsID From[YX_Bbs"&Arr_Rs(1,i)&"] Where TopicID="&Arr_Rs(0,i)&" and BoardID="&Arr_Rs(6,i))
	If Not Rs.Eof Then BbsID=Rs(0)
	Rs.Close
		Response.Write"<tr bgcolor=""#DEDEDE""><td><input type='checkbox' name='Topic' value='"&Arr_Rs(0,i)&"|"&Arr_Rs(6,i)&"|"&Arr_Rs(1,i)&"'></td>"&_
		"<td onmouseover=javascript:this.bgColor='#eeeeee' onmouseout=javascript:this.bgColor=''>&nbsp;"&_
		"<img src='../images/face/"&Arr_Rs(2,i)&".gIf' align='absmiddle'><a href=?Action=SeeRecycle&BbsID="&BbsID&">"&YxBBs.Fun.StrLeft(Arr_Rs(3,i),25)&"</a></td>"&_
		"<td align=center><a target=_blank  href='Profile.Asp?name="&Arr_Rs(4,i)&"' title='查看 "&Arr_Rs(4,i)&" 的资料'>"&Arr_Rs(4,i)&"</a></td>"&_
		"<td align=center>"&Arr_Rs(5,i)&"</td></tr>"
	Next
	Else
	Response.Write"<tr><td height=25 colspan='4'>没有发现被删除的主题</td></tr>"
	End If
	%>
<tr bgcolor="#CCCCCC"><td colspan="4"><input type=checkbox name=chkall value=on onClick="CheckAll(this.form)"> 全选
&nbsp;&nbsp;<input type="submit"  value="删除所选" name="Go"><input type="submit" class="submit" value="还原所选" name="Go"></td>
</tr></form>
<tr bgcolor="#CCCCCC"><td height=20 colspan="4"><%=strPageInfo%></td>
</tr></tbody></table>
<%
End Sub

Sub TBInfo()
Response.Write"<form name='yimxu' style='margin:0' method='POST' action='?Action=Submit'>"
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="4"><b><font color="#FFFFFF">回收站</font></b></td>
	</tr>	
	<tr bgcolor="#DEDEDE">
	  <td height="25" colspan="4">
	  <table width="100%%"  border="0" cellspacing="5" cellpadding="0">
          <tr>
            <td width="84%">【<a href="?Action=Recycle">列出全部主题</a>】<%=TBList(YxBBs.TB)%></td>
            <td width="16%">【<a onclick=checkclick('您确定要清空回收站的全部帖子吗？') href="?Action=DelAll"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle">清空回收站</a>】</td>
          </tr>
    </table>	</tr>
	<tr bgcolor="#CCCCCC">
	  <td width="5%" height="25" align="center"><b>选择</b></td>
	  <td width="55%" align="center"><b>帖子</b></td>
	  <td width="18%" align="center"><b>作者</b></td>
	  <td width="22%" align="center"><b>最后时间</b></td>
	</tr>
<%
	Dim intPageNow,arr_Rs,i,Pages,Conut,page,strPageInfo
	Dim Temp
	intPageNow = Request.QueryString("page")
	Set Pages = New Cls_PageView
	Pages.strTableName = "[YX_BBS"&YxBBs.TB&"]"
	Pages.strPageUrl = "?TB="&YxBBs.TB
	Pages.strFieldsList = "BbsID,TopicID,Face,Caption,Name,LastTime,ReplyTopicID,BoardID"
	Pages.strCondiction = "IsDel=True"
	Pages.strOrderList = "BbsID desc"
	Pages.strPrimaryKey = "BbsID"
	Pages.intPageSize = 25
	Pages.intPageNow = intPageNow
	Pages.strCookiesName = "Recycle"&YxBBs.TB'客户端记录总数
	Pages.Reloadtime=3'每三分钟更新Cookies
	Pages.strPageVar = "page"
	Pages.InitClass
	Arr_Rs = Pages.arrRecordInfo
	strPageInfo = Pages.strPageInfo
	Set Pages = nothing
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
	Response.Write"<tr bgcolor=""#DEDEDE""><td><input type='checkbox' "
	IF Arr_Rs(1,i)=0 Then
		Response.Write "name='Reply' value='"&Arr_Rs(0,i)&"|"&Arr_Rs(6,i)&"|"&Arr_Rs(7,i)&"|"&YxBBs.TB&"'"
	Else
		Response.Write "name='Topic' value='"&Arr_Rs(1,i)&"|"&Arr_Rs(7,i)&"|"&YxBBs.TB&"'"
	End If
	Response.Write"></td>"&_
		"<td onmouseover=javascript:this.bgColor='#eeeeee' onmouseout=javascript:this.bgColor=''>&nbsp;"&_
		"<img src='../images/face/"&Arr_Rs(2,i)&".gIf' align='absmiddle'><a href=?Action=SeeRecycle&BbsID="&Arr_Rs(0,i)&">"&YxBBs.Fun.StrLeft(Arr_Rs(3,i),25)&"</a></td>"&_
		"<td align=center><a target=_blank  href='Profile.Asp?name="&Arr_Rs(4,i)&"' title='查看 "&Arr_Rs(4,i)&" 的资料'>"&Arr_Rs(4,i)&"</a></td>"&_
		"<td align=center>"&Arr_Rs(5,i)&"</td></tr>"
	Next
	Else
	Response.Write"<tr><td height=25 colspan='4'>这个数据表中没有发现被删除的帖子</td></tr>"
	End If
	%>
<tr bgcolor="#CCCCCC"><td colspan="4"><input type=checkbox name=chkall value=on onClick="CheckAll(this.form)"> 全选
&nbsp;&nbsp;<input type="submit"  value="删除所选" name="Go"> 
<input type="submit" class="submit" value="还原所选" name="Go"></td>
</tr></form>
<tr bgcolor="#CCCCCC"><td height=20 colspan="4"><%=strPageInfo%></td>
</tr></tbody></table>
<%
End Sub

Sub SeeRecycle()
Dim BbsID,YxBBs_ubb,EssayType,Sql
BbsID=Trim(Request.QueryString("BbsID"))

Set Rs=YxBBs.execute("select BbsID,Caption,Content,Name,LastTime,BoardID,TopicID,ReplyTopicID,UbbString,Face from [YX_Bbs"&YxBBs.TB&"] where BbsID="&BbsID)
IF Rs.eof then 
	Call GoBack("","该帖不存在或者已经被永久删除")
	Exit Sub
End if
If Rs(7)=0 Then EssayType="主题帖：" Else EssayType="回复帖："
Set YxBBs_ubb=New YxBBsubb_Cls
YxBBs_ubb.UbbString=Rs(8)
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tbody>
<tr bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">回收站　查看帖子</font></b></td>
</tr>
<tr bgcolor="#D7DAEA">
  <td height="25"><%=EssayType&YxBBs.Fun.HtmlCode(Rs(1))%></td>
    <td height="25" align="center">【<a href="?Action=DelRecycle&BbsID=<%=Rs(0)%>&TopicID=<%=Rs(6)%>&TB=<%=YxBBs.TB%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle">永久删除</a>】 【<a href="?Action=Giveback&BbsID=<%=Rs(0)%>&TB=<%=YxBBs.TB%>&BoardID=<%=Rs(5)%>"><img src="../images/mail.gif" width="16" height="16" border="0" align="absmiddle">还原帖子</a>】</td>
    </tr>
<tr bgcolor="#DEDEDE"><td colspan="2"><blockquote><span style='line-height:150%;table-layout:fixed;word-wrap:break-word;word-break:break-all; width:100%'><br>
<img src='../images/face/<%=Rs(9)%>.gIf' align='absmiddle'>
<%If Rs(7)=0 Then Response.Write "<b>"&YxBBs.Fun.HtmlCode(Rs(1))&"</b>"%>
<br><%=YxBBs_ubb.UBB(Rs(2),1)%></Span></blockquote></td></tr>
<tr bgcolor="#DEDEDE"><td colspan="2"><font color="#224021">&nbsp;帖子作者：<%=Rs(3)%>&nbsp;&nbsp;更新时间：<%=Rs(4)%></font></td></tr>
<tr bgcolor="#CCCCCC"><td height="25" colspan="2" align="center"><a href=javascript:history.go(-1)>【返回】</a></td>
    </tr>
</tbody>
</table>
<%Set YxBBs_ubb=Nothing
Rs.Close
End Sub


Sub DelRecycle()
	Dim BbsID,TopicID
	BbsID=Request.QueryString("BbsID")
	TopicID=Request.QueryString("TopicID")
	If TopicID=0 then
	YxBBs.Execute("Delete From [YX_Bbs"&YxBBs.TB&"] where IsDel=True And BbsID="&BbsID)
	Call Suc("","成功删除了这个回复帖！","?Action=Recycle")
	Else
	YxBBs.Execute("Delete From [YX_Topic] where  IsDel=True And TopicID="&TopicID)
	YxBBs.Execute("Delete From [YX_TopicVote] where TopicID="&TopicID)
	YxBBs.Execute("Delete From [YX_TopicVoteUser] where TopicID="&TopicID)
	YxBBs.Execute("Delete From [YX_Bbs"&YxBBs.TB&"] where IsDel=True And (BbsID="&BbsID&" or ReplyTopicID="&TopicID&")")
	Call Suc("","成功删除这个主题（包括其回复帖）！","?Action=Recycle")
	End if
End Sub

Sub DelAll()
	Dim AllTable,I
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		YxBBs.Execute("Delete From [YX_Bbs"&AllTable(i)&"] where IsDel=True")
	Next
	YxBBs.Execute("Delete From [YX_Topic] where IsDel=True")
	YxBBs.execute("delete * from [YX_TopicVote] where  not exists (select name from [YX_Topic] where [YX_TopicVote].TopicID=[YX_Topic].TopicId)")
	YxBBs.execute("delete * from [YX_TopicVoteUser] where  not exists (select name from [YX_Topic] where [YX_TopicVoteUser].TopicID=[YX_Topic].TopicId)")
	Call Suc("","成功清空了回收站！","?Action=Recycle")
End Sub

Sub Giveback
	Dim BbsID,TopicID,ReplyTopicID,BoardID,Temp
	BbsID=Request.QueryString("BbsID")
	Set Rs=YxBBs.Execute("Select TopicID,ReplyTopicID,BoardID,IsDel From[YX_Bbs"&YxBBs.TB&"] where BbsID="&BbsID)
	IF Rs.eof Then
		Call GoBack("","该帖不存在或者已经被永久删除"):Exit Sub
	ElseIf Rs(3)=False Then
		Call Suc("","该帖已经恢复了","?Action=Recycle"):Exit Sub
	End IF
	If Rs(0)=0 And Rs(1)<>0 then
		YxBBs.Execute("Update [YX_Config] Set AllEssayNum=AllEssayNum+1")
		YxBBs.Execute("Update [YX_Board] Set EssayNum=EssayNum+1 Where BoardID="&Rs(2)&" And ParentID<>0")
		YxBBs.Execute("Update [YX_Topic] Set ReplyNum=ReplyNum+1,IsDel=False where TopicID="&Rs(1))
		YxBBs.Execute("Update [YX_Bbs"&YxBBs.TB&"] Set IsDel=False where TopicID="&Rs(1)&" or BbsID="&BbsID)
	Else
		Temp=YxBBs.Execute("Select Count(BbsID) From[YX_bbs"&YxBBs.TB&"] where ReplyTopicID="&Rs(0)&" And BoardID="&rs(2))(0)
		If Isnull(Temp) Then Temp=0
		YxBBs.Execute("Update [YX_Config] Set TopicNum=TopicNum+1,AllEssayNum=AllEssayNum+"&Temp+1&"")
		YxBBs.Execute("Update [YX_Board] Set EssayNum=EssayNum+"&Temp+1&",TopicNum=TopicNum+1 Where BoardID="&Rs(2)&" And ParentID<>0")
		YxBBs.Execute("Update [YX_Topic] Set ReplyNum="&Temp&",IsDel=False where TopicID="&Rs(0))
		YxBBs.Execute("update [YX_Bbs"&YxBBs.TB&"] Set IsDel=False where BbsID="&BbsID&" or ReplyTopicID="&Rs(0))
	End if
	Rs.Close
	Call Suc("","成功的恢复帖子","?Action=Recycle")
End Sub

Sub Submit()
Dim Topic,Reply,Go,Temp,i
Topic=Request.form("Topic")
Reply=Request.form("Reply")
IF Topic="" And Reply="" Then Call GoBack("","请先选择项目。"):Exit Sub
Topic=split(Topic,",")
Reply=split(Reply,",")
Go=Request.form("Go")
	If Go="删除所选" then
		For i=0 to ubound(Topic)
		Temp=split(Topic(I),"|")
		YxBBs.Execute("Delete From [YX_Bbs"&Temp(2)&"] where TopicID="&Temp(0)&" or ReplyTopicID="&Temp(0))
		YxBBs.Execute("Delete From [YX_Topic] where TopicID="&Temp(0))
		YxBBs.Execute("Delete From [YX_TopicVote] where TopicID="&Temp(0))
		YxBBs.Execute("Delete From [YX_TopicVoteUser] where TopicID="&Temp(0))
		Next
		For i=0 to ubound(Reply)
		Temp=split(Reply(I),"|")
		YxBBs.Execute("Delete From [YX_Bbs"&Temp(3)&"] where BbsID="&Temp(0)&" And IsDel=True")
		Next
		Call Suc("","成功的删除所选的帖子","?Action=Recycle")
	ElseIF Go="还原所选" then
		Dim TempNum
		For i=0 to ubound(Topic)
			Temp=split(Topic(I),"|")
			TempNum=YxBBs.Execute("Select Count(BbsID) From[YX_bbs"&Temp(2)&"] where ReplyTopicID="&Temp(0)&" And BoardID="&Temp(1))(0)
			If Isnull(TempNum) Then TempNum=0
			YxBBs.Execute("Update [YX_Config] Set TopicNum=TopicNum+1,AllEssayNum=AllEssayNum+"&TempNum+1&"")
			YxBBs.Execute("Update [YX_Board] Set EssayNum=EssayNum+"&TempNum+1&",TopicNum=TopicNum+1 Where BoardID="&Temp(1)&" And ParentID<>0")
			YxBBs.Execute("Update [YX_Topic] Set ReplyNum="&TempNum&",IsDel=False where TopicID="&Temp(0))
			YxBBs.Execute("update [YX_Bbs"&Temp(2)&"] Set IsDel=False where TopicID="&Temp(0)&" or ReplyTopicID="&Temp(0))
		Next
		For i=0 to ubound(Reply)
		Temp=split(Reply(I),"|")
		Set Rs=YxBBs.Execute("Select Top 1 BbsID From[YX_Bbs"&Temp(3)&"] where BbsID="&Temp(0)&" And IsDel=True")
		If Not Rs.Eof Then
		YxBBs.Execute("Update [YX_Config] Set AllEssayNum=AllEssayNum+1")
		YxBBs.Execute("Update [YX_Board] Set EssayNum=EssayNum+1 Where BoardID="&Temp(2)&" And ParentID<>0")
		YxBBs.Execute("Update [YX_Topic] Set ReplyNum=ReplyNum+1,IsDel=False where TopicID="&Temp(1))
		YxBBs.Execute("Update [YX_Bbs"&Temp(3)&"] Set IsDel=False where TopicID="&Temp(1)&" or BbsID="&Temp(0))
		End If
		Rs.Close
		Next
		Call Suc("","成功的还原所选的帖子","?Action=Recycle")
	End If
End SUB



Function TBList(Num)
	Dim AllTable,I,Temp
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		If Int(AllTable(i))=Int(Num) Then
		Temp=Temp&"【<font Color=red>数据表"&AllTable(i)&"</font>】"
		Else
		Temp=Temp&"【<a href='?Action=TBInfo&TB="&AllTable(i)&"'>数据表"&AllTable(i)&"</a>】"
		End IF
	next
	TBList=Temp
End Function%>


<script language="JavaScript">
<!--
function CheckAll(form)  {
  for (var i=0;i<form.elements.length;i++)    {
    var e = form.elements[i];
    if (e.name != 'chkall'){
	e.checked = form.chkall.checked;
	}
   }
  }
//-->
</script>
