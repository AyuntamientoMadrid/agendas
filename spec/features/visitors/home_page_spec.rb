feature 'Home page' do

  scenario 'Should show page title', :search do
    visit root_path

    expect(page).to have_content I18n.t 'main.title'
  end

  scenario 'Should redirect to Website map' do
    visit root_path
    click_link I18n.t('footer.btn_web_map')
    expect(page).to have_content I18n.t 'websitemap.title'
  end

end
