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
txt2=prompt("flash宽度，高度","500,350"); 
if (txt2!=null) {
	txt=prompt("请输入网上 Flash 文件的地址","http://");
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
		txt2=prompt("视频的宽度，高度","500,350"); 
		if (txt2!=null) {
			txt=prompt("------------------可用文件类型：rm、ra、ram\n视频文件的地址","请输入");
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
		txt2=prompt("------------------可用文件类型：avi、wmv、asf、mov、mp3\n视频的宽度，高度","500,350"); 
		if (txt2!=null) {
			txt=prompt("------------------可用文件类型：avi、wmv、asf、mov、mp3\n视频文件的地址\n","请输入");
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
var text=prompt("请输入文字", "");
if(text){Insert('[SIZE=' + theSmilie + ']'+ text + '[/SIZE]');}
}
function image() {
var enter = prompt("请输入图片地址","http://");
if (enter) {Insert("[IMG]"+enter+"[/IMG]")}
}
function Csound() {
var enter  = prompt("文件后缀名：mid、rmi\n请输入背景音乐地址", "http://");
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
var enter  =prompt("请输入级别数值","1");
if (enter){if (isNaN(enter) || enter<1 || enter>20) {alert("错误！" += "\n" + "您必须输入等级1到20的数值");return;}
Especial("[GRADE="+enter+"]","[/GRADE]")}
}
function Name() {
var FoundErrors = '';
var enter  =prompt("请输入指定查看隐藏内容用户的名称（只单个用户）","");
if (enter){Especial("[USERNAME="+enter+"]","[/USERNAME]")}
}
function Coin() {
var enter  =prompt("请输入拥有多少钱才可以看帖","1000");
if (isNaN(enter)) {alert("错误！\n您必须输入金钱的数值");return;}
if (enter){Especial("[COIN="+enter+"]","[/COIN]")}
}
function Curl() {
var FoundErrors = '';
var enterURL   = prompt("请输入连接网址", "http://");
var enterTxT   = prompt("请输入连接说明", enterURL);
if (!enterURL) {alert("错误！\n您必须输入网址");return}
if (!enterTxT) {alert("错误！\n您必须连接说明");return}
Insert("[URL="+enterURL+"]"+enterTxT+"[/URL]")
}
function Buypost() {
var enter =prompt("注意：只可以发表有价值的帖子赚取金钱，否则会被管理员开除账号！\n请输入您的帖子出售价格","100");
if (isNaN(enter)){alert("错误！\n您必须输入数值价格");return;}
if (enter){Especial("[BUYPOST="+enter+"]","[/BUYPOST]");}
}
function Mark() {
var enter =prompt("请输入可以看帖所需达到的积分","3");
if (isNaN(enter)){alert("错误！\n您必须输入数值积分");return};
if (enter){Especial("[MARK="+enter+"]","[/MARK]")}
}
function Showdate() {
var enter=prompt("请输入日期按这样格式2006-10-1,该帖将这天以后方能浏览","2006-10-1");
if (enter){Especial("[DATE="+enter+"]","[/DATE]")}
}
function Sex() {
var enter=prompt("请输入您指定的性别 男:1  女:0","1");
if (isNaN(enter) | enter>1 | enter<0) {
alert("错误！\n请输入正确性别的数字1或0");
return;
}
if(enter){Especial("[SEX="+enter+"]","[/SEX]")}
}

function Cemail() {
var enter = prompt("请输入邮件地址","");
if (enter){
var p=enter.indexOf('@');
if (p<1 || p==(enter.length-1)){
alert("请输入正确的email地址"); return;
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

var y=0;function presskey(eventobject){if(event.ctrlKey && window.event.keyCode==13){y++;if (y>1) {alert('帖子正在发出，请耐心等待！');return false;}this.document.yimxu.submit();this.document.yimxu.BtnPost.disabled=true;}}

//投票
function SetNum(obj){
	str = '<table width=100% border=0>';
	if(!obj.value){
		obj.value = 1;
	}
	for(i=1;i<=obj.value;i++){
		str += '<tr><td>选项'+i+'：</td><td><input type="text" name="Votes'+i+'" style="width:300"></td></tr>';
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
//控制文本框
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