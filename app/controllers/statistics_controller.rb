class StatisticsController < ApplicationController

  def index
    @lobby_category = Organization.lobby.joins(:category).select("categories.name").group("categories.name").count
    @lobbies_interests = Interest.all.map { |e| [e.name, e.organizations.lobby.count] }.to_h
    @lobbies_active = Organization.lobby.where(invalidated_at: nil, canceled_at: nil).pluck(:name)
    @agent_active = Agent.count
    @event_lobby_activity = Event.where("lobby_activity").count
    @event_all = Event.count
    @holder_all = Holder.count
  end

end
