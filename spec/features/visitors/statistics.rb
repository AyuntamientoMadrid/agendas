feature 'Statistics page' do

  scenario 'view statistics page' do
    visit statistics_path
    expect(page).to have_content I18n.t 'statistics.statistics'
    expect(page).to have_content I18n.t 'statistics.description'
    expect(page).to have_content I18n.t 'statistics.category_lobbies'
  end

end
