<!--#include file="Check.Asp"-->
<%
Dim Action
Action=Request.QueryString("Action")
Select case Action
Case"Save"
	ConfigSave
Case else
	Config
End select
AdminFooter()

Sub Config
Dim Info,Rs
Set Rs=YxBBs.execute("Select BBSName,BBSUrl,BBSClose,CloseInfo,BBSBanner,CopyRight,Info,BuildDate,Uploadtype,AllEssayNum,TopicNum,BadName,MaxOnlineTime,MaxOnlineNum,MaxEssayNum,UserNum,BadEssay,RegAutoSms From [YX_config]")
Info=split(Rs("Info"),"|")
%>
<a name="inc"></a>
<form method=POST name=form style='margin:0' action=System.Asp?Action=Save>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr><td bgcolor="#CCCCCC" align="center"><b><font color="#FFFFFF"> 论坛参数设置</font></b></td>
  </tr>
<tr><td height="25" align="center" bgcolor="#DEDEDE">【<a href="#inc1">上传设置</a>】  【<a href="#inc2">积分金钱设置</a>】 【<a href="#inc3">论坛显示设置</a>】 【<a href="#inc4">论坛系统数据设置</a>】【<a href="#inc5">论坛用户设置</a>】 【<a href="#inc6">论坛系统设置</a>】</td>
</tr></table>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">论坛基本设置</font></b> <a href="#inc">▲</a></td>
  </tr>
<tr bgcolor="#DEDEDE"><td><b>论坛名称：</b><br>
  你的论坛名称</td><td><input type="text" name="BBSName"  value="<%=Rs("BBSName")%>"></td></tr>
<tr bgcolor="#DEDEDE"><td ><b>论坛地址：</b><br>
  论坛的访问地址</td><td><input type="text" name="BBSUrl" style="WIDTH:98%;" value="<%=Rs("BBSUrl")%>"></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛管理目录：</b><br>手动修改管理目录名称，在设置.</td>
<td><input type="text" name="info2" size="10" value="<%=Info(2)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td><b>允许注册：</b><br> 
  设定是否允许新用户注册</td><td><input type="radio" name="info0" value="0" <%if Info(0)="0" then%>checked<%end if%>> 是 <input type="radio" name="info0" value="1" <%if Info(0)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td width="35%"><b>关闭论坛：</b><br>
  维护期间可设置关闭论坛</td><td width="65%"><input type="radio" name="BBSClose" value="0" <%if Not Rs("BBSClose") then%>checked<%end if%>> 开启  <input type="radio" name="BBSClose" value="1" <%if Rs("BBSClose") then%>checked<%end if%>> 关闭</td></tr>
<tr bgcolor="#DEDEDE"><td><b>关闭论坛显示信息：</b><br>
  设置关闭论坛后显示的信息<br>支持Html语法</td><td><textarea rows="3" name="CloseInfo" style="WIDTH:100%;"><%=Rs("CloseInfo")%></textarea></td></tr>
<tr bgcolor="#DEDEDE"><td><b>建站日期：</b><br>
  论坛落成开业的日期</td><td><input type="text" name="BuildDate"  value="<%=Rs("BuildDate")%>"> (格式：YYYY-M-D)</td></tr>
<tr bgcolor="#DEDEDE"><td ><b>论坛顶部广告：</b><br>
支持Html语法<br>风格模板显示代码为{广告}</td><td><textarea rows="3" name="BBSBanner" style="WIDTH: 100%;"><%=Rs("BBSBanner")%></textarea></td></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛版权信息：</b><br>
  支持Html语法</td><td><textarea rows="3" name="CopyRight" style="WIDTH:100%;"><%=Rs("CopyRight")%></textarea></td></tr></table>
<a name="inc1"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">上传设置 </font></b> <a href="#inc">▲</a></td>
  </tr>
<tr bgcolor="#DEDEDE">
  <td width="35%"><b>每次上传个数：</b><br> 
  限制每次上传的个数</td><td><input type="text" name="info3" size="5" value="<%=Info(3)%>"> 个</td></tr>
<tr bgcolor="#DEDEDE"><td><b>最大上传大小：</b><br>
  限制最大上传的大小</td><td><input type="text" name="info4" size="5" value="<%=Info(4)%>"> KB</td></tr>
