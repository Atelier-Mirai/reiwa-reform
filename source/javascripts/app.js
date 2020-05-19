function dropping_header() {
  // if ($('body').is('.home')) {
    // alert('.home');
    $('.main_visual').fadeTo(1800, 1);
    $('.l-header').animate({
      'top': '0',
      'opacity': '1'
    }, 500);
  // }
}

//Smartphone menu
function sp_menu() {
  var winW = $(this).innerWidth();
  $('#sp_menu').click(function() {
    $(this).stop(true, true).toggleClass('active');
    $('.gnavi').stop(true, true).slideToggle();
  });

  $(window).on('load', function() {
    $('#sp_menu').removeClass('active');
    $('.gnavi').css({
      'display': ''
    });
  });

  $(window).on('resize', function() {
    //iOS Safariのスクロール時リサイズイベントには反応させない
    var currentWinW = $(this).innerWidth();
    if (currentWinW !== winW) {
      $('#sp_menu').removeClass('active');
      $('.gnavi').css({
        'display': ''
      });
    }
  });
}

function fixed_footer() {
  $(window).scroll(function() {
    var currentPos = $(this).scrollTop();
    var triggerPos = 150;
    var fixedFooter = $('#fixed_footer');

    if (currentPos > triggerPos) {
      fixedFooter.addClass('active');
    } else {
      fixedFooter.removeClass('active');
    }
  });
}

(function($) {

  $(function() {
    sp_menu();
    fixed_footer();

    // 先頭へ戻る
    var $pagetop = $(".pagetop");
    $pagetop.hide();
    $(window).scroll(function() {
      // 100pxスクロールしたら表示
      $(this).scrollTop() > 100 ? $pagetop.fadeIn() : $pagetop.fadeOut()
    });
    $pagetop.on('click', function() {
      $("body,html").animate({
        scrollTop: 0
      }, 500);
      // $pagetop.hide();
    });
  });

  $(window).on('load', function() {
    var currentW = $(window).innerWidth();
    if (currentW > 979) {
      dropping_header();
      // alert('dropping_header');
    }

    $('#ttl_line').animate({
      width: '100%'
    }, 2000);
  });

})(jQuery);
