feature 'Navigation links', :devise do

  scenario 'view header navigation links' do
    visit root_path
    expect(page).to have_content I18n.t 'header.transparency'
    expect(page).to have_content I18n.t 'header.participation'
    expect(page).to have_content I18n.t 'header.open_data'
  end

end
