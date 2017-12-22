feature 'Home page' do

  scenario 'Should show page title', :search do
    visit root_path

    expect(page).to have_content I18n.t 'main.title'
  end

end
