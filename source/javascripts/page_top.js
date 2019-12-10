$(() => {
  // page_top
  $("#page_top").hide();
  $(window).scroll(() => {
      if ($(this).scrollTop() > 100) {  //100pxスクロールしたら表示
          $("#page_top").fadeIn();
      } else {
          $("#page_top").fadeOut();
      }
  });
  $("#page_top").on('click', () => {
      $("body, html").animate({
          scrollTop: 0
      }, 500); //0.5秒かけてトップへ移動
      return false;
  });
});