<tr bgcolor="#DEDEDE"><td><b>是否允许上传头像：</b></td>
<td><input type="radio" name="info18" value="0" <%if Info(18)="0" then%>checked<%end if%>> 是 <input type="radio" name="info18" value="1" <%if Info(18)="1" then%>checked<%end if%>> 否 </td></tr>
<tr bgcolor="#DEDEDE"> 
  <td><b>上传头像类型：</b><br>
  允许上传的类型，每个字符用“@@”隔开</td><td><input type="text" name="uploadtype" style="WIDTH: 98%;" value="<%=Rs("Uploadtype")%>"></td></tr>
<tr bgcolor="#DEDEDE">
<td><b>头像上传大小限制：</b></td>
<td><input type="text" name="info19" size="5" value="<%=Info(19)%>"> KB</td></tr>
</table>

<a name="inc2"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">
	积分金钱设置 </font></b> <a href="#inc">▲</a></td>
  </tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛发贴：</b><br> 
  论坛发贴增加金钱</td><td width="64%"><input type="text" name="info37" size="5" value="<%=Info(37)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛回帖：</b><br> 
  论坛回帖增加金钱</td><td width="64%"><input type="text" name="info38" size="5" value="<%=Info(38)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛精华：</b><br> 
  论坛精华增加的参数</td><td width="64%">金钱 <input type="text" name="info39" size="2" value="<%=Info(39)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info40" size="2" value="<%=Info(40)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛精华：</b><br> 
  	取消精华减少的参数</td><td width="64%">金钱 <input type="text" name="info41" size="2" value="<%=Info(41)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info42" size="2" value="<%=Info(42)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛置顶：</b><br> 
  	论坛置顶增加的参数</td><td width="64%">金钱 <input type="text" name="info43" size="2" value="<%=Info(43)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info44" size="2" value="<%=Info(44)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛置顶：</b><br> 
  	取消置顶减少的参数</td><td width="64%">金钱 <input type="text" name="info45" size="2" value="<%=Info(45)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info46" size="2" value="<%=Info(46)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛区置顶：</b><br> 
  	论坛区置顶增加的参数</td><td width="64%">金钱 <input type="text" name="info47" size="2" value="<%=Info(47)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info48" size="2" value="<%=Info(48)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛区置顶：</b><br> 
  	取消区置顶减少的参数</td><td width="64%">金钱 <input type="text" name="info49" size="2" value="<%=Info(49)%>">&nbsp;&nbsp; YB
	<input type="text" name="info50" size="2" value="<%=Info(50)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛总置顶：</b><br> 
 	论坛总置顶增加的参数</td><td width="64%">金钱 <input type="text" name="info51" size="2" value="<%=Info(51)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info52" size="2" value="<%=Info(52)%>"> </td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>论坛总置顶：</b><br> 
  	取消总置顶减少的参数</td><td width="64%">金钱 <input type="text" name="info53" size="2" value="<%=Info(53)%>">&nbsp;&nbsp; 
	YB <input type="text" name="info54" size="2" value="<%=Info(54)%>"></td></tr>
<tr bgcolor="#DEDEDE"><td><b>醒目标题需要金钱：</b><br>
  当用户发送留言时扣取费用</td><td><input type="text" name="info13" size="6" value="<%=Info(13)%>"> 元</td></tr>
 
</table>


<a name="inc3"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">论坛显示设置 </font></b> <a href="#inc">▲</a></td>
  </tr>
<tr bgcolor="#DEDEDE"><td width="35%"><b>显示系统信息：</b><br> 
  包括首页公告、快速登陆</td><td><input type="radio" name="info7" value="0" <%if Info(7)="0" then%>checked<%end if%>> 是 <input type="radio" name="info7" value="1" <%if Info(7)="1" then%>checked<%end if%>> 否 </td></tr>
<tr bgcolor="#DEDEDE">
  <td><b>显示在线信息：</b><br> 
  包括各版的显示在线人数信息</td><td><input type="radio" name="info10" value="0" <%if Info(10)="0" then%>checked<%end if%>> 是  <input type="radio" name="info10" value="1" <%if Info(10)="1" then%>checked<%end if%>> 否 </td> </tr>
