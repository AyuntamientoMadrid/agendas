feature 'Event page' do

  before(:each) do
    @user = FactoryGirl.create(:user, :admin)
    signin(@user.email, @user.password)
  end

  scenario 'visit the event detail page' do
    event = FactoryGirl.create(:event)
    visit events_path()
    click_link event.title
    expect(page).to have_content event.title
  end

end
