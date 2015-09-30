$(function(){

  /* FOUNDATION */
  //$(document).foundation();

  /* DATEPICKER */

  /* KEYWORDS */
  $('#delete-keywords').on('click', function(e){
    e.preventDefault();
    $('.keywords').text('');
    $(this).remove();
  })

});
