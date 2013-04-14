<!--#include file="Check.Asp"-->
<!--#include file="../Inc/Page_Cls.Asp"-->
<%
Select Case Request("action")
Case "Classedit"
	UserClassEdit
Case "saveeditClass"
	SaveEditClass
Case "Classadd"
	UserClassAdd
Case "saveaddClass"
	SaveAddClass
Case "UserClass"
	UserClass
Case "EditUser"
	EditUser
Case "UserEdit"
	UserEdit
Case "updateGrade"
	UpdateUserGrade
Case "addGrade"
	UserGradeAdd
Case "SaveAddGrade"
	SaveAddGrade
Case "UserGrade"
	UserGrade
Case "DelUserGrade"
	DelUserGrade
Case "DelUserclass"
        DelUserclass
 Case "update"
	Call UpDateUserData()
Case"outmail"
	Call OutMail()
 Case Else
	Call ShowUserList()
End Select

Call AdminFooter()

Sub UpDateUserData
	Dim UserAction,UserID,ClassID,SuccStr,TopicCount,Flag,i,Urs,AllTable
	UserAction=Request.form("UserAction")
	UserID=Request.form("UserID")
	ClassID=Request.form("ClassID")
	if replace(UserID,",","")="" then
		Call GoBack("","请选择相应的用户！")
		Exit Sub
	end if
	
	'response.write UserID
	'response.end
	Select Case UserAction
		Case 1
			YxBBs.Execute("update [YX_User] Set IsShow=true Where ID in (" &UserID& ")")
			Call Suc("","成功屏蔽用户发言！","Users.Asp")
		Case 2
			YxBBs.Execute("update [YX_User] Set IsShow=false Where ID in (" &UserID& ")")
			Call Suc("","成功解除屏蔽用户发言！","Users.Asp")
		Case 3
			'计算被删贴子数
			Set Urs=Conn.Execute("Select Name from [YX_User] where ID in (" &UserID& ")")
				while not Urs.eof
					AllTable=Split(YxBBs.BBSTable(0),",")
					For i=0 To uBound(AllTable)
						YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where Name='"&Urs(0)&"'")
						YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&Urs(0)&"')")
					Next
					YxBBs.Execute("Delete From[YX_Topic] where  Name='"&Urs(0)&"'")
					YxBBs.Execute("Delete From[YX_Sms] where  MyName='"&Urs(0)&"'")
					YxBBs.Execute("Delete From[YX_Admin] where UserName='"&Urs(0)&"'")
					YxBBs.Execute("Delete From[YX_User] where Name='"&Urs(0)&"'")
					Urs.MoveNext
				wend
			Set Urs=nothing
			Call Suc("","所选用户（包括所有帖子、留言等）已经被彻底删除！","Users.Asp")
		Case 4
			'计算被删贴子数
			Set Urs=Conn.Execute("Select Name from [YX_User] where ID in (" &UserID& ")")
				while not Urs.eof
					AllTable=Split(YxBBs.BBSTable(0),",")
					For i=0 To uBound(AllTable)
					YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where Name='"&Urs(0)&"'")
					YxBBs.Execute("Delete From[YX_Bbs"&AllTable(i)&"] where ReplyTopicID in (Select TopicID From[YX_Topic] where Name='"&Urs(0)&"')")
					Next
					YxBBs.Execute("Delete From[YX_Topic] where Name='"&Urs(0)&"'")
					Urs.MoveNext
				wend
			Set Urs=nothing
			Call Suc("","成功删除所选用户发表的所有帖子！","Users.Asp")
		Case 5
			set rs=Conn.execute("Select GradeNum,GradeName,GradePic from YX_UserGrade Where ClassID="&ClassID)
			if rs.eof or rs.bof then
				Call GoBack("错误提示","没有此用户组或已被删除。")
				Exit sub
			End if
			Conn.Execute("Update YX_User set GradeNum="&Rs("GradeNum")&",GradeName='"&rs("GradeName")&"',GradePic='"&rs("GradePic")&"',ClassID="&ClassID&" where ID in (" &UserID& ")")
			Set rs=nothing
			Call Suc("","成功转移所选用户!","Users.Asp")
	End select
End Sub

Sub ShowUserList()
Dim Action,WhereSql,OrderSql,Order,PageInfo,Keyword,search,ClassID
Order=Request.QueryString("Order")
Keyword=Request.QueryString("Keyword")
search=Request.QueryString("search")
ClassID=Request.QueryString("ClassID")
Action=Lcase(Request.QueryString("Action"))
WhereSql="ID<>0"
If ClassID<>"" Then WhereSql=WhereSql&" And ClassID="&ClassID
If Keyword<>"" then
	if search="1" then
		WhereSql=WhereSql&" And Mail like '%"&KeyWord&"%'"
	else
		WhereSql=WhereSql&" And Name like '%"&KeyWord&"%'"
	end if
