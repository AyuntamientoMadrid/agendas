function initializeAgentAttachment(){
  if ($('#nested-legal-representant-wrapper .legal-representant').length > 0)
    $("#legal_representant_link").hide();

  $('#nested-agent-attachment').bind('cocoon:after-insert', function() {
    $("#new-agent-attachment-link").hide();
  });
  $('#nested-agent-attachment').bind("cocoon:after-remove", function() {
    $("#new-agent-attachment-link").show();
    $("#nested-agent-attachment .alert-box").css('display', 'block');
  });
}

$(function(){
  initializeAgentAttachment();
});
