require 'rails_helper'

describe Newsletter do
  let(:newsletter) { build(:newsletter) }

  it "is valid" do
    expect(newsletter).to be_valid
  end

  it 'is not valid without a subject' do
    newsletter.subject = nil
    expect(newsletter).not_to be_valid
  end

  it 'is not valid without a body' do
    newsletter.body = nil
    expect(newsletter).not_to be_valid
  end

  describe '#list_of_recipient_emails' do

    it 'returns list of recipients that have a certain interest' do
      culture = create(:interest, name: 'Culture')
      health  = create(:interest, name: 'Health')

      organization1 = create(:organization)
      organization2 = create(:organization)
      organization3 = create(:organization)

      organization1.interests << [culture, health]
      organization2.interests << culture

      newsletter.update(interest: culture)

      recipients = newsletter.list_of_recipient_emails

      expect(recipients.count).to eq(2)
      expect(recipients).to include(organization1.email)
      expect(recipients).to include(organization2.email)

      newsletter.update(interest: health)

      recipients = newsletter.list_of_recipient_emails
      expect(recipients.count).to eq(1)
      expect(recipients).to eq([organization1.email])
    end

  end

  describe "#deliver" do

    it "sends an email to every recipient with a certain interest" do
      interest = create(:interest)

      organization1 = create(:organization)
      organization2 = create(:organization)
      organization3 = create(:organization)

      organization1.interests << interest
      organization2.interests << interest
      clear_emails

      create(:newsletter, interest: interest).deliver

      expect(emails_sent_to(organization1.email).count).to eq 1
      expect(emails_sent_to(organization2.email).count).to eq 1
      expect(emails_sent_to(organization3.email).count).to eq 0
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "skips invalid emails" do
      interest = create(:interest)
      newsletter = create(:newsletter, interest: interest)

      organization1 = create(:organization)
      organization2 = create(:organization)

      organization1.interests << interest
      organization2.interests << interest

      valid_email = "john@gmail.com"
      invalid_email = "john@gmail..com"

      organization1.update(email: valid_email)
      organization2.update(email: invalid_email)
      clear_emails

      newsletter.deliver

      expect(emails_sent_to(valid_email).count).to eq 1
      expect(emails_sent_to(invalid_email).count).to eq 0
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "stores a log of the users that have received the newsletter" do
      interest = create(:interest)

      organization1 = create(:organization)
      organization2 = create(:organization)
      organization3 = create(:organization)

      organization1.interests << interest
      organization2.interests << interest
      clear_emails

      newsletter = create(:newsletter, interest: interest)
      newsletter.deliver

      expect(Log.count).to eq 2

      organizations = Log.pluck(:organization_id)
      expect(organizations).to include(organization1.id)
      expect(organizations).to include(organization2.id)

      log = Log.first
      expect(log.organization_id).to eq(organization1.id)
      expect(log.action).to eq("email")
      expect(log.actionable).to eq(newsletter)
    end

  end
end
