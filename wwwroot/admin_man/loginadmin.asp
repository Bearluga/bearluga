<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<%

rem ����Ա��¼����

rem ����Ѿ���¼, ֱ����ת��index.asp
if isAdminLog = true then response.redirect "index.asp"

rem ���嵱��¼ʧ��ʱ��ʾ������
sub AdminLoginFailed
	response.write "<script language='javascript'>"
	response.write "window.alert('��¼ʧ��, ����Ա�û��������벻��ȷ.');"
	response.write "window.location = 'loginadmin.asp';"
	response.write "</script>"
end sub

dim sAction
sAction = request.querystring.item("a")
if sAction = "login" then
	' ��һ�� У���ύ����������, �����������ȷ, ֱ����ʾ����
	dim sAccount, sPwd
	sAccount = request.form.item("adminaccount")
	sPwd     = request.form.item("pwd")
	if len(sAccount)<5 or len(sPwd)<6 then
		call AdminLoginFailed
	end if

	' �ڶ��� �����ݿ���ȥ��֤�����Ƿ���ȷ
%>
<!--#include file = "..\include\dbconnection.asp" -->
<%
	' �������ݿ�
	dim bIsLogin
	bIsLogin = true
	dim objConn
	if bDBConnection(objConn) = false then
		response.write "���ݿ�����ʧ��."
		response.end
	end if

	' �����ݱ�
	dim sSQL
	sSQL = "select top 1 1 from tAdmins where admin_account='" & sAccount & "' and admin_pwd='" & sPwd & "';"
	dim objRs
	set objRs = server.createobject("adodb.recordset")
	objRs.open sSQL, objConn, 0, 1
	if objRs.eof and objRs.bof then bIsLogin = false
	objRs.close
	set objRs = nothing 
	
	' �ر����ݿ�
	call vDBDisConn(objConn)
	
	' ������ ��¼����Ĵ���, �����¼�ɹ�, ����session, ����ת������Ա����ҳ; �����¼ʧ��, ����ת����¼ҳ
	if bIsLogin = true then
		session.contents.item("admin_u") = sAccount
		response.redirect "index.asp"
	else
		call AdminLoginFailed
	end if
 
	response.end
end if
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style\style1.css" type="text/css">
<title>����Ա��¼</title>

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

function editsub()
{
  var sAccount = document.getElementById("adminaccount").value;
  if( len(sAccount)<5 || len(sAccount)>16 )
  {	
	alert("����Ա�û�������Ӧ����5��16�ֽ�֮��,�������������Ա�û���");
	document.getElementById("pwd").focus();
	return false;
  }  

  var sPwd = document.getElementById("pwd").value;
  if( len(sPwd)<6 || len(sPwd)>16 )
  {
	alert("���볤��Ӧ����6��16�ֽ�֮��,��������������");
	document.getElementById("pwd").focus();
	return false;
  }  

  document.getElementById("subbut").disabled = true;
  document.getElementById("post").submit();
}
</script>

</head>

<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td align="center" valign="middle" height="300">
<form name="post" id="post" method="post" action="loginadmin.asp?a=login">
<table border="0" cellpadding="3" cellspacing="1" class="forumline" align="center" width="300">
	<tr>
	  <th class="thHead" colspan="2">����Ա��¼</th>
	</tr>
	<tr>
	  <td class="row2" align="center" width="30%">����Ա�û���</td>
	  <td class="row2" width="70%"><input type="text" size="16" maxlength="16" name="adminaccount" id="adminaccount" /></td>
	</tr>
	<tr>
	  <td class="row2" align="center" width="30%">����</td>
	  <td class="row2" width="70%"><input type="password" size="16" maxlength="16" name="pwd" id="pwd" /></td>
	</tr>
	<tr>
	  <td class="catBottom" colspan="2" align="center"><span class="cattitle">
		<input type="button" id="subbut" name="subbut" value="��¼" class="mainoption" onclick="editsub();" />
		&nbsp;&nbsp;
		<input type="reset" value="����" id="subres" name="subres" class="liteoption" />
		</span></td>
	</tr>
</table>
</form>
</td></tr>
</table>

</body>
</html>
