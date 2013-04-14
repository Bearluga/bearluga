(function() {
  var $sideNavList, $mainContent;
  var myScroll;

  function switchPage() {
    var linkClass = $(this).parent().attr('class');
    if(linkClass && linkClass.indexOf('active') !== -1){
      return;
    }
    var me = this;
    var link = $(this).attr('data-link');
    if (link) {
      $('yy-loading').addClass('yy-in-progress');
      $('yy-content-area').addClass('yy-in-progress');
      changeContent($mainContent, link,

      function() {
        //onAfter
        adjustVerticallyCentered();
        setTimeout(function() {
          myScroll.refresh();
          myScroll.scrollTo(0, 0, 0);
          myScroll.scrollTo(-100, 0, 0);
        }, 100);

        $("#know-more").off('click').on('click', function(){
          $(".yy-veritically-center").css({
            'top' : '-100px',
            'opacity' : 0
          });

          $('.pager .next a').click();
        })
      },

      function() {
        //onBefore
        $sideNavList.find('.active').removeClass('active');
        $(me).parent().addClass('active');
        $('.yy-loading').addClass('yy-in-progress');
      },

      function() {
        //onBeforeAfter
        $('.yy-loading').removeClass('yy-in-progress');
      }); //end changeContent
    }
  }

  function adjustHeight() {
    var wrapper = $('#iscroll-wrapper'),
      height = $('#footer').offset().top - wrapper.offset().top - $('#footer').height();
    wrapper.css('height', height);
  }

  function adjustVerticallyCentered() {
    if ($('.yy-content-area .yy-veritically-center').length !== 0) {
      var height = $('.yy-content-area').parent().height() - 38;
      var marginTop = -$('.yy-veritically-center').innerHeight() / 2;
      $('.yy-content-area').css({
        'height': height,
      });
      // $('.yy-veritically-center').css({
      //   'margin-top': marginTop,
      //   'top': '50%',
      //   'opacity': '1'
      // });

      setTimeout(function() {
        $('.yy-veritically-center').addClass('adjustMargin');
      }, 500);
    } else {
      $('.yy-content-area').css({
        'height': 'auto',
      });
    }
  }

  function bindEvents() {
    $sideNavList.on('click', 'li a', switchPage);
    $sideNavList.find('.nav-header').on('click', function() {
      var icon = $(this).find('i');
      // if(icon.attr('class')==="icon-chevron-down"){
      //   icon.attr('class', 'icon-chevron-up');
      // }else{
      //   icon.attr('class', 'icon-chevron-down');  
      // }
      // icon.toggleClass('upsidedown');
    });
    $(window).on('resize', function() {
      adjustHeight();
      adjustVerticallyCentered();
    });
    $('.yy-nav-list .collapse').collapse({
      toggle: false
    }).on('show', function() {
      var showingitem = this;
      $(this).prev().find('i').addClass('upsidedown');
      $sideNavList.find('.collapse').each(function(index, item) {
        if (showingitem !== item) {
          $(item).collapse('hide');
        }
      });
    }).on('hide', function(){
      $(this).prev().find('i').removeClass('upsidedown');
    });

    //pager highlighting effect on hovering
    $('.pager a').mouseover(function() {
      $(this).children('i').addClass('icon-white');
    }).mouseout(function() {
      $(this).children('i').removeClass('icon-white');
    }).on('click', function(){
      //paging navigation
      var isPrev = $(this).parent().hasClass('previous');
      var currentIndex = $('.yy-nav-list a').index($('.yy-nav-list li.active a')[0]);
      var nextIndex = (isPrev)? currentIndex-1: currentIndex+1;
      if(nextIndex >= 0 && nextIndex < $('.yy-nav-list a').length){
        var nextLinkEle = $('.yy-nav-list a').eq(nextIndex);
        $(nextLinkEle.closest('div.collapse')).collapse('show');
        setTimeout(function(){
          $('.yy-nav-list a').eq(nextIndex).click();
        }, 300);
      }else{
        console.log("no more pages");
      }
    });

    $('#content-yy-sidenav a').on('click', function(){
      var ele = $(this).attr('href');
      myScroll.scrollToElement("div[scrollToId='"+ele+"']", 500);
    });

  }

  function loadiScroll() {
    setTimeout(function() {
      myScroll = new iScroll('iscroll-wrapper', {
        fadeScrollbar: true,
        hideScrollbar: true
      });
    }, 100);
  }

  function loadHome() {
    $sideNavList.find('#yy-nav-homelink').click();
  }

  function init() {
    $sideNavList = $(".yy-nav-list");
    $mainContent = $(".yy-content-area");
    adjustHeight();
    bindEvents();
    loadHome();
    loadiScroll();
  }

  function matrixToArray(matrix) {
    return matrix.substr(7, matrix.length - 8).split(', ');
  }

  $(document).ready(function() {
    init();
  });

}())