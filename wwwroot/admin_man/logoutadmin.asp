<%@language=vbscript codepage=936%>
<!--#include file = "..\include\public.asp" -->
<!--#include file = "include\admin_common.asp" -->
<!--#include file = "validate_check.asp" -->
<%
rem ����Ա�˳�
session.contents.remove("admin_u")
response.redirect "loginadmin.asp"
%>
