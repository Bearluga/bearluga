<%@ LANGUAGE = VBScript CodePage = 936%>
<%
Option Explicit
Response.Buffer = True
Dim Conn,Db,StartTime,Timeset,SqlNum
Timeset=0
StartTime = Timer()
SqlNum=0
Db="../TBData/YxBBs.Asp"

Sub ConnectionDatabase
	Dim ConnStr
	Set conn=Server.CreateObject("ADODB.Connection")
	ConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&server.mappath(Db)
	On Error Resume Next
	Conn.Open ConnStr
	If Err Then
		err.Clear
		Set Conn = Nothing
		esponse.Write "数据库连接错误，请修改Admin目录下的Conn.Asp"
		Response.End
	End If
End Sub
%>
<!-- #include File="../inc/Public_Cls.Asp" -->
<!-- #include File="../inc/YX_Cls.Asp" -->
<%
Dim YxBBs,Cache
Set YxBBs = New Cls_Public
Set Cache = New Cls_Cache
YxBBs.SystemConfig()
YxBBs.CheckUser()
%>
