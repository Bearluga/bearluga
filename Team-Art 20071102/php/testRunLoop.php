<!DOCTYPE html>
<html lang="en" dir="ltr" id="jquery-runloop" class="no-js">
<head>
   <meta charset="utf-8">
   <title>jQuery.runloop Plugin</title>
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
   <meta name="viewport" content="width=500"> 
    <script>
      document.getElementById('jquery-runloop').className = "js";
    </script>
<style>
   html, body {
      background: #fff;
      font-size: 10px;
      line-height: 10px;
      margin: 0;
      padding: 0;
   }
   p{
	
   }
   
   h1, p {
     margin: 0;
     padding: 0;
   }
   h1 {
      color: #333;
      font-family:"华文新魏";
	  line-height: 55px;
      white-space: nowrap;
   }
   p {
      color: #a1b1c1;
      font-family:"华文新魏";
	  font-size: 24px;
	  line-height: 130%;
      margin: 2px 0;
   }
   a {
      font-weight: bold;
      color: #B4C3f3;
      -webkit-transition: color .3s ease-out;
      -moz-transition: color .3s ease-out;
      -o-transition: color .3s ease-out;
      transition: color .3s ease-out;
   }
   a:focus,
   a:hover {
      color: #fff;
   }
   .copyright {
      font-size: 1.2em;
      margin-top: 2.5em;
   }
   #demo div {
      overflow: hidden;
   }
   #demo {
      height: 40em;
      left: 50%;
      margin: -25em 0 0 -20em;
      position: absolute;
      top: 50%;
      width: 40em;
   }
   #intro {
      background: black;
      border: 2px solid white;
      border-width: 0 2px;
      height: 5em;
      opacity: 1;
      padding: 0 2em;
   }
   #box {
      border-radius: 4px;
      border: 2px solid #333;
      height: 34.6em;
      padding: 0 2em;
      position: relative;
      width: 35.6em;
   }
   .no-js #box {
      background-color: red;
   }
   .js #box {
      border-color: white;
      padding: 0;
   }
   .js p,
   .js #intro h1 {
      opacity: 0;
      position: relative;
   }
   #box h1 {
      color: #a1b1c1;
      top: -2.3em;
      padding-top: 1em;
      padding-bottom: 0.25em;
      position: relative;
   }
   
</style>

</head>

<body>

<!-- Demo area -->
<div id="demo">
   
   <div id="intro">
      <h1>秉承国外先进的管理理念和实践</h1>
   </div>
   <div id="box">
      <h1 id="drowning">&nbsp;</h1>
      <p class="a">专业</p> 
      <p class="b">&nbsp;&nbsp;&nbsp;&nbsp;诚信</p>
      <p class="c">共享</p>
      <p class="copyright">Made by <a href="http://farukat.es/">Faruk Ateş</a>, dual-licensed MIT/BSD.</p>
   </div>

</div>
<!-- / demo area -->

<script src="../js/jquery.js"></script>
<script>!window.jQuery && document.write(unescape('%3Cscript src="/js/jquery.min.js"%3E%3C/script%3E'))</script>

<script src="../js/jquery.runloop.1.0.3.js"></script>

<script>
$(document).ready(function() {

   // JavaScript enabled; initiate some of the CSS for this
   $("#intro h1").css({
      bottom: '-1.5em',
      opacity: 1
   });
   $("#box").css({
      'border-color': '#333',
      height: 0,
      width: 0
   });
   $("p").css({
      opacity: 0,
      position: 'relative',
      left: '-3em'
   });
   $("p.b, p.copyright").css({
      left: '3em'
   });
   
   
   // Make a new runloop. Probably best not to attach it to the window object, but it's useful for this demo
   // as it allows you to inspect the myRunloop object using Firebug/Web Inspector.
   window.myRunloop = jQuery.runloop();
   
   // You add keyframes with addKey(); the first parameter is the percentage into the overall runloop duration,
   // the second is the function to execute at that keyframe point.
   myRunloop.addKey('20%', function(){ $("#box").animate( { width:'35.6em', paddingLeft:'2em', paddingRight:'2em' }, { duration:1000, queue:false } ) });
   
   // But you don't have to do individual addKey() calls; use addMap() to add multiple keyframes at once:
   myRunloop.addMap({
      '15%': function(){ $("#intro h1").animate( { bottom:'0' }, { duration:1000, queue:false } )},
      '30%': function(){
         // This demo shows that you can even pause and continue the runloop from inside keyframe calls
         
         $("#drowning").text($("#intro h1").text());
         
         // Continue the runloop; no need to specify a duration if we're continuing
         myRunloop.play();
      },
      '40%': function(){ $("#box").animate({ height:'34.6em' }, { duration:1500, queue:false } ) },
      '50%': function(){ 
         $("#intro h1").animate({ bottom:'-2.3em' }, { duration:1000, queue:false } );
         $("#box h1").animate({ top:0 }, { duration:1000, queue:false } );
      },
      '55%': function(){  $("p.a").animate( { opacity:1, left:0 }, { duration:500, queue:false } );  },
      '70%': function(){  $("p.b").animate( { opacity:1, left:0 }, { duration:500, queue:false } ); },
      '85%': function(){  $("p.c").animate( { opacity:1, left:0 }, { duration:500, queue:false } );  },
      '100%': function(){ $("p.copyright").animate( { opacity:1, left:0 }, { duration:650, queue:false } ); }
   });

   // You can stack multiple calls at each keyframe, too:
   myRunloop.addKey('50%', function(){ if(window.console) console.log('First call at 50%'); });
   myRunloop.addKey('50%', function(){ if(window.console) console.log('Second call at 50%'); });

   // You can add a callback to the end of the runloop, but note: it's the same as this: addKey('100%', func);
   function optionalCallback(){
      if(window.console) console.log('Runloop done!');
   };
   
   // Start playing the runloop, in this case with a duration of 10s.
   // If the duration is omitted and no runloop was playing, it'll default to 500ms.
   myRunloop.play(10000, optionalCallback);

});

var _gaq = [['_setAccount', 'UA-3764464-3'], ['_setDomainName', '.farukat.es'], ['_trackPageview']];
(function(d, t) {
  var g = d.createElement(t),
      s = d.getElementsByTagName(t)[0];
  g.async = true;
  g.src = ('https:' == location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  s.parentNode.insertBefore(g, s);
})(document, 'script');
</script> 
</body>
</html>