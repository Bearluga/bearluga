var yy = {};
yy.currentRequest = null;

function loadPage(newContentURL, change) {
  return $.ajax({
    url: newContentURL,
    async: true,
    dataType: 'html',
    cache: 'false',
    error: function() {
      console.error('[service.local] Stub "' + newContentURL + '" doesn\'t exist.');
    }
  }).done(function(newContent) {
    setTimeout(
    function() {
      change(newContent);
    }, Math.floor(Math.random() *1)+0);
  });
}

function changeContent(obj, newContentURL, onAfter, onBefore, onBeforeAfter) {
  yy.currentRequest = newContentURL;

  if (onBefore) {
    onBefore();
  }

  var change = function(newContent) {
    if (yy.currentRequest !== newContentURL) {
      return;
    }
    $(obj).hide();
    $(obj).get(0).innerHTML = newContent;

    if(onBeforeAfter){
      onBeforeAfter();
    }

    $(obj).fadeIn(400, function() {
      if (onAfter) {
        onAfter();
      }
    });
  }
  loadPage(newContentURL, change);
}