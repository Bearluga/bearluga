<!--#include file="Inc/SysConfig.Asp"-->
<!--#include file="Inc/Page_Cls.Asp"-->
<%if Request("action")="" then%>

<%
Dim Action,WhereSql,OrderSql,Order,PageInfo
Order=Request.QueryString("Order")
Action=Lcase(Request.QueryString("Action"))
Call YxBBs.Head("在线用户列表")
OrderSql="ID Desc"
ShowListTop()
ShowUserList()
ShowListBottom()
YxBBs.Footer()
Set YxBBs=Nothing

Sub ShowListTop()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表顶部")
	Temp=Replace(Temp,"{标题}",YxBBs.Stats)
	Response.Write Temp
End Sub

Sub ShowListBottom()
	Dim Temp
	Temp=YxBBs.Template.ReadTemplate("各项列表底部")
	Temp=Replace(Temp,"{分页}",PageInfo)
	Response.Write Temp
End Sub

Sub ShowUserList()
	Dim Pages,Page,arr_Rs,i,Temp,Content,Arr_Ip,NameStr
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_Online]"
	pages.strFieldsList = "Name,ClassID,IP,Locate,BoardID,BoardURL,OldTime,LastTime"
	pages.strCondiction = WhereSql
	pages.strOrderList = OrderSql
	Pages.strPrimaryKey = "Id"
	pages.intPageSize = 20
	pages.intPageNow = Page
	pages.strCookiesName = "Online_List"'客户端记录总数
	'pages.Reloadtime=1
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Content="<tr height=25 bgcolor=#EEEEEE align=center><td>用户名</td><td>IP</td><td>用户组</td><td>当前位置</td><td>登陆时间</td><td>最后活动时间</td></tr>"
	If IsArray(Arr_Rs) Then
	For i = 0 to UBound(Arr_Rs,2)
		IF YxBBs.ClassID>2 then
			Temp=YxBBs.Fun.GetIp(Arr_Rs(2,i),2)
		Else
			Temp=Arr_Rs(2,i)
		End If
		If Arr_Rs(0,i)="" Then
			NameStr="访客"
		Else
			NameStr="<a href='Profile.Asp?Name="&Arr_Rs(0,i)&"'>"&Arr_Rs(0,i)&"</a>"
		End If
		Content=Content &"<tr Height=25><td align='center' >"&NameStr&"</td><td align='center'>"&Temp&"</td><td align='center'>"&Arr_Rs(1,i)&"</td><td align='center'><a href="""&Arr_Rs(5,i)&""">"&Arr_Rs(3,i)&"</a></td><td align='center'>"&Arr_Rs(6,i)&"</td><td align='center'>"&Arr_Rs(7,i)&"</td></tr>"
	Next
	End If
	Response.Write Content
End Sub
%>
<%end if%>
<%if Request("action")="LoadIng" then%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%
Dim ID,OnlineList
ID=Request.QueryString("ID")
If ID="1" Then Session(YxBBs.CacheName&"Online")=""
If Session(YxBBs.CacheName&"Online")="1" Then
	If ID<>"1" Then Session(YxBBs.CacheName&"Online")=""
	OnlineList=""
Else
	Session(YxBBs.CacheName&"Online")="1"
	OnlineList=ShowOnlineList()
End If
Set YxBBs=Nothing

Function ShowOnlineList()
	Dim Temp,Rs,Sql,Templist,Page,PageMax,PageInfo,Arr_Rs,I,AllOnlineNum,sintPageSize,II
	Dim onlineName,LookUser,OnlineIP,Title,UserPic
	TempList=""
	sintPageSize=30
	Page = YxBBs.CheckNum(request.QueryString("page"))
	AllOnlineNum=YxBBs.Execute("SELECT COUNT(ID) From [Yx_Online]"&Temp&"")(0)
	Session(YxBBs.CacheName & "AllOnlineNum")=AllOnlineNum
	If AllOnlineNum mod sintPageSize = 0 Then
		PageMax = AllOnlineNum \ sintPageSize
	Else
		PageMax = AllOnlineNum \ sintPageSize + 1
	End If
	If Page>PageMax Then Page=PageMax
	If Page<1 Then Page=1
	If YxBBs.BoardID<>0 Then
	Temp="where BoardID="&YxBBs.BoardID&" "
	End If
	Sql = "Select Id,ClassID,Name,Ip,BoardID,oldtime,LastTime,locate From [YX_Online]"&Temp&" order by ID Asc"
	If Not IsObject(Conn) Then ConnectionDatabase
	Set rs = Server.CreateObject("Adodb.RecordSet")
	Rs.open Sql, Conn, 1, 1
	If Not(rs.eof or rs.bof) Then
		Rs.PageSize = sintPageSize
		Rs.AbsolutePage = Page
		If Not(rs.eof or rs.bof) Then Arr_Rs = Rs.getrows(sintPageSize)
	End If
	Rs.Close:Set Rs=Nothing
	If IsArray(Arr_Rs) Then
		Temp=Split(Replace(YxBBs.Template.ReadTemplate("用户类型图片"),VbCrlf,""),"|")
	  For i = 0 to UBound(Arr_Rs,2)
	  II=II+1
		onlineName=Arr_Rs(2,i)
		LookUser=True
		Select case Arr_Rs(1,i)
		Case 0
				IF YxBBs.ClassID<=2 then
					OnlineName="隐身会员"
					LookUser=False
				End If
				UserPic=Temp(0)
			Case 1
				UserPic=Temp(1)
			Case 2
				UserPic=Temp(2)
			Case 3
				UserPic=Temp(3)
			Case 4
				UserPic=Temp(4)
			Case 5
				UserPic=Temp(5)
			case 6
				OnlineName="访客"
				LookUser=False
				UserPic=Temp(6)
			End Select
		If YxBBs.ClassID<=2 Then
				OnlineIP=Arr_Rs(3,i)
			Else
				OnlineIP="-"
			End If
		Title="所在位置："&Arr_Rs(7,i)&"<br>进入时间："&Arr_Rs(5,i)&"<br>活动时间："&Arr_Rs(6,i)&"<br>真实IP地址："&OnlineIp&""
		If YxBBs.FoundUser And OnlineName=YxBBs.Myname then 
				Templist=Templist&"<td>"&UserPic&" <font color=""#FF6600"" title=""这是你自己"">"&OnlineName&"</font></td>"
			Else
				If LookUser Then
					Templist=Templist&"<td>"&UserPic&" <a title="""&Title&""" href=""Profile.Asp?name="&Arr_Rs(2,i)&""">"&OnlineName&"</a></td>"
				Else
					Templist=Templist&"<td>"&UserPic&" <span title="""&Title&""">"&OnlineName&"</span></td>"
				End If
			End If
		IF II=6 then II=0:Templist=Templist&"</tr><tr>"
	  Next    
		PageInfo="<table width=100% ><tr><td>&nbsp;共"&PageMax&"页&nbsp;第"&Page&"页&nbsp;</td>"
                if Page<>1 then
                PageInfo=PageInfo&"<td><a target='hiddenframe' href='Online.asp?Action=LoadIng&page=1&BoardID="&YxBBs.BoardID&"&id=1'>&nbsp;首页&nbsp;</a></td>"
		PageInfo=PageInfo& "<td><a target='hiddenframe' href='Online.asp?Action=LoadIng&page="&cstr(Page-1)&"&BoardID="&YxBBs.BoardID&"&id=1'>&nbsp;上一页&nbsp;</a></td>"
                Else
			PageInfo=PageInfo& "</tr></table>"
		end if
                If PageMax-Page>=1 then
		PageInfo=PageInfo& "<td><a target='hiddenframe' href='Online.asp?Action=LoadIng&page="&cstr(Page+1)&"&BoardID="&YxBBs.BoardID&"&id=1'>&nbsp;下一页&nbsp;</a>　</td>"
		PageInfo=PageInfo& "<td><a target='hiddenframe' href='Online.asp?Action=LoadIng&page="&PageMax&"&BoardID="&YxBBs.BoardID&"&id=1'>&nbsp;尾页&nbsp;</a></td></tr></table>"
                Else
			PageInfo=PageInfo& "</tr></table>"
		End if
		TempList="<table border=0 width='100%'>"&TempList&"</table>"
	End If
		Temp=YxBBs.Template.ReadTemplate("在线显示")
		Temp=Replace(Temp,"{用户列表}",Templist)
		Temp=Replace(Temp,"{分页}",PageInfo)
		Temp=Replace(Temp,CHR(34),CHR(39))
		Temp=Replace(Temp,VbCrlf,"")
		ShowOnlineList=Temp
End Function
%>
<script language="JavaScript" type="text/JavaScript">
parent.showon.innerHTML="<%=OnlineList%>";
</script>

<%end if%>