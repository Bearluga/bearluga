<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
   <head>
      <title>CSS3PIE test case</title>
      <style type="text/css">
         li,
         a,
         span,
         p
         {
            behavior: url("/PIE/PIE.htc");
            border: 1px solid black; /* to make finding the edges easier */
            width: 5em; /* to make testing the p easier */
            padding: 1em; /* the p error seems to be dependent on size */
       -pie-watch-ancestors:1;
         }
         
         li
         {
            border: none;
         
         }
         
         li:hover > *
         {
			 background-color:green;
            -pie-background: linear-gradient(top, #eeeeee 0%,#aaaaaa 100%);
			
         
         }
      </style>
   </head>
   <body>
      <ul>
         <li><a>Item 1</a></li>
         <li><span>Item 2</span></li>
         <li><p>Item 3</p></li>
      </ul>
   </body>
</html>