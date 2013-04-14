<!--#include file="Inc/SysConfig.Asp"-->
<% 
  Dim Sql, Rss, Siteurl, I, BoardID, Tconn,Tconnstr, Tdb, Content, Arr, Sitename, Boardname,Rs
  BoardID=Cnum(Request("BoardID"))
	SiteURL="http://"&Request.ServerVariables("server_name")&Request.ServerVariables("script_name")&""
	SiteURL=Left(SiteURL,inStrRev(SiteURL,"/"))  
  sitename=YxBBs.execute("select BBSName from [YX_Config]")(0)
  sitename=split(sitename,"|")(0)
  
  if BoardID<>"" then
  	boardname=YxBBs.execute("select BoardName from [YX_Board] where BoardID="&BoardID&"")(0)
		boardname=split(boardname,"|")(0)
		sitename=sitename&" - "&boardname
	end if
	

	Rss="<?xml version=""1.0"" encoding=""GB2312"" ?><rss version=""2.0""><channel>"
  Rss=Rss&"<title>"&sitename&"</title><link>"&siteurl&"Default.Asp</link><language>zh-cn</language><description> "&sitename&" </description><generator>Rss Generator By YimXu.Com</generator><copyright>http://www.YimXu.com/</copyright>"
  if BoardID="" then
		sql="select top 20 TopicID,Caption,Name,addtime,SqlTableID from [yx_Topic] order by TopicID desc"
	else
		sql="select top 20 TopicID,Caption,Name,addtime,SqlTableID from [yx_Topic] where BoardID="&BoardID&" order by TopicID desc"
	end if
	Set Rs=YxBBs.Execute(sql)
	arr=rs.getrows
	rs.close
	set rs=nothing	
	for i=0 to ubound(arr,2)
		sql="Select content From [yx_bbs1] where TopicID="&arr(0,i)&""
		content=conn.Execute(sql)(0)
		if len(content)>500 then content=left(""&content&"",500)&"..."
		Rss=Rss&"<item>"
		Rss=Rss&"<title>"&arr(1,i)&"</title>"
		Rss=Rss&"<link>"&SiteURL&"show.asp?id="&arr(0,i)&"</link>"
		Rss=Rss&"<author>"&arr(2,i)&"</author>"
		Rss=Rss&"<description><![CDATA["&htmlcoder(content)&"]]></description>"
		Rss=Rss&"<pubDate>"&arr(3,i)&"</pubDate>"
		Rss=Rss&"</item>"
	next
	
		
		If Isobject(Tconn) Then
			Tconn.Close
			Set Tconn = Nothing
		End If
	
  Rss=Rss&"</channel></rss>"
  
  Response.CharSet="gb2312"
  Response.ContentType="text/xml" 
 	Response.Write Rss
 	
 	'=========================================
 	function cnum(str)
		if isnull(str) or str=""  then
			exit function
		else
			if not isnumeric(str) then
				cnum=""
			else
				cnum=int(str)
			end if
		end if
	end function
	function htmlcoder(str)
	if not isnull(str) and str<>"" then
		str = replace(str, ">", "&gt;")
		str = replace(str, "<", "&lt;")
		str = Replace(str, CHR(32), " ")
		str = Replace(str, CHR(9), " ")
		str = Replace(str, CHR(34), "&quot;")
		str = Replace(str, CHR(39), "&#39;")
		str = Replace(str, CHR(13), "")
		str = Replace(str, CHR(10), "<br>")
		str = Replace(str, "script", "&#115;cript")
	htmlcoder = str
	end if
	end function
%>