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
<%
rem ��ӹ���Ա
dim sAction
sAction = request.querystring.item("action")
if sAction = "a" then
	' �ȼ�����
	dim sAccount, sName, sPwd, sPwd2
	sAccount = trim(request.form.item("account"))
	sName    = trim(request.form.item("truename"))
	sPwd     = trim(request.form.item("pwd1"))
	sPwd2    = trim(request.form.item("pwd2"))
	if len(sAccount)<5 or len(sAccount)>16 or instr(sAccount,"'")>0 or len(sName)<1 or instr(sName,"'")>0 or len(sPwd)<6 or len(sPwd)>16 or sPwd<>sPwd2 then
		response.write "<script language='javascript'>"
		response.write "alert('�ύ�����ݲ��Ϸ�, ����Ա���ʧ��.');"
		response.write "window.location = 'admin_add.asp';"
		response.write "</script>"
		response.end
	end if
	sPwd = replace(sPwd, "'", "''")
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
	dim objConn
	if bDBConnection(objConn)=false then
		response.write "�������ݿ�ʧ��."
		response.end
	end if

	dim bAddFlag
	bAddFlag = true

	dim sSQL
	sSQL = "insert into tAdmins(admin_account,admin_name,admin_pwd) values('" & sAccount & "','" & sName & "','" & sPwd & "');"
	on error resume next
	objConn.execute sSQL
	if err.number<>0 then bAddFlag = false
	on error goto 0

	vDBDisConn(objConn)
	if bAddFlag = true then
		response.write "<script language='javascript'>"
		response.write "alert('��ӹ���Ա�ɹ�.\n');"
		response.write "window.location = 'admin_show.asp';"
		response.write "</script>"
	else
		response.write "<script language='javascript'>"
		response.write "alert('��ӹ���Աʧ��, ��ȷ�ϴ˹���Ա�û����Ƿ��Ѿ�����.');"
		response.write "window.location = 'admin_add.asp';"
		response.write "</script>"
	end if

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

function OnSubmit()
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
<h1>��ӹ���Ա</h1>
<form id="frmAdd" action="admin_add.asp?action=a" method="post">
  <table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline" align="center">
	<tr>
	  <th class="thHead" colspan="2">��ӹ���Ա</th>
	</tr>
	<tr>
	  <td class="row1">����Ա�û���</td>
	  <td class="row2"><input type="text" size="25" id="account" name="account" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">����Ա����</td>
	  <td class="row2"><input type="text" size="25" id="truename" name="truename" value="" maxlength="10" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">����</td>
	  <td class="row2"><input type="password" size="25" id="pwd1" name="pwd1" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="row1">ȷ������</td>
	  <td class="row2"><input type="password" size="25" id="pwd2" name="pwd2" value="" maxlength="16" class="post" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center">
	    <input type="button" name="btnSub" value="���" class="mainoption" onclick="OnSubmit();" />
	    <input type="reset" name="btnReset" value="����" class="mainoption" />
	  </td>
	</tr>
  </table>
</form>
</body>
</html>

