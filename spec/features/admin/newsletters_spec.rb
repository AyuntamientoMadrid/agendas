require 'rails_helper'

feature "Admin newsletter emails" do

  let!(:default_locale) { I18n.locale }

  before do
    admin = create(:user, :admin)
    login_as(admin)

    I18n.locale = :en
  end

  after do
    I18n.locale = default_locale
  end

  scenario "Show" do
    newsletter = create(:newsletter, subject: "This is a subject",
                                     body: "This is a body")

    visit admin_newsletter_path(newsletter)

    expect(page).to have_content "This is a subject"
    expect(page).to have_content "This is a body"
    expect(page).to have_content "If you do not wish to continue receiving this type of emails"
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
    culture = create(:interest)

    visit admin_newsletters_path

    click_link "New newsletter"

    fill_in_newsletter_form(subject: "This is a subject",
                            body: "This is a body",
                            interest: culture.name)

    click_button "Create Newsletter"

    expect(page).to have_content "Newsletter created successfully"
    expect(page).to have_content "This is a subject"
    expect(page).to have_content "This is a body"
  end

  scenario "Update" do
    culture = create(:interest)
    newsletter = create(:newsletter)

    visit admin_newsletters_path
    within("#newsletter_#{newsletter.id}") do
      click_link "Edit"
    end

    fill_in_newsletter_form(subject: "This is an updated subject",
                            body: "This is an updated body",
                            interest: culture.name )
    click_button "Update Newsletter"

    expect(page).to have_content "Newsletter updated successfully"
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

  scenario "Send newsletter email to organization with a certain interest" do
    culture = create(:interest, name: 'Culture')
    health  = create(:interest, name: 'Health')

    organization1 = create(:organization)
    organization2 = create(:organization)
    organization3 = create(:organization)

    organization1.interests << culture
    organization2.interests << culture
    clear_emails

    visit new_admin_newsletter_path

    fill_in "newsletter_subject", with: "Newsletter about culture"
    fill_in "newsletter_body", with: "There are many events coming up!"
    select culture.name, from: "newsletter_interest_id"
    click_button "Create Newsletter"

    expect(page).to have_content "Newsletter created successfully"

    click_link "Send"

    expect(emails_sent_to(organization1.email).count).to eq 1
    expect(emails_sent_to(organization2.email).count).to eq 1
    expect(emails_sent_to(organization3.email).count).to eq 0

    email = first_email_sent_to(organization1.email)
    expect(email.subject).to eq('Newsletter about culture')
    expect(email.from).to eq(['no-reply@madrid.es'])
    expect(email.body).to include('There are many events coming up!')
  end

end
