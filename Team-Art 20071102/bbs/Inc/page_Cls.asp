<%
 Class Cls_PageView
  Private CookiesCacheName,CookiesCacheData,sstrCookiesName,CSQL
  Private sstrPageUrl,sstrPageVar,sstrTableName,sstrFieldsList,sstrCondiction,sstrOrderList,sstrPrimaryKey,sintRefresh
  Private sintRecordCount,sintPageSize,sintPageNow,sintPageMax,sstrPageInfo,sReloadtime
  
  Private Sub Class_Initialize
   sstrCookiesName = ""
   sstrPageUrl = ""
   sstrPageVar = "page"
   sstrTableName = ""
   sstrFieldsList = ""
   sstrCondiction = ""
   sstrOrderList = ""
   sstrPrimaryKey = ""
   sintRefresh = 0
   Reloadtime=3
   sintRecordCount = 0
   sintPageSize = 0
   sintPageNow = 0
   sintPageMax = 0
   CSQL=""
   CookiesCacheName=LCase(Replace(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"),Split(request.ServerVariables("SCRIPT_NAME"),"/")(ubound(Split(request.ServerVariables("SCRIPT_NAME"),"/"))),""))
  End Sub
   
  Private Sub class_terminate()
  ' Set Conn=nothing
  End Sub
    
 '���ʼ��,�ⲿ����
  Public Sub InitClass()
	If Not IsObject(Conn) Then ConnectionDatabase
	Call InitRecordCount()
	Call InitPageInfo()   
  End Sub
  
  '�����¼���� Cookies ����
  Public Property Let strCookiesName(Value)
   sstrCookiesName = Value
  End Property
  '������� Cookies ��ʱ��
  Public Property Let Reloadtime(Value)
   sReloadtime = Value
  End Property  
  'ת���ַ
  Public Property Let strPageUrl(Value)
   sstrPageUrl = Value
  End Property
   

  ' ����
  Public Property Let strTableName(Value)
   sstrTableName = Value
  End Property
  '�ֶ��б�
  Public Property Let strFieldsList(Value)
   sstrFieldsList = Value
  End Property
  '��ѯ����
  Public Property Let strCondiction(Value)
   If Value <> "" Then
    sstrCondiction = " WHERE " & Value
   Else
    sstrCondiction = ""
   End If
  End Property
  '�����ֶ�, ��: [ID] ASC, [CreateDateTime] DESC
  Public Property Let strOrderList(Value)
   If Value <> "" Then
    sstrOrderList = " ORDER BY " & Value
   Else
    sstrOrderList = ""
   End If
  End Property
   '����ܼ�¼��
  Public Property Let CountSQL(TSQL)
	CSQL=TSQL
  End Property 
 '����ͳ�Ƽ�¼�����ֶ�
  Public Property Let strPrimaryKey(Value)
   sstrPrimaryKey = Value
  End Property
  
  'ÿҳ��ʾ�ļ�¼����
  Public Property Let intPageSize(Value)
   sintPageSize = toNum(Value, 20)
  End Property

  '��ǰҳ
  Public Property Let intPageNow(Value)
   sintPageNow = toNum(Value, 1)
  End Property
  
  'ҳ���������
  Public Property Let strPageVar(Value)
   sstrPageVar = Value
  End Property
  
  '�Ƿ�ˢ��. 1 Ϊˢ��, ����ֵ��ˢ��
  Public Property Let intRefresh(Value)
   sintRefresh = toNum(Value, 0)
  End Property
  
  '��õ�ǰҳ
  Public Property Get intPageNow()
   intPageNow = sintPageNow
  End Property
  
  '��÷�ҳ��Ϣ
  Public Property Get strPageInfo()
   strPageInfo = sstrPageInfo
  End Property
  
    'cookiesʱ���Ƿ����
   	Private Function ObjIsEmpty()
		Dim Temp
		ObjIsEmpty=True
		Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
		CookiesCacheData=Split(Temp,"|||")
		If Instr(Temp,"|||")=0 Then Exit Function
		If Not IsArray(CookiesCacheData) Then Exit Function
		If Not IsDate(CookiesCacheData(1)) Then Exit Function
		If DateDiff("s",CDate(CookiesCacheData(1)),Now()) < 60*sReloadtime  Then
			ObjIsEmpty=False
		End If
	End Function

  
  'ȡ�ü�¼��, ��ά������ִ�, �ڽ���ѭ�����ʱ������ IsArray() �ж�
  Public Property Get arrRecordInfo()
	Dim rs, sql
	sql = "SELECT " & sstrFieldsList & " FROM " & sstrTableName & sstrCondiction & sstrOrderList
	If Not IsObject(Conn) Then ConnectionDatabase
	Set rs = Server.CreateObject("Adodb.RecordSet")
	rs.open sql, Conn, 1, 1
	If Not(rs.eof or rs.bof) Then
		rs.PageSize = sintPageSize
		If sintpageNow=0 Then sintpageNow=1
		rs.AbsolutePage = sintPageNow
		If Not(rs.eof or rs.bof) Then
			arrRecordInfo = rs.getrows(sintPageSize)
		Else
			arrRecordInfo = ""
		End If
	Else
		arrRecordInfo = ""
	End If
	rs.close
	Set rs = nothing
  End Property
  
  '��ʼ����¼��
  Private Sub InitRecordCount()
	If Not ObjIsEmpty() Then
		sintRecordCount = Value
	Else
		Dim sql,rs
		If CSQL="" Or IsNull(CSQL) Then
			sql = "SELECT COUNT(" & sstrPrimaryKey & ")" & " FROM " & sstrTableName & sstrCondiction
			If Not IsObject(Conn) Then ConnectionDatabase
			Set rs = Conn.execute(sql)
			If rs.eof or rs.bof Then
			sintRecordCount = 0
			Else
			sintRecordCount = rs(0)
			End If
			Rs.close
			Set Rs=nothing
		Else
			sintRecordCount=CSQL
		End If
		Value=sintRecordCount
	End If
End Sub

    Private  Property Let Value(ByVal vNewValue)
	Dim Temp
		If sstrCookiesName<>"" Then 
		    Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
			CookiesCacheData=Split(Temp,"|||")
			If IsArray(CookiesCacheData) And Instr(Temp,"|||")>0 Then
				CookiesCacheData(0)=vNewValue
				CookiesCacheData(1)=Now()
			Else
				ReDim CookiesCacheData(2)
				CookiesCacheData(0)=vNewValue
				CookiesCacheData(1)=Now()
			End If
			SetCookies CookiesCacheName&"_"&sstrCookiesName,CookiesCacheData
		Else
			Err.Raise vbObjectError + 1, "YxBBsCacheServer", " please change the CacheName."
		End If		
	End Property
	
	Private Property Get Value()
	Dim Temp
		If sstrCookiesName<>"" Then 
		    Temp = Request.Cookies("YxBBs")(CookiesCacheName&"_"&sstrCookiesName)
			CookiesCacheData=Split(Temp,"|||")
			If IsArray(CookiesCacheData) And Instr(Temp,"|||")>0 Then
				Value=CookiesCacheData(0)
			Else
				Err.Raise vbObjectError + 1, "YxBBsCacheServer", " The CacheData Is Empty."
			End If
		Else
			Err.Raise vbObjectError + 1, "YxBBsCacheServer", " please change the CacheName."
		End If
	End Property 
  
  '��ʼ����ҳ��Ϣ
  Private Sub InitPageInfo()
	Dim surl,i,PageNMin,PageNMax
	sstrPageInfo = ""
	surl = sstrPageUrl   
	If Instr(1, surl, "?", 1) > 0 Then
	surl = surl & "&" & sstrPageVar & "="
	Else
	surl = surl & "?" & sstrPageVar & "="
	End If
	If sintPageNow <= 0 Then sintPageNow = 1
	If sintRecordCount mod sintPageSize = 0 Then
		sintPageMax = sintRecordCount \ sintPageSize
	Else
		sintPageMax = sintRecordCount \ sintPageSize + 1
	End If
	If sintPageNow > sintPageMax Then sintPageNow = sintPageMax
	sstrPageInfo =  "<table width='100%' border='0' cellspacing='0' cellpadding='0'><tbody><tr><td>&nbsp;ҳ��<b><font color=""#990000"">" & sintPageNow & "</font> / " & sintPageMax & " </b>ҳ "
	sstrPageInfo = sstrPageInfo & " ��<b>" & sintRecordCount & "</b> ����¼ <b>" & sintPageSize & "</b> ��/ҳ "
	If sintPageNow > 1 then
		sstrPageInfo = sstrPageInfo & "��<b><a href='" & surl & (sintPageNow - 1) & "'>��ҳ</a></b>��"
	End If
	If sintPageMax - sintPageNow => 1 then
		sstrPageInfo = sstrPageInfo & "��<b><a href='" & surl & (sintPageNow + 1) & "'>��ҳ</a></b>�� "
	End If
	sstrPageInfo = sstrPageInfo &"</TD><TD align='right'>��ҳ��"
	PageNMin=sintPageNow-4
	if PageNMin<1 then PageNMin=1' ��ʾ��Сҳ��
	PageNMax=sintPageNow+4
	if PageNMax>sintPageMax then PageNMax=sintPageMax' ��ʾ���ҳ��
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & "1'><font title='��ҳ' face=webdings>9</font></a> "
	If sintPageNow>5 Then'���ҳ��ֵ����5����ʾ(��ǰ)��ǰ
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & (sintPageNow - 5) & "' ><font title='����ҳ' face=webdings>7</font></a> "
	End if
	For i =PageNMin To PageNMax'ѭ�����ҳ��
	If(i=sintPageNow) Then
	sstrPageInfo = sstrPageInfo &"<font color='#FF6600'><b>"& i &"</b></font> "
	else
	sstrPageInfo = sstrPageInfo &"<b><A title='ת����"& i &"ҳ' HREF='" & surl & i &"'>"& i &"</A></b> "
	End if
	Next
	If (sintPageMax-sintPageNow)>5  Then
		sstrPageInfo = sstrPageInfo &"<a href='" & surl & (sintPageNow + 5) & "'><font title='����ҳ' face=webdings>8</font></a>"
	End if
	sstrPageInfo = sstrPageInfo &"<a href='" & surl & sintPageMax & "' ><font title='βҳ' face=webdings>:</font></a>"
	sstrPageInfo = sstrPageInfo &"</td><td align='right'>ת��<input maxLength='6' size='2' name='topage' value='"&sintPageNow&"' onkeydown=if(window.event.keyCode==13){window.location.href='"&surl&"'+topage.value;}> <input Class='go' value='GO' type='button' onClick=location.href='"&surl&"'+topage.value>&nbsp;</TD></TR></TBODY></TABLE>"
End Sub
    
  '��¼Cookies
  Private Sub SetCookies(Name,NewValue)
	   Response.Cookies("YxBBs").Expires = Date()+1
       Response.Cookies("YxBBs")(Name)=Join(NewValue,"|||")
  End Sub
 '���Cookies
    Public Sub DelCookiesCache(Name)
        Response.Cookies("YxBBs").Expires = Date()+1
		Response.Cookies("YxBBs")(CookiesCacheName&"_"&Name)=""
	End Sub
   '������ת��
  Private function toNum(s, Default)
	s = s & ""
	If s <> "" And IsNumeric(s) Then
		toNum = int(s)
	Else
		toNum = Default
	End If
  End function
End Class
 %>