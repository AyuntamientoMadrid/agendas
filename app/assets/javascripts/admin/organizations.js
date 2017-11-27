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

  var agents_i = 0;

  $('#nested-agents').on('cocoon:after-insert', function() {
    agents_i ++;
    $('#new_agent').attr("id",'new_agent_' + agents_i);
  });

  var represented_i = 0;
  $('#nested-represented-entities').on('cocoon:after-insert', function() {
    represented_i ++;
    $('#new_represented_entity').attr("id",'new_represented_entity_' + represented_i);
  });



});

function restore_legal_representant(e){
  e.preventDefault();
  $('#nested-legal-representant-wrapper .legal-representant').show();
  $(this).remove();
  $('#organization_legal_representant_attributes__destroy').val(0);
}
