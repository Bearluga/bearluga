<!--#include file="Check.Asp"-->
<%
Const MaxDepth=3
Server.ScriptTimeout =999999
Response.Write("<table width='98%' border='0' align='center' cellpadding='4' cellspacing='1' bgcolor='#FFFFFF'><tr bgcolor='#CCCCCC'><td height='25' align='center'>论坛版面管理</td></tr><tr bgcolor=#DEDEDE><td align='center'><a href='?'>论坛管理</a> | <a href='?Action=AddClass'>增加分类</a> | <a href='?Action=AddBoard'>增加论坛</a> | <a href='?Action=ClassOrders'>分类排序</a> | <a href='?Action=BoardUpdate'>论坛整理</a> | <a href='?Action=BoardUnite'>论坛合并</a></td></tr></table><br>")
Response.flush
Select Case Request("Action")
Case "AddClass"
	AddClass
Case "SaveClass"
	SaveClass
Case "EditClass"
	EditClass
Case "SaveEditClass"
	SaveEditClass
Case "DelClass"
	DelClass
Case "AddBoard"
	AddBoard
Case "SaveBoard"
	SaveBoard
Case "EditBoard"
	EditBoard
Case "SaveEditBoard"
	SaveEditBoard
Case "DelBoard"
	DelBoard
Case "ClassOrders"
	ClassOrders
Case "SaveClassOrders"
	SaveClassOrders
Case "BoardUnite"
	BoardUnite
Case "SaveBoardUnite"
	SaveBoardUnite
Case "ClearData"
	ClearData
Case "StartClearData"
	StartClearData
Case "PassUser"
	PassUser
Case "SavePassUser"
	SavePassUser
Case "BoardUpdate"
	BoardUpdate
Case "OrdersBoard"
	OrdersBoard
Case else
	BoardInfo()
end select
AdminFooter()

Sub updateBoardCache
	Cache.Name="BoardInfo"
	Cache.clean()
	Cache.Name="BoardList1"
	Cache.clean()
	Cache.Name="BoardList2"
	Cache.clean()	
End Sub

Sub BoardInfo
	Dim Rs,Brs,i,Install,Temp,II,Po,BoardType
	%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" align="center">论坛版面</td>
	<td align="center">相应操作</td>
	</tr>
	<%
	Set Rs=YxBBs.execute("Select BoardID,BoardName,ParentID,Depth,Child,BoardType from [YX_board] order by Rootid,orders")
	If Rs.eof or Rs.Bof Then
		Call GoBack("","论坛没有分类！请先<a href=Board.Asp?Action=AddClass> 添加分类</a>")
		Exit Sub
	End If
	Brs=Rs.GetRows(-1)
	Rs.close
	For I=0 To Ubound(Brs,2)
	Temp="<td height=25>"
	Install="&nbsp;&nbsp;<a href='?Action=AddBoard&BoardID="&BRs(0,i)&"'>添加论坛</a>"
	If Brs(3,i)=0 Then'分类
		Temp="<tr bgcolor=#CCCCCC>"&Temp
		If Brs(4,i)>0 Then'如果有子论坛
			Temp=Temp&Brs(1,i)&" ("&Brs(4,i)&")"
		Else
			Temp=Temp&Brs(1,i)
		End If
		Install=Install & "&nbsp;|&nbsp;<a href='?Action=EditClass&BoardID="&Brs(0,i)&"'>分类改名</a>"
		If Brs(4,i)>0 Then
			Install=Install & "&nbsp;|&nbsp;<a href=javascript:alert('不能删除！该分类含有论坛!\n\n要删除本类，必须先把属下的论坛删除或移走。')>删除分类</a>"
		Else
			Install=Install & "&nbsp;|&nbsp;<a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href='?Action=DelClass&BoardID="&Brs(0,i)&"'>删除分类</a>"
		End If
	Else'版面
		Temp="<tr bgcolor=#DEDEDE>"&Temp
		Po=""
			For II=1 To Brs(3,i)
				Po=Po&" <font color=red>∣</Font> "
			Next
		If Brs(4,i)>0 Then'如果有子论坛
			Temp=Temp&Po&Brs(1,i)&" ("&Brs(4,i)&")"
		Else
			Temp=Temp&Po&Brs(1,i)
		End If
		Install=Install & " | <a href='?Action=EditBoard&BoardID="&Brs(0,i)&"'>修改</a> | <a href='BoardSetting.asp?BoardID="&Brs(0,i)&"'>权限设置</a>"
		If Brs(4,i)>0 Then
			Install=Install & " | <a href='javascript:' onclick=alert('不能删除！该版面含有子论坛!\n\n要删除本版，必须先把属下的子论坛删除或移走。')>删除</a>"
		Else
			Install=Install & " | <a onclick=checkclick('删除后将不能恢复！您确定要删除吗？') href='?Action=DelBoard&BoardID="&Brs(0,i)&"'>删除</a>"
		End If
		Install=Install & " | <a href='?Action=ClearData&BoardID="&BRs(0,i)&"'>清理</a> | <a href='?Action=OrdersBoard&BoardID="&BRs(0,i)&"'>置前</a>"
		If Brs(5,i) Then
			Install=Install & " | <a href='?Action=PassUser&BoardID="&BRs(0,i)&"'>认证用户</a>"
		End If
	End If
	Response.Write(Temp&"</td><td>"&Install&"</td></tr>")
Next
%>
<tr bgcolor="#DEDEDE"><td colspan="2">&nbsp;</td>
</tr></tbody></table>
<%
End Sub

Sub OrdersBoard
	Dim BoardID,ParentID,RootID,Orders,ParentStr,I,BoardNum,P_Rs,BoardName
	BoardID=YxBBs.BoardID
	Set Rs=YxBBs.execute("Select Orders,ParentID,ParentStr,BoardName From[Yx_Board] where BoardID="&YxBBs.BoardID)
	IF Rs.Eof or Rs.Bof Then
		Call GoBack("系统出错！","该版面不存在，可能已经删除了！")
		Exit Sub
	End If
	Orders=Rs(0)
	ParentID=Rs(1)
	ParentStr=Rs(2)
        
	Rs.Close
	'当版面为类时
	If ParentID=0 then Call GoBack("系统出错！","版面ID出错。"):Exit Sub
	'得到其下属版面数
	ParentStr=ParentStr & ","
	BoardNum=YxBBs.Execute("select count(*) from [Yx_Board] where ParentStr like '%"&ParentStr & BoardID&"%'")(0)
	If Isnull(BoardNum) Then BoardNum=1
	'获得父级信息
	Set P_rs=YxBBs.Execute("select * from [Yx_board] where Boardid="&ParentID)
	'在获得移动过来的版面数后更新排序在指定论坛之后的论坛排序数据
	YxBBs.Execute("update [Yx_Board] set orders=Orders + "&BoardNum&"+1  where RootID="&P_rs("RootID")&" And orders>"&P_rs("orders")&"")
	'更新当前版面数据
	YxBBs.Execute("update [Yx_Board] set orders="&P_Rs("orders")&"+1 Where BoardID="&BoardID)
	Dim TempParentStr
	i=1
	'更新下属，同时获得移动总数i
	'如果有则更新下属版面数据
	Set Rs=YxBBs.Execute("select * from [Yx_Board] where ParentStr like '%"&ParentStr & BoardID&"%' order by orders")
	Do while not rs.eof
	i=i+1
	If P_rs("parentstr")="0" Then'如果其父级为类，那么其下属的版面数据
		TempParentStr=P_rs("boardid") & "," & Replace(rs("parentstr"),ParentStr,"")
	Else
		TempParentStr=P_rs("parentstr") & "," & P_rs("boardID") & "," & replace(Rs("Parentstr"),ParentStr,"")
	End If
	YxBBs.Execute("update [Yx_Board] set orders="&P_rs("orders")&"+"&I&",ParentStr='"&TempParentStr&"' where BoardID="&Rs("BoardID"))
	Rs.movenext
	Loop
	Rs.Close
	P_Rs.Close
	Set P_Rs=Nothing
	UpdateBoardCache
	Call Suc("","成功的将该版面置前!","?")
	Response.End
