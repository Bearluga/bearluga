<!--#include file="Check.Asp"-->
<%
Dim Action,ID
ID=Request.QueryString("ID")
If ID="" Then ID=0

Action=Lcase(Request.QueryString("Action"))
Select case Action
Case "plus"
	Plus
Case "editplus"
	EditPlus
Case "faction"
	Faction
Case "editfaction"
	EditFaction
Case "bank"
	Bank
Case "savebank"
	SaveBank
Case "saveplus"
	SavePlus
Case "delplus"
	DelPlus
Case "delfaction"
	DelFaction
Case  "updatefaction"
	UpdateFaction
End select
AdminFooter()

Sub Plus
	Dim i
%>
	<form method=POST name=form style='margin:0' action=Plus.Asp?Action=SavePlus>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">添加论坛插件</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>插件名称：</td>
	<td><input type="text" name="PlusName" size="20"></td></tr>
	<tr bgcolor="#DEDEDE"><td>连接文件：</td>
	<td><input type="text" name="PlusUrl" size="38">(请填写相对路径)</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form><br>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" ><b>插件名称</b></td><td><b>连接文件</b></td><td align="center"><b>操作</b></td></tr>
	<%
	Set Rs=YxBBs.Execute("Select ID,Name,Url,Flag From [YX_Plus] order by Flag desc")
	Do while Not Rs.eof
	%>
	<tr bgcolor="#DEDEDE"><td><%=Rs(1)%></td><td>&nbsp;<a href="<%=Rs(2)%>" target="_blank"><%=Rs(2)%></a></td>
	<td align="center"><a href="?Action=EditPlus&ID=<%=Rs(0)%>"><img src="../images/edit.gif" width="18" height="13" border="0" align="absmiddle"> 编辑</a> <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href="Plus.Asp?Action=DelPlus&ID=<%=Rs(0)%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"> 删除</a></td>
	</tr>
	<%Rs.movenext
	Loop
	Rs.Close
	%>
</table>
	</form>
<%End Sub

Sub EditPlus
	Set Rs=YxBBs.Execute("Select name,Url,Flag From [YX_Plus] where ID="&ID&"")
%>
	<form method=POST name=form style='margin:0' action=Plus.Asp?Action=SavePlus>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">修改论坛插件</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>插件名称：</td>
	<td><input name="ID" type="hidden" value="<%=ID%>"><input type="text" name="PlusName" size="20" value="<%=Rs(0)%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>连接文件：</td>
	<td><input type="text" name="PlusUrl" size="38" value="<%=Rs(1)%>">(请填写相对路径)</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
<%Rs.Close
End Sub

Sub Faction
Dim UserNum%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" align="center">帮派名称</td>
	<td>掌门人</td>
	<td>人数</td>
	<td>创派时间</td>
	<td>操作</td>
	</tr>
	<%
	Set Rs=YxBBs.Execute("Select ID,Name,User,BuildDate From [YX_Faction] order by ID desc")
	Do while Not Rs.eof
	UserNum=YxBBs.Execute("select count(ID) from [YX_User] where Faction='"&Rs(1)&"'")(0)
	%>
	<tr bgcolor="#DEDEDE"><td align="center"><%=Rs(1)%></td><td align="center">&nbsp;<%=Rs(2)%></td><td align="center"><%=UserNum%></td><td align="center"><%=Rs(3)%></td>
	<td align="center"><a href="?Action=EditFaction&ID=<%=Rs(0)%>"><img src="../images/edit.gif" width="18" height="13" border="0" align="absmiddle"> 编辑</a> <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href="Plus.Asp?Action=DelFaction&Name=<%=Rs(1)%>"><img src="../images/del.gif" width="18" height="18" border="0" align="absmiddle"> 删除</a></td>
	</tr>
	<%Rs.movenext
	Loop
	Rs.Close
	%>
</table>
<%End Sub

Sub EditFaction
	Set Rs=YxBBs.Execute("Select Name,FullName,Note,User,BuildDate From [YX_Faction] where ID="&ID)
