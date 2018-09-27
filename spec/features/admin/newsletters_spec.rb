require 'rails_helper'

feature "Admin newsletter emails" do

  background do
    admin = create(:user, :admin)
    login_as(admin)
  end

  before do
    I18n.locale = :en
  end

  after do
    I18n.locale = :es
  end

  scenario "Show" do
    newsletter = create(:newsletter, subject: "This is a subject",
                                     body: "This is a body")

    visit admin_newsletter_path(newsletter)

    expect(page).to have_content "This is a subject"
    expect(page).to have_content "This is a body"
  end


  scenario "Index" do
    3.times { create(:newsletter) }

    visit admin_newsletters_path

    expect(page).to have_css(".newsletter", count: 3)

    Newsletter.find_each do |newsletter|
      within("#newsletter_#{newsletter.id}") do
        expect(page).to have_content newsletter.subject
      end
    end
  end

  scenario "Create" do
    visit admin_newsletters_path

    click_link "New newsletter"

    fill_in_newsletter_form(subject: "This is a subject",
                            body: "This is a body" )
    click_button "Create Newsletter"

    expect(page).to have_content "Newsletter created successfully"
    expect(page).to have_content "This is a subject"
    expect(page).to have_content "This is a body"
  end

  scenario "Update" do
    newsletter = create(:newsletter)

    visit admin_newsletters_path
    within("#newsletter_#{newsletter.id}") do
      click_link "Edit"
    end

    fill_in_newsletter_form(subject: "This is an updated subject",
                            body: "This is an updated body" )
    click_button "Update Newsletter"

    expect(page).to have_content "Newsletter updated successfully"
    expect(page).to have_content "This is an updated subject"
    expect(page).to have_content "This is an updated subject"
  end

  scenario "Destroy" do
    newsletter = create(:newsletter)

    visit admin_newsletters_path
    within("#newsletter_#{newsletter.id}") do
      click_link "Delete"
    end

    expect(page).to have_content "Newsletter deleted successfully"
    expect(page).to have_css(".newsletter", count: 0)
  end

  scenario 'Errors on create' do
    visit new_admin_newsletter_path

    click_button "Create Newsletter"

    expect(page).to have_content error_message
  end

  scenario "Errors on update" do
    newsletter = create(:newsletter)
    visit edit_admin_newsletter_path(newsletter)

    fill_in "newsletter_subject", with: ""
    click_button "Update Newsletter"

    expect(page).to have_content error_message
  end

  scenario "Send newsletter email to admin users" do
    admin_user1 = create(:user, :admin)
    admin_user2 = create(:user, :admin)
    standard_user1 = create(:user)
    standard_user2 = create(:user)
    clear_emails

    login_as(admin_user1)
    visit new_admin_newsletter_path

    fill_in "newsletter_subject", with: "Newsletter for admins"
    fill_in "newsletter_body", with: "Beta testing newsletters"
    click_button "Create Newsletter"

    expect(page).to have_content "Newsletter created successfully"

    click_link "Send"

    expect(emails_sent_to(admin_user1.email).count).to eq 1
    expect(emails_sent_to(admin_user2.email).count).to eq 1
    expect(emails_sent_to(standard_user1.email).count).to eq 0
    expect(emails_sent_to(standard_user2.email).count).to eq 0

    email = first_email_sent_to(admin_user1.email)
    expect(email.subject).to eq('Newsletter for admins')
    expect(email.from).to eq(['no-reply@madrid.es'])
    expect(email.body).to include('Beta testing newsletters')
  end

end
