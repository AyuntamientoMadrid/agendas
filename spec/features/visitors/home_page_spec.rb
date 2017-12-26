feature 'Home page' do

  scenario 'Should show page title', :search do
    visit root_path

    expect(page).to have_content I18n.t 'main.title'
  end

  scenario 'Should redirect to Website map', :search do
    visit root_path
    find(:xpath, "/html/body/footer/div[2]/div/div[2]/ul/li[3]/a").click
    expect(page).to have_content I18n.t 'websitemap.title'
  end

end
