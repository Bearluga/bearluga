function fontchuli(){
if (document.selection && document.selection.type == "Text") {
var range = document.selection.createRange();
var ch_text=range.text;
range.text = fontbegin + ch_text + fontend;
}
else {
document.yimxu.content.value=document.yimxu.content.value+fontbegin+fontend;
document.yimxu.content.focus();
}
}

function AddText(text) {
	if (document.yimxu.content.createTextRange && document.yimxu.content.caretPos) {      
		var caretPos = document.yimxu.content.caretPos;      
		caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == ' ' ?
		text + ' ' : text;
	}
	else document.yimxu.content.value += text;
	document.yimxu.content.focus(caretPos);
}
function Especial(A,B){
fontbegin=A
fontend=B
fontchuli();
	}
function Insert(theSmilie){
	if (document.selection && document.selection.type == "Text") {
var range = document.selection.createRange();
range.text += theSmilie
} 
else {
document.yimxu.content.value +=theSmilie + '';
document.yimxu.content.focus();
}}

function COLOR(color){
fontbegin="[COLOR="+color+"]";
fontend="[/COLOR]";
fontchuli();
}

function swf() {                
txt2=prompt("flash��ȣ��߶�","500,350"); 
if (txt2!=null) {
	txt=prompt("���������� Flash �ļ��ĵ�ַ","http://");
	if (txt!=null) {
	  if (txt2=="") {
		AddTxt="[FLASH=500,350]"+txt;
		AddText(AddTxt);
		AddTxt="[/FLASH]";
		AddText(AddTxt);
	   } else {
		AddTxt="[FLASH="+txt2+"]"+txt;
	AddText(AddTxt);
	AddTxt="[/FLASH]";
	AddText(AddTxt);
 }        
}  
}
}
function Crm() {
		txt2=prompt("��Ƶ�Ŀ�ȣ��߶�","500,350"); 
		if (txt2!=null) {
			txt=prompt("------------------�����ļ����ͣ�rm��ra��ram\n��Ƶ�ļ��ĵ�ַ","������");
			if (txt!=null) {
				if (txt2=="") {
					AddTxt="[RM=500,350]"+txt;
					AddText(AddTxt);
					AddTxt="[/RM]";
					AddText(AddTxt);
				} else {
					AddTxt="[RM="+txt2+"]"+txt;
					AddText(AddTxt);
					AddTxt="[/RM]";
					AddText(AddTxt);
				}         
			} 
		}
}
function Cwmv() {
		txt2=prompt("------------------�����ļ����ͣ�avi��wmv��asf��mov��mp3\n��Ƶ�Ŀ�ȣ��߶�","500,350"); 
		if (txt2!=null) {
			txt=prompt("------------------�����ļ����ͣ�avi��wmv��asf��mov��mp3\n��Ƶ�ļ��ĵ�ַ\n","������");
			if (txt!=null) {
				if (txt2=="") {
					AddTxt="[MP=500,350]"+txt;
					AddText(AddTxt);
					AddTxt="[/MP]";
					AddText(AddTxt);
				} else {
					AddTxt="[MP="+txt2+"]"+txt;
					AddText(AddTxt);
					AddTxt="[/MP]";
					AddText(AddTxt);
				}         
			} }}

function ybbsize(theSmilie){
var text=prompt("����������", "");
if(text){Insert('[SIZE=' + theSmilie + ']'+ text + '[/SIZE]');}
}
function image() {
var enter = prompt("������ͼƬ��ַ","http://");
if (enter) {Insert("[IMG]"+enter+"[/IMG]")}
}
function Csound() {
var enter  = prompt("�ļ���׺����mid��rmi\n�����뱳�����ֵ�ַ", "http://");
if (enter) {Insert("[SOUND]"+enter+"[/SOUND]")}
}
function fly() {
fontbegin="[FLY]";
fontend="[/FLY]";
fontchuli();
}
function move() {
fontbegin="[MOVE]";
fontend="[/MOVE]";
fontchuli();
}
function center() {
fontbegin="[ALIGN=center]";
fontend="[/ALIGN]";
fontchuli();
}
function LIGHT() {
fontbegin="[LIGHT]";
fontend="[/LIGHT]";
fontchuli();
}
function Grade() {
var enter  =prompt("�����뼶����ֵ","1");
if (enter){if (isNaN(enter) || enter<1 || enter>20) {alert("����" += "\n" + "����������ȼ�1��20����ֵ");return;}
Especial("[GRADE="+enter+"]","[/GRADE]")}
}
function Name() {
var FoundErrors = '';
var enter  =prompt("������ָ���鿴���������û������ƣ�ֻ�����û���","");
if (enter){Especial("[USERNAME="+enter+"]","[/USERNAME]")}
}
function Coin() {
var enter  =prompt("������ӵ�ж���Ǯ�ſ��Կ���","1000");
if (isNaN(enter)) {alert("����\n�����������Ǯ����ֵ");return;}
if (enter){Especial("[COIN="+enter+"]","[/COIN]")}
}
function Curl() {
var FoundErrors = '';
var enterURL   = prompt("������������ַ", "http://");
var enterTxT   = prompt("����������˵��", enterURL);
if (!enterURL) {alert("����\n������������ַ");return}
if (!enterTxT) {alert("����\n����������˵��");return}
Insert("[URL="+enterURL+"]"+enterTxT+"[/URL]")
}
function Buypost() {
var enter =prompt("ע�⣺ֻ���Է����м�ֵ������׬ȡ��Ǯ������ᱻ����Ա�����˺ţ�\n�������������ӳ��ۼ۸�","100");
if (isNaN(enter)){alert("����\n������������ֵ�۸�");return;}
if (enter){Especial("[BUYPOST="+enter+"]","[/BUYPOST]");}
}
function Mark() {
var enter =prompt("��������Կ�������ﵽ�Ļ���","3");
if (isNaN(enter)){alert("����\n������������ֵ����");return};
if (enter){Especial("[MARK="+enter+"]","[/MARK]")}
}
function Showdate() {
var enter=prompt("���������ڰ�������ʽ2006-10-1,�����������Ժ������","2006-10-1");
if (enter){Especial("[DATE="+enter+"]","[/DATE]")}
}
function Sex() {
var enter=prompt("��������ָ�����Ա� ��:1  Ů:0","1");
if (isNaN(enter) | enter>1 | enter<0) {
alert("����\n��������ȷ�Ա������1��0");
return;
}
if(enter){Especial("[SEX="+enter+"]","[/SEX]")}
}

