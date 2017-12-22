feature 'Infringement mailbox' do
  background do
    create(:user, :admin)
  end

  scenario 'Anyone can visit the mailbox page' do
    visit new_infringement_email_path

    expect(page).to have_content I18n.t('infringement_mailbox.title')
  end

  scenario 'Emails are send to the admins' do
    visit new_infringement_email_path

    fill_in :infringement_email_subject, with: "Título del incumplimiento"
    fill_in :infringement_email_link, with: "www.agenda.es"
    attach_file("infringement_email_attachment", Rails.root + "spec/fixtures/dummy.jpg")

    sleep(5)

    click_button I18n.t('infringement_mailbox.send')

    expect(page).to have_content I18n.t('infringement_mailbox.sent')
  end

  scenario 'Invalid files are not been sent' do
    visit new_infringement_email_path

    fill_in :infringement_email_subject, with: "Título del incumplimiento"
    fill_in :infringement_email_link, with: "www.agenda.es"
    attach_file("infringement_email_attachment", Rails.root + "spec/fixtures/dummy.pdf")

    sleep(5) # to pass the invise_captcha

    click_button I18n.t('infringement_mailbox.send')

    expect(page).to have_content 'El fichero no es válido'

  end

  scenario 'Invisible capthcha is working' do
    visit new_infringement_email_path

    fill_in :infringement_email_subject, with: "Título del incumplimiento"
    fill_in :infringement_email_link, with: "www.agenda.es"
    attach_file("infringement_email_attachment", Rails.root + "spec/fixtures/dummy.jpg")

    click_button I18n.t('infringement_mailbox.send')

    expect(current_path).to eq(new_infringement_email_path)
    expect(page).to_not have_content I18n.t('infringement_mailbox.sent')
  end

  scenario 'Fill contact data' do
    visit new_infringement_email_path

    fill_in :infringement_email_name, with: "Añade tu nombre"
    fill_in :infringement_email_first_surname, with: "Añade tu apellido"
    fill_in :infringement_email_email, with: "Añade tu email"
    fill_in :infringement_email_phone, with: "Añade tu teléfono"

    click_button I18n.t('infringement_mailbox.send')
  end

end
