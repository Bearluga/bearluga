<!--#include file="Check.Asp"-->
<%
Dim action,ClassID,BoardID,BoardSetting,Sql

action=Request("action")

If action="edit" Then
	Call EditBoardSetting
Else
	Call Main
End if

Sub EditBoardSetting
BoardID=Request.form("BoardID")
IF BoardID="" or not isNumeric(BoardID) then
	Call GoBock("错误提示","参数错误码，请确认正确的参数！")
	Exit sub
End if

BoardSetting=Request.form("TopicCode") & "," & Request.form("UpLoadType") & "," & Request.form("TopicMaxLong") & "," & Request.form("ArticleMaxLong") & "," & Request.form("BoardMaxVote") & "," & Request.form("UserMinPost") & "," & Request.form("UserMinRemark") & "," & Request.form("UserMinMoneys") & "," & Request.form("UserMinLoginTimes") & "," & Request.form("UserMinDigestNum") & "," & Request.form("UserMinRegTime")
Dim Rs
Set Rs=Server.CreateObject("Adodb.Recordset")
sql="select * from YX_Board where BoardID="& BoardID
rs.open sql,conn,1,3
If not (rs.eof and rs.bof) then
	rs("BoardSetting")=BoardSetting
	rs.update
Else
	Call GoBock("错误提示","没有此版块，或者已被删除！")
	Exit sub
End if
rs.close
Set rs=nothing
Cache.name="BoardInfo":Cache.clean()
Call Suc("","版块权限设置成功!","Board.Asp")
End sub

Sub Main
dim BoardID,BoardName,BoardSetting,Rs
BoardID=Request("BoardID")
if Not IsNumeric(ClassID) then
	Call GoBock("错误提示","参数错误，请提交正确的参数！")
	Exit sub
end if

set rs=Conn.execute("Select BoardID,BoardName,BoardSetting from YX_Board where BoardID="& BoardID)
if rs.eof or rs.bof then
	Call GoBock("错误提示","找不到此版块或已被删除！")
	Exit sub
else
	BoardName=rs("BoardName")
	BoardSetting=split(rs("BoardSetting"),",")
%>
 <form action="?action=edit" method=post name="creator">
	<table cellpadding=6 cellspacing=1 border=0 width=95% bgcolor="#FFFFFF" align="center">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center height="14"><font color="#800000"><b>设 置 版 块 权 限</b></font></td></tr>
 		<tr>
		<td bgcolor=#d7d7d7 width="35%" height="20">版块名称</td>		
		<td bgcolor=#d7d7d7 height="20"><INPUT TYPE="hidden" name="BoardID" value="<%=BoardID%>" readonly>
		<input name="BoardName" size="20" value="<%=BoardName%>" style="width: 128; height: 18">　</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2" height="14"><font color="#000077"><b>版块相关</b></font></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">发贴使用验证码</td>
		<td bgcolor=#d7d7d7 height="20">是<input name="TopicCode" type="radio" value="1" <%if BoardSetting(0)=1 then response.write "checked"%>>&nbsp;否<input name="TopicCode" type="radio" value="0" <%if BoardSetting(0)=0 then response.write "checked"%>></td>
		</tr>
		<tr>
          <td bgcolor=#d7d7d7 height="20">上传类型</td>
          <td bgcolor=#d7d7d7 height="20">
            <input name="UpLoadType" size="20" value="<%=BoardSetting(1)%>"></td>
	  </tr>
		<tr>
		<td bgcolor=#d7d7d7 height="20">主题限制长度</td>
		<td bgcolor=#d7d7d7 height="20">
		<input name="TopicMaxLong" size="20" value="<%=BoardSetting(2)%>"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="26">帖子内容最大字节数</td>		
		<td bgcolor=#d7d7d7 height="26">
		<input name="ArticleMaxlong" size="20" value="<%=BoardSetting(3)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">最多投票项目</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="BoardMaxVote" size="20" value="<%=BoardSetting(4)%>" ></td>
		</tr>
		<tr>
		<td bgcolor=#E7E7E7 colspan="2" height="14"><font color="#000077"><b>用户相关</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">用户至少文章数</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinPost" size="20" value="<%=BoardSetting(5)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">用户至少积分</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinRemark" size="20" value="<%=BoardSetting(6)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">用户至少金钱</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinMoneys" size="20" value="<%=BoardSetting(7)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">登陆次数至少几次</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinLoginTimes" size="20" value="<%=BoardSetting(8)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">用户至少精华文章</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinDigestNum" size="20" value="<%=BoardSetting(9)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">至少注册时间（单位为分钟）</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinRegTime" size="20" value="<%=BoardSetting(10)%>" ></td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center height="20">
		<input type="submit" value="修 改" name="B1"></td></tr>
	</table>
</form>
<%
end if
End sub

AdminFooter()
%>