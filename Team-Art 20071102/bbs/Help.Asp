<!--#include file="Inc/SysConfig.Asp"-->
<%
Dim Content
YxBBs.Head("查看论坛帮助")
Select Case Request.QueryString("Action")
Case "ubb"
	ubb
Case "Grade"
	Grade
Case Else
	Main
End Select
YxBBs.Footer()
Set YxBBs=Nothing

Sub Main
	Dim Content
Content="<br><br><b>  === 常规帮助 ===</b>"&_
	"<ul><li><b>问：怎样才能加入论坛？</b></li>"&_
"<ul><li>答：您可以点击论坛顶部的'注册'注册为本站会员,请将必填资料认真填写效,以便您能正常注册和使用密码找回功能.</li>"&_
        "<li>您当然可以不必注册为我们的会员,但是为了您能够使用本论坛的全部功能,我们仍建议您注册.</li></ul></ul>"&_
	"<ul><li><b>怎样才能知道自己的积分和积分的排名情况？</b></li>"&_
	"<ul><li>只要在论坛里找到自己的用户名，点击即可查看自己的积分。</li>"&_
	"<li>对于论坛排名，您可以通过点论坛菜单的<a href=Members.Asp>用户列表</a>查看。</li></ul></ul>"&_
	"<ul><li><b>怎样才能在帖子后加上签名？ </b></li>"&_
	"<ul><li>您可以通过论坛顶部“YourName”下“修改资料”个性签名一栏中写入您的个性签名。</li>"&_
	"<li>签名支持UBB，可以使用图片，格式是[img]图片地址[/img]。</li></ul></ul>"&_
	"<ul><li><b>如何快速找到需要的文章？</b></li>"&_
	"<ul><li>您可以使用论坛的搜索功能，搜索整个论坛您可以在“面版”下的“<a href=Search.Asp>论坛搜索</a>”内写入满足的条件即可搜索。</li>"&_
        "<li>另外在各版面下方也可以按照帖子内容搜索。还可以选择使用“今日新帖”、“一周内新帖”、“最旺人气帖”、“最旺回复帖”等进行简易搜索。</li></ul></ul>"&_
	"<ul><li><b>什么是精华区？帖子是谁将它加入精华区的？如何查看？</b>"&_
	"<ul><li>精华区是论坛版面存放相对有价值，技术含量较高或内容比较有意义的帖子的，网友通常可以在精华区内找到很多有用的东西。本论坛的每个版面都有自己的精华区。精华区由版主管理。版主可以将版面上的帖子加入到精华区。并可编辑进行再加工。</li>"&_
	"<li>只要进入相关版面，在版面的右上方就可以看到”本版精华“字样，点击即可查看；在“面版”下也有一个“精华区”，那是全部论坛的精华所在，不建议您以此种方式查看，如果您想找相关精华请到相关版面查找。</li></ul></ul>"&_
	"<ul><li><b>成为版主的条件是什么？有哪些权利？</b></li>"&_
	"<ul><li>版主当然有所见长之处，并且为人热心，愿意为网友无偿服务。</li>"&_
	"<li>拥有一定群众基础，能花时间维护论坛的。</li>"&_
	"<li>版主可以查询版面的帖子，可以任意删除或编辑版面的帖子。</li>"&_
	"<li>版主可以把帖子加锁（解锁），置顶（解除置顶），提升和沉底帖子，加入精华区（解除精华），发布版面公告。</li>"&_ 
	"<li>版主可以在所属版面上发布或删除公告。</li>"&_
	"<li>如果论坛开启了版主继承功能，上级版主还可以管理下级论坛的帖子。</li></ul></ul>"&_
        "<ul><li><b>遗忘了密码怎么办？</b></li>"&_
       "<ul><li>如果遗忘密码，你可以用注册时填写的密码问题和密码答案来<a href=UserSetup.Asp?Action=ForgetPassword>取回密码</a>。</ul><ul><li>如果你忘记了密码提示和密码答案，请与论坛管理员联系，由他（她）来为你设定新的密码。</li></ul><br>"&_
"<br><li><font face=Wingdings color=#9ec750>v</font><a href=?Action=ubb><font color=red><b>相关帮助：帖子标签帮助</b></font></a></li><font face=Wingdings color=#9ec750>v</font><br><li><font face=Wingdings color=#9ec750>v</font><a href=?Action=Grade><font color=red><b>相关帮助：论坛等级帮助</b></font></a><font face=Wingdings color=#9ec750>v</font></li></ul></blockquote>"
Call YxBBs.ShowTable("常规帮助",Content)
End sub

