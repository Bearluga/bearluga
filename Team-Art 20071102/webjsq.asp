<%
'==================================
 '站长计数器v1.0
 '制　作：中国站长在线
 '网站：http://www.web591.cn
 '最新版本下载：http://www.web591.cn/591code/
 
'声 明:	
   '本软件系免费程序,提供给个人免费使用,除保留版权外无其它任何限制。
   '未经作者许可禁止用于任何商业用途。
'站长计数器功能：
   '1.计数器数字图片和文字两种机制共存。
   '2.页面显示计数和IP防刷新计数两种计数模式。
   '3.Script脚本方式调用计数器代码。
   '4.共5种图片样式任您选择使用，并且可以方便地增加计数器图片样式。
   '5.稳定性、安全性、速度上表现都很优秀，功能齐全，代码集成程度高、完全公开，专业制作，完全免费。
   '6.适合网站设计人员在制作企业站时使用。
 
'站长在线其它作品：FreeAd8百万格子 V3.5 商业版、Web591站长自助链、网上征文投稿系统、
'　　　　　　　    站长留言本 V1.0 等。

'此段版权注释不会影响网页打开速度，请勿删除!
'　　　　　　　　　　　2006年12月01日									
'===================================
%>
document.write("<%
'连接数据库
Provider = "Provider=Microsoft.Jet.OLEDB.4.0;"
Path = "Data Source=" & Server.MapPath("web#jsqmdb.asp")
Set conn= Server.CreateObject("ADODB.Connection")
p1=Provider&Path
conn.Open P1

Sub MyCounter(refresh,ty,picid)
	Dim CountNum
	SET Rs = Server.CreateObject("ADODB.Recordset")
	Rs.Open "Select * From counters" , conn,1,3

	Select Case refresh
	    '刷新不计数
		Case 1
			if isempty(session("number")) then
				application.lock
				Rs("TOTAL")=Rs("TOTAL") + 1 
				application.unlock
				session("number")=true
			end if
		'刷新记数
		Case 2
			Rs("TOTAL")=Rs("TOTAL") + 1
	End Select

	Rs.Update
	CountNum=Rs("TOTAL")

	Rs.close
	set Rs=nothing
	Conn.Close
	Set Conn = Nothing
Call DispNum(CountNum,ty,picid)
End Sub

Sub DispNum(CountNum,ty,picid)
	If ty="True" Then
		Dim S, i, G,pid
                pid=picid
		S = CStr(CountNum)
		For i = 1 to Len(S)
		 G = G &  "<img src=images/"&pid&"/" & Mid(S, i, 1) & ".gif align=middle>"
		Next
                response.write("")
		Response.write (G)
                response.write("")
	Else
		response.write("您是本站第 <font color=#FFC700><b>"&CountNum&"</b></font> 位客人")
	End If
End Sub

If Request("action")="freesoho" Then
	If Request("refresh")<>"" and Request("ty")<>"" Then Call MyCounter(Request("refresh"),Request("ty"),Request("Picid")) End If
End If
%>");