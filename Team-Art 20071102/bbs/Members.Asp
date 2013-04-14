<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<%if Request("action")="" then%>
<%
Dim Action,WhereSql,OrderSql,Order,PageInfo,Keyword,PageSize,Admintype,myvar

If Not YxBBs.Founduser Then YxBBs.Error("您还没有注册或者登陆！")
Order=Request.QueryString("Order")
Keyword=Request.QueryString("Keyword")
Action=Lcase(Request.QueryString("Action"))
Call YxBBs.Head("查看用户列表")
WhereSql="IsDel=False"
If Keyword<>"" Then WhereSql=WhereSql&" And Name like '%"&KeyWord&"%'"
Select Case Action
	Case"sex"
		OrderSql="Sex"
	Case"coin"
		OrderSql="Coin"
	Case"essay"
		OrderSql="EssayNum"
	Case"mark"
		OrderSql="Mark"
	Case"regtime"
		OrderSql="RegTime"
	Case"grade"
		OrderSql="GradeNum"
	Case else
		OrderSql="ID"
End select
IF Order<>"1" Then OrderSql =OrderSql&" Desc"
ShowListTop()
ShowUserList()
ShowListBottom()
YxBBs.Footer()
Set YxBBs=Nothing

Sub ShowListTop()
	Response.Write"<table align=center width='650' border='0' cellpadding='6' cellspacing='0'><tr><td><form style=""margin:0px; ""> <input type=""text"" name=""keyword"" size=""20"" onkeyup=""ValidateTextboxAdd(this,'BtnSearch')"" onpropertychange=""ValidateTextboxAdd(this,'BtnSearch')""> <input type=""Submit"" value=""模糊查找"" name=""BtnSearch"" disabled></form></td><td> 排序方式：<a href=?Action="&Action&"&Order=1&KeyWord="&KeyWord&">顺</a> / <a href=?Action="&Action&"&Order=2&KeyWord="&KeyWord&">倒</a></td></tr></table>"
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	Temp=Replace(Temp,"{标题}",YxBBs.Stats )
	Response.Write Temp
End Sub

Sub ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}",PageInfo)
	Response.Write Temp
End Sub

Sub ShowUserList()
	Dim Pages,Page,arr_Rs,i,Temp,Content
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_User]"
	pages.strPageUrl = "?Action="&Action&"&Order="&Order&"&KeyWord="&KeyWord
	pages.strFieldsList = "Name,Sex,Mail,EssayNum,Coin,Mark,RegTime,GradeName"
	pages.strCondiction = WhereSql
	pages.strOrderList = OrderSql
	Pages.strPrimaryKey = "ID"
	pages.intPageSize = 20
	pages.intPageNow = Page
	pages.strCookiesName = "Members_"&KeyWord
	pages.Reloadtime=3'每三分钟更新Cookies
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Content="<tr height=25 bgcolor=#EEEEEE align=center><td width='20%'><b>用户名</b></td><td width='5%'><b>性别</b></td><td width='25%'><b>E-MAIL</b></td><td width='10%'><b>发帖数</b></td><td width='10%'><b>金钱</b></td><td width='10%'><b>积分</b></td><td width='10%'><b>注册时间</b></td><td width='25%'><b>等级</b></td></tr>"
	If IsArray(Arr_Rs) Then
		For i = 0 to UBound(Arr_Rs, 2)
			If Arr_Rs(1,i) Then Temp="男" Else Temp="女"
			Content=Content &"<tr Height=25><td align='center' ><a href='Profile.Asp?Name="&Arr_Rs(0,i)&"'>"&Arr_Rs(0,i)&"</a></td><td align='center'>"&Temp&"</td><td><a href='mailto:"&Arr_Rs(2,i)&"'>&nbsp;&nbsp;"&Arr_Rs(2,i)&"</a></td><td align='center'>"&Arr_Rs(3,i)&"</td><td align='center'>"&Arr_Rs(4,i)&"</td><td align='center'>"&Arr_Rs(5,i)&"</td><td>&nbsp;&nbsp;"&Formatdatetime(Arr_Rs(6,i),2)&"</td><td align='center'>"&Arr_Rs(7,i)&"</td></tr>"
		Next
	End If
	Response.Write Content
End Sub
%>
<%end if%>

<%if Request("action")="log" then
If Not YxBBs.Founduser Then YxBBs.Error("您还没有注册或者登陆！")
If Not YxBBs.IsBoardAdmin Then
		If YxBBs.ClassID>2 Then YxBBs.Error("您的权限不足已查看论坛日志！")
	End If
Call YxBBs.Head("查看论坛LOG")
ShowListToplog()
BoardEven()
ShowListBottom()
YxBBs.Footer()
Set YxBBs=Nothing

Sub ShowListToplog()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	Temp=Replace(Temp,"{标题}",YxBBs.Stats )
	Response.Write Temp
End Sub

