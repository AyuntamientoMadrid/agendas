require 'rails_helper'
require 'cancan/matchers'

describe "Abilities::Administrator" do
  subject(:ability) { Ability.new(user) }

  let(:user) { create(:user, :admin) }
  let(:holder) { create(:holder) }
  let(:event) { create(:event) }

  it { should be_able_to(:index, Users) }
  it { should be_able_to(:show, user) }
  it { should be_able_to(:edit, user) }
  it { should be_able_to(:destroy, user) }

  it { should be_able_to(:index, Holder) }
  it { should be_able_to(:show, holder) }
  it { should be_able_to(:edit, holder) }
  it { should be_able_to(:destroy, holder) }

  it { should be_able_to(:index, Event) }
  it { should be_able_to(:new, event) }
  it { should be_able_to(:show, event) }
  it { should be_able_to(:edit, event) }
  it { should be_able_to(:destroy, event) }

end