<tr bgcolor="#DEDEDE"><td><b>显示会员生日：</b><br>
  是否显示首页的会员生日信息</td><td><input type="radio" name="info32" value="0" <%if Info(32)="0" then%>checked<%end if%>> 是  <input type="radio" name="info32" value="1" <%if Info(32)="1" then%>checked<%end if%>> 否 </td></tr>
<tr bgcolor="#DEDEDE">
  <td><b>显示论坛联盟：</b><br> 
  是否显示论坛首页的友情连接</td><td><input type="radio" name="info8" value="0" <%if Info(8)="0" then%>checked<%end if%>> 是 <input type="radio" name="info8" value="1" <%if Info(8)="1" then%>checked<%end if%>> 否 </td></tr>
<tr bgcolor="#DEDEDE"><td><b>显示执行时间：</b><br> 
是否显示页面下部的加载时间</td><td><input type="radio" name="info33" value="1" <%if Info(33)="1" then%>checked<%end if%>> 以毫秒显示 <input type="radio" name="info33" value="2" <%if Info(33)="2" then%>checked<%end if%>> 以秒显示 <input type="radio" name="info33" value="0" <%if Info(33)="0" then%>checked<%end if%>> 不显示</td></tr></table>
<a name="inc4"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
  <tr  bgcolor="#CCCCCC"><td height="25" colspan="2" ><font color="#FFFFFF"><b>论坛系统数据设置</b> [以下信息一般不建议用户修改，带*号的在整理论坛时将会被自动修正]</font>
  <input name="sqlauto" type="checkbox" onclick="nocent();" value="checkbox" ><font color="#FFFFFF">修改 <a href="#inc">▲</a></font></td></tr>
<tr bgcolor="#DEDEDE"><td width="35%"><b>论坛会员总数 ：</b><br> 
  论坛注册用户总数</td><td><input type="text" name="usernum" size="20" value="<%=Rs("UserNum")%>" disabled> *</td></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛帖子总数：</b><br> 
  论坛所有的帖子总数</td><td><input type="text" name="allessaynum" size="20" value="<%=Rs("AllEssayNum")%>" disabled> *</td></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛主题总数：</b><br>
  论坛主题帖子总数</td><td><input type="text" name="topicnum" size="20" value="<%=Rs("TopicNum")%>" disabled> *</td></tr>
<tr bgcolor="#DEDEDE"><td><b> 论坛最高日发贴 ：</b><br>
  记录历史最高的日发贴</td><td><input type="text" name="maxessaynum" size="20" value="<%=Rs("MaxEssayNum")%>" disabled></td></tr>
<tr bgcolor="#DEDEDE"><td><b> 最高在线人数：</b><br> 
  历史最高同时在线纪录人数</td><td><input type="text" name="maxonlinenum" size="20" value="<%=Rs("MaxOnlineNum")%>" disabled></td></tr>
<tr bgcolor="#DEDEDE"><td><b>最高在线人数发生时间：</b><br>
  历史最高同时在线纪录人数的那个时间</td><td><input type="text" name="maxonlinetime" size="20" value="<%=Rs("MaxOnlineTime")%>" disabled> (格式：YYYY-M-D H:M:S)</td></tr></table>
  
  <a name="inc5"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">
	<span lang="zh-cn">用户信息</span>设置</font></b> <a href="#inc">▲</a></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>自定义头衔级别 ：</b></td><td width="64%">
	<input type="text" name="info25" size="5" value="<%=Info(25)%>"> 级</td></tr>
<tr bgcolor="#DEDEDE">
<td><b>头像上传等级限制：</b></td>
<td><input type="text" name="info35" size="5" value="<%=Info(35)%>"> 级</td></tr>
<tr bgcolor="#DEDEDE">
<td><b>文件上传等级限制：</b></td>
<td><input type="text" name="info36" size="5" value="<%=Info(36)%>"> 级 *如果想禁止上传，就设置21级</td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>允许个人签名：</b><br>
  是否允许帖子显示用户签名</td><td width="64%"><input type="radio" name="info12" value="0" <%if Info(12)="0" then%>checked<%end if%>> 是 <input type="radio" name="info12" value="1" <%if Info(12)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td width="34%"><b>新留言提示：</b><br>
  当用户有新留言时是否弹出提示</td><td width="64%"><input type="radio" name="info11" value="0" <%if Info(11)="0" then%>checked<%end if%>> 文字 <input type="radio" name="info11" value="1" <%if Info(11)="1" then%>checked<%end if%>> 弹出</td></tr>


