<%
rem ������Ա�Ƿ��¼
function isAdminLog()
	isAdminLog = true
	if session.contents.item("admin_u") = "" then isAdminLog = false 
end function

rem ������Ŀ���͵ı��, �õ���Ŀ����������
rem 1 - ������Ŀ; 2 - ���ߵ���; 3 - ���߱�
function getProjectTypeName( typeid )
	dim aTypeName(2)
	aTypeName(0) = "���߲���"
	aTypeName(1) = "���ߵ���"
	aTypeName(2) = "���߱�"
	typeid = typeid - 1
	typeid = typeid mod 3
	getProjectTypeName = aTypeName(typeid)
end function

rem �õ��������������
function getQuestionTypeName( typeid )
	dim aTypeName(2)
	aTypeName(0) = "����ѡ��"
	aTypeName(1) = "����ѡ��"
	aTypeName(2) = "�ʴ�"
	typeid = typeid - 1
	typeid = typeid mod 3
	getQuestionTypeName = aTypeName(typeid)
end function

rem �õ��Ա������
function getGenderText( typeid )
	if isnull(typeid) or len(typeid)<1 then
		getGenderText = "δ��д"
	elseif typeid=1 then
		getGenderText = "��"
	elseif typeid=2 then
		getGenderText = "Ů"
	else
		getGenderText = "δ֪"
	end if
end function

rem �õ�һ��������ַ�
function getRndChar( n )
	dim sRndChar
	sRndChar = "abcdefghijklmnopqrstuvwxyz0123456789"
	n = (n mod 36) + 1
	getRndChar = mid( sRndChar, n, 1 )
end function
%>
