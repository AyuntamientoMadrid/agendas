feature 'Event page' do

  scenario 'visit the event detail page' do
    event = FactoryGirl.create(:event)
    #visit show_path(event)
    visit root_path
    click_link event.title
    expect(page).to have_content event.title
  end

end