<tr bgcolor="#DEDEDE"><td width="34%"><b>游客查看精华帖 ：</b><br>  
  是否允许游客浏览精华主题</td><td width="64%"><input type="radio" name="info34" value="0" <%if Info(34)="0" then%>checked<%end if%>> 是 <input type="radio" name="info34" value="1" <%if Info(34)="1" then%>checked<%end if%>> 否</td></tr>

<tr bgcolor="#DEDEDE"><td width="34%"><b>游客查看上传资源 ：</b><br>  
  是否允许游客浏览上传资源</td><td width="64%"><input type="radio" name="info55" value="1" <%if Info(55)="1" then%>checked<%end if%>> 是 <input type="radio" name="info55" value="0" <%if Info(55)="0" then%>checked<%end if%>> 否</td></tr>

<tr bgcolor="#DEDEDE"><td ><b>注册发送留言：</b><br>
  是否给新注册用户自动发送留言</td><td><input type="radio" name="info5" value="0" <%if Info(5)="0" then%>checked<%end if%>> 是 <input type="radio" name="info5" value="1" <%if Info(5)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td><b>注册发送留言内容：</b><br>
  给新注册用户自动发送留言的内容</td><td><textarea rows="3" name="regautosms" style="WIDTH: 100%;"><%=Rs("RegAutoSms")%></textarea> </td></tr>
<tr bgcolor="#DEDEDE"><td ><b>注册时限：</b><br>  
  同一用户来源2次注册的间隔时间<br>如果不想使用这项功能, 请设置为0 <br></td><td><input type="text" name="info28" size="5" value="<%=Info(28)%>" ONKEYPRESS='event.returnValue=(event.keyCode >= 48) && (event.keyCode <= 57);'> 分钟</td></tr>
<tr bgcolor="#DEDEDE"><td><b>登陆时限：</b><br>
  同一用户来源2次登陆的间隔时间<br>如果不想使用这项功能, 请设置为0 </td><td><input type="text" name="info29" size="5" value="<%=Info(29)%>"> 分钟</td></tr>
<tr bgcolor="#DEDEDE"><td ><b>发贴时限：</b><br>
  同一个用户发帖的间隔时间<br>如果不想使用这项功能, 请设置为0</td><td><input type="text" name="info30" size="5" value="<%=Info(30)%>"> 秒</td></tr>
<tr bgcolor="#DEDEDE"><td><b>编辑帖子时限：</b><br>
  普通用户可以编辑帖子的有效时间<br>如果不想使用这项功能, 请设置为0</td><td><input type="text" name="info31" size="5" value="<%=Info(31)%>"> 分钟 </td></tr>
</table>


<a name="inc6"></a><br>
<table width="98%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#FFFFFF">
<tr bgcolor="#CCCCCC"><td height="25" colspan="2" ><b><font color="#FFFFFF">论坛系统设置</font></b> <a href="#inc">▲</a></td>
</tr>
<tr bgcolor="#DEDEDE"><td width="35%"><b>版主继承：</b><br> 
  设定上级版主可以管理下级子论坛</td><td><input type="radio" name="info1" value="0" <%if Info(1)="0" then%>checked<%end if%>> 是 <input type="radio" name="info1" value="1" <%if Info(1)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td ><b>禁止注册的用户名：</b><br>
  用于过滤用户名和头衔称号<br> 每个字符请用“@@”隔开</td><td><input type="text" style="WIDTH: 98%;" name="badname" value="<%=Rs("BadName")%>"></td></tr>
<tr bgcolor="#DEDEDE"><td><b>帖子过滤脏字：</b><br>
  帖子字符过滤后用被“*”代替<br>每个字符请用“@@”隔开</td><td><input type="text" style="WIDTH: 98%;" name="badessay" value="<%=Rs("BadEssay")%>"></td></tr>

