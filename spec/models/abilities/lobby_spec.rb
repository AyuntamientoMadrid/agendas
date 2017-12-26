require 'rails_helper'
require 'cancan/matchers'

feature "Abilities::User lobby" do
  let(:lobby_user)    { create(:user, role: :lobby) }
  let!(:organization) { create(:organization, user: lobby_user) }

  subject(:ability) { Ability.new(lobby_user) }

  describe "Agents" do
    let!(:agent)                      { create(:agent, organization: organization) }
    let!(:another_organization_agent) { create(:agent) }

    it { should be_able_to(:index, Agent) }
    it { should be_able_to(:new, Agent) }
    it { should be_able_to(:edit, agent) }
    it { should be_able_to(:update, agent) }
    it { should_not be_able_to(:destroy, agent) }

    it { should_not be_able_to(:edit, another_organization_agent) }
    it { should_not be_able_to(:update, another_organization_agent) }
    it { should_not be_able_to(:destroy, another_organization_agent) }
  end

  describe "OrganizationInterests" do
    let!(:organization_interest)      { create(:organization_interest, organization: organization) }
    let!(:another_organization_organization_interest) { create(:organization_interest) }

    it { should be_able_to(:index, OrganizationInterest) }
    it { should be_able_to(:update, organization_interest) }
    it { should_not be_able_to(:update, another_organization_organization_interest) }
  end
end
