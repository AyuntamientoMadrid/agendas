$(function () {
  $('#delete-keywords').on('click', function(e){
    e.preventDefault();
    $('#keyword').val('');
    $('form').submit();
    $(this).remove();
  });
});
