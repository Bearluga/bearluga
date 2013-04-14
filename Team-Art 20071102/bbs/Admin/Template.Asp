<!--#include file="Check.Asp"-->
<%
Dim Temp,i,Str,SkinConn
dim Action,ID
ID=Request("ID")
Str="页面属性|菜单属性|页面头部|你的位置|快速登陆|用户信息|分区表格|版块列表|版块最后回复|分区底部表格|内容表格|在线统计|版块在线|在线显示|主题列表顶部|主题列表|主题列表底部|帖子顶部|显示投票|帖子信息|帖子底部|用户登陆|各项列表顶部|各项列表底部|首页图例|页面底部|版块类型图片|用户类型图片|发帖图片|帖子信息链接|帖子状态图片"
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#4D65A4"><td height="25" colspan="3" bgcolor="#CCCCCC" ><b><font color="#FFFFFF">论坛风格设置 </font></b></td>
  </tr>
<tr><td height="25" colspan="3" align="center" bgcolor="#DEDEDE"><a href="?">【风格管理】</a> &nbsp; <a href="?Action=Add">【添加风格】</a>&nbsp;&nbsp;<a href="?Action=Load">【风格数据导入】</a>&nbsp;&nbsp;<a href="?Action=SkinData">【风格数据导出】</a></td>
</tr></table><br>
<%
Select Case Request("Action")
Case "Add"
	Add
Case "SaveAdd"
	SaveAdd
Case "Del"
	Del
Case "Auto"
	Auto
Case "IsMode"
	IsMode
Case "Edit"
	Edit
Case "UpdateName"
	UpdateName
Case "EditSkin"
	EditSkin
Case "SkinData"
	SkinData
Case "Load"
	Load
Case "DataPost"
	DataPost
Case Else
	Main
End Select
AdminFooter()

Function SaveReplace(Str)
	Str = Replace(Str,"[","{LFG}")
	Str = Replace(Str,"]","{RFG}")
	SaveReplace = Str
End Function

Sub updateName
	YxBBs.Execute("Update [YX_SkinStyle] Set SkinName='"&Replace(Request("SkinName"),"'","''")&"' Where SkinID="&ID)
	Call Suc("","风格名称修改成功。","?")
	'Cache.name="Skin_"& ID
	'Cache.clean()
	'Cache.Name="SkinList"
	'Cache.clean()
	Application.Contents.RemoveAll
End Sub

Sub Add
Dim Temp,SkinName,txt,IsMode
Set RS=YxBBs.Execute("Select Top 1 SkinName,SkinID,SkinContent From [YX_SkinStyle] Where IsMode")
If not Rs.Eof Then
	IsMode=True
	SkinName=Rs("SkinName")
	YxBBs.Template.TemplateContent=RS("SkinContent")
	Temp=YxBBs.Template.ReadTemplateName
	Txt="当前的元素引用 风格模版 <font color=red>" & SkinName &"</font>"
Else
	IsMode=False
	Temp=Split(Str,"|")
	Txt="当前没有引用 风格模版 "
End If
Rs.Close
%>
<script>
var isopen=1;
</script>
<FORM METHOD=POST style="margin:0 " ACTION="?Action=SaveAdd">
	<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
	  <tr  bgcolor="#4D65A4"><td height="25" colspan="2" bgcolor="#CCCCCC" ><b><font color="#FFFFFF">添加新风格 </font></b></td>
	</tr>
	<tr><td height="40" bgcolor="#DEDEDE"><b>风格名称：</b>
	  <INPUT TYPE="text" NAME="SkinName" >&nbsp;&nbsp;&nbsp;<%=Txt%></td></tr>
	<tr>
	  <td colspan="2" bgcolor="#DEDEDE">
<%
		For i = 0 to Ubound(Temp)
			 Response.Write "<tr bgcolor=""#DEDEDE""><td><li>" & Temp(i) & " 【<a href=#this onclick=""javascript:if(isopen==1){viewcode" & i & ".style.display='block';isopen=0;}else{viewcode" & i & ".style.display='none';isopen=1;}"">添加元素</a>】 </td></tr><tr><td bgcolor=#F6F6F6 id='viewcode"& i &"' style='color:#999999;display:none'><TEXTAREA NAME='TmpName_"&i&"' ROWS=20>"
			 If IsMode Then
			 Response.Write YxBBs.Fun.HtmlCode(YxBBs.Template.ReadTemplate(Temp(i)))
			 End If
			 Response.Write"</TEXTAREA></td></tr>"
		Next
%>
<TR>
	<TD align=Left bgcolor="#CCCCCC"><input name="submit" type="submit" value=" 添 加 "></td>
</TR>
</table>
</table>
</form>
<%
End Sub