End Sub


Sub AddClass
	Dim NewBoardID
	Set Rs=YxBBs.Execute("select Max(BoardID) from [YX_Board]")
	IF Rs.Eof or Rs.Bof Then
		NewBoardID=1
	Else
		NewBoardID=Rs(0)+1
	End If
	If Not isnumeric(NewBoardID) Then NewBoardID=1
	Rs.Close
	%><form method=POST style="margin:0" action="?Action=SaveClass">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr  bgcolor="#CCCCCC">
	    <td height="25" colspan="2" >添加分类</td>
	  </tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>分类名称：</b><br>
	  论坛的分类名称</td><td><input name="NewBoardID" type="hidden" value="<%=NewBoardID%>"><input type=text name="BoardName" size=30></td></tr>
  <tr bgcolor="#CCCCCC"><td colspan="2"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table></form>
	<%
End Sub

Sub SaveClass
	Dim BoardName,NewBoardID,MaxRootID
	BoardName=YxBBs.Fun.GetStr("BoardName")
	NewBoardID=YxBBs.Fun.GetStr("NewBoardID")
	IF BoardName="" Or Not isnumeric(NewBoardID) Then
		Call GoBack("",""):Exit Sub
	Else
		Set Rs=YxBBs.Execute("select BoardID from [YX_Board] where BoardID="&NewBoardID)
		If Not (rs.eof and rs.bof) then
			Call GoBack("错误提示","不能指定和别的论坛一样的序号！")
			Exit Sub
		End if
		Rs.Close
		Set Rs=YxBBs.Execute("Select Max(RootID) From YX_Board")
		MaxRootID=Rs(0)+1
		If isnull(MaxRootID) then MaxRootID=1
		Rs.Close
		YxBBs.execute("Insert into [YX_Board](BoardName,BoardID,BoardSetting,RootID,Depth,ParentID,Orders,Child,ParentStr)Values('"&BoardName&"',"&NewBoardID&",'0,0,30,30720,10,0,0,0,0,0,0',"&MaxRootID&",0,0,0,0,'0')")
		UpdateBoardCache
		Call Suc("","成功的添加了论坛分类 <b>"&BoardName&"</b> !","?")
	End If
End Sub

Sub EditClass
	Dim BoardID
	Set Rs=YxBBs.Execute("Select BoardName from[YX_Board] where BoardID="&YxBBs.BoardID&"")
	If Rs.Eof Then
		Call GoBack("系统出错","论坛找不到这个分类，可能已经删除了。"):Exit Sub
	End If
	%><form method=POST style="margin:0" action="?Action=SaveEditClass">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" >修改分类 </td>
	  </tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>分类名称：</b><br>
	  修改论坛分类的名称</td><td><input name="BoardID" type="hidden" value="<%=YxBBs.BoardID%>"><input type=text name="BoardName" value="<%=Rs(0)%>" size=30></td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="2"  align="center"><input type="submit" value=" 修 改 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table></form>
	<%Rs.Close
End Sub

Sub SaveEditClass
	Dim BoardName,BoardID
	BoardName=YxBBs.Fun.GetStr("BoardName")
	BoardID=YxBBs.Fun.GetStr("BoardID")
	IF BoardName="" Or Not isnumeric(BoardID) Then
		Call GoBack("",""):Exit Sub
	Else
		If YxBBs.Execute("select BoardID from [YX_Board] where BoardID="&BoardID).eof then
			Call GoBack("系统出错","论坛找不到这个分类，可能已经删除了。"):Exit Sub
		End if
		YxBBs.execute("Update [YX_Board] Set BoardName='"&BoardName&"' where BoardID="&BoardID)
		UpdateBoardCache
		Call Suc("","成功的把论坛分类名称改为 <b>"&BoardName&"</b> !","?")
	End If
End Sub

Sub DelClass
	IF  YxBBs.Execute("Select Count(BoardID) From[YX_Board] where ParentID="&YxBBs.BoardID)(0)=0 Then
		YxBBs.Execute("Delete From[YX_Board] where ParentID=0 And BoardID="&YxBBs.BoardID)
		Call Suc("","成功的删除了分类!","?")
	End If
End Sub

Sub AddBoard
	If YxBBs.Execute("Select BoardID from [YX_Board] where Depth=0").Eof Then
		Call GoBack("","没有分类不能添加论坛！请先<a href=Board.Asp?Action=AddClass> ·添加分类</a>")
		Exit Sub
	End if%>
	<form method=POST style="margin:0" action="?Action=SaveBoard">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr  bgcolor="#CCCCCC">
	    <td height="25" colspan="2" >论坛添加</td>
	  </tr>
	<tr bgcolor="#DEDEDE"><td width="35%" height="40"><b>论坛名称：</b><br>
	  论坛版面的名称</td><td width="65%"><input type=text name="BoardName" size=30>*</td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>标志图片：</b><br>
	  论坛版面Logo地址，可以不填</td><td><input type=text name="BoardImg" size=30></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>论坛版主：</b><br>
	  添加多版主请用|分隔，如：Name|Name</td><td><input type=text name="BoardAdmin" size=30></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>论坛介绍：</b><br>
	  论坛版面描述</td><td><textarea rows="3" name="Introduce"></textarea>*</td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>属于分类或论坛：</b><br>
	  选择要属于那个分类或那个论坛</td><td><select size="1" name="ParentID"><%=YxBBs.BoardIDList(YxBBs.BoardID,20)%></select>*</td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>限制用户等级：</b><br>
	  指定等级以上用户才可进入论坛</td><td>
	<select size="1" name="BoardGrade">
	<option value="0" selected>0级：游客</option>
	<%
	Dim UG
	set UG=Conn.execute("Select GradeNum,GradeName from YX_UserGrade order by GradeNum asc")
	while not UG.Eof
		Response.Write "<option value="&UG(0)&">"&UG(0)&"级："&UG(1)&"</option>"
	UG.MoveNext
	wend
	set UG=nothing
	%>
	</select>*</td></tr>
	<tr><td bgcolor=#d7d7d7><b>是否认证版面：</b><br>
	  认证版只有版主和人证会员</td><td bgcolor=#d7d7d7><input type="radio" value="1" name="BoardType">是&nbsp; <input name="BoardType" type="radio" value="0" checked>
	  否</td></tr>
	<tr><td bgcolor=#d7d7d7><b>锁定版面：</b><br>
	  锁定之后不可以发布帖子</td><td bgcolor=#d7d7d7><input type="radio" value="1" name="BoardLock">是&nbsp; <input name="BoardLock" type="radio" value="0" checked>
	  否</td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="2"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
	<%
