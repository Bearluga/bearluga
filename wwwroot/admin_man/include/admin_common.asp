<%
rem 检测管理员是否登录
function isAdminLog()
	isAdminLog = true
	if session.contents.item("admin_u") = "" then isAdminLog = false 
end function

rem 根据项目类型的编号, 得到项目的类型名称
rem 1 - 测试项目; 2 - 在线调查; 3 - 在线表单
function getProjectTypeName( typeid )
	dim aTypeName(2)
	aTypeName(0) = "在线测试"
	aTypeName(1) = "在线调查"
	aTypeName(2) = "在线表单"
	typeid = typeid - 1
	typeid = typeid mod 3
	getProjectTypeName = aTypeName(typeid)
end function

rem 得到问题的类型名称
function getQuestionTypeName( typeid )
	dim aTypeName(2)
	aTypeName(0) = "单项选择"
	aTypeName(1) = "多项选择"
	aTypeName(2) = "问答"
	typeid = typeid - 1
	typeid = typeid mod 3
	getQuestionTypeName = aTypeName(typeid)
end function

rem 得到性别的名称
function getGenderText( typeid )
	if isnull(typeid) or len(typeid)<1 then
		getGenderText = "未填写"
	elseif typeid=1 then
		getGenderText = "男"
	elseif typeid=2 then
		getGenderText = "女"
	else
		getGenderText = "未知"
	end if
end function

rem 得到一个随机的字符
function getRndChar( n )
	dim sRndChar
	sRndChar = "abcdefghijklmnopqrstuvwxyz0123456789"
	n = (n mod 36) + 1
	getRndChar = mid( sRndChar, n, 1 )
end function
%>
