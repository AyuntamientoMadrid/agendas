$(function(){
  $('#nested-legal-representant-wrapper').bind('cocoon:after-insert', function() {
    $("#legal_representant_link").hide();
  });
  $('#nested-legal-representant-wrapper').bind("cocoon:after-remove", function() {
    if ($("#legal_representant_link").length > 0) {
      $("#legal_representant_link").show();
    } else {
      link = $('<a href="#" id="cancel-link">Cancelar Eliminación</a>')
      link.bind("click", restore_legal_representant);
      link.appendTo('#nested-legal-representant-wrapper > .small-12.columns');
    }
  });
  if ($('#nested-legal-representant-wrapper .legal-representant').length > 0) {
    $("#legal_representant_link").hide();
  }

  function toggle_hidden(id) {
    var hiddenField = $(id),
        val = hiddenField.val();
    hiddenField.val(val === "true" ? "false" : "true");
  }

  $('#invalidate_link').bind('click', function(e){
    e.preventDefault();

    toggle_hidden('#organization_invalidate')
    $('#invalidate-reason').toggle();
  });

  $('#validate_link').bind('click', function(e){
    e.preventDefault();

    toggle_hidden('#organization_validate')
    $('#invalidate-reason').hide();
    $('#validate_link').toggleClass('success');
  });

});

function restore_legal_representant(e){
  e.preventDefault();
  $('#nested-legal-representant-wrapper .legal-representant').show();
  $(this).remove();
  $('#organization_legal_representant_attributes__destroy').val(0);
}