Sub SaveAdd
Dim Temp,Content,ResultErr,TS
  If Request("SkinName")="" Then
     Call GoBack("","请填写风格名称！")
	 Exit Sub
  End IF
  Temp=Split(Str,"|")
  For i = 0 to Ubound(Temp)
      Content=Content&VBCrlf&VBCrlf&"["&Temp(i)&"]"&VBCrlf&VBCRLF&SaveReplace(Request("TmpName_"&i))&VBCRLF&VBCrlf&"[/"&Temp(i)&"]"
      If Request("TmpName_"&i)="" Then
        ResultErr=ResultErr&"<FONT COLOR=#FF0033>"&Temp(i)&"</FONT>，"
	  End If
  Next
  YxBBs.Execute("Insert Into YX_SkinStyle(SkinName,SkinContent) values('"&Replace(Request("SkinName"),"'","''")&"','"&Replace(Content,"'","''")&"')")
  If ResultErr<>"" Then
	  Call Suc("","此风格模版以下的元素"&ResultErr&" 没有内容!<li>请到风格管理里面编辑！","?")
  Else
	  Call Suc("","成功添加<b>"&Request("SkinName")&"</b>风格","?")
	  Application.Contents.RemoveAll
  End If
End Sub

Sub Auto
   YxBBs.Execute("Update [YX_Config] Set SkinID="&ID)
   YxBBs.Execute("Update [YX_SkinStyle] Set Flag=True where SkinID="&ID )
   YxBBs.Execute("Update [YX_SkinStyle] Set Flag=False where SkinID<"&ID&" or SkinID>"&ID)
   Call Suc("","风格设为论坛默认使用成功！","?")
   Application.Contents.RemoveAll
End Sub

Sub IsMode
   YxBBs.Execute("Update [YX_SkinStyle] Set IsMode=True where SkinID="&ID )
   YxBBs.Execute("Update [YX_SkinStyle] Set IsMode=False where SkinID<"&ID&" or SkinID>"&ID)
   Call Suc("","此风格被设置为添加论坛风格的引用模版！","?")
End Sub

Sub Del
	YxBBs.Execute("Delete From [YX_SkinStyle] Where SkinID="&ID)
	Call Suc("","风格已被成功删除！","?")
	Application.Contents.RemoveAll
End Sub

Sub Main
Dim  Rs,RsT,MainID
Set RsT=YxBBs.Execute("Select SkinID,SkinName,Flag,Ismode From [YX_SkinStyle] Order By SkinID Asc")
Rs=Rst.GetRows()
RsT.CLose
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td width="8%" height="25" align="center"><b><font color="#FFFFFF">风格ID</font></b></td>
<td width="43%" align="center"><b><font color="#FFFFFF">风格名称</font></b></td>
<td width="49%" align="center"><b><font color="#FFFFFF">风格管理</font></b></td>
</tr>
  <%
	Dim i
    For i=0 To UBound(Rs,2)
	%>
	 <tr bgcolor="#DEDEDE"><td align="center"><%=Rs(0,i)%></td><td align="center"><%=Rs(1,i)%></td><td align="center">
		 <% If Rs(2,i) Then 
		 Response.write "<FONT  COLOR=#FF0033><b>√</b> 论坛默认</FONT>"
		 Else
		 REsponse.write "<b>×</b> <A HREF=""?Action=Auto&ID="&Rs(0,i)&""">论坛默认</A>"
		 End IF
		 REsponse.write " &nbsp; "
		 If Rs(3,i) Then
		 Response.write "<FONT  COLOR=#FF0033><b>√</b> 做为模版</FONT>"
		 Else
		 REsponse.write "<b>×</b> <A HREF=""?Action=IsMode&ID="&Rs(0,i)&""">做为模版</A>"
		 End IF		 
		 %>　&nbsp; <A HREF="?Action=Edit&ID=<%=Rs(0,i)%>"><img src="../images/edit.gif" border="0" align="absmiddle"> 修改</A> &nbsp; <A HREF="?Action=Del&ID=<%=Rs(0,i)%>" onclick="<%if Rs(2,i) then%>alert('此风格论坛正在使用中，论坛默认风格不能删除！');return false;<%else%>checkclick('删除后将不能恢复！您确定要删除吗？')<%end if%>"><img src="../images/del.gif" border="0" align="absmiddle"> 删除</a></td>
  </tr>
    <%Next%>
</table>
<%
End Sub


Sub Edit
	Dim Temp,SkinName
	Set RS=YxBBs.Execute("Select SkinName,SkinContent From [YX_SkinStyle] Where SkinID="&ID)
	SkinName=Rs(0)
	YxBBs.Template.TemplateContent=RS(1)
	Rs.Close
	Temp=YxBBs.Template.ReadTemplateName
	%>
	<br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<TR><TD align=Left bgcolor="#CCCCCC"><FORM METHOD=POST style="margin:0" ACTION="?Action=UpdateName"><FONT  COLOR="#FF0033"><B>风格名称：</B></FONT><INPUT TYPE="text" NAME="SkinName" value="<%=SkinName%>"> <INPUT TYPE="hidden" name="ID" value="<%=ID%>"><INPUT TYPE="submit" value="更改风格名称">