sub ubb
Content=Content&"<br><br><b>=== UBB标签帮助 ===</b>"&_
	"<ul><li><b>UBB标签就是不允许使用HTML语法的情况下，通过论坛的特殊转换程序，以至可以支持少量常用的、无危害性的HTML效果显示。以下为具体使用说明：</b></li>"&_
	"<ul><li><p><font color=red>[B]</font><b>文字</b><font color=red>[/B]</font><br>在文字的位置可以任意加入您需要的字符，显示为粗体效果。</li>"&_
	"<p><li><font color=red>[I]</font><i>文字</i><font color=red>[/I]</font><br>在文字的位置可以任意加入您需要的字符，显示为斜体效果。</li>"&_
	"<p><li><font color=red>[U]</font><u>文字</u><font color=red>[/U]</font><br>在文字的位置可以任意加入您需要的字符，显示为下划线效果。</li>"&_
	"<p><li><font color=red>[align=center]</font>文字<font color=red>[/align]</font><br>在文字的位置可以任意加入您需要的字符，center位置center表示居中，left表示居左，right表示居右。</li>"&_
	"<p><li><A HREF='http://www.yimxu.com/'><font color=red>http://www.yimxu.com</font></A><br>直接输入网址，论坛会自动识别</li>"&_
	"<P><li><font color=red>[URL=http://www.yimxu.com]</font><A HREF=http://www.yimxu.com>Y网</A><font color=red>[/URL]</font>：<br>或则你也可以连接具体地址或者文字连接。</li>"&_
	"<P><li><font color=red>[EMAIL]</font><A HREF=""mailto:abc@abc.com"">abc@abc.com</A><font color=red>[/EMAIL]</font><br></li>"&_
	"<font color=red>[EMAIL=MAILTO:abc@abc.com]</font><A HREF=""mailto:abc@abc.com"">信箱</A><font color=red>[/EMAIL]</font>：<br>有两种方法可以加入邮件连接，可以连接具体地址或者文字连接。</li>"&_
	"<P><li><font color=red>[img]</font>http://www.yimxu.com/logo.gif<font color=red>[/img]</font><br>在标签的中间插入图片地址可以实现插图效果。</li>"&_
	"<P><li><font color=red>[flash]</font>Flash连接地址<font color=red>[/Flash]</font><br>在标签的中间插入Flash图片地址可以实现插入Flash。</li>"&_
	"<P><li><font color=red>[code]</font>文字<font color=red>[/code]</font><br>在标签中写入文字可实现html中编号效果。</li>"&_
	"<P><li><font color=red>[fly]</font>文字<font color=red>[/fly]</font><br>在标签的中间插入文字可以实现文字飞翔效果，类似跑马灯。</li>"&_
	"<P><li><font color=red>[move]</font>文字<font color=red>[/move]</font><br>在标签的中间插入文字可以实现文字移动效果，为来回飘动。</li>"&_
	"<P><li><font color=red>[light]</font>文字<font color=red>[/light]</font><br>在标签的中间插入文字可以实现文字五颜六色的闪光特效。</li>"&_
	"<P><li><font color=red>[shadow=255,red,2]</font>文字<font color=red>[/shadow]</font><br>在标签的中间插入文字可以实现文字阴影特效，shadow内属性依次为宽度、颜色和边界大小。</li>"&_
	"<P><li><font color=red>[color=颜色代码]</font>文字<font color=red>[/color]</font><br>输入您的颜色代码，在标签的中间插入文字可以实现文字颜色改变。</li>"&_
	"<P><li><font color=red>[size=数字]</font>文字<font color=red>[/size]</font><br>输入您的字体大小，在标签的中间插入文字可以实现文字大小改变。</li>"&_
	"<P><li><font color=red>[face=字体]</font>文字<font color=red>[/face]</font><br>输入您需要的字体，在标签的中间插入文字可以实现文字字体转换。</li>"&_
	"<P><li><font color=red>[em1]</font><br>论坛心情图片代码。其中的数字1到X之间是图片代码。</ul><br>"&_
        "<li><font face=Wingdings color=#9ec750>v</font><a href=?Action=main><font color=red><b>相关帮助：论坛基本帮助</b></font></a></li><font face=Wingdings color=#9ec750>v</font><br><li><font face=Wingdings color=#9ec750>v</font><a href=?Action=Grade><font color=red><b>相关帮助：论坛等级帮助</b></font></a><font face=Wingdings color=#9ec750>v</font></li><br><br>"
	 Call YxBBs.ShowTable("UBB标签",Content)
End sub
sub Grade
Dim Rs
	Content="<tr><td height=25>会员等级</td><td>等级称号</td><td>所需帖数</td><td>等级图片</td></tr>"
	Set Rs=YxBBs.Execute("Select GradeNum,GradeName,GradePic,UserMinPostNum from YX_UserGrade Order By GradeNum")
	Do while Not Rs.eof
		Content=Content&"<tr><td height=25>"&Rs(0)&"</td><td>"&Rs(1)&"</td><td>"&Rs(3)&"</td><td><img src="""&Rs(2)&"""></td></tr>"
		Rs.MoveNext
	Loop
	Content=Content&"<tr><td colspan=4>&nbsp;&nbsp;特别说明：<br>&nbsp;&nbsp;<b><font color=red>18</font></b>级为论坛版主<br>&nbsp;&nbsp;<b><font color=red>19</font></b>级为前台管理员<br>&nbsp;&nbsp;<b><font color=red>20</font></b>级为论坛站长<br> </font><br><br><li><font face=Wingdings color=#9ec750>v</font><a href=?Action=main><b>相关帮助：论坛基本帮助</b></a></li><font face=Wingdings color=#9ec750>v</font><br><li><font face=Wingdings color=#9ec750>v</font><a href=?Action=ubb><b>相关帮助：帖子标签帮助</b></a><font face=Wingdings color=#9ec750>v</font></li><br><br>"
    Call YxBBs.ShowTable("论坛等级",Content)
End sub
%>