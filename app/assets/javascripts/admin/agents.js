function initializeAgentAttachment(){
  if ($('#nested-agent-attachments .nested-fields').length > 0)
    $("#new-agent-attachment-link").hide();

  $('#nested-agent-attachments').bind('cocoon:after-insert', function() {
    $("#new-agent-attachment-link").hide();
  });
  $('#nested-agent-attachments').bind("cocoon:after-remove", function() {
    $("#new-agent-attachment-link").show();
    $("#nested-agent-attachment .alert-box").css('display', 'block');
  });
}

$(function(){
  initializeAgentAttachment();
});
