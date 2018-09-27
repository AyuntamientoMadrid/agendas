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

    it 'returns list of recipients excluding users that are not admins' do
      admin_user1 = create(:user, :admin)
      admin_user2 = create(:user, :admin)
      standard_user1 = create(:user)

      expect(newsletter.list_of_recipient_emails.count).to eq(2)

      expect(newsletter.list_of_recipient_emails).to include(admin_user1.email)
      expect(newsletter.list_of_recipient_emails).to include(admin_user2.email)
      expect(newsletter.list_of_recipient_emails).to_not include(standard_user1.email)
    end

  end

  describe "#deliver" do

    it "sends an email with the newsletter to every recipient" do
      admin_user1 = create(:user, :admin)
      admin_user2 = create(:user, :admin)
      standard_user1 = create(:user)
      clear_emails

      create(:newsletter).deliver

      expect(emails_sent_to(admin_user1.email).count).to eq 1
      expect(emails_sent_to(admin_user2.email).count).to eq 1
      expect(emails_sent_to(standard_user1.email).count).to eq 0
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "skips invalid emails" do
      valid_email = "john@gmail.com"
      invalid_email = "john@gmail..com"

      valid_email_user = create(:user, :admin, email: valid_email)
      invalid_email_user = create(:user, :admin, email: invalid_email)
      clear_emails

      newsletter.deliver

      expect(emails_sent_to(valid_email).count).to eq 1
      expect(emails_sent_to(invalid_email).count).to eq 0
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

  end
end