%>
	<form method=POST name=form style='margin:0' action=Plus.Asp?Action=UpdateFaction>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tbody>
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">修改帮派</font></b></td>
	</tr>
	<tr bgcolor="#DEDEDE"><td>帮派名称：</td>
	<td><input name="ID" type="hidden" value="<%=ID%>"><input name="Name" type="text" value="<%=Rs(0)%>" size="20" maxlength="40"></td></tr>
	<tr bgcolor="#DEDEDE"><td>帮派全称：</td>
	<td><input name="FullName" type="text" value="<%=Rs(1)%>" size="38" maxlength="150"></td></tr>
	<tr bgcolor="#DEDEDE"><td>帮派宗旨：</td>
	<td><input name="Note" type="text" value="<%=Rs(2)%>" size="50" maxlength="250"></td></tr>
	<tr bgcolor="#DEDEDE"><td>掌门人：</td>
	<td><input type="text" name="User" size="10" value="<%=Rs(3)%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td>创派日期：</td>
	<td><input type="text" name="BuildDate" size="20" value="<%=Rs(4)%>"></td></tr>
<tr bgcolor="#CCCCCC"><td colspan="5"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
<%Rs.Close
End Sub

Sub Bank
%>
<form method=POST  style='margin:0' action=Plus.Asp?Action=SaveBank  onSubmit="ok.disabled=true;ok.value='银行正在处理-请稍等。。。'">
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tbody>
<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><b><font color="#FFFFFF">后台银行</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td align='right' >对象：</td>
<td>
<select name='User' style='font-size: 9pt'>
<option value=0>所有在线用户</option>
<option value=1 selected>所有版主</option>
<option value=2>所有总版主</option>
<option value=3>所有管理员</option>
<option value=4>管理团队(板主+管理员)</option>
<option value=5>所有注册用户</option>
</select></td></tr>
<tr bgcolor="#DEDEDE"><td align='right' valign='top'>操作：</td>
  <td><input name="Flag" type="radio" value="1" checked>
    送钱 
      <input name="Flag"  type="radio"value="0">
      扣钱</td>
  </tr>
  <tr bgcolor="#DEDEDE"><td align='right' valign='top'>金额：</td>
  <td><input name="Coin" type="text" value="1000" size="10" maxlength="5"></td>
  </tr>
<tr bgcolor="#CCCCCC"><td colspan='2' align='center'><input  type='submit' value='确定' name="ok">&nbsp;<input type='reset' value='重写'>
</td></tr></table>
</form>
<%
End Sub

Sub SavePlus
	Dim PlusName,PlusUrl,Flag,ID
	PlusName=YxBBs.Fun.GetStr("PlusName")
	PlusUrl=YxBBs.Fun.GetStr("PlusUrl")
	ID=YxBBs.Fun.GetStr("ID")
	If PlusName="" or PlusUrl="" Then
		Call GoBack("",""):Exit Sub
	End IF
	IF ID<>"" Then
		YxBBs.Execute("Update [YX_Plus] Set name='"&PlusName&"',url='"&PlusUrl&"' where ID="&ID)
		Cache.name="PlusMenu":Cache.Clean()
		Call Suc("","成功的修改了插件："&PlusName&"","Plus.Asp?Action=Plus")	
	Else
		YxBBs.Execute("insert into [YX_Plus](name,url) values('"&PlusName&"','"&PlusUrl&"')")
		Cache.name="PlusMenu":Cache.Clean()
		Call Suc("","成功的添加了插件："&PlusName&"","Plus.Asp?Action=Plus")
	End IF
End Sub

Sub DelPlus
	Dim ID
	ID=Request.QueryString("ID")
	YxBBs.Execute("Delete From[YX_Plus] where ID="&ID)
	Cache.name="PlusMenu":Cache.Clean()
	Call Suc("","成功删除了插件","Plus.Asp?Action=Plus")
End Sub