</FORM></td>
</TR><TR><TD bgcolor="#DEDEDE">
<table border=1 bordercolor=#DEF0FE  cellspacing="2" width="100%" align=center style="font-size: 12px; font-family: Verdana;line-height:22px;TABLE-LAYOUT:fixed;word-break:break-all">
<%
	If IsArray(Temp) Then
		For i = 0 to Ubound(Temp)
			 Response.Write "<tr><td bordercolor=#999999><table width='100%'><tr><td width='50%'><li>" & Temp(i) & " </td><td  width='50%'>【<a href=#this onclick=""javascript:if(isopen==1){viewcode" & i & ".style.display='block';isopen=0;}else{viewcode" & i & ".style.display='none';isopen=1;}"">查看</a>】 【<a href=#edit onclick=""Edit(viewcode" & i & ",'" & Temp(i) & "')"">修改</a>】</td></tr></table></td></tr><tr><td bgcolor=#E7ECF1 id='viewcode"& i &"' bordercolor=#999999 style='color:#888888;display:none'>" &HtmlenCode(YxBBs.Template.ReadTemplate(Temp(i)))&  "</td></tr>"
		Next
	Else
		Response.Write "<tr><td>暂时还没有风格模板元素</td><td align=right></td></tr>"
	End If
%>
</table>
<br>
<form name=form1 style="margin:0 " method=Post action="?Action=EditSkin">
<table border=1 bordercolor=#FFFFFF width=98% align=center style="font-size: 11px; font-family: Verdana;line-height:22px">
 <tr><td bordercolor=#999999><INPUT TYPE="hidden" Name="SkinName" value="no"><INPUT TYPE="hidden" name="ID" value="<%=ID%>">
       <font color=red>修改风格元素</font><a name=edit></a>：&nbsp;<INPUT TYPE="text" NAME="NodeType" ReadOnly>
       <br> &nbsp;&nbsp;元素值 <br><textarea name=Content cols="100" rows="15" style="font-size:12px"></textarea>
<div align="center"><input type=submit value=" 修改风格 "></div></td></tr>
</table>
</form>
</TD>
</TR>
</TABLE>
<%
End Sub


Sub EditSkin
	Dim Temp
	ID=YxBBs.Fun.GetStr("ID")
	Set Rs=YxBBs.Execute("Select SkinContent From[YX_SkinStyle] where SkinID="&ID)
	YxBBs.Template.TemplateContent=Rs(0)
	Rs.Close
	If Request.Form("SkinName")<>"no" and Request.Form("SkinName")<>"" Then
		Temp=YxBBs.Template.EditTemplate(Request.Form("SkinName"),Request.Form("Content"))
		YxBBs.Execute("Update [YX_SkinStyle] Set SkinContent='"&Replace(Temp,"'","''")&"' Where SkinID="&ID)
		Call Suc("","风格的元素 ["&Request.Form("SkinName")&"] 风格修改成功。",Request.ServerVariables("HTTP_REFERER"))
		Cache.Name="Skin_"& ID
		Cache.Clean()
	Else
	     Call GoBack("","请先选取相应的风格元素。")
	End If
End Sub

function HTMLEncode(fString)
	if not isnull(fString) then
		fString = replace(fString, ">", "&gt;")
		fString = replace(fString, "<", "&lt;")
		fString = Replace(fString, CHR(32), "&nbsp;")
		fString = Replace(fString, CHR(9), "&nbsp;")
		fString = Replace(fString, CHR(34), "&quot;")
		fString = Replace(fString, CHR(39), "&#39;")
		fString = Replace(fString, CHR(13), "")
		fString = Replace(fString, CHR(10) & CHR(10), "</P><P> ")
		fString = Replace(fString, CHR(10), "<BR> ")
		HTMLEncode = fString
	end if
end function

