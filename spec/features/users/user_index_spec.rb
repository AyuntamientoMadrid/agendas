include Warden::Test::Helpers
Warden.test_mode!

feature 'User index page', :devise do

  after(:each) do
    Warden.test_reset!
  end

  scenario 'user sees own email address' do
    user = FactoryGirl.create(:user, :admin)
    login_as(user, scope: :user)
    visit users_path
    expect(page).to have_content user.email
  end

end