end if

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
Response.Write "<table align=center width='95%' border='0' cellpadding='6' cellspacing='1' Bgcolor=#FFFFFF>"&_
"<tr Bgcolor=#CCCCCC><td colspan=6>查看按：<a href=?Action=Sex&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">姓别</a>&nbsp;/&nbsp;<a href=?Action=Essay&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">贴数</a>&nbsp;/&nbsp;<a href=?Action=Coin&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">金钱</a>&nbsp;/&nbsp;<a href=?Action=Mark&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">积分</a>&nbsp;/&nbsp;<a href=?Action=RegTime&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">注册时间</a>&nbsp;/&nbsp;<a href=?Action=Grade&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">等级</a></td><td colspan=3> 排序方式：<a href=?Action="&Action&"&Order=1&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">顺</a> / <a href=?Action="&Action&"&Order=2&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID&">倒</a></td></tr>"
	Dim Pages,Page,arr_Rs,i,Temp,Content
	Page = Request.QueryString("page")
	Set pages = New Cls_PageView
	pages.strTableName = "[YX_User]"
	pages.strPageUrl = "?Action="&Action&"&Order="&Order&"&Search="&Search&"&Keyword="&Keyword&"&ClassID="&ClassID
	pages.strFieldsList = "ID,Name,Sex,Mail,EssayNum,Coin,Mark,RegTime,GradeName"
	pages.strCondiction = WhereSql
	pages.strOrderList = OrderSql
	Pages.strPrimaryKey = "ID"
	pages.intPageSize = 20
	pages.intPageNow = Page
	pages.strCookiesName = "Members"&KeyWord&search&ClassID
	pages.Reloadtime=3
	pages.strPageVar = "page"
	pages.InitClass
	Arr_Rs = pages.arrRecordInfo
	PageInfo = pages.strPageInfo
	page=pages.intPageNow
	Set pages = nothing
	Response.Write "<form method=""POST"" action=""?action=update"" name=""recycle""><tr Bgcolor=#EFEFEF><td height=25 colspan=9>用户信息管理</td></tr><tr height=25 bgcolor=#CCCCCC align=center><td width='20%'><b>用户名</b></td><td width='10%'><b>性别</b></td><td width='10%'><b>E-mail</b></td><td width='10%'><b>发帖数</b></td><td width='10%'><b>金钱</b></td><td width='10%'><b>积分</b></td><td width='15%'><b>注册时间</b></td><td width='15%'><b>等级</b></td><td><input type=checkbox value=""on"" name=""chkall"" onclick=""CheckAll(this.form)""></td></tr>"
	If IsArray(Arr_Rs) Then
		For i = 0 to UBound(Arr_Rs, 2)
			If Arr_Rs(2,i) Then Temp="男" Else Temp="女"
			Response.Write "<tr Height=25 Bgcolor=#EFEFEF><td align='center'><a href='?action=UserEdit&UserID="&Arr_Rs(0,i)&"'>"&Arr_Rs(1,i)&"</a></td><td align='center'>"&Temp&"</td><td align='center'><a href='mailto:"&Arr_Rs(3,i)&"'><img src='../images/mail.gif' border='0'></a></td><td align='center'>"&Arr_Rs(4,i)&"</td><td align='center'>"&Arr_Rs(5,i)&"</td><td align='center'>"&Arr_Rs(6,i)&"</td><td align='center'>"&Formatdatetime(Arr_Rs(7,i),2)&"</td><td align='center'>"&Arr_Rs(8,i)&"</td><td><input type=""checkbox"" name=""UserID"" value="""&Arr_Rs(0,i)&"""></td></tr>"
		Next
	End If
	Response.Write "<tr><td bgcolor=#e7e7e7 colspan=9 align=center><input type=""radio"" value=""1"" name=""useraction""> 屏蔽用户 <input type=""radio"" value=""2"" name=""useraction""> 解除屏蔽 <input type=""radio"" value=""3"" name=""useraction""> 删除用户资料 <input type=""radio"" value=""4"" name=""useraction""> 删除用户帖子 <input type=""radio"" value=""5"" name=""useraction"" checked> 移动到用户组 <select size=""1"" name=""ClassID"">"
		Dim UCL
		set UCL=Conn.execute("Select ClassID,ClassName from YX_UserClass Where ClassID<>6 order by ClassID asc")
		while not UCL.eof
			If UCL(0)=5 Then
				Response.Write "<option value="&UCL(0)&" selected>"&UCL(1)&"</option>"
			Else
				Response.Write "<option value="&UCL(0)&">"&UCL(1)&"</option>"
			End If
		UCL.MoveNext
		wend
		set UCL=nothing
	Response.Write "</select> <input type=""submit"" value=""执行操作"" name=""B1"" onclick=""{if(confirm('确定执行选择的操作吗?')){this.document.recycle.submit();return true;}return false;}""></td></tr>"
	Response.Write "</form><tr><td height=25 colspan=9 Bgcolor=#CCCCCC>"&PageInfo&"</td></tr></table>"
%>
<br>
<form>
<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<tr>
	<td bgcolor=#e7e7e7 align=center>
	<font color="#800000">搜索 <select size="1" name="search">
		<option value=0>用户名</option>
		<option value=1>Email</option>
	</select>&nbsp; <input type="text" name="keyword" size="20"> 
	<input type="Submit" value="查找" name="B1"></font></td></tr>	
  </table>
 </form>
<script language="JavaScript">
<!--
function CheckAll(form) {
 for (var i=0;i<form.elements.length;i++)	{
	var e = form.elements[i];
	if (e.name != 'chkall')
		e.checked = form.chkall.checked; 
	}
 }
//-->
</script>
<%
End Sub
%>

<%
Sub UpdateUserGrade
Server.ScriptTimeout=99999999
dim GradeNum,GradeName,GradePic,UserMinPostNum,ClassID,i
for i=1 to Request.form("GradeNum").count
	GradeNum=replace(Request.form("GradeNum")(i),"'","")
	GradeName=replace(Request.form("GradeName")(i),"'","")
        GradeNum=replace(Request.form("GradeNum")(i),"'","")
	GradePic=replace(Request.form("GradePic")(i),"'","")
	UserMinPostNum=replace(Request.form("UserMinPostNum")(i),"'","")
	ClassID=replace(Request.form("ClassID")(i),"'","")
	
		Dim Rs
		set Rs=Conn.execute("Select GradeNum,GradeName,GradePic,ClassID from YX_User where GradeNum="&GradeNum)
		if not rs.eof then
			if rs("GradeName")<>GradeName or rs("GradePic")<>GradePic or rs("ClassID")<>Cint(ClassID) then
				Conn.execute("Update YX_User set GradeNum="&GradeNum&",GradeName='"& GradeName &"',GradePic='"&GradePic&"',ClassID="&ClassID&" where GradeName='"&rs("GradeName")&"'")
			end if
		end if
		Set Rs=Nothing
		Conn.execute("Update YX_UserGrade set GradeName='"&GradeName&"',GradeNum="&GradeNum&",GradePic='"&GradePic&"',UserMinPostNum="&UserMinPostNum&",ClassID="&ClassID&" where GradeNum="&GradeNum&"")
	
next
Call Suc("","用户等级设置成功！","?Action=UserGrade")
End sub

Sub UserGrade
%>
	<form method="POST" action="?action=updateGrade">
		<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
		<tr>
	<td bgcolor=#e7e7e7 colspan=6 align=center>
	<font color="#800000"><b>用 户 等 级 管 理</b></font></td></tr> 
 		<tr>
		<td bgcolor=#d7d7d7 align="center">名称</td>		
		<td bgcolor=#d7d7d7 width="12%" align="center">等级</td>		
		<td bgcolor=#d7d7d7 width="20%" align="center">图片</td>		
		<td bgcolor=#d7d7d7 width="15%" align="center">最少发贴量</td>		
		<td bgcolor=#d7d7d7 width="15%" align="center">所属用户组ID</td>		
		<td bgcolor=#d7d7d7 width="10%" align="center">操作</td>		
		</tr>
		<%
		Dim Rs
		set rs=Conn.execute("select * from YX_UserGrade order by GradeID asc")
		while not rs.eof 
		%>
 		<tr>
		<td bgcolor=#d7d7d7 align="center">
		<INPUT TYPE="hidden" name="GradeID" value="<%=rs("GradeID")%>">
		<input type="text" name="GradeName" size="23" value="<%=rs("GradeName")%>"></td>		
		<td bgcolor=#d7d7d7 align="center">
		<input type="text" name="GradeNum" size="12" value="<%=rs("GradeNum")%>" disabled></td>		
		<td bgcolor=#d7d7d7 align="center">
		<input type="text" name="GradePic" size="17" value="<%=rs("GradePic")%>"></td>		
		<td bgcolor=#d7d7d7 align="center">
		<input type="text" name="UserMinPostNum" size="13" value="<%=rs("UserMinPostNum")%>"></td>		
		<td bgcolor=#d7d7d7 align="center">
		<input type="text" name="ClassID" size="10" value="<%=rs("ClassID")%>"></td>		
		<td bgcolor=#d7d7d7 align="center"><a href="?Action=DelUserGrade&GradeID=<%=rs("GradeID")%>">删除</a></td>		
		</tr> 
		<%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
		<tr>
		<td bgcolor=#e7e7e7 colspan=6 align=center>
		<input type="submit" value="提交" name="B1"></td></tr>
	</table>
	</form>
<%
End Sub

Sub DelUserGrade
dim GradeID
GradeID=request("GradeID")
YxBBs.Execute("Delete * From [YX_UserGrade] where GradeID="&GradeID&"")
Call Suc("","用户等级删除成功！建议您到更新用户数据中进行更新操作！","?Action=UserGrade")
End Sub

Sub DelUserclass
dim ClassID
ClassID=request("ClassID")
YxBBs.Execute("Delete * From [YX_UserClass] where ClassID="&ClassID&"")
Call Suc("","用户组删除成功！建议您到更新用户数据中进行更新操作！","?Action=UserClass")
End Sub

Sub SaveAddGrade
	dim GradeName,GradeNum,GradePic,UserMinPostNum,ClassID,flag,ErrStr
	GradeName=Request.form("Gradename")
	GradeNum=Request.form("GradeNum")
	GradePic=Request.form("GradePic")
	UserMinPostNum=Request.form("UserMinPostNum")
	ClassID=Request.form("ClassID")
	flag=false
	ErrStr=""
	if GradeName="" then
		ErrStr="<li>等级名没写。<br>"
		flag=true
	end if
	
	if GradeNum="" then
		ErrStr=ErrStr&"<li>等级序号没写。<br>"
		flag=true
	elseif Not isNumeric(GradeNum) then
		ErrStr=ErrStr&"<li>等级序号只能是数字。<br>"
		flag=true
	end if
	
	if GradePic="" then
		ErrStr=ErrStr&"<li>等级图片没有。<br>"
		flag=true
	end if
	
	if UserMinPostNum="" then
		ErrStr=ErrStr&"<li>新的等级需要文章数没写"
		flag=true
	elseif Not isNumeric(UserMinPostNum) then
		ErrStr=ErrStr&"<li>新的等级文章数只能是数字"
		flag=true
	end if
	
	if flag then
		Call GoBack("错误提示",ErrStr)
		exit sub
	end if
	
	Dim Rs,Sql
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select * from YX_UserGrade where GradeName='" & GradeName& "'"
	rs.open sql,conn,1,3
	if rs.eof or rs.bof then
		rs.addnew
		rs("GradeName")=GradeName
		rs("GradeNum")=GradeNum
		rs("GradePic")=GradePic
		rs("UserMinPostNum")=UserMinPostNum
		rs("ClassID")=ClassID
		rs.update
	else
		Call GoBack("","<li>该等级名称已经存在。")
                
		Exit sub
	end if
	rs.close
	set rs=nothing
	Call Suc("","用户等级添加成功！建议您到更新用户数据中进行更新操作！","?Action=UserGrade")
End sub

Sub UserGradeAdd
%>
	<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<form action="?action=SaveAddGrade" method=post>
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	<b><font color="#800000">添加新的用户等级</font></b></td></tr> 
 		<tr>
		<td bgcolor=#d7d7d7 width=40%><font color=#000077><b>名称</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="GradeName" size="30">　</td>
		</tr><tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>等级</b></font></td>		
		<td bgcolor=#d7d7d7>
		<input name="GradeNum" size="30"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>图片</b></font></td>		
		<td bgcolor=#d7d7d7>
		<input name="GradePic" size="30"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>最少发贴量</b></font></td>		
		<td bgcolor=#d7d7d7>
		<input name="UserMinPostNum" size="30"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>所属用户组</b></font></td>		
		<td bgcolor=#d7d7d7>
		<select size="1" name="ClassID">
		<%
		Dim Rs
		set rs=Conn.execute("Select ClassID,ClassName from YX_UserClass order by ClassID asc")
		while not rs.eof
		%>
		<option value="<%=rs("ClassID")%>"><%=rs("ClassName")%></option>
		<%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
		</select>
		</td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="添 加" name="B1"></td></tr>
	</form>
	</table>
<%
End sub



Sub EditUser

Dim Rs,ClassID,UserName,UserID,OldPassword,Password,Question,Answer,Sex,GradeName,Email,HomePage,QQ,ICQ,MSN,HeadFile,HeadWidth
Dim UserTitle,Mark,Coin,BankSave
Dim HeadHeight,Sign,BirthDay,RegistTime,LastLoginTime,UserAction,OldClassID,OldAnswer,OldPassowrd,SQL,OldUserName,AllTable,i
UserID=Request.Form("UserID")
ClassID=Request.Form("ClassID")
OldClassID=Request.Form("OldClassID")
UserName=Request.Form("UserName")
OldUserName=Request.Form("OldUserName")
Password=Request.Form("Password")
OldPassword=Request.Form("OldPassword")
Question=Request.Form("Question")
Answer=Request.Form("Answer")
OldAnswer=Request.Form("OldAnswer")
Sex=Request.Form("Sex")
UserTitle=Request.Form("UserTitle")
Mark=Request.Form("Mark")
Coin=Request.Form("Coin")
BankSave=Request.Form("BankSave")
Email=Request.Form("Email")
HomePage=Request.Form("HomePage")
QQ=Request.Form("QQ")
ICQ=Request.Form("ICQ")
MSN=Request.Form("MSN")
HeadFile=Request.Form("HeadFile")
HeadWidth=Request.Form("HeadWidth")
HeadHeight=Request.Form("HeadHeight")
Sign=Request.Form("Sign")
BirthDay=Request.Form("BirthDay")
RegistTime=Request.Form("RegistTime")
LastLoginTime=Request.Form("LastLoginTime")
UserAction=Request.Form("UserAction")
If Cint(ClassID)<>Cint(OldClassID) Then
	Set Rs=Conn.Execute("Select GradeNum,GradeName,GradePic from YX_UserGrade Where ClassID="&ClassID)
	If rs.eof or rs.bof then
		Call GoBack("错误提示","没有此用户组或已被删除！")
		Exit sub
	End if
	Conn.Execute("Update YX_User Set GradeNum="&Rs("GradeNum")&",GradeName='"&rs("GradeName")&"',GradePic='"&rs("GradePic")&"',ClassID="&ClassID&" where ID =" &UserID)
	Set Rs=Nothing
End If

If OldUserName<>"" or UserName<>"" or UserName <> OldUserName Then
	If LCase(UserName)=LCase(OldUserName) Then
		IF YxBBs.Execute("select name From[YX_User] where Name='"&OldUserName&"'").eof Then Call GoBack("","这个用户根本不存在！"):Exit Sub
	Else
		IF YxBBs.Execute("select name From[YX_User] where Name='"&OldUserName&"'").eof Then Call GoBack("","这个用户根本不存在！"):Exit Sub
		If Not YxBBs.Execute("select name From[YX_User] where Name='"&UserName&"'").eof Then Call GoBack("","新用户名称已经被注册了！"):Exit Sub
	End If
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		YxBBs.Execute("Update [YX_Bbs"&AllTable(i)&"] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
	Next
	YxBBs.Execute("Update [YX_TopicVoteUser] Set [User]='"&UserName&"' where Lcase([User])='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_Topic] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_Sms] Set MyName='"&UserName&"' where Lcase(MyName)='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_Sms] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_Placard] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_User] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
	YxBBs.Execute("Update [YX_Admin] Set Name='"&UserName&"' where Lcase(Name)='"&OldUserName&"'")
End If

Set Rs=Server.CreateObject("Adodb.Recordset")
Sql="Select * From YX_User Where ID="&UserID
Rs.Open Sql,Conn,1,3
If Rs.Eof Then
	Call GoBack("错误提示","没有此用户或已被删除。")
	Exit Sub
End If
Rs("Name")=UserName
If Password<>"" Then Rs("Password")=MD5(Password)
Rs("Clue")=Question
If Answer<>"" Then Rs("Answer")=MD5(Answer)
Rs("Sex")=Sex
Rs("Home")=HomePage
Rs("QQ")=QQ
Rs("Mail")=Email
Rs("Pic")=HeadFile
Rs("PicW")=HeadWidth
Rs("PicH")=HeadHeight
Rs("Sign")=Sign
Rs("Honor")=UserTitle
Rs("Mark")=Mark
Rs("Coin")=Coin
Rs("BankSave")=BankSave
Rs("BirthDay")=BirthDay
Rs("RegTime")=RegistTime
Rs("LastTime")=LastLoginTime
Rs("IsShow")=UserAction
Rs.update
Rs.CLose
Set Rs= Nothing
Call Suc("","用户修改成功!","Users.Asp")
End Sub

Sub UserEdit
Dim Rs,i,ClassID,UserName,UserID,Password,Question,Answer,Sex,GradeName,Email,HomePage,QQ,ICQ,MSN,HeadFile,HeadWidth
Dim UserTitle,Mark,Coin,BankSave
Dim HeadHeight,Sign,BirthDay,RegistTime,LastLoginTime,UserAction
UserID=Request("UserID")
Set Rs=Conn.Execute("Select * From YX_User Where ID="&UserID)
If Rs.Eof Then
	Call GoBack("错误提示","找不到用户或已被删除！")
	Response.End
End If
ClassID=Rs("ClassID")
UserName=Rs("Name")
Password=Rs("Password")
Question=Rs("Clue")
Answer=Rs("Answer")
Sex=Rs("Sex")
GradeName=Rs("GradeName")
Email=Rs("Mail")
Homepage=Rs("Home")
QQ=Rs("QQ")
HeadFile=Rs("Pic")
HeadWidth=Rs("PicW")
HeadHeight=Rs("PicH")
Sign=Rs("Sign")
UserTitle=Rs("Honor")
Mark=Rs("Mark")
Coin=Rs("Coin")
BankSave=Rs("BankSave")
Birthday=Rs("Birthday")
RegistTime=Rs("RegTime")
LastLoginTime=Rs("LastTime")
useraction=Rs("IsShow")
Set Rs=Nothing
%>
<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<form action="?action=EditUser" method=post>
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<p align="left"><font color="#800000"><b>用户基本资料修改</b></font></td></tr> 
	
 		<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>用户组</b></font></td>		
		<td bgcolor=#d7d7d7>
		<INPUT TYPE="hidden" Name="UserID" Value="<%=UserID%>">
		<INPUT TYPE="hidden" Name="OldClassID" Value="<%=ClassID%>">
		<select size="1" name="ClassID">
		<%
		Dim UCL
		set UCL=Conn.execute("Select ClassID,ClassName from YX_UserClass Where ClassID<>6 order by ClassID Asc")
		while not UCL.eof
			Response.write "<option value='"&UCL("ClassID")&"'"
			If ClassID=UCL("ClassID") Then Response.Write "Selected"
			Response.write ">"&UCL("ClassName")&"</option>"
			UCL.MoveNext
		wend
		set UCL=nothing
		%>
		</select></td>
		</tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>用户名</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<INPUT TYPE="hidden" name="OldUserName" value="<%=UserName%>">
		<input name="UserName" size="30" value="<%=UserName%>">　</td>
	  </tr>
	
 		<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>密&nbsp;&nbsp; 码</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<INPUT TYPE="hidden" name="OldPassword" value="<%=Password%>">
		<input name="Password" size="30" >　如果不修改请留空</td>
		</tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>密码问题</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="Question" size="30" value="<%=Question%>">　</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>密码答案</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<INPUT TYPE="hidden" name="OldAnswer" value="<%=Answer%>">
		<input name="Answer" size="30">　如果不修改请留空</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>性别</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%><INPUT TYPE="radio" NAME="Sex" value="1" <%If Sex Then Response.write"Checked"%>>
		男 <INPUT TYPE="radio" NAME="Sex" value="0" <%If Not Sex Then Response.write"Checked"%>>
		女</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>自定头衔</b></font></td>		
		<td bgcolor=#d7d7d7>
		<input name="UserTitle" size="30" value="<%=UserTitle%>"></td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>论坛等级</b></font></td>		
		<td bgcolor=#d7d7d7>
		<input name="GradeName" size="30" value="<%=GradeName%>" readonly></td>
	  </tr>
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<p align="left"><font color="#800000"><b>用户联系资料</b></font></td>
	</tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>邮箱</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="Email" size="30" value="<%=Email%>">　</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>个人主页</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="HomePage" size="30" value="<%=HomePage%>">　</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>QQ号码</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="QQ" size="30" value="<%=QQ%>">　</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>论坛头像</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="HeadFile" size="30" value="<%=HeadFile%>">　图片宽<input name="HeadWidth" size="5" value="<%=Headwidth%>">&nbsp; 
		图片高<input name="HeadHeight" size="5" value="<%=HeadHeight%>"></td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>个人签名<br>
		　</b></font></td>		
		<td bgcolor=#d7d7d7><textarea rows="4" name="Sign" cols="29"><%=Sign%></textarea></td>
	  </tr>
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<p align="left"><font color="#800000"><b>积分相关</b></font></td>
	</tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>用户金钱</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%><input name="Coin" size="30" value="<%=Coin%>"></td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>用户存款</b></font></td>		
		<td bgcolor=#d7d7d7><input name="BankSave" size="30" Value="<%=BankSave%>"></td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>用户积分</b></font></td>		
		<td bgcolor=#d7d7d7><input name="Mark" size="30" value="<%=Mark%>"></td>
	  </tr>
	
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<p align="left"><font color="#800000"><b>日期相关</b></font></td>
	</tr>
	<tr>
		<td bgcolor=#d7d7d7 width=40%><font color="#000077"><b>出生日期</b></font></td>		
		<td bgcolor=#d7d7d7 width=60%>
		<input name="Birthday" size="30" value="<%=Birthday%>">　
		格式:1986-8-12</td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>注册时间</b></font></td>		
		<td bgcolor=#d7d7d7><input name="RegistTime" size="30" Value="<%=RegistTime%>"></td>
	  </tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>最后登录</b></font></td>		
		<td bgcolor=#d7d7d7><input name="LastLoginTime" size="30" value="<%=LastLoginTime%>"></td>
	  </tr>
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<p align="left"><font color="#800000"><b>用户设置</b></font></td>
	</tr>
	<tr>
		<td bgcolor=#d7d7d7><font color="#000077"><b>用户状态</b></font></td>		
	  <td bgcolor=#d7d7d7>正常 
		<input type="radio" value="0" name="useraction" <%If Not UserAction Then Response.write "Checked"%>>&nbsp; 
		屏蔽 
		<input type="radio" value="1" name="useraction" <%If UserAction Then Response.write "Checked"%>>	    </td>
	  </tr>
	<tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="编 辑" name="B1"></td></tr>
	</form>
</table>
<%
End sub
%>

<%
Sub UserClass
%>
  <table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=5 align=center>
	
	<font color="#800000"><b>组 户 组 管 理</b></font></td></tr> 
	
	  <tr>
		<td bgcolor=#d7d7d7 width="20%" align="center"><b><font color="#000077">
		用户组</font></b></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><font color="#000077"><b>
		用户数量</b></font></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><font color="#000077"><b>
		编辑权限</b></font></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><font color="#000077"><b>
		例出所有用户</b></font></td>
                <td bgcolor=#d7d7d7 width="20%" align="center"><font color="#000077"><b>
		操作</b></font></td>		
    </tr> 
	  <%
		Dim User_Count,Uc
		set rs=Conn.execute("Select ClassID,ClassName from YX_UserClass")
		while not rs.eof 
			Set uc=Conn.execute("Select Count(ID) from YX_User Where ClassID="&Rs(0)&"")
				User_Count=uc(0)
				uc.close
			set uc=nothing
		%>
	  <tr>
		<td bgcolor=#d7d7d7 width="20%" align="center"><%=rs("ClassName")%></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><%=User_Count%></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><a href="?Action=Classedit&ClassID=<%=rs("ClassID")%>">编辑</a></td>		
		<td bgcolor=#d7d7d7 width="20%" align="center"><a href="Users.Asp?ClassID=<%=Rs("ClassID")%>">查看</a></td>
                <td bgcolor=#d7d7d7 width="20%" align="center"><a href="users.asp?Action=DelUserclass&ClassID=<%=Rs("ClassID")%>" onclick="checkclick('删除前请先将该组用户全部移动到其他组,否则后果自负!\n\n您确定要删除吗？')">删除</a></td>		
	  </tr>
	  <%
		rs.movenext
		wend
		rs.close
		set rs=nothing
		%>
	  <tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=5 align=center>&nbsp;
		</td>
	  </tr>
  </table>
<%
End Sub


Sub saveeditClass
	Dim ClassID,ClassSetting,Sql
	ClassID=Request.form("ClassID")
	IF ClassID="" or not isNumeric(ClassID) then
		Call GoBack("错误提示","参数错误码，请确认正确的参数。")
		Exit sub
	End if
	
	ClassSetting=Request.form("CanViewUserinfo") & "," & Request.form("CanViewNewTopic") & "," & Request.form("CanViewTopicDigest") & "," & Request.form("CanNewTopic") & "," & Request.form("CanPostMyTopic") & "," & Request.form("CanPostOrtherTopic") & "," & Request.form("CanUpfile") & "," & Request.form("CanNewTopicVote") & "," & Request.form("CanPostTopicVote") & "," & Request.form("CanEditMyTopic") & "," & Request.form("CanSendMessage") & "," & Request.form("SendMaxCount") & "," & Request.form("SendMessageMaxSize") & "," & Request.Form("SmsBoxMaxSize") & "," & Request.form("CanDelTopic") & "," & Request.form("CanMoveTopic") & "," & Request.form("CanTopTopic") & "," & Request.form("CanTTopTopic") & ","& Request.form("CanEditTopic") & "," & Request.form("CanDigestTopic") & "," & Request.form("CanLockTopic")
	
	Dim Rs
	Set rs=server.createobject("Adodb.Recordset")
	sql="select * from YX_UserClass where ClassID="& Request.form("ClassID")
	rs.open sql,conn,1,3
	If not (rs.eof and rs.bof) then
		'rs("ClassName")=ClassName
		rs("ClassSetting")=ClassSetting
		rs.update
	Else
		Call GoBack("错误提示","没有此用户组，或者已被删除。")
		Exit sub
	End if
	rs.close
	Set rs=nothing
	
	Call Suc("","用户组修改成功！","?")
End sub

Sub UserClassEdit
	Dim Rs,ClassID,ClassName,ClassSetting
	ClassID=Request("ClassID")
	if Not IsNumeric(ClassID) then
		Call GoBack("错误提示","参数错误，请提交正确的参数")
		Exit sub
	end if
	set rs=Conn.execute("Select * from YX_UserClass where ClassID="& ClassID)
	if rs.eof or rs.bof then
		Call GoBack("错误提示","找不到此用户组或已被删除。")
		Exit sub
	else
		ClassName=rs("ClassName")
				ClassSetting=split(rs("ClassSetting"),",")
%>
 <form action="?action=saveeditClass" method=post name="creator">
	<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	<font color="#800000"><b>用 户 组 编 辑</b></font></td></tr>
 		<tr>
		<td bgcolor=#d7d7d7 width="35%">组名称</td>		
		<td bgcolor=#d7d7d7><INPUT TYPE="hidden" name="ClassID" value="<%=ClassID%>">
		<input name="ClassName" size="20" value="<%=ClassName%>" readonly>　</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2"><font color="#000077"><b>一般权限</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7>可以查看会员信息</td>		
		<td bgcolor=#d7d7d7>是<input name="canviewuserinfo" type="radio" value="1" <%if ClassSetting(0)=1 then response.write "checked"%>>&nbsp;否<input name="canviewuserinfo" type="radio" value="0" <%if ClassSetting(0)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以查看其他人发布的主题</td>		
		<td bgcolor=#d7d7d7>是<input name="CanViewNewTopic" type="radio" value="1" <%if ClassSetting(1)=1 then response.write "checked"%>>&nbsp;否<input name="CanViewNewTopic" type="radio" value="0" <%if ClassSetting(1)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以浏览精华帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="canviewTopicDigest" type="radio" value="1" <%if ClassSetting(2)=1 then response.write "checked"%>>&nbsp;否<input name="canviewTopicDigest" type="radio" value="0" <%if ClassSetting(2)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发布新主题</td>		
		<td bgcolor=#d7d7d7>是<input name="CanNewTopic" type="radio" value="1" <%if ClassSetting(3)=1 then response.write "checked"%>>&nbsp;否<input name="CanNewTopic" type="radio" value="0" <%if ClassSetting(3)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以回复自己的主题</td>		
		<td bgcolor=#d7d7d7>是<input name="CanPostMyTopic" type="radio" value="1" <%if ClassSetting(4)=1 then response.write "checked"%>>&nbsp;否<input name="CanPostMyTopic" type="radio" value="0" <%if ClassSetting(4)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以回复其他人的主题</td>		
		<td bgcolor=#d7d7d7>是<input name="CanPostOrtherTopic" type="radio" value="1" <%if ClassSetting(5)=1 then response.write "checked"%>>&nbsp;否<input name="CanPostOrtherTopic" type="radio" value="0" <%if ClassSetting(5)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以上传附件 </td>		
		<td bgcolor=#d7d7d7>是<input name="CanUpfile" type="radio" value="1" <%if ClassSetting(6)=1 then response.write "checked"%>>&nbsp;否<input name="CanUpfile" type="radio" value="0" <%if ClassSetting(6)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发布新投票</td>		
		<td bgcolor=#d7d7d7>是<input name="CanNewTopicVote" type="radio" value="1" <%if ClassSetting(7)=1 then response.write "checked"%>>&nbsp;否<input name="CanNewTopicVote" type="radio" value="0" <%if ClassSetting(7)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以参与投票</td>		
		<td bgcolor=#d7d7d7>是<input name="CanPostTopicVote" type="radio" value="1" <%if ClassSetting(8)=1 then response.write "checked"%>>&nbsp;否<input name="CanPostTopicVote" type="radio" value="0" <%if ClassSetting(8)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以编辑自己的帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanEditMyTopic" type="radio" value="1" <%if ClassSetting(9)=1 then response.write "checked"%>>&nbsp;否<input name="CanEditMyTopic" type="radio" value="0" <%if ClassSetting(9)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发送短信</td>		
		<td bgcolor=#d7d7d7>是<input name="CanSendMessage" type="radio" value="1" <%if ClassSetting(10)=1 then response.write "checked"%>>&nbsp;否<input name="CanSendMessage" type="radio" value="0" <%if ClassSetting(10)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>每天最多上传附件</td>		
		<td bgcolor=#d7d7d7><input name="SendMaxCount" size="10" value="<%=ClassSetting(11)%>"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>上传附件大小限制</td>		
		<td bgcolor=#d7d7d7><input name="SendMessageMaxSize" size="10" value="<%=ClassSetting(12)%>">byte</td>
		</tr><tr>
		<td bgcolor=#d7d7d7>信箱大小限制</td>		
		<td bgcolor=#d7d7d7><input name="SmsBoxMaxSize" size="10" value="<%=ClassSetting(13)%>">KB</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2"><font color="#000077"><b>管理权限</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7>可以删除其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanDelTopic" type="radio" value="1" <%if ClassSetting(14)=1 then response.write "checked"%>>&nbsp;否<input name="CanDelTopic" type="radio" value="0" <%if ClassSetting(14)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以移动其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanMoveTopic" type="radio" value="1" <%if ClassSetting(15)=1 then response.write "checked"%>>&nbsp;否<input name="CanMoveTopic" type="radio" value="0" <%if ClassSetting(15)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以固顶/解除固顶帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanTopTopic" type="radio" value="1" <%if ClassSetting(16)=1 then response.write "checked"%>>&nbsp;否<input name="CanTopTopic" type="radio" value="0" <%if ClassSetting(16)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以进行帖子总固顶操作</td>		
		<td bgcolor=#d7d7d7>是<input name="CanTTopTopic" type="radio" value="1" <%if ClassSetting(17)=1 then response.write "checked"%>>&nbsp;否<input name="CanTTopTopic" type="radio" value="0" <%if ClassSetting(17)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以编辑其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanEditTopic" type="radio" value="1" <%if ClassSetting(18)=1 then response.write "checked"%>>&nbsp;否<input name="CanEditTopic" type="radio" value="0" <%if ClassSetting(18)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以加入/解除精华帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanDigestTopic" type="radio" value="1" <%if ClassSetting(19)=1 then response.write "checked"%>>&nbsp;否<input name="CanDigestTopic" type="radio" value="0" <%if ClassSetting(19)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以锁定/解除锁定其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanLockTopic" type="radio" value="1" <%if ClassSetting(20)=1 then response.write "checked"%>>&nbsp;否<input name="CanLockTopic" type="radio" value="0" <%if ClassSetting(20)=0 then response.write "checked"%>></td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="修 改" name="B1"></td></tr>
   </table>
</form>

<%
end if
End sub

Sub saveaddClass
	Dim ClassName,ClassSetting
	ClassName=Request.form("ClassName")
	IF ClassName="" then
		Call GoBack("","您没有输入组名,请输入组名。")
		Exit sub
	End if
	
	ClassSetting=Request.form("CanViewUserinfo") & "," & Request.form("CanViewNewTopic") & "," & Request.form("CanViewTopicDigest") & "," & Request.form("CanNewTopic") & "," & Request.form("CanPostMyTopic") & "," & Request.form("CanPostOrtherTopic") & "," & Request.form("CanUpfile") & "," & Request.form("CanNewTopicVote") & "," & Request.form("CanPostTopicVote") & "," & Request.form("CanEditMyTopic") & "," & Request.form("CanSendMessage") & "," & Request.form("SendMaxCount") & "," & Request.form("SendMessageMaxSize") & "," & Request.form("MessageMaxSize") & "," & Request.form("CanDelTopic") & "," & Request.form("CanMoveTopic") & "," & Request.form("CanTopTopic") & "," & Request.form("CanTTopTopic") & ","& Request.form("CanEditTopic") & "," & Request.form("CanDigestTopic") & "," & Request.form("CanLockTopic")
	Dim Rs
	Set rs=Conn.Execute("Select * from YX_UserGrade where GradeName='" & ClassName & "'")
	
	If Not(rs.eof and rs.bof) then
		Call GoBack("","该等级名称已经存在!")
		Exit sub
	End if
	
	Dim Sql
	Set Rs=Server.CreateObject("Adodb.Recordset")
	sql="select * from YX_UserClass where ClassName='"& ClassName &"'"
	rs.open sql,conn,1,3
	If rs.eof or rs.bof then
		rs.addnew
		rs("ClassName")=ClassName
		rs("ClassSetting")=ClassSetting
		rs.update
	Else
		Call GoBack("","该用户组名称已经存在！")
		Exit sub
	End if
	
	rs.close
	set rs=nothing
	Call Suc("","用户组添加成功！","?Action=UserClass")
End sub

Sub UserClassAdd
%>
 <form action="?action=saveaddClass" method=post name="creator">
	<table width=95% border=0 align="center" cellpadding=6 cellspacing=1 bgcolor="#FFFFFF">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
	
	<font color="#800000"><b>用 户 组 添 加</b></font></td></tr> 
	
 		<tr>
		<td bgcolor=#d7d7d7 width="35%">组名称</td>		
		<td bgcolor=#d7d7d7>
		<input name="ClassName" size="20">　</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2"><font color="#000077"><b>一般权限</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7>可以查看会员信息</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="canviewuserinfo" type="radio" value="1">&nbsp;否<input name="canviewuserinfo" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以查看其他人发布的主题</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanViewNewTopic" type="radio" value="1">&nbsp;否<input name="CanViewNewTopic" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以浏览精华帖子</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="canviewTopicDigest" type="radio" value="1">&nbsp;否<input name="canviewTopicDigest" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发布新主题</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanNewTopic" type="radio" value="1">&nbsp;否<input name="CanNewTopic" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以回复自己的主题</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanPostMyTopic" type="radio" value="1">&nbsp;否<input name="CanPostMyTopic" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以回复其他人的主题</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanPostOrtherTopic" type="radio" value="1">&nbsp;否<input name="CanPostOrtherTopic" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以上传附件 </td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanUpfile" type="radio" value="1">&nbsp;否<input name="CanUpfile" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发布新投票</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanNewTopicVote" type="radio" value="1">&nbsp;否<input name="CanNewTopicVote" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以参与投票</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanPostTopicVote" type="radio" value="1">&nbsp;否<input name="CanPostTopicVote" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以编辑自己的帖子</td>		
		<td bgcolor=#d7d7d7>是<input CHECKED name="CanEditMyTopic" type="radio" value="1">&nbsp;否<input name="CanEditMyTopic" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以发送短信</td>		
		<td bgcolor=#d7d7d7>是<input name="CanSendMessage" type="radio" value="1" checked>&nbsp;否<input name="CanSendMessage" type="radio" value="0"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>最多发送用户</td>		
		<td bgcolor=#d7d7d7><input name="SendMaxCount" size="10" value="5"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>短信内容大小限制</td>		
		<td bgcolor=#d7d7d7>
		<input name="SendMessageMaxSize" size="10" value="300">byte</td>
		</tr><tr>
		<td bgcolor=#d7d7d7>信箱大小限制</td>		
		<td bgcolor=#d7d7d7><input name="MessageMaxSize" size="10" value="100">KB</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2"><font color="#000077"><b>管理权限</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7>可以删除其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanDelTopic" type="radio" value="1">&nbsp;否<input name="CanDelTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以移动其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanMoveTopic" type="radio" value="1">&nbsp;否<input name="CanMoveTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以固顶/解除固顶帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanTopTopic" type="radio" value="1">&nbsp;否<input name="CanTopTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以进行帖子总固顶操作</td>		
		<td bgcolor=#d7d7d7>是<input name="CanTTopTopic" type="radio" value="1">&nbsp;否<input name="CanTTopTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以编辑其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanEditTopic" type="radio" value="1">&nbsp;否<input name="CanEditTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以加入/解除精华帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanDigestTopic" type="radio" value="1">&nbsp;否<input name="CanDigestTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#d7d7d7>可以锁定/解除锁定其它人帖子</td>		
		<td bgcolor=#d7d7d7>是<input name="CanLockTopic" type="radio" value="1">&nbsp;否<input name="CanLockTopic" type="radio" value="0" checked></td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center>
		<input type="submit" value="添 加" name="B1"></td></tr>
   </table>
</form>
<%
End sub%>
<%
Sub OutMail
Dim I,Temp,MailFso,MailObj,MailRs,USex,UBurn
I=1
Set MailFso=Server.CreateObject("Scripting.FileSystemObject")
Set MailObj=MailFso.CreateTextFile(Server.MapPath("outmail.csv"),True)
	MailObj.Write"姓名,电子邮件地址,QQ,个人主页,性别,生日,foxaddrID"
Set	MailRs=yxbbs.Execute("Select Name,Mail,QQ,Home,Sex,Birthday From yx_User")
	Do While Not MailRs.Eof
		If IsDate(MailRs("Birthday")) Then
			UBurn=MailRs("Birthday")
		Else
			UBurn=""
		End if
		If MailRs("Sex") Then 
			USex="男"
		Else
			Usex="女"
		End If
		MailObj.Write VbCrlf&MailRs("Name")&","&MailRs("Mail")&","&MailRs("QQ")&","&MailRs("Home")&","&USex&","&UBurn&","&I
		I=I+1
	MailRs.MoveNext
	Loop
	MailRs.Close
Set MailFso=Nothing
Call Suc("","导出<span style=""color:#ff0000"">"&I&"</span>条记录.论坛管理目录下找到outmail.csv,将其导入foxmail就可以了(导入方法可以看看foxmail帮助),建议您在下载完outmail.csv后将其删除以免别人下载,并且在导入到foxmail后最好压缩修复一下.","?")
End Sub%>