<tr bgcolor="#DEDEDE">
  <td ><b>登录验证码：</b><br>
  是否在用户登录验时输入验证码<br>防止机器登陆</td><td><input type="radio" name="info6" value="0" <%if Info(6)="0" then%>checked<%end if%>> 是 <input type="radio" name="info6" value="1" <%if Info(6)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td><b>在线超时：</b><br>
  设定论坛在线人数统计超时</td><td><input type="text" name="info27" size="5" value="<%=Info(27)%>"> 分钟 </td></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛分页显示条数：</b><br> 
  设定每页显示最大记录</td><td><input type="text" name="info26" size="5" value="<%=Info(26)%>"> 条</td></tr>
<tr bgcolor="#DEDEDE"><td><b>识别网址：</b><br>
  自动识别帖子上的网址</td><td><input type="radio" name="info9" value="0" <%if Info(9)="0" then%>checked<%end if%>> 是 <input type="radio" name="info9" value="1" <%if Info(9)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td><b>成为热帖的最低人气值：</b><br>
  热门话题标准为主题回复数</td><td><input type="text" name="info24" size="5" value="<%=Info(24)%>"> 条</td></tr>
<tr bgcolor="#DEDEDE"><td><b>论坛头像个数：</b><br>
  设定论坛自带头像的数目</td><td><input type="text" name="info14" size="5" value="<%=Info(14)%>"> 个</td></tr>
<tr bgcolor="#DEDEDE"><td><b>头像最大寸尺：</b><br>
  头像的最大高度和宽度</td><td><input type="text" name="info15" size="5" value="<%=Info(15)%>"> 像素</td></tr>
<tr bgcolor="#DEDEDE"><td><b>头像默认宽度：</b><br>
  头像的默认寸尺宽度</td><td><input type="text" name="info16" size="5" value="<%=Info(16)%>"> 像素</td></tr>
<tr bgcolor="#DEDEDE"><td><b>头像默认高度：</b><br>
  头像的默认寸尺高度</td><td><input type="text" name="info17" size="5" value="<%=Info(17)%>"> 像素 </tr>

<tr bgcolor="#DEDEDE"><td ><b>投票限制条数 ：</b><br>  
  设定用户发投票主题的最大数目</td><td><input type="text" name="info23" size="6" value="<%=Info(23)%>"> 条</td></tr>
<tr bgcolor="#DEDEDE"><td><b>是否开启帖图标签 ：</b><br>
  帖子显示图片</td><td><input type="radio" name="info22" value="0" <%if Info(22)="0" then%>checked<%end if%>> 是 <input type="radio" name="info22" value="1" <%if Info(22)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td ><b>是否其它站图片 ：</b><br>
  允许从其他站点链接如Http://...<br></td><td><input type="radio" name="info21" value="0" <%if Info(21)="0" then%>checked<%end if%>> 是 <input type="radio" name="info21" value="1" <%if Info(21)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#DEDEDE"><td><b>是否开启Flash标签 ：</b><br> 
  帖子显示Flash动画</td><td><input type="radio" name="info20" value="0" <%if Info(20)="0" then%>checked<%end if%>> 是 <input type="radio" name="info20" value="1" <%if Info(20)="1" then%>checked<%end if%>> 否</td></tr>
<tr bgcolor="#CCCCCC"><td colspan="2"  align="center"><input type="submit" value="确定修改">&nbsp;&nbsp;<input type="reset" value="重 置">&nbsp;<a href="#inc">▲</a></td></tr></table>
</form>
<SCRIPT>
function nocent()
{
	if(document.form.usernum.disabled==true)
	{
		document.form.usernum.disabled=false;
		document.form.allessaynum.disabled=false;
		document.form.topicnum.disabled=false;
		document.form.maxessaynum.disabled=false;
		document.form.maxonlinenum.disabled=false;
		document.form.maxonlinetime.disabled=false;
		}
	else
	{
		document.form.usernum.disabled=true;
		document.form.topicnum.disabled=true;
		document.form.maxessaynum.disabled=true;
		document.form.allessaynum.disabled=true;
		document.form.maxonlinenum.disabled=true;
		document.form.maxonlinetime.disabled=true;
	}}
</SCRIPT>
<%
Rs.Close 
End Sub

