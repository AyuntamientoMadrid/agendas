class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      if Rails.application.secrets.madrid
        can [:index,:update,:show, :import], User
        can :manage, Event
        can :index, Area
        can [:index, :show], Holder
        can :manage, Organization
        can :manage, Question
      else
        can :manage, :all
      end
      can :index, :activities
    elsif user.lobby?
      can [:index, :new, :create, :show], Event
      can [:edit, :update], Event, status: "requested"
      can [:show, :edit, :update, :add_agents, :add_interests], Organization, id: user.organization_id
    else
      if Holder.managed_by(user.id).any?
        can :manage, Event, id: Event.ability_titular_events(user)
        can :show, Event, id: Event.ability_events(user)
        can :create, Event
      else
        can :index, Event
      end
    end
  end
end

