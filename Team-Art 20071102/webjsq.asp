<%
'==================================
 'վ��������v1.0
 '�ơ������й�վ������
 '��վ��http://www.web591.cn
 '���°汾���أ�http://www.web591.cn/591code/
 
'�� ��:	
   '�����ϵ��ѳ���,�ṩ���������ʹ��,��������Ȩ���������κ����ơ�
   'δ��������ɽ�ֹ�����κ���ҵ��;��
'վ�����������ܣ�
   '1.����������ͼƬ���������ֻ��ƹ��档
   '2.ҳ����ʾ������IP��ˢ�¼������ּ���ģʽ��
   '3.Script�ű���ʽ���ü��������롣
   '4.��5��ͼƬ��ʽ����ѡ��ʹ�ã����ҿ��Է�������Ӽ�����ͼƬ��ʽ��
   '5.�ȶ��ԡ���ȫ�ԡ��ٶ��ϱ��ֶ������㣬������ȫ�����뼯�ɳ̶ȸߡ���ȫ������רҵ��������ȫ��ѡ�
   '6.�ʺ���վ�����Ա��������ҵվʱʹ�á�
 
'վ������������Ʒ��FreeAd8������� V3.5 ��ҵ�桢Web591վ������������������Ͷ��ϵͳ��
'��������������    վ�����Ա� V1.0 �ȡ�

'�˶ΰ�Ȩע�Ͳ���Ӱ����ҳ���ٶȣ�����ɾ��!
'����������������������2006��12��01��									
'===================================
%>
document.write("<%
'�������ݿ�
Provider = "Provider=Microsoft.Jet.OLEDB.4.0;"
Path = "Data Source=" & Server.MapPath("web#jsqmdb.asp")
Set conn= Server.CreateObject("ADODB.Connection")
p1=Provider&Path
conn.Open P1

Sub MyCounter(refresh,ty,picid)
	Dim CountNum
	SET Rs = Server.CreateObject("ADODB.Recordset")
	Rs.Open "Select * From counters" , conn,1,3

	Select Case refresh
	    'ˢ�²�����
		Case 1
			if isempty(session("number")) then
				application.lock
				Rs("TOTAL")=Rs("TOTAL") + 1 
				application.unlock
				session("number")=true
			end if
		'ˢ�¼���
		Case 2
			Rs("TOTAL")=Rs("TOTAL") + 1
	End Select

	Rs.Update
	CountNum=Rs("TOTAL")

	Rs.close
	set Rs=nothing
	Conn.Close
	Set Conn = Nothing
Call DispNum(CountNum,ty,picid)
End Sub

Sub DispNum(CountNum,ty,picid)
	If ty="True" Then
		Dim S, i, G,pid
                pid=picid
		S = CStr(CountNum)
		For i = 1 to Len(S)
		 G = G &  "<img src=images/"&pid&"/" & Mid(S, i, 1) & ".gif align=middle>"
		Next
                response.write("")
		Response.write (G)
                response.write("")
	Else
		response.write("���Ǳ�վ�� <font color=#FFC700><b>"&CountNum&"</b></font> λ����")
	End If
End Sub

If Request("action")="freesoho" Then
	If Request("refresh")<>"" and Request("ty")<>"" Then Call MyCounter(Request("refresh"),Request("ty"),Request("Picid")) End If
End If
%>");