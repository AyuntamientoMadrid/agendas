class EventAgentExistenceValidator < ActiveModel::Validator
  def validate(record)
    return unless  record.lobby_activity && record.event_agents.empty?
    record.errors.add(:event_agents, I18n.translate('backend.event.event_agent_needed'))
  end
end