End Sub

Sub SaveBoard
	Dim BoardName,Introduce,BoardAdmin,BoardImg,BoardGrade,BoardLock,BoardType,ParentID,NewBoardID,RootID,Depth,Child,Orders,ParentStr,I
	BoardName=YxBBs.Fun.GetStr("BoardName")
	Introduce=YxBBs.Fun.GetStr("Introduce")
	BoardAdmin=YxBBs.Fun.GetStr("BoardAdmin")
	BoardGrade=YxBBs.Fun.GetStr("BoardGrade")
	BoardLock=YxBBs.Fun.GetStr("BoardLock")
	BoardType=YxBBs.Fun.GetStr("BoardType")
	BoardImg=YxBBs.Fun.GetStr("BoardImg")
	ParentID=YxBBs.Fun.GetStr("ParentID")
	If Not isnumeric(ParentID) or BoardName="" Or Introduce="" Then
		Call GoBack("",""):Exit Sub
	End If
	Set Rs=YxBBs.Execute("select Max(BoardID) from [YX_Board]")
	IF Rs.Eof or Rs.Bof Then
		Call GoBack("","没有分类不能添加论坛！请先<a href=Board.Asp?Action=AddClass> ·添加分类</a>")
		Exit Sub
	Else
		NewBoardID=Rs(0)+1
	End If
	Rs.Close
	Set Rs=YxBBs.execute("Select RootID,Depth,Child,Orders,ParentStr,ParentID From[YX_Board] where BoardID="&ParentID&"")
	IF Rs.Eof or Rs.Bof Then
		Call GoBack("系统程式出错！","没有指定父类或父论坛！")
		Exit Sub
	End If
	RootID=Rs(0)
	Depth=Rs(1)
	Child=Rs(2)
	Orders=Rs(3)
	ParentStr=Rs(4)
	Rs.Close
	If Depth+1>MaxDepth Then
		Call GoBack("","考滤到论坛的实用易用，本论坛限制了最多只能有" & MaxDepth & "级论坛!")
		Exit Sub
	End If
	If ParentStr=0 Then
		ParentStr=ParentID
	Else
		ParentStr=ParentStr & "," & ParentID
	End If
	YxBBs.execute("Insert into [YX_Board](BoardID,BoardName,Introduce,BoardAdmin,BoardImg,BoardSetting,BoardLock,BoardType,RootID,Depth,ParentID,ParentStr,Orders,Child)Values("&NewBoardID&",'"&BoardName&"','"&Introduce&"','"&BoardAdmin&"','"&BoardImg&"','0,gif|jpg|swf|zip|rar|bmp,30,30720,10,0,0,0,0,0,0',"&BoardLock&","&BoardType&","&RootID&","&Depth+1&","&ParentID&",'"&ParentStr&"',"&Orders+1&",0)")
	If BoardAdmin <> "" Then Call addmaster(BoardAdmin,"none",0)
	If ParentID<>0 then
		If Depth>0 then
			'当上级分类深度大于0的时候要更新其父类（或父类的父类）的版面数和相关排序
			For i=1 to Depth
				'更新其父类版面数
				YxBBs.Execute("update [YX_Board] set Child=Child+1 where BoardID="&parentID)
				'得到其父类的父类的版面ID
				Set rs=YxBBs.Execute("select ParentID from [YX_Board] where BoardID="&parentID)
				If not (rs.eof and rs.bof) then
					ParentID=rs(0)
				End if
				Rs.Close
				'当循环次数大于1并且运行到最后一次循环的时候直接进行更新
				If i=depth then
				YxBBs.Execute("update [YX_Board] set Child=Child+1 where BoardID="&parentID)
				End if
			next
			'更新该版面排序以及大于本需要和同在本分类下的版面排序序号
			YxBBs.Execute("update [YX_Board] set Orders=orders+1 where RootID="&RootID&" And orders>"&orders)
			YxBBs.Execute("update [YX_Board] set Orders="&Orders&"+1 where BoardID="&NewBoardID&"")
		Else
			'当上级分类深度为0的时候只要更新上级分类版面数
			YxBBs.Execute("update [YX_Board] set child=child+1 where Boardid="&ParentID)
			Set rs=YxBBs.Execute("select max(Orders) from [YX_Board]")
			YxBBs.Execute("update [YX_Board] set Orders="&rs(0)&"+1 where BoardID="&NewBoardID )
			Rs.Close
		End if
	End if
	Call Suc("","成功的添加了论坛 <b>"&BoardName&"</b> !","Board.Asp")	
	updateBoardCache
End Sub

Sub EditBoard
	Dim BoardName,BoardLock,BoardType,Introduce,BoardImg,ParentID,BoardAdmin,BoardGrade
	Set Rs=YxBBs.execute("Select ParentID,BoardName,BoardAdmin,BoardGrade,BoardLock,BoardType,Introduce,BoardImg From[YX_Board] Where BoardID="&YxBBs.BoardID&"")
	If Rs.eof Then
		Call GoBack("","该版面不存在，可能已经删除了")
		Exit Sub
	Else
		ParentID=Rs(0)
		BoardName=Rs(1)
		BoardAdmin=Rs(2)
		BoardGrade=Rs(3)
		BoardLock=Rs(4)
		BoardType=Rs(5)
		Introduce=Rs(6)
		BoardImg=Rs(7)
	End IF
	Rs.Close%><form method=POST style="margin:0" action="?Action=SaveEditBoard">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr bgcolor="#CCCCCC">
	    <td height="25" colspan="2" >编辑论坛</td>
	  </tr>
	<tr bgcolor="#DEDEDE"><td width="35%" height="40"><b>论坛名称：</b><br>
	  论坛版面的名称</td><td height="65%"><input name="BoardID" value="<%=YxBBs.BoardID%>" type="hidden"><input name="boardname" type=text value="<%=BoardName%>" size=30></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>标志图片：</b><br>
	  论坛版面Logo地址，可以不填</td><td><input type=text name="BoardImg" value="<%=BoardImg%>" size=30></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>论坛介绍：</b><br>
	  论坛版面描述</td><td><textarea rows="3" name="Introduce"><%=Introduce%></textarea></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>论坛版主：</b><br>
	  添加多版主请用@@分隔，如：Name@@Name</td><td><input type=text name="BoardAdmin" size=30 value="<%=BoardAdmin%>"><input type="hidden" name="OldBoardAdmin" size=30 value="<%=BoardAdmin%>"></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>属于分类或论坛：</b><br>
	  选择要属于那个分类或那个论坛</td><td><select size="1" name="ParentID"><%=YxBBs.BoardIDList(ParentID,20)%></select></td></tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>限制用户等级：</b><br>
	  指定等级以上用户才可进入论坛</td><td>
	<select size="1" name="BoardGrade">
	<option value="0" selected>0级：游客</option>
	<%
	Dim UG
	set UG=Conn.execute("Select GradeNum,GradeName from YX_UserGrade order by GradeNum asc")
	while not UG.Eof
		If UG(0)=BoardGrade Then
			Response.Write "<option value="&UG(0)&" selected>"&UG(0)&"级："&UG(1)&"</option>"
		Else
			Response.Write "<option value="&UG(0)&">"&UG(0)&"级："&UG(1)&"</option>"
		End If
	UG.MoveNext
	wend
	set UG=nothing
	%>
	</select>*</td></tr>
	<tr><td bgcolor=#d7d7d7><b>是否认证版面：</b><br>
	  认证版只有版主和人证会员</td><td bgcolor=#d7d7d7><input type="radio" value="1" name="BoardType" <%if BoardType=1 then response.write "Checked"%>>是&nbsp; <input type="radio" value="0" name="BoardType" <%if BoardType=0 then response.write "Checked"%>>否</td></tr>
	<tr><td bgcolor=#d7d7d7><b>锁定版面：</b><br>
	  锁定之后不可以发布帖子</td><td bgcolor=#d7d7d7><input type="radio" value="1" name="BoardLock" <%if BoardLock=1 then response.write "Checked"%>>是&nbsp; <input type="radio" value="0" name="BoardLock" <%if BoardLock=0 then response.write "Checked"%>>否</td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="2"  align="center"><input type="submit" value=" 提 交 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table>
	</form>
	<%
