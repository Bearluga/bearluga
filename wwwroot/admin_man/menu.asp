<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html dir="ltr">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312"  />
<link rel="stylesheet" href="style/style1.css" type="text/css">
<title>���߱��ռ���̨����</title>
</head>
<body bgcolor="#E5E5E5" text="#000000" link="#006699" vlink="#5493B4">
<table width="100%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr>
	<td align="center" >
	  <table width="100%" cellpadding="4" cellspacing="1" border="0" class="forumline">
		<tr>
		  <th height="25" class="thHead"><b>���߱��ռ���̨����</b></th>
		</tr>
		<tr>
		  <td height="28" class="catSides"><span class="cattitle">��Ŀ����</span></td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="project_list.asp"  target="main" class="genmed">���������Ŀ</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="project_add.asp"  target="main" class="genmed">�����Ŀ</a></span>
		  </td>
		</tr>
<!--		<tr>
		  <td class="row1"><span class="genmed"><a href="#"  target="main" class="genmed">Pruning</a></span>
		  </td>
		</tr>
-->
		<tr>
		  <td height="28" class="catSides"><span class="cattitle">�û�����</span></td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="user_list.asp" target="main" class="genmed">����û�</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="user_add.asp"  target="main" class="genmed">����û�</a></span>
		  </td>
		</tr>
		<tr>
		  <td height="28" class="catSides"><span class="cattitle">��Ŀ����</span></td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="question_list.asp"  target="main" class="genmed">�����Ŀ</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="question_add.asp"  target="main" class="genmed">�����Ŀ</a></span>
		  </td>
		</tr>

		<tr>
		  <td height="28" class="catSides"><span class="cattitle">������</span></td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="result_query.asp"  target="main" class="genmed">��������ѯ</a></span>
		  </td>
		</tr>
<!--
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_add.asp"  target="main" class="genmed">��ӹ���Ա</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_update_step1.asp"  target="main" class="genmed">�޸Ĺ���Ա</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_delete.asp"  target="main" class="genmed">ɾ������Ա</a></span>
		  </td>
		</tr>
-->
		<tr>
		  <td height="28" class="catSides"><span class="cattitle">�������Ա</span></td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_show.asp"  target="main" class="genmed">������й���Ա</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_add.asp"  target="main" class="genmed">��ӹ���Ա</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_update_step1.asp"  target="main" class="genmed">�޸Ĺ���Ա</a></span>
		  </td>
		</tr>
		<tr>
		  <td class="row1"><span class="genmed"><a href="admin_delete.asp"  target="main" class="genmed">ɾ������Ա</a></span>
		  </td>
		</tr>
		<tr>
  		  <td height="28" class="catSides"><span class="cattitle">����</span></td>
		</tr>
<!--
		<tr>
		  <td class="row1"><span class="genmed"><a href="#"  target="main" class="genmed">����Ա</a></span>
		  </td>
		</tr>
-->
		<tr>
		  <td class="row1"><span class="genmed"><a href="logoutadmin.asp"  target="_parent" class="genmed">�˳�</a></span>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
</body>
</html>
