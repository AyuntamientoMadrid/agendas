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
      else
        can :manage, :all
      end
      can :index, :activities
    else
      can :manage, Event, id: Event.ability_titular_events(user)
      if(Event.has_manage_holders(user))
        can :new, Event
      end
      can :create, Event
      can :show, Event, id: Event.ability_events(user)
      cannot :destroy, Event do |event|
        event.scheduled < Time.now
      end
    end
  end
end

