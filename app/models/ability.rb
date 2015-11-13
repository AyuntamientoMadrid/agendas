class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
        if Rails.application.secrets.madrid
            can [:index,:update,:show], User
            can :manage, Event
            can :index, Area
            can [:index, :show], Holder
        else
            can :manage, :all
        end
    else
        can :manage, Event, user_id: user.id
        can :delete, Event do |event|
            event.scheduled > Time.now
        end
    end
  end
end
