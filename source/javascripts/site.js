$(function(){

  // 先頭に戻る
  $("#page_top").hide();
  $(window).scroll(function(){
    if ($(this).scrollTop() > 100) { //100pxスクロールしたら表示
      $("#page_top").fadeIn();
    } else {
      $("#page_top").fadeOut();
    }
  });
  $("#page_top").on("click", function() {
    $("body, html").animate({
      scrollTop: 0
    }, 500); //0.5秒かけてトップへ移動
    return false;
  });

  // pagination
  // 最初は active 以外のコンテンツを非表示に
  $(".page-content").hide();
  $(".page-content.active").show();
  var active_id = $(".pagination .page-item.active a").attr("href");
  $("active_id").show();
  // page がクリックされたときに、そのコンテンツを表示
  $(".page-item").on("click", function() {
    $(".page-content").hide();
    var time = 100;
    var href = $(this).find("a").attr("href");
    var target = $(href);
    var distance = target.offset().top;
    $($(this).find("a").attr("href")).show();
    $("html, body").animate({
      scrollTop: distance
    }, time, "swing");
    return false;
  });

  // 固定フッター 電話をかける 表示用
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

  // 工事施行例 工事名称表示用
  $(window).scroll(function() {
    var currentPos = $(this).scrollTop();
    var triggerPos = 215;
    var fixed_construction_name = $('.construction.name');

    if (currentPos > triggerPos) {
      fixed_construction_name.addClass('active');
    } else {
      fixed_construction_name.removeClass('active');
    }
  });
});
