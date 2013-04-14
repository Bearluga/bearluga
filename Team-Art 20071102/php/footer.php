
<div id="footer">

	<div id="foot"> <!-- this extra div is just centering the fixed width area of the footer content -->

		<p>版权所有© 2007 天慕众和企业管理咨询（北京）有限公司     京ICP备07015011号</p>

	</div>

</div>

		<script>

			(function($){
				//cache nav
				var nav = $("#topNav");
				//add indicator and hovers to submenu parents
				nav.find("li").each(function() {
					if ($(this).find("ul").length > 0) {
						//$("<span>").text("^").appendTo($(this).children(":first"));
						//show subnav on hover
						$(this).mouseenter(function() {
							$(this).find("ul").stop(true, true).slideDown();
						});			
						//hide submenus on exit
						$(this).mouseleave(function() {
							$(this).find("ul").stop(true, true).slideUp();
						});
					}
				});
			})(jQuery);
		</script>