End Sub

Sub SaveEditBoard
	Dim BoardID,BoardName,Introduce,BoardAdmin,OldBoardAdmin,BoardGrade,BoardLock,BoardType,BoardImg,ParentID,RootID,Depth,Child,Orders,ParentStr,I
	Dim NewParentID,BoardNum,P_Rs
	BoardID=YxBBs.Fun.GetStr("BoardID")
	BoardName=YxBBs.Fun.GetStr("BoardName")
	Introduce=YxBBs.Fun.GetStr("Introduce")
	BoardAdmin=YxBBs.Fun.GetStr("BoardAdmin")
	BoardGrade=YxBBs.Fun.GetStr("BoardGrade")
	OldBoardAdmin=YxBBs.Fun.GetStr("OldBoardAdmin")
	BoardLock=YxBBs.Fun.GetStr("BoardLock")
	BoardType=YxBBs.Fun.GetStr("BoardType")
	BoardImg=YxBBs.Fun.GetStr("BoardImg")
	NewParentID=YxBBs.Fun.GetStr("ParentID")
	If Not isnumeric(NewParentID) or BoardName="" Or Introduce="" Then
		Call GoBack("",""):Exit Sub
	ElseIF BoardID=NewParentID Then
		Call GoBack("","所属论坛不能指定自己！"):Exit Sub
	End If
	Set Rs=YxBBs.execute("Select RootID,Depth,Child,Orders,ParentID,ParentStr From[YX_Board] where BoardID="&BoardID)
	IF Rs.Eof or Rs.Bof Then
		Call GoBack("系统出错！","该版面不存在，可能已经删除了！")
		Exit Sub
	End If
	RootID=Rs(0)
	Depth=Rs(1)
	Child=Rs(2)
	Orders=Rs(3)
	ParentID=Rs(4)
	ParentStr=Rs(5)
	Rs.Close
	If ParentID=0 then
		Call GoBack("系统出错！","分类不能设置"):Exit Sub
	ElseIf Int(NewParentID)<>Int(ParentID) Then
		'判断所指定的论坛是否其下属论坛
		Set Rs=YxBBs.Execute("select BoardID from [YX_board] where ParentStr like '%"&ParentStr&","&BoardID&"%' and BoardID="&NewParentID)
		if not (Rs.eof and Rs.bof) then
			Call GoBack("","您不能指定该版面的下属子论坛作为所属论坛")
			Exit sub
		End if
		Rs.Close
		'获得新选的父级
		Set P_rs=YxBBs.Execute("select * from [YX_board] where Boardid="&NewParentID)
			If P_rs("Depth")+1> MaxDepth Or (Child>0 And P_Rs("Depth")+2>MaxDepth) Then
			P_rs.Close:Set P_rs=Nothing
			Call GoBack("","本论坛限制了最多只能有" & MaxDepth & "级论坛.")
			Exit Sub
		End If
	End if
	YxBBs.Execute("Update [YX_Board] Set BoardName='"&BoardName&"',Introduce='"&Introduce&"',BoardAdmin='"&BoardAdmin&"',BoardGrade="&BoardGrade&",BoardLock="&BoardLock&",BoardType="&BoardType&",BoardImg='"&BoardImg&"' where BoardID="&BoardID&"")
	If BoardAdmin <> OldBoardAdmin Then Call addmaster(BoardAdmin,OldBoardAdmin,1)
	If Int(NewParentID)<>Int(ParentID) Then
	'将一个分论坛移动到其他分论坛下
	'获得所指定的论坛的相关信息
	'得到其下属版面数
	ParentStr=ParentStr & ","
	BoardNum=YxBBs.Execute("select count(*) from [YX_Board] where ParentStr like '%"&ParentStr & BoardID&"%'")(0)
	If Isnull(BoardNum) Then BoardNum=1
	'在获得移动过来的版面数后更新排序在指定论坛之后的论坛排序数据
	YxBBs.Execute("update [YX_Board] set orders=Orders + "&BoardNum&"+1  where RootID="&P_rs("RootID")&" And orders>"&P_rs("orders")&"")
	'更新当前版面数据
	If P_rs("parentstr")="0" Then
		YxBBs.Execute("update [YX_Board] set Depth="&P_Rs("Depth")&"+1,orders="&P_Rs("orders")&"+1,rootid="&P_rs("Rootid")&",ParentID="&NewParentID&",ParentStr='" & P_Rs("BoardID") & "' Where BoardID="&BoardID)
	Else
		YxBBs.Execute("update [YX_Board] set Depth="&P_Rs("Depth")&"+1,orders="&P_Rs("orders")&"+1,rootid="&P_rs("Rootid")&",ParentID="&NewParentID&",ParentStr='" & P_Rs("ParentStr") & ","& P_Rs("BoardID") &"' Where BoardID="&BoardID)
	End If
	Dim TempParentStr
	i=1
	'更新下属，同时获得移动总数i
	'如果有则更新下属版面数据
	'深度为原有深度加上当前所属论坛的深度
	Set Rs=YxBBs.Execute("select * from [YX_Board] where ParentStr like '%"&ParentStr & BoardID&"%' order by orders")
	Do while not rs.eof
	i=i+1
	If P_rs("parentstr")="0" Then'如果其父级为类，那么其下属的版面数据
		TempParentStr=P_rs("boardid") & "," & Replace(rs("parentstr"),ParentStr,"")
	Else
		TempParentStr=P_rs("parentstr") & "," & P_rs("boardID") & "," & replace(Rs("Parentstr"),ParentStr,"")
	End If
	YxBBs.Execute("update [YX_Board] set depth=depth+"&P_rs("depth")&"-"&depth&"+1,orders="&P_rs("orders")&"+"&I&",Rootid="&P_rs("Rootid")&",ParentStr='"&TempParentStr&"' where BoardID="&Rs("BoardID"))
	Rs.movenext
	Loop
	Rs.Close
	Dim TempParentID,II
	TempParentID=NewParentID
	If RootID=P_rs("RootID") then'在同一分类下移动
		'更新所指向的上级论坛版面数，i为本次移动过来的版面数
		'更新其父类版面数
		YxBBs.Execute("update [YX_Board] set Child=child+"&i&" where (not ParentID=0) and BoardID="&TempParentID)
		For II=1 to P_Rs("depth")
			'得到其父类的父类的版面ID
			Set Rs=YxBBs.Execute("Select ParentID from [YX_Board] where (not ParentID=0) and BoardID="&TempParentID)
			If Not (rs.eof and rs.bof) then
				TempParentid=Rs(0)
				'更新其父类的父类版面数
			YxBBs.Execute("update [YX_Board] set Child=child+"&i&" where (not ParentID=0) and BoardID="&TempParentID)
			''''YxBBs.Execute("update [YX_Board] set Child=child+"&i&" where (not ParentID=0) and boardid in　（）)
			End if
		Next
		'更新其原父类版面数
		YxBBs.Execute("update [YX_Board] set Child=child-"&i&" where (not ParentID=0) and BoardID="&ParentID)
		'更新其原来所属论坛数据
		For II=1 to Depth
			'得到其原父类的父类的版面ID
			Set rs=YxBBs.Execute("select ParentID from [YX_Board] where (not ParentID=0) and BoardID="&ParentID)
			if not (rs.eof and rs.bof) then
				ParentID=rs(0)
				'更新其原父类的父类版面数
				YxBBs.Execute("update [YX_Board] set child=child-"&i&" where (not ParentID=0) and  boardid="&ParentID)
			End IF
		Next
	Else
	'更新所指向的上级论坛版面数，i为本次移动过来的版面数
	'更新其父类版面数
		YxBBs.Execute("update [YX_Board] set Child=child+"&i&" where BoardID="&TempParentID)
		For II=1 to P_Rs("depth")
			'得到其父类的父类的版面ID
			Set Rs=YxBBs.Execute("Select ParentID from [YX_Board] where BoardID="&TempParentID)
			If Not (rs.eof and rs.bof) then
				TempParentid=Rs(0)
				'更新其父类的父类版面数
			YxBBs.Execute("update [YX_Board] set Child=child+"&i&" where  BoardID="&TempParentID)
			End if
		Next
	'更新其原父类版面数
	YxBBs.Execute("update [YX_Board] set Child=child-"&i&" where BoardID="&ParentID)
	'更新其原父类的其它版面排序
	YxBBs.Execute("Update [YX_Board] Set Orders=Orders-"&i&" where RootID="&RootID&" and Orders>"&Orders)
	'更新其原来所属论坛数据
		For II=1 to Depth
			'得到其原父类的父类的版面ID
			Set rs=YxBBs.Execute("select ParentID from [YX_Board] where BoardID="&ParentID)
			if not (rs.eof and rs.bof) then
				ParentID=rs(0)
				'更新其原父类的父类版面数
				YxBBs.Execute("update [YX_Board] set child=child-"&i&" where boardid="&ParentID)
			End IF
		Next
	End if
	P_rs.Close:Set P_rs=Nothing
  End If
	Call Suc("","论坛修改成功 !","Board.Asp")	
	UpdateBoardCache
End Sub

Sub DelBoard
	Dim AllTable,I,II,Depth,ParentID,RootID,Orders
	Set Rs=YxBBs.Execute("Select Depth,ParentID,RootID,Orders,Child From[YX_Board] where BoardID="&YxBBs.BoardID)
	If Rs.Eof Then 
		Call Goback("系统出错","不存在，论坛可能已经删除了 !")
		Exit Sub
	ElseIf Rs(4)>0 Then
		Call Goback("系统出错","该论坛含有属下论坛，不能删除 !")
		Exit sub
	Else
		Depth=Rs(0)
		ParentID=Rs(1)
		RootID=Rs(2)
		Orders=Rs(3)
	End If
	Rs.Close
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		YxBBs.Execute("Delete from [YX_Bbs"&AllTable(i)&"] where BoardID="&YxBBs.BoardID&"")
	Next

	Set Rs=YxBBs.Execute("Select TopicID From[YX_Topic] where BoardID="&YxBBs.BoardID&" And IsVote ")
	Do While Not Rs.Eof
		YxBBs.Execute("Delete from [YX_TopicVote] where TopicID="&Rs(0))
		YxBBs.Execute("Delete from [YX_TopicVoteUser] where TopicID="&Rs(0))
	Rs.MoveNext
	Loop
	Rs.Close
	'删除主题记录
	YxBBs.Execute("Delete From[YX_Topic] where BoardID="&YxBBs.BoardID)
	YxBBs.Execute("Delete From[YX_Board] where BoardID="&YxBBs.BoardID)
	'更新其父类的版面数
	YxBBs.Execute("update [YX_Board] set Child=child-1 where BoardID="&ParentID)
	'更新其父类的其它版面排序
	YxBBs.Execute("Update [YX_Board] Set Orders=Orders-1 where RootID="&RootID&" and Orders>"&Orders)
	'更新其所属论坛数据
		For II=1 to Depth
			'得到其父类的父类的版面ID
			Set rs=YxBBs.Execute("select ParentID from [YX_Board] where BoardID="&ParentID)
			if not (rs.eof and rs.bof) then
				ParentID=rs(0)
				'更新其父类的父类版面数
				YxBBs.Execute("update [YX_Board] set child=child-1 where boardid="&ParentID)
			End IF
			Rs.Close
		Next
	Call Suc("","成功的删除论坛版面 (包括该论坛的所有帖子)!","Board.Asp")	
	UpdateBoardCache
End Sub

Sub ClassOrders
	Dim BoardID
	Set Rs=YxBBs.Execute("Select BoardID,BoardName,RootID from[YX_Board] where Depth=0 order by RootID")
	If Rs.Eof Then
		Call GoBack("","论坛没有分类！请先<a href=?Action=AddClass> 添加分类</a>")
		Exit Sub
	End If
	%><form method=POST style="margin:0" action="?Action=SaveClassOrders">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr  bgcolor="#4D65A4">
	    <td height="25" colspan="2" bgcolor="#CCCCCC" >分类排序</td>
	  </tr>
	<tr><td height="25" colspan="2" align="center" bgcolor="#DEDEDE">排序方式按从小到大排序，请用数字填写，排序数字不能相同。</td>
	</tr>
	<%
	Do while not rs.eof
	Response.Write"<tr><td height='25'>&nbsp;"&Rs(1)&"</td><td><input name='BoardID' type='hidden' value='"&Rs(0)&"'><input name='RootID' type='hidden' value='"&Rs(2)&"'><input type=text name='NewRootID' value='"&Rs(2)&"' size=4 ></td></tr>"
	Rs.MoveNext
	Loop
	%>
	<tr bgcolor="#4D65A4"><td colspan="2"  align="center" bgcolor="#CCCCCC"><input type="submit" value=" 修 改 ">&nbsp;&nbsp;<input type="reset" value=" 重 置 "></td></tr></table></form>
	<%Rs.Close
End Sub

Sub SaveClassOrders
	Dim BoardID,RootID,NewRootID,Temp,I
	Temp=","
	For i=1 to Request.form("BoardID").count
		BoardID = Request.form("BoardID")(i)
		RootID = Request.form("RootID")(i)
		NewRootID = Request.form("NewRootID")(i)
		If InStr(Temp,","&NewRootID&",")>0 Then 
			Call GoBack("排序错误","各分类排序的数字不能一样!")
			Exit Sub
		End If
		Temp=Temp&NewRootID&","
		IF Not IsNumeric(BoardID) or Not isnumeric(NewRootID) Then
			Call GoBack("排序错误","请用数字填写!")
			Exit Sub
		End IF
	Next
	For i=1 to Request.form("BoardID").count
		BoardID = Request.form("BoardID")(i)
		RootID = Request.form("RootID")(i)
		NewRootID = Request.form("NewRootID")(i)
		If RootID<>NewRootID Then
			YxBBs.Execute("Update [YX_Board]Set RootID="&NewRootID&" where BoardID="&BoardID)
			Temp=BoardID
			YxBBs.Execute("Update [YX_Board] Set RootID="&NewRootID&" where ParentStr like '%"&Temp&"%' And RootID="&RootID&"")
		End If
	Next
	Call Suc("","排序成功！","?")	
	UpdateBoardCache
End Sub

Sub Addmaster(s,o,n)
	Dim Arr,Oarr,i,Sql
	Dim GradeNum,GradeName,Gradepic
	'Set Rs = YxBBs.Execute("SELECT GradeName,GradePic FROM YX_UserGrade WHERE ClassID = 3 ORDER BY UserMinPostNum DESC")
	Set Rs=Conn.Execute("Select GradeNum,GradeName,GradePic FROM YX_UserGrade WHERE ClassID = 3 ORDER BY UserMinPostNum DESC")
	If Not (Rs.Eof And Rs.Bof) Then
		GradeNum = Rs(0)
		GradeName = Rs(1)
		Gradepic = Rs(2)
	End If
	Randomize
	Arr = Split(s,"@@")
	Oarr = Split(o,"@@")
	Set Rs = Server.Createobject("Adodb.Recordset")
	For i = 0 To Ubound(Arr)
		Sql = "SELECT * FROM [YX_User] WHERE Name = '" & Arr(i) & "'"
		Rs.Open Sql,Conn,1,3
		If Rs.Eof And Rs.Bof Then
			Call GoBack("",Arr(i) &"这个用户还没有注册!")
		Else
			If Rs("ClassID") = 5 Then
				Rs("GradeNum") = GradeNum
				Rs("GradeName") = GradeName
				Rs("Gradepic") = Gradepic
				Rs("ClassID") = 3
				Rs.Update
			End If
		End If
		Rs.Close
	Next
	'判断原版主在其他版面是否还担任版主，如没有担任则撤换该用户职位。
	If n = 1 Then
		Dim Iboardmaster
		Dim UserGrade, Article
		Iboardmaster = False
		For i = 0 To Ubound(Oarr)
			Set Rs = YxBBs.Execute("SELECT BoardAdmin FROM YX_Board")
			Do While Not Rs.Eof
				If InStr("|" & Trim(Rs(0)) & "|","|" & Trim(Oarr(i)) & "|") > 0 Then
					Iboardmaster = True
					Exit Do
				End If
				Rs.Movenext
			Loop
			If Not Iboardmaster Then
				Set Rs = YxBBs.Execute("SELECT ID,ClassID,EssayNum FROM [YX_User] WHERE Name='" & Trim(Oarr(i)) & "' Or ClassID=3")
				If Not (Rs.Eof And Rs.Bof) Then
					'If Rs(1) > 2 Then
						If Not Isnumeric(Rs(2)) Or Rs(2) = "" Then
							Article = 0
						Else
							Article = Cstr(Rs(2))
						End If
						'取对应注册会员的等级
						Set UserGrade = YxBBs.Execute("SELECT TOP 1 GradeNum,GradeName,GradePic FROM YX_UserGrade WHERE UserMinPostNum <= " & Article & " AND NOT UserMinPostNum = -1 AND ClassID = 5 ORDER BY UserMinPostNum DESC")
						If Not (UserGrade.Eof And UserGrade.Bof) Then
							YxBBs.Execute("UPDATE [YX_User] Set GradeNum="&UserGrade(0)&",GradePic='"&UserGrade(2)&"',GradeName='"&UserGrade(1)&"',ClassID=5 WHERE ID="&Rs(0))
						End If
						UserGrade.Close:Set UserGrade = Nothing
					'End If
				End If
			End If
			Iboardmaster = False
		Next
	End If
	Set Rs = Nothing
End Sub

Sub BoardUnite
	%><form method=POST style="margin:0" action="?Action=SaveBoardUnite">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#4D65A4"><td height="25" bgcolor="#CCCCCC">论坛合并</td>
	</tr>
	<tr><td height="40" bgcolor="#DEDEDE">将论坛： 
	  <select size="1" name="BoardID"><option value='0'>请选择原论坛</option><%=YxBBs.BoardIDList(0,0)%></select> 合并到论坛： <select size="1" name="NewBoardID"><option value='0'>请选择目标论坛</option><%=YxBBs.BoardIDList(0,0)%></select> 中 <input type="submit" onclick=checkclick('操作后将不能恢复！您确定要合并吗？') value=" 论坛合并 "></td></tr>
	<tr bgcolor="#E8F4EF"><td height="40" bgcolor="#CCCCCC" ><b>注意事项：</b><font color=red>此操作不可恢复，请慎重操作！</font><br>
	分类不能操作，不能和其属下的论坛合并。<br>
	合并后原论坛(包括属下论坛)将被删除，所有帖子(包括属下论坛的帖子)将转移到指定的目标论坛中 </td></tr></table></form>
	<%
End Sub

Sub SaveBoardUnite
	Dim BoardID,NewBoardID,TempParentStr,TempParentID,Rs1
	Dim I,AllTable
	Dim ParentStr,Depth,ParentID,Child,RootID
	BoardID=YxBBs.Fun.Getstr("BoardID")
	NewBoardID=YxBBs.Fun.Getstr("NewBoardID")
	IF BoardID="" Or NewBoardID="" Then
		Call GoBack("","请先指定论坛后再进行合并！")
		Exit Sub
	ElseIf BoardID=NewBoardID Then
		Call Goback("","同一个论坛不用合并了！")
		Exit sub
	End If

	Set Rs=YxBBs.Execute("Select ParentStr,BoardID,Depth,ParentID,Child,RootID from YX_board where BoardID="&BoardID)
	If Rs(2)="0" then
		Call Goback("系统错误","分类不能做合并操作！")
		Exit Sub
	End If
	ParentStr=Rs(0) & "," & Rs(1)
	ParentID=Rs(3)
	TempParentStr=rs(1)
	DepTh=rs(2)
	Child=rs(4)+1
	RootID=rs(5)
	Rs.Close
	TempParentID=ParentID
	'判断是否合并到下属论坛
	Set Rs=YxBBs.Execute("Select BoardID From [YX_Board] where BoardID="&NewBoardID&" And ParentStr like '%"&ParentStr&"%'")
	If Not (rs.eof and rs.bof) then
		Call Goback("","不能将论坛合并到其下属论坛中!")
		Exit Sub
	End if
	Rs.Close
	'得到全部下属论坛ID
	i=0
	Set Rs=YxBBs.Execute("Select BoardID from [YX_Board] where RootID="&RootID&" And ParentStr like '%"&ParentStr&"%'")
	do while not rs.eof
		If i=0 then
			TempParentStr=Rs(0)
		Else
			TempParentStr=TempParentStr & "," & Rs(0)
		End if
		i=i+1
		Rs.movenext
	loop
	If i>0 then
		ParentStr=TempParentStr & "," & BoardID
	Else
		ParentStr=BoardID
	End if
	'更新其原来所属论坛版面数
	YxBBs.Execute("update [YX_Board] set Child=Child-"&child&" where BoardID="&TempParentID)
	'更新其原来所属论坛数据，排序相当于剪枝而不需考虑
	For I=1 to Depth
		'得到其父类的父类的版面ID
		Set rs=YxBBs.Execute("select ParentID from [YX_Board] where boardID="&TempParentID)
		If Not (rs.eof and rs.bof) then
			TempParentID=rs(0)
			YxBBs.Execute("update [YX_Board] set Child=Child-"&Child&" where boardid="&TempParentID)
		End if
	Next
	'更新论坛帖子数据
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
		YxBBs.Execute("update [YX_BBS"&AllTable(i)&"] set BoardID="&NewBoardID&" where BoardID in ("&ParentStr&")")
	Next
	YxBBs.Execute("update [YX_Topic] set BoardID="&NewBoardID&" where BoardID in ("&ParentStr&")")
	'删除被合并论坛
	Set Rs=YxBBs.Execute("Select Sum(EssayNum),sum(TopicNum),sum(TodayNum) from [YX_Board] where RootID="&RootID&" And BoardID in ("&ParentStr&")")
	YxBBs.Execute("Delete from [YX_Board] where RootID="&RootID&" And BoardID in ("&ParentStr&")")
	'更新新论坛帖子计数
	YxBBs.Execute("update [YX_Board] set EssayNum=EssayNum+"&rs(0)&",TopicNum=TopicNum+"&rs(1)&",TodayNum=TodayNum+"&rs(2)&" where BoardID ="&NewBoardID&"")
	'更新上级版块
	set Rs1=YxBBs.Execute("select Depth,ParentStr,Boardid from [YX_Board] where BoardID="&NewBoardID)
	If Rs1(0)>1 Then
	ParentStr=Rs1(0)
	YxBBs.Execute("update [YX_Board] set EssayNum=EssayNum+"&rs(0)&",TopicNum=TopicNum+"&rs(1)&",TodayNum=TodayNum+"&rs(2)&" where boardid in ("&ParentStr&")")
	End If
	Rs1.Close:Set Rs1=Nothing
	Rs.Close
	Call Suc("","合并成功！已经将原论坛（包括属下）的所有帖子合并到目标论坛。","?")
	UpdateBoardCache
End Sub

Sub ClearData
	Set Rs=YxBBs.execute("Select BoardName,TopicNum,EssayNum From[YX_Board] where BoardID="&YxBBs.BoardID&"")
	IF Rs.Eof Then
		Call GoBack("","论坛版面不存在，可能经被删除了")
		Exit Sub
	End If%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2"><%=Rs("BoardName")%> 数据清理</td>
	</tr>
	<tr bgcolor="#DEDEDE"><td height="40"><b>帖子信息</b><br>
	  版面主题数：<%=Rs("TopicNum")%><br>版面总帖数：<%=Rs("EssayNum")%><br>精华主题数：<%=YxBBs.Execute("Select Count(TopicID) From[YX_Topic] where IsGood and BoardID="&YxBBs.BoardID&"")(0)%><br></td><td><b>注意事项</b><br>
	    <font color=red>此操作不可恢复！精华帖子不会被删除！</Font><br>如果您的论坛数据众多，执行此操作将消耗大量的服务器资源。<br>执行过程请耐心等候，最好选择夜间在线人少的时候更新。</td></tr>
<tr bgcolor="#CCCCCC"><td height="40" colspan="2" ><form method=POST style="margin:0" action="?Action=StartClearData">清除 <b><%=Rs(0)%></b> 在 <input name="BoardID" value="<%=YxBBs.BoardID%>" type="hidden"><select name="SqlTableID"><option value="0">所有数据表</option><%=SqlTableList%></select> 中 <input type=text name="ClearDate" value="365" size=5> 天前的帖子。 <input type="submit" value=" 执行清理 ">
</form></td></tr></tbody></table>
	<%Rs.Close
End Sub

Sub StartClearData
	Dim SqlTableID,ClearDate,BoardID,AllTable,i
	SqlTableID=YxBBs.Fun.GetStr("SqlTableID")
	ClearDate=YxBBs.Fun.GetStr("ClearDate")
	BoardID=YxBBs.Fun.GetStr("BoardID")
	If Not isnumeric(ClearDate) or Not isNumeric(SqlTableID) or Not isNumeric(BoardID)  Then
		Call GoBack("","请用数字填写！")
		Exit Sub
	End If	
	IF Int(SqlTableID)=0 Then
		AllTable=Split(YxBBs.BBSTable(0),",")
	Else
		AllTable=Split(SqlTableID,",")
	End if
	For i=0 to uBound(AllTable)
		Set Rs=YxBBs.Execute("Select TopicID,isVote From[YX_Topic] where BoardID="&BoardID&" And IsGood=False And  DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&ClearDate&" ")
		Do While Not Rs.Eof
		YxBBs.Execute("Delete from [YX_Bbs"&AllTable(i)&"] where BoardID="&BoardID&" And (TopicId="&RS(0)&" Or ReplyTopicId="&RS(0)&")")
		IF Rs(1) Then'删除投票
			YxBBs.Execute("Delete from [YX_TopicVote] where TopicID="&RS(0)&"")
			YxBBs.Execute("Delete from [YX_TopicVoteUser] where TopicID="&RS(0)&"")
		End If
		Rs.movenext
		Loop
		Rs.Close
		YxBBs.Execute("Delete From[YX_Topic] where BoardID="&BoardID&" And SqlTableID="&AllTable(i)&" And IsGood=False And  DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')>"&ClearDate&" ")
	Next
	Call Suc("","成功的清理了论坛数据！","?")
End Sub

Sub PassUser
	Set Rs=YxBBs.execute("Select PassUser,BoardName From [YX_Board] where BoardID="&YxBBs.BoardID&" And ParentID<>0")
	IF Rs.eof Then
		Call GoBack("","此论坛的类型不是认证论坛，不能设置认证用户。")
		Exit Sub
	End If%>
	<form method=POST style='margin:0' action="?Action=SavePassUser">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr bgcolor="#CCCCCC"><td height="25" colspan="2">修改论坛论证用户</td>
	</tr>
	<tr bgcolor="#DEDEDE"><td width="30%" height="28"><b>所在论坛：</b> </td>
	<td width="70%"><input name="BoardID" value="<%=YxBBs.BoardID%>" type="hidden"><%=Rs("BoardName")%></td></tr>
	<tr bgcolor="#DEDEDE"><td height="28"><b>通过认证的用户：</b><br>
	  各用户之间用“|”隔开<Br>请不要使用回车键Enter</td><td height="28"><textarea name="PassUser" rows="3"><%=Rs("PassUser")%></textarea></td></tr>
	<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><input type="submit" value=" 提 交 "> &nbsp;&nbsp;<input type="reset" name="Submit" value=" 重 置 "></td></tr></tbody></table>
	</table></form>
	<%Rs.Close
End Sub

Sub SavePassUser
	Dim PassUsers,BoardID
	BoardID=YxBBs.Fun.GetStr("BoardID")
	PassUsers=Trim(Replace(Request.Form("PassUser"),"'",""))
	PassUsers=Replace(PassUsers,chr(10), "")
	PassUsers=Replace(PassUsers,chr(13), "")
	YxBBs.Execute("Update [YX_Board] Set PassUser='"&PassUsers&"' where BoardID="&BoardID&" And ParentID<>0")
	Cache.Name="BoardInfo"
	Cache.clean()
	Call Suc("","成功的更新了该论坛的认证会员！","?")
End Sub

Sub BoardUpdate
	%>
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	<tr><td bgcolor="#DEDEDE"><div align="center"><b><span id=YxBBsT name=YxBBsT>数据版面正在整理，请稍等</span></b></div>
	  <table width="400" border="0" align="center" cellpadding="1" cellspacing="1">
	<tr><td bgcolor=#d7d7d7>
	<table width="400" border="0" cellspacing="0" cellpadding="1">
	<tr> 
	<td bgcolor=ffffff height=9><img src="../images/hr1.gif" width=0 height=16 id=YxBBsimg name=YxBBsimg align=absmiddle></td>
	</tr></table>
	</td></tr></table>
	<div align="center"><span id=YxBBstxt name=YxBBstxt style="font-size:9pt">0</span><span style="font-size:9pt">%</span></div></td></tr></table><br>
	<%Response.Flush
	Dim BoardNum,EssayNum,TopicNum,TodayNum,ParentStr,LastReply,LastCaption
	Dim AllTable,I,II,III,SQL
	BoardNum=YxBBs.Execute("Select Count(BoardID) from[YX_Board] Where ParentID<>0")(0)
	II=0
	Set Rs=YxBBs.Execute("Select BoardID,BoardName,Child,ParentStr,RootID from[YX_Board] Where ParentID<>0  Order by Child,RootID,Orders Desc")
	If Not Rs.EOF Then 
	SQL=Rs.GetRows()
	Rs.Close
	For i=0 to UBound(SQL,2)
	EssayNum=0
	TopicNum=0
	TodayNum=0
	LastReply=""
	LastCaption="无"
	AllTable=Split(YxBBs.BBSTable(0),",")
	For III=0 To uBound(AllTable)
		EssayNum=EssayNum+YxBBs.Execute("Select Count(*) From[YX_Bbs"&AllTable(III)&"] where BoardID="&SQL(0,i)&" And IsDel=False")(0)
		TodayNum=TodayNum+YxBBs.Execute("Select Count(*) From[YX_Bbs"&AllTable(III)&"] where BoardID="&SQL(0,i)&" And IsDel=False And DATEDIFF('d',[LastTime],'"&YxBBs.NowBbsTime&"')<1")(0)
	Next
	TopicNum=YxBBs.Execute("Select Count(TopicID) From[YX_Topic] where BoardID="&SQL(0,i)&" and IsDel=False")(0)
	Set Rs=YxBBs.execute("Select top 1 TopicID,Name,Caption,AddTime,Face,SqlTableID,BoardID From [YX_Topic] where IsDel=False And BoardID="&SQL(0,i)&" order by TopicID desc")
	If Not Rs.eof then
		LastCaption=replace(YxBBs.Fun.StrLeft(Rs("Caption"),20),"'","&#39;")
		LastReply=Rs("Name")&"|"&LastCaption&"|"&Rs("AddTime")&"|"&Rs("Face")&"|"&Rs("TopicID")&"|"&Rs("BoardID")&"|"&Rs("SqlTableID")&""
	End If
	Rs.Close
	YxBBs.Execute("update [YX_Board] Set EssayNum="&EssayNum&",TodayNum="&TodayNum&",TopicNum="&TopicNum&",LastReply='"&LastReply&"' where BoardID="&SQL(0,i)&"")
	'如果有上级论坛，那么更新上级论坛
	If SQL(2,I)>0 Then
		ParentStr=SQL(3,i) & "," & SQL(0,i)
		Set Rs=YxBBs.Execute("Select Sum(EssayNum),Sum(TopicNum),Sum(TodayNum) From [YX_Board] Where ParentStr = '"&ParentStr&"'")
		If Not IsNull(Rs(0)) Then EssayNum = Rs(0) + EssayNum
		If Not IsNull(Rs(1)) Then TopicNum = Rs(1) + TopicNum
		If Not IsNull(Rs(2)) Then TodayNum = Rs(2) + TodayNum
		Rs.Close
		Set Rs=YxBBs.execute("Select top 1 TopicID,Name,Caption,AddTime,Face,SqlTableID,BoardID From [YX_Topic] where IsDel=False And BoardID In ("&ParentStr&") Order by LastTime Desc")
		If Not Rs.eof then
			LastCaption=replace(YxBBs.Fun.StrLeft(Rs("Caption"),20),"'","&#39;")
			LastReply=Rs("Name")&"|"&LastCaption&"|"&Rs("AddTime")&"|"&Rs("Face")&"|"&Rs("TopicID")&"|"&Rs("BoardID")&"|"&Rs("SqlTableID")&""
		End If
		Rs.Close
		YxBBs.Execute("update [YX_Board] Set EssayNum="&EssayNum&",TodayNum="&TodayNum&",TopicNum="&TopicNum&",LastReply='"&LastReply&"' where BoardID="&SQL(0,i)&"")
	End IF
	Call Table("论坛 <Font color=blue>"&SQL(1,i)&"</Font> 整理成功","总帖数"&EssayNum&" | 主题数："&TopicNum&" | 今日帖："&TodayNum&" | 最新主题："&LastCaption&"")
	II=II+1
	Response.Write "<script>YxBBsimg.width=" & Fix((ii/BoardNum) * 400) & ";" & VbCrLf
	Response.Write "YxBBstxt.innerHTML=""" & FormatNumber(ii/BoardNum*100,4,-1) & """;" & VbCrLf
	Response.Write "</script>" & VbCrLf
	Response.Flush
	Next
	End If
	Response.Write "<script>YxBBsimg.width=400;YxBBstxt.innerHTML=""100"";YxBBsT.innerHTML=""<font color=red>成功完成整理！</font>"";</script>"
	updateBoardCache
End Sub

Function SqlTableList()
	Dim AllTable,I
	AllTable=Split(YxBBs.BBSTable(0),",")
	For i=0 To uBound(AllTable)
	SqlTableList=SqlTableList&"<option value='"&AllTable(I)&"'>数据表"&AllTable(I)&"</option>"
	Next
End Function


Sub Table(Str1,Str2)
	Response.Write("<table width='98%' border='1' align='center' cellpadding='3' cellspacing='2' bordercolor='#999999' bordercolordark='#FFFFFF' bgcolor='#DEF0FE'><tr><td><Div style='margin:5;line-height: 150%'>"&Str1&"<br>"&Str2&"</Div></td></tr></table>")
End Sub
%>