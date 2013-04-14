var resultArray = [];
var finishedArray = [];
var dName = "/wine-searcher/";
var prefix = "scripts/search3.cfm/_/USA/OR/"
var avaArray = ["Applegate Valley", "Columbia Gorge", "Columbia Valley", "Red Hill Douglas County", "Rogue Valley", "Snake Valley", "Umpqua Valley", "Walla Walla Valley", "Willamette Valley"];
var counter = 0;
var completedIndices = {};
var T = null;
var pollingStep = 120000;
var started = false;

function start() {
  $("h1.current").off('click').on('click', function(){
    pause();
  });

  if( counter === avaArray.length){
    loadFinishedWineries();
    processWinery(Math.floor(Math.random() * resultArray.length));
    return;
  }

  writeToMyConsole("started loading areas");
  completedIndices = $("#completedIndices");

  $(avaArray).each(function(index, item) {
    if(!item){
      return;
    }
    $.ajax({
      url: dName + prefix + item + '/',
      async: true,
      crossDomain: true,
      dataType: 'html',
      error: function(error) {
        console.error('[service.local] Stub "'  + '" doesn\'t exist. because', error);
      }
    }).done(function(newContent) {
      var _areaName = item;
      var list = $(newContent).find("table b a");
      $(list).each(function(index, wineryHTML) {
        var _wineryHrf = $(wineryHTML).attr('href').replace(/http:\/\/www.wineweb.com\//, '');
        var obj = {
          wineryHrf: _wineryHrf,
          areaName: _areaName
        };
        resultArray.push(obj);
      });
      if (++counter === avaArray.length) {
        writeToMyConsole("Done loading all links for wineries in Oregon, " + resultArray.length + " wineries have been found");
        resultArray.sort(compare);
        loadFinishedWineries();
        processWinery(Math.floor(Math.random() * resultArray.length));
      }
    }); //done handling wineries in an area
  });
}

function loadFinishedWineries() {
  finishedArray = completedIndices.html().trim().split(" ");
  $(finishedArray).each(function(index) {
    finishedArray[index] = parseInt(this, 10);
  });
}

function processWinery(wineryIndex) {
  if (wineryIndex > resultArray.length) {
    wineryIndex = Math.floor(Math.random() * resultArray.length);
    // writeToMyConsole("<h1>Work Complete!</h1>");
    // return;
  }
  if (finishedArray.indexOf(wineryIndex)!== -1){
    processWinery(wineryIndex+1);
    return;
  }
  var winery = resultArray[wineryIndex];
  writeToMyConsole("Start processing winery " + wineryIndex);
  $.ajax({
    url: dName + winery.wineryHrf,
    async: true,
    dataType: 'text',
    error: function() {
      console.error('[service.local] Stub "' + '" doesn\'t exist.');
      T = setTimeout(function() {
        processWinery(wineryIndex+1);
      }, pollingStep);
    }
  }).done(function(wineryDetail) {
    if (wineryDetail.indexOf("The pattern of access to these pages indicate that someone may be using an automated program to display these wineries.") !== -1) {
      console.log("failed... to load " + wineryIndex);
      writeToMyConsole("Failed processing winery " + wineryIndex);
      T = setTimeout(function() {
        processWinery(wineryIndex+20);
      }, pollingStep);
      return;
    }

    var wInfo = ($(wineryDetail).find("#content").eq(0));
    winery.wName = wInfo.find('h1#head1').text();
    var otherInfo = wInfo.find('p').eq(1);
    $(otherInfo.text().split('\n')).each(function(index, item) {
      if (index === 0) {
        winery.wAdd1 = this.trim();
      } else if (index === 1) {
        winery.wAdd2 = this.trim();
        winery.city = winery.wAdd2.substring(0, winery.wAdd2.indexOf(','));
      } else if (index === 3) {
        winery.phone = this.trim();
      }
    });

    if (!winery.wName) {
      //incomplete information
      // console.log("winery name N/A for " +wineryIndex);
      // writeToMyConsole("winery name N/A for " +wineryIndex);
      T = setTimeout(function() {
        processWinery(wineryIndex+1);
      }, pollingStep);

      winery.wName = winery.wineryHrf.match(/\d\/.{0,}(?=\/)/)[0].match(/[^\d\/]{1,}/)[0].replace(/-/, " ");
      winery.wAdd1 = winery.wineryHrf;
      // return;
    }

    var wName = "<span class='name'>" + winery.wName + "</span><br/>";
    var wAdd1 = "<span class='add'>" + winery.wAdd1 + "</span><br/>";
    var wAdd2 = "<span class='add'>" + winery.wAdd2 + "</span><br/>";
    var wPhone = "<span class='phone'>" + winery.phone + "</span><br/>";
    var wCity = "<span class='city'>" + winery.city + "</span><br/>";

    $('#tbody').append("<tr> <td>" + wName + "</td><td>" + wAdd1 + "</td><td>" + wAdd2 + "</td><td>" + wPhone + "</td><td>" + wCity + "</td><td>" + winery.areaName + "</td></tr>");

    completedIndices.html(completedIndices.html() + " " + wineryIndex);
    finishedArray.push(wineryIndex)
    writeToMyConsole("Finished processing winery " + wineryIndex);

    T = setTimeout(function() {
      processWinery(wineryIndex + 1);
    }, pollingStep);

  });
}

function compare(a, b) {
  if (a.wineryHrf < b.wineryHrf) return -1;
  if (a.wineryHrf > b.wineryHrf) return 1;
  return 0;
}

function pause(){
  if(T!= null){
    clearTimeout(T);
  }
  writeToMyConsole("Paused...");
  $("h1.current").off('click').on('click', function(){
    start();
  });
}

function getCurrentTime(){
  var d = new Date();
  return d.getHours() + " : " + d.getMinutes() + " : " + d.getSeconds();
}

function writeToMyConsole(content){
  $("h1.current").html(getCurrentTime() + "  -  " + content);
}

$(document).ready(function(){
  $("h1.current").on('click', function(){
    start();
  });
});