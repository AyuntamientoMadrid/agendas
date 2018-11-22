require 'rails_helper'

describe Log do

  describe "#activity" do

    it "creates a log entry for an activity" do
      organization = create(:organization)
      newsletter = create(:newsletter)

      expect{ Log.activity(organization, :email, newsletter) }.to change { Log.count }.by(1)

      log = Log.last
      expect(log.organization_id).to eq(organization.id)
      expect(log.action).to eq("email")
      expect(log.actionable).to eq(newsletter)
    end

  end

end
