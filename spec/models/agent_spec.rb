require 'rails_helper'

describe Agent do

  let(:agent) { build(:agent) }

  it "should be valid" do
    expect(agent).to be_valid
  end

  it "should not be valid whitout name" do
    agent.name = nil

    expect(agent).not_to be_valid
  end

  it "should not be valid whitout identifier" do
    agent.identifier = nil

    expect(agent).not_to be_valid
  end

  it "should not be valid whitout from" do
    agent.from = nil

    expect(agent).not_to be_valid
  end

  describe "#fullname" do
    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = ""
      agent.second_surname = ""

      expect(agent.fullname).to eq "Name"
    end

    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = "FirstSurname"
      agent.second_surname = ""

      expect(agent.fullname).to eq "Name, FirstSurname"
    end

    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = "FirstSurname"
      agent.second_surname = "SecondSurname"

      expect(agent.fullname).to eq "Name, FirstSurname, SecondSurname"
    end
  end

  describe "scopes" do

    describe "by_organization" do

      it "should return all agents by organization" do
        organization = create(:organization)
        agent1 = create(:agent, organization: organization)
        agent2 = create(:agent, organization: organization)

        agents = Agent.by_organization(organization)

        expect(agents.count).to eq(2)
        expect(agents).to include agent1
        expect(agents).to include agent2
      end

    end

    describe "from_active_organizations" do
      it "should return all agents from an active organization" do
        # active organization means: invalidate <> true && canceled_at == nil
        organization = create(:organization)
        not_active_organization = create(:organization)
        not_active_organization.update(invalidate: true)

        agent1 = create(:agent, organization: organization)
        agent2 = create(:agent, organization: organization)
        create(:agent, organization: not_active_organization)

        agents = Agent.all

        expect(agents.count).to eq(3)

        agents = Agent.from_active_organizations

        expect(agents.count).to eq(2)
        expect(agents).to include agent1
        expect(agents).to include agent2
      end
    end

  end
end
