//Oregon
var dName = "Oregon/";
var list = ["ormerch.html", "ormerch2.html"];

$(list).each(function(index, item) {
  $.ajax({
    url: dName + item,
    async: true,
    dataType: 'text',
    error: function() {
      console.error('[service.local] Stub "' + site + '" doesn\'t exist.');
    }
  }).done(function(newContent) {
    var fullList;
    if (index == 0) {
      fullList = $(newContent).find("tbody td").children("table").children("tbody").find("tr:nth-child(4)");
    } else {
      fullList = $(newContent).find("tbody td").children("table").children("tbody").find("tr").eq(4);
    }
    $('body').append(fullList.html());
  });
});

setTimeout(function() {
  $('p').each(function(index, item){
    processWinery(index, item);
  });
  $('dl').each(function(index, item){
    item.find(p).remove();
    processWinery(index, item);
  });

}, 3000);


function processWinery(index, item) {
  if ($(item).html().match(/--/) != null) {
    return;
  } else if ($(item).html().indexOf('href="#top"') !== -1) {
    return;
  }
  // if(index > 3) return;
  var winery = $(item);

  var wName = 'no name';
  var wHours = '(Hours not Available)';
  var wAdd = 'address';
  var wTel = 'phone number N/A';
  var otherInfo = '';
  var sToAppend = '';

  var fullText = winery.text();
  var hoursPattern = /\([.\s\S]*\)/gm;

  if (hoursPattern.test(fullText)) {
    //has hour
    var startHourIndex = fullText.indexOf('\('),
      endHourIndex = fullText.indexOf('\)');
    wHours = fullText.substring(startHourIndex, endHourIndex + 1);
    wName = fullText.substring(0, startHourIndex).trim();
    otherInfo = fullText.substring(endHourIndex + 1).trim();
    var telArr = otherInfo.match(/\d{3}-\d{3}-\d{4}/);
    if (telArr) {
      wTel = otherInfo.substring(otherInfo.indexOf(telArr[0]));
      otherInfo = otherInfo.substring(0, otherInfo.indexOf(telArr[0]));
    }
    $('#tbody').append("<tr> <td><span class='name'>" + wName + "</span></td><td><span class='hour'>" + wHours + "</span></td><td>" + otherInfo + "</td><td><span class='phone'>" + wTel + "</span></td></tr>");


  } else {
    console.log("ok", fullText);

    var arr = fullText.split('\n');

    var finalArr = [];
    $(arr).each(function(index, item) {
      var content = item.replace(/\s{2,}/g, '');
      if (content !== '') {
        finalArr.push(content);
      }
    });

    $(finalArr).each(function(index, item) {
      if (index === 0) {
        sToAppend = sToAppend.concat("<td><span class=name>" + item + "</span></td>");
      } else if (index === 1) {
        sToAppend = sToAppend.concat("<td>Hours N/A</td>");
      } else {
        sToAppend = sToAppend.concat("<td>" + item + "</td>");
      }
    });
    $('#tbody').append("<tr>" + sToAppend + "</tr>");

  }

}


/*
var wName = 'no name';
    var wHours = '';
    var sToAppend = '';
    var firstChild = $(winery).find(">:first-child");
    if (!firstChild[0]) {
      return;
    }
    var firstChildName = firstChild[0].tagName.toLowerCase();
    if (firstChildName === "br") {
      firstChild.remove().delete;
      firstChild = $(winery).find(">:first-child");
      if (!firstChild[0]) {
        return;
      }
      firstChildName = firstChild[0].tagName.toLowerCase();
    }


    if (firstChildName === 'font') {
      wName = "SUP" + $(winery).find("font").eq(0).remove().text();
      wHours = $(winery).find("b").eq(0).remove().text();

      if ($(winery).find("font").length !== 0) {
        var otherInfoArray = $(winery).find("font").html().split('<br>');
        $(otherInfoArray).each(function(index, item) {
          var content = item.replace(/\s{2,}/g, '');
          if (content !== '') {
            sToAppend = sToAppend.concat("<td>" + item.replace(/\s{2,}/g, '') + "</td>");
          }
        });
      }
    } else {
      if (firstChildName === 'b' || firstChildName === 'span') {
        var name_and_hours = $(winery).find("b").remove();
        name_and_hours.find("font").each(function(index, item) {
          if (index == 0) {
            // console.log(index, "name" + this.innerHTML.replace(/<br>/gi,''));
            wName = "<span class='name'>" + this.innerHTML.replace(/<br>/gi, '') + "</span><br/>";

          } else if (index == 1) {
            // console.log(index, "hours" + this.innerHTML.replace(/<br>/gi,''));
            wHours = this.innerHTML.replace(/<br>/gi, '').replace(/\n/gi, '');
          } else {
            console.log("has more ", this);
          }
        });

        if (wName === 'no name') {
          wName = name_and_hours.text().replace(/\s{2,}/g, '');
        }

        if ($(winery).find("font").length !== 0) {
          var otherInfoArray = $(winery).find("font").html().split('<br>');
          $(otherInfoArray).each(function(index, item) {
            var content = item.replace(/\s{2,}/g, '');
            if (content !== '') {
              sToAppend = sToAppend.concat("<td>" + item.replace(/\s{2,}/g, '') + "</td>");
            }
          });
        }
      }
      else{
        console.log("another tag", firstChildName);
      }
    }

    console.log("----------");
    console.log(wName);
    console.log(wHours);
    console.log(sToAppend);
    console.log("----------");

    $('#tbody').append("<tr> <td>" + wName + "</td><td>" + wHours + "</td>" + sToAppend + "</tr>");
*/