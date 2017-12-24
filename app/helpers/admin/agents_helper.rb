module Admin::AgentsHelper

  def agent_attachment_persisted_data(attachment)
    return "data-persisted=true" if attachment.persisted?
  end

  def agent_attachment_persisted_remove_notice(attachment)
    render partial: 'layouts/admin_messages',
           locals: {
            alert: t("backend.agents.attachment_destroy_notice")
          } if attachment.present?
  end

  def agents_public_assignments_editor(agent)
    agent.new_record? ? "mceNoEditor" : "tinymce"
  end

end