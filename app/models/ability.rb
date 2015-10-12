class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
        if Settings.madrid
            can [:index,:update], User
        else
            can :manage, :all
        end
    else
        can :manage, Event, user_id: user.id
        can :delete, Event, scheduled > Time.now
    end
  end
end
