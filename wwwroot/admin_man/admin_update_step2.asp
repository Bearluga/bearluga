<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css" />
<title>��ӹ���Ա - ���߱��ռ���̨����</title>
<!--#include file = "..\include\dbconnection.asp" -->
<%
dim sAccount
dim objConn
if bDBConnection(objConn)=false then
	response.write "�������ݿ�ʧ��."
	response.end
end if

dim sTrueName
dim sSQL

rem �����ύ�޸�����
dim sAction
sAction = request.querystring.item("action")
if sAction = "u" then
	sAccount  = request.form.item("account")
	sTrueName = request.form.item("truename")
	dim sPwd, sPwd2
	sPwd      = request.form.item("pwd1")
	sPwd2     = request.form.item("pwd2")

	' У������
	if len(sAccount)<5 or len(sAccount)>16 or instr(sAccount,"'")>0 or len(sTrueName)<1 or instr(sTrueName,"'")>0 or len(sPwd)<6 or len(sPwd)>16 or sPwd<>sPwd2 then
		response.write "<script language='javascript'>"
		response.write "alert('�ύ�����ݲ��Ϸ�, ����Ա��Ϣ�޸�ʧ��.');"
		response.write "window.location = 'admin_update_step2.asp?account=" & sAccount & "';"
		response.write "</script>"
		response.end
	end if
	sPwd = replace(sPwd, "'", "''")
	sSQL = "update tAdmins set admin_name='" & sTrueName & "'"
	if sPwd <> "******" then sSQL = sSQL & ",admin_pwd='" & sPwd & "'"
	sSQL = sSQL & " where admin_account='" & sAccount & "';"

	response.write "<script language='javascript'>"
	on error resume next
	objConn.execute sSQL
	if err.number=0 then
		response.write "alert('�޸Ĺ���Ա��Ϣ�ɹ�.\n');"
	else
		response.write "alert('�޸Ĺ���Ա��Ϣʧ��.');"
	end if
	response.write "window.location = 'admin_update_step1.asp';"
	response.write "</script>"
	on error goto 0
	call vDBDisConn(objConn)
	response.end
end if

rem �����������admin_update_step1.asp���������û���, ��ʾ��������, ���û��޸�
sAccount = trim(request.querystring.item("account"))
if len(sAccount)<1 then
	response.write "<script language='javascript'>"
	response.write "window.alert('���ύ�����ݲ��Ϸ�.');"
	response.write "window.location='admin_update_step1.asp';"
	response.write "</script>"
	response.end
end if

sTrueName = ""
sSQL = "select top 1 admin_name from tAdmins where admin_account='" & sAccount & "';"
dim objRs
set objRs = server.createobject("adodb.recordset")
objRs.open sSQL, objConn, 0, 1
if not(objRs.eof and objRs.bof) then
	sTrueName = objRs.fields(0)
end if
objRs.close
set objRs = nothing

if len(sTrueName)<1 then
	response.write "<script language='javascript'>"
	response.write "window.alert('�Ҳ����˹���Ա.');"
	response.write "window.location='admin_update_step1.asp';"
	response.write "</script>"
	response.end
end if
%>
<script language="javascript">
function len(str)
{
  var nLen = 0;
  for( var n=0; n<str.length; n++ )
  {
    if( str.charAt(n) <= '~' )
      nLen += 1;
    else
      nLen += 2;
  }
  return nLen;
}

function OnUpdate()
{
	var account  = document.getElementById("account").value;
	var truename = document.getElementById("truename").value;
	var pwd1     = document.getElementById("pwd1").value;
	var pwd2     = document.getElementById("pwd2").value;
	
	if ( len(account)<5 || len(account)>16 )
	{	
		alert("����Ա�û�������Ӧ����5��16�ֽ�֮��,�������������Ա�û���");
		document.getElementById("account").focus();
		return false;
	}
	if ( len(truename)<1 )
	{
		alert("����Ա��������Ϊ��.");
		document.getElementById("truename").focus();
		return false;
	}
	if ( len(pwd1)<6 || len(pwd2)>16 )
	{
		alert("���볤��Ӧ����6��16�ֽ�֮��,��������������");
		document.getElementById("pwd1").focus();
		return false;
	}
	if ( pwd1 != pwd2 )
	{
		alert("�����������벻��ͬ�������������û�����.");
		document.getElementById("pwd1").focus();
		return false;
	}
	
	document.getElementById("frmAdd").submit();
	return true;
}
</script>

</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<h1>�޸Ĺ���Ա</h1>
<form id="frmAdd" action="admin_update_step2.asp?action=u" method="post">
  <table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline" align="center">
	<tr>
	  <th class="thHead" colspan="2">�޸Ĺ���Ա</th>
	</tr>
	<tr>
	  <td class="row1">����Ա�û���</td>
	  <td class="row2"><input type="text" size="25" id="account" name="account" value="<%=sAccount%>" maxlength="16" class="post" readonly/> <span style="color:#555">(ע:����Ա�û��������޸�)</span></td>
	</tr>
	<tr>
	  <td class="row1">����Ա����</td>
	  <td class="row2"><input type="text" size="25" id="truename" name="truename" value="<%=sTrueName%>" maxlength="10" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">����</td>
	  <td class="row2"><input type="password" size="25" id="pwd1" name="pwd1" value="******" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">ȷ������</td>
	  <td class="row2"><input type="password" size="25" id="pwd2" name="pwd2" value="******" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center">
	    <input type="button" name="btnSub" value="�޸�" class="mainoption" onclick="OnUpdate();" />
	    <input type="reset" name="btnReset" value="����" class="mainoption" />
	  </td>
	</tr>
  </table>
</form>
</body>
</html>