Sub DataPost
	Dim Msg,MdbName
	IF ID="" Then Call GoBack("","您还没有选定一个项目！"):Exit Sub
	MdbName=Request("SkinMdb")
    If Request("To")="InputSkin" Then
	    SkinConnection(mdbname)
	    If Request("submit")="删除" Then
	       SkinConn.Execute("Delete From [YX_SkinStyle] Where SkinID In ("&ID&")")
		   Call Suc("","风格模版成功删除！","?"):Exit Sub
		Else
		  Set Rs=SkinConn.Execute(" select SkinName,SkinContent from [YX_SkinStyle] where SkinID in ("&ID&")  order by SkinID ")
          While Not Rs.Eof
              YxBBs.Execute("Insert Into [YX_SkinStyle](SkinName,SkinContent) values('"&Replace(Rs(0),"'","''")&"','"&Replace(Rs(1),"'","''")&"')")  
			  Rs.Movenext
          Wend
		  	Rs.Close
		  Call Suc("","风格模版数据导入成功！","?")
		  Cache.Name="SkinList"
		  Cache.clean()
		  Exit Sub
		End If
    Else
	      SkinConnection(MdbName)
	      Set Rs=YxBBs.Execute(" select SkinName,SkinContent from [YX_SkinStyle] where SkinID in ("&ID&")  order by SkinID ")
          While Not Rs.Eof
              SkinConn.Execute("Insert Into [YX_SkinStyle](SkinName,SkinContent) values('"&Replace(Rs(0),"'","''")&"','"&Replace(Rs(1),"'","''")&"')")  
			  Rs.Movenext
          Wend 
		  Rs.Close
		  Call Suc("","风格模版数据导出成功！","?")
   End If
End Sub


Sub SkinData
Dim FlagName,MdbName,act
If Request("Flag")="LoadThis" Then
    FlagName="导入"
    act="InputSkin"
    MdbName=trim(Request.form("SkinMdb"))
    If MdbName="" Then
		Call GoBack("","请填写导出风格模版保存的表名")
		Exit Sub
	End If
Else
	FlagName="导出"
	act="OutSkin"
End If
%>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC">
    <td height="25" colspan=8 ><b><font color="#FFFFFF"><%=FlagName%>风格模版数据</font></b></td>
  </tr>
  <tr bgcolor="#DEDEDE">
    <td width="10%" height=25 align="center"><b>序号</b></font></td>
    <td align="center"><b>风格名称</b></font></td>
    <td width="15%" align="center"><b>选择</b></font></td>
  </tr>
  <form action="?Action=DataPost&To=<%=Act%>" method=post name=even>
    <%
   If act="InputSkin" Then
	  SkinConnection(MdbName)
	  Set Rs=SkinConn.Execute("select SkinID,SkinName from [YX_SkinStyle] order by SkinID")
   Else
	 set  Rs=YxBBs.Execute("select SkinID,SkinName from [YX_SkinStyle] order by SkinID")
	 MdbName="../Skins/YX_SkinStyle.mdb"
   End If
   Dim Temp,i
   IF Rs.Eof Then Call GoBack("","该数据库中没有风格模版的数据！"):Exit Sub
   Temp=Rs.GetRows()
   For i=0 To Ubound(Temp,2)
   %>
    <tr bgcolor="#DEDEDE"><td  align="center"><%=Temp(0,i)%></td><td align="center"><%=Temp(1,i)%></td><td  align="center"><input type="checkbox" name="ID" value="<%=Temp(0,i)%>"></td></tr>
    <%Next%>
    <tr bgcolor="#CCCCCC"><td colspan="4" align=center> <%=FlagName%>的数据库：
          <input type="text" name="SkinMdb" size="30" value="<%=MdbName%>"> <input type="submit" name="submit" value="<%=FlagName%>">
          <%If act="InputSkin" Then%>
          <input type="submit" name="submit" value=删除  onClick="checkclick('删除后将不能恢复！您确定要删除吗？');">
          <%End If%>
<input type=checkbox name=chkall value=on onClick="CheckAll(this.form)"> 全选</td></tr></form></table><%
End Sub

Sub Load()
%>
<form action="?action=SkinData&Flag=LoadThis" method=post>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF"><tr  bgcolor="#CCCCCC"><td height="25" colspan="3" ><b><font color="#FFFFFF">导入风格模版数据</font></b></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="40%"><b><font color="#000077">导入风格模版数据库名：</font></b></td>        
	   <td width="60%">
      <input name="skinmdb"  size="30" value="../Skins/YX_SkinStyle.mdb"></td>
    </tr>
	   <tr bgcolor="#CCCCCC">
	   <td colspan=2 align=center valign=middle>
         <input type="submit" value="下一步" name="B1"></td></tr>
  </table>
</form>
<%End Sub

Sub SkinConnection(mdbname)
On Error Resume Next 
	Set SkinConn = Server.CreateObject("ADODB.Connection")
	SkinConn.open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(MdbName)
	If Err Then 
		Call GoBack("",Mdbname&" 数据库不存在！")
		AdminFooter()
		Response.end
	End If
End Sub
%>
<script language="JavaScript">
<!--
var isopen=1;
function Edit(obj,Node){
	document.all.form1.NodeType.value = Node;
	document.all.form1.SkinName.value = Node;
	document.all.form1.Content.value = obj.innerText;
}
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