Sub ConfigSave
	Dim BBSName,BBSUrl,BBSClose,CloseInfo,BBSbanner,CopyRight,I,Temp,IsOpen,UserNum,UploadType,BuildDate,AllEssayNum,TopicNum,MaxEssayNum,MaxOnlineNum,MaxOnlineTime,BadName,BadEssay,RegAutoSms
	IsOpen=False
	Temp=""
	For i=0 to 55
		IF i=0 or i=1 Then
			IF YxBBs.Fun.GetStr("info"&i)="" Then
				Call GoBack("","")
				Exit Sub
			End if
			If Not YxBBs.Fun.isInteger(YxBBs.Fun.GetStr("info"&i)) then
				Call GoBack("","一些参数必须填为正整数，否则论坛不能正常运行。")
				Exit Sub
			End if
		End if
		Temp=Temp&YxBBs.Fun.GetStr("info"&i)&"|"
	Next
	BBSName=YxBBs.Fun.GetStr("BBSName")
	BBSUrl=YxBBs.Fun.GetStr("BBSUrl")
	BBSClose=YxBBs.Fun.GetStr("BBSClose")
	CloseInfo=YxBBs.Fun.GetStr("CloseInfo")
	BBSbanner=YxBBs.Fun.GetStr("BBSBanner")
	CopyRight=YxBBs.Fun.GetStr("CopyRight")
	BuildDate=YxBBs.Fun.GetStr("builddate")
	UploadType=YxBBs.Fun.GetStr("uploadtype")
	BadName=YxBBs.Fun.GetStr("badname")
	BadEssay=YxBBs.Fun.GetStr("badessay")
	RegAutoSms=YxBBs.Fun.GetStr("regautosms")
	IF Request.form("sqlauto")<>"" Then
		IsOpen=True
		UserNum=YxBBs.Fun.GetStr("usernum")
		AllEssayNum=YxBBs.Fun.GetStr("allessaynum")
		TopicNum=YxBBs.Fun.GetStr("topicnum")
		MaxEssayNum=YxBBs.Fun.GetStr("maxessaynum")
		MaxOnlineNum=YxBBs.Fun.GetStr("maxonlinenum")
		MaxOnlineTime=YxBBs.Fun.GetStr("maxonlinetime")
		If  Not YxBBs.Fun.isInteger(UserNum) Or Not YxBBs.Fun.isInteger(AllEssayNum) or Not YxBBs.Fun.isInteger(TopicNum) or Not YxBBs.Fun.isInteger(MaxEssayNum) or Not YxBBs.Fun.isInteger(MaxOnlineNum) Then
			Call GoBack("","一些参数必须填为正整数，否则论坛不能正常运行。")
		End if
	End If
	IF IsOpen Then
		YxBBs.execute("update [YX_Config] set BBSName='"&BBSName&"',BBSUrl='"&BBSUrl&"',BBSClose="&BBSClose&",CloseInfo='"&CloseInfo&"',BBSBanner='"&BBSBanner&"',CopyRight='"&CopyRight&"',Info='"&Temp&"',UpLoadtype='"&UploadType&"',BuildDate='"&BuildDate&"',BadName='"&BadName&"',BadEssay='"&BadEssay&"',RegAutoSms='"&RegAutoSms&"',UserNum="&UserNum&",AllEssayNum="&AllEssayNum&",TopicNum="&TopicNum&",MaxEssayNum="&MaxEssayNum&",MaxOnlineNum="&MaxOnlineNum&",MaxOnlineTime='"&MaxOnlineTime&"'")
	Else
		YxBBs.execute("update [YX_Config] set BBSName='"&BBSName&"',BBSUrl='"&BBSUrl&"',BBSClose="&BBSClose&",CloseInfo='"&CloseInfo&"',BBSBanner='"&BBSBanner&"',CopyRight='"&CopyRight&"',Info='"&Temp&"',UpLoadtype='"&UploadType&"',BuildDate='"&BuildDate&"',BadName='"&BadName&"',BadEssay='"&BadEssay&"',RegAutoSms='"&RegAutoSms&"'")
	End If
	Call Suc("修改成功","论坛名称以及其他参数修改成功","System.Asp")
	Cache.Name="Config"
	Cache.Clean()
End Sub
%>