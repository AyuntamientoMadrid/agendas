feature 'Statistics page' do

  scenario 'view statistics page' do
    visit statistics_path
    expect(page).to have_content I18n.t 'statistics.description'
    expect(page).to have_content I18n.t 'statistics.category_lobbies'
  end

 scenario 'view items on statistics page' do
    create(:event, published_at: Time.zone.yesterday)
    create(:interest , name: "Houses")
    visit statistics_path
    within "#public_agendas" do
      expect(page).to have_content "1"
    end
    expect(page).to have_content "Houses"
  end
end
