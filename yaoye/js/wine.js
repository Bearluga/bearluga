var dName = "wine/";
var avaArray = ["ancient-lakes-wineries.php", "columbia-cascade-wineries.php", "columbia-gorge-wineries.php", "columbia-valley-wineries.php", "horse-heaven-hills-wineries.php", "lake-chelan-wineries.php", "kitsap-peninsula-wineries.php", "naches-heights-wineries.php", "sound-island-wineries.php", "south-sound-wineries.php", "olympic-peninsula-wineries.php", "rattlesnake-hills-wineries.php", "red-mountain-wineries.php", "snipes-mountain-wineries.php", "wahluke-slope-wineries.php", "walla-walla-wineries.php", "yakima-valley-wineries.php"];

$(avaArray).each(function(index,item){
  $.ajax({
    url: dName+item,
    async: true,
    dataType: 'text',
    error: function() {
      console.error('[service.local] Stub "' + item + '" doesn\'t exist.');
    }
  }).done(function(newContent){
    var areaName = item.replace(/(-wineries.php)/, '');

    var list = $(newContent).find("#leftcolumn .spacer").eq(0).find('a');
    console.log(areaName, list);
    // console.log();
    // $('#tbody').append("<tr class = '"+areaName+"'></tr>");
    $(list).each(function(index, winery){
      // $('body').append(this + "<br/>");  
      $.ajax({
        url: dName + $(winery).attr('href'),
        async: true,
        dataType: 'text',
        error: function() {
          console.error('[service.local] Stub "' + item + '" doesn\'t exist.');
        }
      }).done(function(wineryDetail){
        var wInfo = ($(wineryDetail).find("#pagewrapper table").eq(0));

        var wName = "<span class='name'>" + $(wInfo).find(" h1").text() +"</span><br/>";
        var wAdd1 = "<span class='add'>" + $(wInfo).find(" tr:nth-child(2) td:last-child").text() +"</span><br/>";
        var wAdd2 = "<span class='add'>" + $(wInfo).find(" tr:nth-child(3) td:last-child").text() +"</span><br/>";
        var wPhone = "<span class='phone'>" + $(wInfo).find(" tr:nth-child(4) td:last-child").text() +"</span><br/>";
        var wCity = "<span class='city'>" + wAdd2.substr(0, wAdd2.indexOf(',')) +"</span><br/>";
        
        console.log("wname" , wName);
        $('#tbody').append("<tr> <td>"+wName+ "</td><td>" +wAdd1+"</td><td>"+wAdd2+"</td><td>"+wPhone +"</td><td>"+ wCity+"</td><td>"+ areaName +"</td></tr>");

      });
    });

  })
});

