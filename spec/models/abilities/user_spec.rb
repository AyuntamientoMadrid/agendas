require 'rails_helper'
require 'cancan/matchers'

describe "Abilities::User" do
  subject(:ability) { Ability.new(user) }

  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }

  it { should be_able_to(:index, Event) }
  it { should be_able_to(:show, event) }
  it { should be_able_to(:edit, event) }

  it { should_not be_able_to(:manage, User) }
  it { should_not be_able_to(:manage, Area) }
  it { should_not be_able_to(:manage, Holder) }

end
