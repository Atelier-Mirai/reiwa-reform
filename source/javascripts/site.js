$(() => {
  page_top
  $("#page_top").hide();
  $(window).scroll(() => {
    if ($(this).scrollTop() > 100) { //100pxスクロールしたら表示
      $("#page_top").fadeIn();
    } else {
      $("#page_top").fadeOut();
    }
  });
  $("#page_top").on("click", () => {
    $("body, html").animate({
      scrollTop: 0
    }, 500); //0.5秒かけてトップへ移動
    return false;
  });

  // 最初は active 以外のコンテンツを非表示に
  $(".page-content").hide();
  $(".page-content.active").show();
  let active_id = $(".pagination .page-item.active a").attr("href");
  $(`${active_id}`).show();
  // page がクリックされたときに、そのコンテンツを表示
  $(".page-item").on("click", function() {
    $(".page-content").hide();
    let time = 100;
    let href = $(this).find("a").attr("href");
    let target = $(href);
    let distance = target.offset().top;
    $($(this).find("a").attr("href")).show();
    $("html, body").animate({
      scrollTop: distance
    }, time, "swing");
    return false;
  });

  // Porfolio isotope and filter
  const portfolioIsotope = $(".portfolio-container").isotope({
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
