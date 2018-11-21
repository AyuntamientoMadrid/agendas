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

    it 'always includes the group admin email' do
      recipients = newsletter.list_of_recipient_emails
      expect(recipients).to eq([newsletter.admin_email])
    end

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

      expect(recipients.count).to eq(3)
      expect(recipients).to include(organization1.email)
      expect(recipients).to include(organization2.email)
      expect(recipients).to include(newsletter.admin_email)

      newsletter.update(interest: health)

      recipients = newsletter.list_of_recipient_emails
      expect(recipients.count).to eq(2)
      expect(recipients).to include(organization1.email)
      expect(recipients).to include(newsletter.admin_email)
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
      expect(emails_sent_to(organization2.email).count).to eq 1
      expect(emails_sent_to(newsletter.admin_email).count).to eq 1
      expect(ActionMailer::Base.deliveries.count).to eq(3)
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
      expect(emails_sent_to(newsletter.admin_email).count).to eq 1
      expect(ActionMailer::Base.deliveries.count).to eq(2)
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

      expect(Log.count).to eq 3

      organizations = Log.pluck(:organization_id)
      expect(organizations).to include(organization1.id)
      expect(organizations).to include(organization2.id)

      log = Log.where(organization_id: organization1.id).first
      expect(log.action).to eq("email")
      expect(log.actionable).to eq(newsletter)

      log = Log.where(organization_id: nil).first
      expect(log.action).to eq("admin_email")
      expect(log.actionable).to eq(newsletter)
    end

    it "continues sending the newsletter if there is an exception in a delivery" do
      allow_any_instance_of(Newsletter)
      .to receive(:list_of_recipient_emails)
      .and_return(["john@gmail.com", nil, "isable@gmail.com"])

      allow_any_instance_of(Newsletter)
      .to receive(:valid_email?)
      .and_return(true)

      clear_emails
      newsletter = create(:newsletter)
      newsletter.deliver

      expect(emails_sent_to("john@gmail.com").count).to eq 1
      expect(emails_sent_to("isable@gmail.com").count).to eq 1

      expect(Log.count).to eq(3)

      error_log = Log.second
      expect(error_log.organization_id).to eq(nil)
      expect(error_log.action).to eq("email_error")
      expect(error_log.actionable).to eq(newsletter)
    end

  end
end
