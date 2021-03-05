$(function(){
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
});
