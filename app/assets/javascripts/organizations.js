$(function () {
  $('#delete-keywords').on('click', function(e){
    console.log('Hola');
    e.preventDefault();
    $('#keyword').val('');
    $('form').submit();
    $(this).remove();
  });
});