function Cemail() {
var enter = prompt("�������ʼ���ַ","");
if (enter){
var p=enter.indexOf('@');
if (p<1 || p==(enter.length-1)){
alert("��������ȷ��email��ַ"); return;
}
Insert("[EMAIL]"+enter+"[/EMAIL]")
}
}
function Cbold() {
fontbegin="[B]";
fontend="[/B]";
fontchuli();
}
function Citalic() {
fontbegin="[I]";
fontend="[/I]";
fontchuli();
}
function Cunder() {
fontbegin="[U]";
fontend="[/U]";
fontchuli();
}
function ying() {
fontbegin="[SHADOW=255,yellow,1]";
fontend="[/SHADOW]";
fontchuli();
}
function Code() {
fontbegin="[code]\n";
fontend="\n[/code]";
fontchuli();
}
function DoTitle(addTitle){
document.yimxu.caption.value=addTitle+document.yimxu.caption.value;
document.yimxu.caption.focus();
document.yimxu.caption.value+="";
}
function openwin()
{document.preview.caption.value=document.yimxu.caption.value;
document.preview.content.value=document.yimxu.content.value;
var popupWin = window.open('See.Asp?Action=preview', 'preview', 'left=0,width=600,height=400,resizable=1,scrollbars=yes,menubar=no,status=yes');
document.preview.submit()
}

var y=0;function presskey(eventobject){if(event.ctrlKey && window.event.keyCode==13){y++;if (y>1) {alert('�������ڷ����������ĵȴ���');return false;}this.document.yimxu.submit();this.document.yimxu.BtnPost.disabled=true;}}

//ͶƱ
function SetNum(obj){
	str = '<table width=100% border=0>';
	if(!obj.value){
		obj.value = 1;
	}
	for(i=1;i<=obj.value;i++){
		str += '<tr><td>ѡ��'+i+'��</td><td><input type="text" name="Votes'+i+'" style="width:300"></td></tr>';
	}
	window.optionid.innerHTML=str+'<INPUT TYPE="hidden" name="AutoValue" value="'+obj.value+'"></table>';
}

function showpic() {
	if(document.all.MaoDiv.style.display=='block')
		{document.all.MaoDiv.style.display='none'}
	else
		{document.all.MaoDiv.style.display='block'}
	document.all.MaoDiv.style.posLeft=window.event.x-400;
	if(document.all.MaoDiv.style.posLeft<0){
		document.all.MaoDiv.style.posLeft = 160;
	}
	document.all.MaoDiv.style.posTop=window.event.y+document.body.scrollTop-200;
	if(MView.location=='about:blank'){MView.location.replace('INC/EmotPic.htm')}
	if(document.all.MaoDiv.style.posTop<0){
		document.all.MaoDiv.style.posTop= 0;
	}
}  

function copyit(obj){
	obj.select();
	js=obj.createTextRange();
	js.execCommand("Copy");
}
function saveAs(obj){
	var winname=window.open('','test','top=10000');
	winname.document.open("text/html", "replace");
	winname.document.write(obj.value);
	winname.document.execCommand('saveas','','code.html');
	winname.close();
}
function runit(obj)
{
var winname=window.open("","test","");
winname.document.open("text/html", "replace");
winname.document.write(obj.value);
winname.document.close();
}
//�����ı���
function textarea_Size(num,obj)
{
 if (parseInt(obj.rows)+num>=5) {
  obj.rows = parseInt(obj.rows) + num; 
 }
 if (num>0)
 {
  obj.width="90%";
 }
}
function checkclick(msg){if(confirm(msg)){event.returnValue=true;}else{event.returnValue=false;}}