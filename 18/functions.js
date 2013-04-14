function tabSwitch(new_tab, new_content) {
	document.getElementById('tab_1').className = '';
	document.getElementById('tab_2').className = '';
	document.getElementById(new_tab).className = 'active';	
}
