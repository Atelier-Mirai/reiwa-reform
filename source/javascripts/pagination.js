$(() => {
  // .pagination
  //   li.page-item.active
  //     a href="#page1" 1
  // 最初は active 以外のコンテンツを非表示に
  $(".page-content").hide();
  $(".page-content.active").show();
  let active_id = $(".pagination .page-item.active a").attr("href");
  $(`${active_id}`).show();
  // page がクリックされたときに、そのコンテンツを表示
  $(".page-item").on('click', function(){
    $(".page-content").hide();
    let time = 100;
    let href = $(this).find('a').attr("href");
    let target = $(href);
    let distance = target.offset().top;
    $($(this).find('a').attr("href")).show();
    $("html, body").animate({
      scrollTop: distance
    }, time, "swing");
    return false;
  });
});
