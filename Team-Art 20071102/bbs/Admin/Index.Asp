<!--#include file="check.Asp"-->
<%
Set YxBBs=Nothing
%>
<title>论坛管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%
if Request("action")="left" then 
	Call mainleft()
Else
	Call main()
End If

Sub Main()
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>后台管理</title>
</head>
<frameset rows="*" framespacing="0" frameborder="1" border="false" id="frame" scrolling="yes">
  <frameset cols="181,*" framespacing="0" frameborder="1" border="false" id="frame" scrolling="yes">
  <frame name="left" scrolling="auto" marginwidth="0" marginheight="0" src="?action=left">
  <frame name="main" scrolling="auto" src="Admin.Asp?Action=Right">
  </frameset>
</frameset>
<noframes>
<body leftmargin="2" topmargin="0" marginwidth="0" marginheight="0">
  <p>你的浏览器版本过低！！！本系统要求IE5及以上版本才能使用本系统。</p>
</body>
</noframes>
</html>
<%
End Sub

sub mainleft()
Dim B
B="<img src='../images/bullet.gif' width='15' height='20'>"
%>
<style type="text/css">
<!--
BODY {BACKGROUND: #799ae1; MARGIN: 0px; FONT: 9pt 宋体}
TABLE {BORDER: 0px; }
TD {FONT: 12px 宋体;}
IMG {BORDER-RIGHT: 0px; BORDER-TOP: 0px; VERTICAL-ALIGN: bottom; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px}
A {FONT: 12px 宋体; COLOR: #295C87; TEXT-DECORATION: none}
A:hover {COLOR: #FB921E}
.sec_menu {BORDER-RIGHT: white 1px solid; BACKGROUND: #d6dff7; OVERFLOW: hidden; BORDER-LEFT: white 1px solid; BORDER-BOTTOM: white 1px solid}
.menu_title SPAN {FONT-WEIGHT: bold; LEFT: 8px; COLOR: #0066CC; POSITION: relative; TOP: 2px}
.menu_title2 SPAN {FONT-WEIGHT: bold; LEFT: 8px; COLOR: #428eff; POSITION: relative; TOP: 2px}
-->
</style>
<SCRIPT language=javascript1.2>
function showsubmenu(sid)
{
whichEl = eval("menu" + sid);
if (whichEl.style.display == "none")
{
eval("menu" + sid + ".style.display=\"\";");
}
else
{
eval("menu" + sid + ".style.display=\"none\";");
}
}
</SCRIPT>
<base target="Right">
</head>
<body onselectstart="return false">
<TABLE cellSpacing=0 cellPadding=0 width="100%" align=left border=0><TBODY><TR><TD vAlign=top>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY><TR><TD vAlign=bottom height=42><IMG height=38 src="../images/title.gif" width=158> </TD></TR></TBODY></TABLE>
<TABLE width=158 align=center cellPadding=0 cellSpacing=0 bgcolor="#D6E0F9"><TBODY>
<TR style="CURSOR: hand"><TD  height=4 colspan="4" valign="top" class=menu_title></TD></TR>
<TR style="CURSOR: hand"><TD width="23"  height=21 class=menu_title valign="top">
<div align="right"><img src="../images/home.gif" width="16" height="16" align="absmiddle"><br></div></TD>
<TD width="55" class=menu_title><b><a target="_top" href="Index.Asp"> 管理首页</a></b> </TD>
<TD width="22" class=menu_title valign="top"><div align="right"><img src="../images/exit.gif" width="16" height="16" align="absmiddle"><br></div></TD>
<TD width="56" class=menu_title><b><a target="_top" href="login.Asp?action=exit"> 退出管理</a></b> </TD>
</TR></TBODY></TABLE>
	<table height=2><tr><td></td></tr></table>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY>
<TR style="CURSOR: hand"><TD class=menu_title id=menuTitle1 onclick="showsubmenu(1)" background="../images/title_bg_hide.gif" height=25>
<span>&nbsp;系统常规设置</span> </TD></TR><TR>
<TD><DIV class=sec_menu id=menu1 style="DISPLAY: none;">
<TABLE style="POSITION: relative; top: 10px;" cellSpacing=0   cellPadding=0 width=135 align=center><TBODY>
<TR><TD height=20><%=B%><a href="System.Asp" target="main">论坛信息设置 </a></TD></TR>
<TR><TD height=20><%=B%><a href="Admin1.Asp" target="main">论坛联盟管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=LockIp" target="main">I P 封锁管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Admin.Asp?Action=setadv" target="main">贴间广告管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Other.Asp?Action=Clean" target="main">更新论坛缓存</a></TD></TR>
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE> <table height=2><tr><td></td></tr></table>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY><TR style="CURSOR: hand">         
<TD class=menu_title id=menuTitle2 onclick="showsubmenu(2)" background="../images/title_bg_show.gif" height=25>
<span>&nbsp;分类版块管理</span> </TD></TR>         
<TR><TD><DIV class=sec_menu id=menu2 style="DISPLAY: none;">         
<TABLE style="POSITION: relative; TOP: 10px;" cellSpacing=0 cellPadding=0 width=135 align=center><TBODY>         
<TR><TD height=20><%=B%><a href="Board.Asp" target="main">论坛版面管理</a></TD> </TR>
<TR><TD height=20><%=B%><a href="Board.Asp?Action=AddClass" target="main">添加论坛分类</a></TD> </TR>         
<TR><TD height=20><%=B%><a href="Board.Asp?Action=AddBoard" target="main">添加论坛版面</a></TD> </TR> 
<TR><TD height=20><%=B%><a href="Other.Asp?Action=UpdateBbs" target="main">论坛整理修复</a></TD> </TR>
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE>		
	<table height=2><tr><td></td></tr></table>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY>
<TR style="CURSOR: hand"><TD class=menu_title id=menuTitle3 onclick="showsubmenu(3)" background="../images/title_bg_show.gif"  height=25>
<span>&nbsp;用户信息管理</span></TD></TR>
<TR><TD><DIV class=sec_menu id=menu3 style="DISPLAY: none;">
<TABLE style="POSITION: relative; top: 10px;" cellSpacing=0  cellPadding=0 width=135 align=center><TBODY>
<TR><TD height=20><%=B%><a href="Users.Asp" target="main">用户信息管理</a> | <a href="Users.Asp?action=outmail" target="main">导出</a></TD></TR>
<TR><TD height=20><%=B%><a href="Admin.Asp?action=addadmin1" target="main">管理帐号添加</a> | <a href="Admin.Asp" target="main">管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Users.Asp?Action=Classadd" target="main">用户分组添加</a> | <a href="Users.Asp?Action=UserClass" target="main">管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Users.Asp?Action=addGrade" target="main">用户级别添加</a> | <a href="Users.Asp?Action=UserGrade" target="main">管理</a></TD></TR>
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE>
      <table height=2><tr><td></td></tr></table>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY>         
<TR style="CURSOR: hand"><TD class=menu_title id=menuTitle4 onclick="showsubmenu(4)" background="../images/title_bg_show.gif" height=25>
<SPAN>&nbsp;帖子留言文件</SPAN> </TD></TR>         
<TR><TD><DIV class=sec_menu id=menu4 style="DISPLAY: none;">          
<TABLE style="POSITION: relative; TOP: 10px;" cellSpacing=0  cellPadding=0 width=135 align=center>         <TBODY>
<TR><TD height=20><%=B%><a href="Other.Asp?Action=DelEssay" target="main">批量删除帖子</a></TD></TR>          
<TR><TD height=20><%=B%><a href="Other.Asp?Action=MoveEssay" target="main">批量移动帖子</a></TD></TR>          
<TR><TD height=20><%=B%><a href="Other.Asp?Action=DelSms" target="main">批量删除留言</a></TD></TR>          
<TR><TD height=20><%=B%><a href="Other.Asp?Action=AllSms" target="main">群发信件留言</a></TD></TR>          
<TR><TD height=20><%=B%><a href="Upload.Asp" target="main">上传文件管理</a></TD></TR> 
<TR><TD height=20><%=B%><a href="Admin.Asp?Action=Recycle" target="main">帖子回收站</a></TD></TR> 
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE>         
  	<table height=2><tr><td></td></tr></table>			
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY>         
<TR style="CURSOR: hand"><TD class=menu_title id=menuTitle5 onclick="showsubmenu(5)" background="../images/title_bg_show.gif"  height=25>
<SPAN>&nbsp;论坛插件管理</SPAN> </TD></TR>         
<TR><TD><DIV class=sec_menu id=menu5 style="DISPLAY: none;">          
<TABLE style="POSITION: relative; TOP: 10px;" cellSpacing=0 cellPadding=0 width=135 align=center>  <TBODY>  
<TR><TD height=20><%=B%><a href="Plus.Asp?Action=Plus" target="main">论坛插件管理</a></TD></TR>
<TR><TD height=20><%=B%><a href="Plus.Asp?Action=Bank" target="main">后台银行管理</a></TD></TR>	
<TR><TD height=20><%=B%><a href="Plus.Asp?Action=Faction" target="main">论坛帮派管理</a></TD></TR>
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE>         


	<table height=2><tr><td></td></tr></table>
<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY>         
<TR style="CURSOR: hand"><TD class=menu_title id=menuTitle7 onclick="showsubmenu(7)" background="../images/title_bg_show.gif" height=25>
<SPAN>&nbsp;数据相关操作</SPAN> </TD></TR>
<TR><TD><DIV class=sec_menu id=menu7 style="DISPLAY: none;">          
<TABLE style="POSITION: relative; TOP: 10px;" cellSpacing=0    cellPadding=0 width=135 align=center><TBODY> 
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=CompressData" target="main">压缩数据库</a></TD></TR>         
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=BackupDate" target="main">备份数据库</a></TD></TR>         
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=RestoreData" target="main">恢复数据库</a></TD></TR>        
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=SqlTable" target="main">数据表管理</a></TD></TR>         
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=ExecuteSql" target="main">执行SQL语句</a></TD></TR>
<TR><TD height=20><%=B%><a href="Admin1.Asp?Action=SpaceSize" target="main">空间占用情况</a></TD></TR>
</TBODY></TABLE><br></DIV></TD></TR></TBODY></TABLE>        

<TABLE cellSpacing=0 cellPadding=0 width=158 align=center><TBODY><TR><TD vAlign=bottom height=42><IMG height=131 src="../images/logo admin.gif" width=100> </TD></TR></TBODY></TABLE>

<%end sub%>