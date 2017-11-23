$(function(){
  $('#nested-legal-representant').bind('cocoon:after-insert', function() {
    $("#legal_representant_link").hide();
  });
  $('#nested-legal-representant').bind("cocoon:after-remove", function() {
    $("#legal_representant_link").show();
  });
});
