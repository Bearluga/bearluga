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
	Call GoBock("������ʾ","���������룬��ȷ����ȷ�Ĳ�����")
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
	Call GoBock("������ʾ","û�д˰�飬�����ѱ�ɾ����")
	Exit sub
End if
rs.close
Set rs=nothing
Cache.name="BoardInfo":Cache.clean()
Call Suc("","���Ȩ�����óɹ�!","Board.Asp")
End sub

Sub Main
dim BoardID,BoardName,BoardSetting,Rs
BoardID=Request("BoardID")
if Not IsNumeric(ClassID) then
	Call GoBock("������ʾ","�����������ύ��ȷ�Ĳ�����")
	Exit sub
end if

set rs=Conn.execute("Select BoardID,BoardName,BoardSetting from YX_Board where BoardID="& BoardID)
if rs.eof or rs.bof then
	Call GoBock("������ʾ","�Ҳ����˰����ѱ�ɾ����")
	Exit sub
else
	BoardName=rs("BoardName")
	BoardSetting=split(rs("BoardSetting"),",")
%>
 <form action="?action=edit" method=post name="creator">
	<table cellpadding=6 cellspacing=1 border=0 width=95% bgcolor="#FFFFFF" align="center">
	<tr>
	<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center height="14"><font color="#800000"><b>�� �� �� �� Ȩ ��</b></font></td></tr>
 		<tr>
		<td bgcolor=#d7d7d7 width="35%" height="20">�������</td>		
		<td bgcolor=#d7d7d7 height="20"><INPUT TYPE="hidden" name="BoardID" value="<%=BoardID%>" readonly>
		<input name="BoardName" size="20" value="<%=BoardName%>" style="width: 128; height: 18">��</td>
		</tr><tr>
		<td bgcolor=#E7E7E7 colspan="2" height="14"><font color="#000077"><b>������</b></font></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">����ʹ����֤��</td>
		<td bgcolor=#d7d7d7 height="20">��<input name="TopicCode" type="radio" value="1" <%if BoardSetting(0)=1 then response.write "checked"%>>&nbsp;��<input name="TopicCode" type="radio" value="0" <%if BoardSetting(0)=0 then response.write "checked"%>></td>
		</tr>
		<tr>
          <td bgcolor=#d7d7d7 height="20">�ϴ�����</td>
          <td bgcolor=#d7d7d7 height="20">
            <input name="UpLoadType" size="20" value="<%=BoardSetting(1)%>"></td>
	  </tr>
		<tr>
		<td bgcolor=#d7d7d7 height="20">�������Ƴ���</td>
		<td bgcolor=#d7d7d7 height="20">
		<input name="TopicMaxLong" size="20" value="<%=BoardSetting(2)%>"></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="26">������������ֽ���</td>		
		<td bgcolor=#d7d7d7 height="26">
		<input name="ArticleMaxlong" size="20" value="<%=BoardSetting(3)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">���ͶƱ��Ŀ</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="BoardMaxVote" size="20" value="<%=BoardSetting(4)%>" ></td>
		</tr>
		<tr>
		<td bgcolor=#E7E7E7 colspan="2" height="14"><font color="#000077"><b>�û����</b></font></td>		
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">�û�����������</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinPost" size="20" value="<%=BoardSetting(5)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">�û����ٻ���</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinRemark" size="20" value="<%=BoardSetting(6)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">�û����ٽ�Ǯ</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinMoneys" size="20" value="<%=BoardSetting(7)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">��½�������ټ���</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinLoginTimes" size="20" value="<%=BoardSetting(8)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">�û����پ�������</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinDigestNum" size="20" value="<%=BoardSetting(9)%>" ></td>
		</tr><tr>
		<td bgcolor=#d7d7d7 height="20">����ע��ʱ�䣨��λΪ���ӣ�</td>		
		<td bgcolor=#d7d7d7 height="20">
		<input name="UserMinRegTime" size="20" value="<%=BoardSetting(10)%>" ></td>
		</tr><tr>
		<td bgcolor=#e7e7e7 valign=middle colspan=2 align=center height="20">
		<input type="submit" value="�� ��" name="B1"></td></tr>
	</table>
</form>
<%
end if
End sub

AdminFooter()
%>