Sub boardeven()
	Dim Rs,Sql,TempStr
        Set Rs=YxBBs.Execute("select * from [YX_logs] where Logtime order by Logtime desc")
		TempStr="<form method='post' style='margin:0px' action='?Action=DelLog'><tr height=25 bgcolor=#EEEEEE align=center><td width='15%'>操作对象</td><td width='55%'>事件内容</td><td width='20%'>操作时间</td><td width='15%'>操作用户</td></tr>"
		While (Not rs.eof) 
			TempStr = TempStr & "<tr height=25 align=center><td width='15%'><a href='Profile.Asp?name="&Rs("ToName")&"' title='查看 "&Rs("ToName")&" 的资料 '>"&Rs("ToName")&"</a></td><td width='55%'>"&YxBBs.Fun.HtmlCode(Rs("LogContent"))&"</td><td width='15%'>"&Rs("LogTime")&"</td><td width='20%'><a href='Profile.Asp?name="&Rs("UserName")&"' title='用户ＩＰ："&Rs("UserIP")&"'>"&Rs("UserName")&"</a></td></tr>"
			Rs.Movenext
		Wend
      TempStr=TempStr&"<tr height=25><td colspan='4'align='right'><input type='Submit' class='button' name='Del' value='清空3天之前的管理记录'>&nbsp;&nbsp;&nbsp;</td></tr></form>"         
    Response.Write TempStr
    Rs.Close
	Set Rs=Nothing
End Sub

Sub ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
             
	Response.Write Temp
End Sub


end if%>

<%
if Request("action")="DelLog" then
If Not YxBBs.IsBoardAdmin Then
		If YxBBs.ClassID>2 Then YxBBs.Error("您的权限不足已查看论坛日志！")
	End If
YxBBs.Execute("Delete From [YX_Logs] where DATEDIFF('d', LogTime,'"&YxBBs.NowBBSTime&"')>3")
               Response.Write ("<script type='text/javascript'>alert('恭喜您成功删除3天之前的管理记录！');window.location.href='?Action=log';</script>")
end if%>

<%if Request("action")="admin" then
Call  YxBBs.Head("管理团队")
whereSql="ClassID<=3"
	Admintype="管理团队列表"
ShowListToplog()
ShowList()
ShowListBottom()
YxBBs.Footer()
Set YxBBs=Nothing


Sub ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}",PageInfo)
	Response.Write Temp
End Sub

Sub ShowList()
	Dim Pages,Page,arr_Rs,i,Temp,Content
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_User]"
	pages.strPageUrl = "?Action=admin"&Action
	pages.strFieldsList = "Name,GradeName,Mail,lastTime"
	pages.strCondiction = WhereSql
	pages.strOrderList = "LastTime desc"
	Pages.strPrimaryKey = "Name"
	pages.intPageSize = 20
	pages.intPageNow = Page
	pages.strCookiesName = "Admin_List"&Action'客户端记录名称
	pages.Reloadtime=10'分钟更新
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Content="<tr height=25 bgcolor=#E3E3E3><td width='15%' align='center'><b>名 称</b><td width='15%' align='center'><b>管理级别</b></td><td width='25%' align='center'><b>评价</b></td></td><td width='10%' align='center'><b>在线</b></td><td width='10%' align='center'><b>留言</b></td><td width='25%' align='center'><b>最后登陆</b></td></tr>"
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs, 2)
               if datediff("d",Arr_Rs(3,i),date())<=3 then
myvar="<img src=images/tl.gif border=0> 工作负责,值得学习."
elseif datediff("d",Arr_Rs(3,i),date())<=7 then
myvar="<img src=images/tl.gif border=0> 有点松散,<font color=red>7</font> 天内还有登陆."
elseif datediff("d",Arr_Rs(3,i),date())>=7 then
myvar="<img src=images/tl.gif border=0> 已经 <font color=red>7</font> 天以上没有登陆了."

end if
if datediff("d",Arr_Rs(3,i),date())>=10 then
myvar=" <img src=images/tl.gif border=0> <font color=red>10</font>天没有登陆，警告."
end if
if datediff("d",Arr_Rs(3,i),date())>=15 then
myvar="<img src=images/tl.gif border=0> <font color=red>15</font>日未登陆,将取消资格.</font>"
end if
if datediff("d",Arr_Rs(3,i),date())>=20 then
myvar="<img src=images/tl.gif border=0> <font color=red>20</font>日未登陆,将取消资格.</font>"

end if
		Content=Content &"<tr height=25><td align='center'><a href='Profile.Asp?Name="&Arr_Rs(0,i)&"'>"&Arr_Rs(0,i)&"</a></td><td align='center'>"&Arr_Rs(1,i)&"</td><td>&nbsp;&nbsp;"&myvar&"</td><td align='center'>"&IsOnline(Arr_Rs(0,i))&"</td><td align='center'><a href='Sms.asp?Action=write&Name="&Arr_Rs(0,i)&"'><img src='images/sms.gif' border='0'></a></td><td>&nbsp;&nbsp;"&Arr_Rs(3,i)&"</td></tr>"
	Next
	End If
	Response.Write Content
End Sub

Function IsOnline(TUserName)
	Dim Temp,Rs,Ary_Rs,i
	IsOnline="×"
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
		Cache.add Temp,dateadd("n",5,YxBBs.NowBBSTime)'5分钟
	End If
	If InStr(Temp,","&TUserName&",")>0 Then IsOnline="<font color=""#FF0000"">√</font>"
End Function
end if
%>

