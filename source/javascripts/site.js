$(function(){
  // page_top
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
  $("$("+active_id+")").show();
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

  // Porfolio isotope and filter
  var portfolioIsotope = $(".portfolio-container").isotope({
    itemSelector: ".portfolio-item",
    layoutMode: "fitRows"
  });

  $("#portfolio-flters li").on("click", function() {
    $("#portfolio-flters li").removeClass("filter-active");
    $(this).addClass("filter-active");
    portfolioIsotope.isotope({
      filter: $(this).data("filter")
    });
  });
});
