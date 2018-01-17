feature 'Passwords' do

  it_behaves_like "password editable", "user"
  it_behaves_like "password editable", "admin"
  it_behaves_like "password editable", "lobby"

  scenario "Edit Should not be available for anonymous users" do
    visit admin_edit_password_path

    expect(page).to have_content "Tienes que iniciar sesión o registrarte para poder continuar"
  end

end
