// (($ => {
//   $.fn.autoplay = function (options) {
//     // 設定事項
//     const settings = $.extend({
//       autoplay: true,
//       speed:    3000
//     }, options);
//
//     // 関数本体
//     return this.each((i, e) => {
//       if (settings.autoplay == false) {
//         return false;
//       }
//
//       e = $(e);
//       const slide_count = $('input[name="carousel-radio"]').length;
//       setInterval(()=>{
//         next_index = (get_active_slide_number() + 1) % slide_count;
//         $(`#slide-${next_index}`).click();
//       }, settings.speed);
//     });
//   };
//
//   function get_active_slide_number(){
//     let index;
//     $('input[name="carousel-radio"]').each( (i, e) => {
//       if ($(e).prop('checked') == true){
//         index = i;
//         // id    = $(e).prop('id'); // id 取得
//         return false;
//       }
//     });
//     return index;
//   };
// })(jQuery));
