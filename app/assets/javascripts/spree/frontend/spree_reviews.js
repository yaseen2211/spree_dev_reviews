//= require jquery.rating
//= require spree/frontend
//= require spree/frontend/spree_auth

// Navigating to a page with ratings via TurboLinks shows the radio buttons
$(document).on('page:load', function () {
  $('input[type=radio].star').rating();
});
$(document).on('click','.js-rating-event',function () {
    let id = $(this).attr('data-formidreview');
    $('.js-review-form-'+id).css('display','block')
    let span= $('.js-form-'+id).find('span');
    let c = 0;
    for(let i = 0;i < 5; i++){
        if($(span[i]).hasClass('active')){
            c +=1
        }
    }
    $('.js-review-form-'+id).children('#rating').val(c.toString());
})
function readMoreFunction() {
    var dots = document.getElementById("dots");
    var moreText = document.getElementById("more");
    var btnText = document.getElementById("myBtn");

    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "Read more";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "Read less";
        moreText.style.display = "inline";
    }
}
// $(document).on('click','.js-rating-modal',function(){
//     debugger;
//     let id = $(this).attr('id');
//     let el = $('#'+id).first().children();
//     let old_stars = $('.star-rating-control').first().children();
//     let c =0;
//     for(let i =0 ;i < 5; i++){
//         if($(el).hasClass('active')){
//             c += 1;
//             $(old_stars[i+1]).addClass('star-rating-on')
//         }
//         el = $(el).children();
//     }
//     if (c > 0){
//         $(old_stars[c+1]).trigger('click');
//     }
//
// })