Sub DelFaction
	Dim Name
	Name=Request.QueryString("Name")
	YxBBs.Execute("Delete * From[YX_Faction] where Name='"&Name&"'")
	YxBBs.Execute("update [YX_User] Set Faction='' where Faction='"&Name&"'")
	Call Suc("","成功删除了帮派！","Plus.Asp?Action=Faction")
End Sub

Sub UpdateFaction
	Dim Name,FullName,Note,User,BuildDate,ID
	ID=YxBBs.Fun.GetStr("ID")
	Name=YxBBs.Fun.GetStr("Name")
	FullName=YxBBs.Fun.GetStr("FullName")
	Note=YxBBs.Fun.GetStr("Note")
	User=YxBBs.Fun.GetStr("User")
	BuildDate=YxBBs.Fun.GetStr("BuildDate")
	IF Name="" Or FullName="" Or Note="" or User="" Then Call Goback("",""):Exit Sub
	If Not isDate(BuildDate) Then BuildDate=YxBBs.NowBBSTime
	Set Rs=YxBBs.Execute("Select Name From[YX_Faction] where ID="&ID)
	If Rs.Eof Then Call Goback("","记录已被删除了！")
	If Name<>Rs(0) Then
	YxBBs.Execute("update [YX_User] Set Faction='"&Name&"' where Faction='"&Rs(0)&"'")
	End If
	Rs.Close
	YxBBs.Execute("update [YX_Faction] Set [Name]='"&Name&"',FullName='"&FullName&"',[Note]='"&Note&"',[User]='"&User&"',BuildDate='"&BuildDate&"' where ID="&ID)
	Call Suc("","成功的更新了帮派！","Plus.Asp?Action=Faction")
End Sub

Sub SaveBank
	Dim UserType,Sql,Coin,Flag,I,MRs
	UserType=YxBBs.Fun.GetStr("User")
	Coin=YxBBs.Fun.GetStr("Coin")
	Flag=YxBBs.Fun.GetStr("Flag")
	If Coin="" Then Call GoBack("",""):Exit Sub
	If Not isnumeric(Coin) Then Call GoBack("","金额请用数字填写！"):Exit Sub
	Select case UserType
		case"0"
			Sql="select name From [YX_Online] where ClassID<>6"
		case"1"
			sql="select name from [YX_User] where ClassID=3 and not isdel"
		case"2"
			sql="select name from [YX_User] where ClassID=2 and not isdel"
		case"3"
			sql="select name from [YX_User] where ClassID=1 and not isdel"
		case"4"
			sql="select name from [YX_User] where ClassID<=3 and not isdel"
		case"5"
			sql="select name from [YX_User] where ClassID=5 and not isdel"
		case else
			Call GoBack("","非法操作"):Exit Sub
	End select
	Set Rs=YxBBs.Execute(Sql)
	If Not Rs.Eof Then
		MRs=Rs.GetRows(-1)
		Rs.close
		For I=0 to Ubound(MRs,2)
			If Flag="1" Then
				YxBBs.Execute("update [YX_user] set Coin=Coin+"&Coin&" where Name='"&MRs(0,i)&"'")
			Else
				Set Rs=YxBBs.Execute("Select Coin,BankSave From[YX_user] where Name='"&MRs(0,i)&"'")
				If Not Rs.Eof Then
					IF CCur(Rs(0)) < CCur(Coin) Then
						If CCur(Coin)-CCur(Rs(0))>CCur(Rs(1)) Then
							YxBBs.Execute("update [YX_user] set Coin=0,BankSave=0 where Name='"&MRs(0,i)&"'")
						Else
							YxBBs.Execute("update [YX_user] set Coin=0,BankSave=BankSave-"&CCur(Coin)-CCur(Rs(0))&" where Name='"&MRs(0,i)&"'")
						End If
					Else
						YxBBs.Execute("update [YX_user] set Coin=Coin-"&Coin&" where Name='"&MRs(0,i)&"'")
					End If
				End If
				Rs.Close
			End If
		Next
		Cache.name="BankPlacard"
		Cache.clean()
	End If
	Call Suc("","银行处理成功！","Plus.Asp?Action=Bank")
End Sub
%>