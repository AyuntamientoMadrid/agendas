feature "OrganizationInterests" do

  describe "Index" do

    let!(:user)  { create(:user, :user) }
    let!(:lobby) { create(:user, :lobby) }
    let!(:admin) { create(:user, :admin) }
    let!(:interest) { create(:interest) }
    let!(:organization) { create(:organization, user: lobby) }

    describe "Should not be able" do

      scenario "To holder users" do
        login_as(user)
        visit admin_organization_organization_interests_path(organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

      scenario "To lobby users when accessing through other organizations" do
        login_as(lobby)
        other_organization = create(:organization)
        visit admin_organization_organization_interests_path(other_organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

    end

    describe "Should be able" do

      scenario "To admin users" do
        login_as(admin)
        visit admin_organization_organization_interests_path(organization)

        expect(page).to have_content "Editar áreas de interés"
      end

      scenario "To lobby users when accessing through own organizations" do
        login_as(lobby)
        visit admin_organization_organization_interests_path(organization)

        expect(page).to have_content "Editar áreas de interés"
      end

    end

    scenario "Should show checked organization interests" do
      login_as(lobby)
      organization_interests = create_list(:organization_interest, 2, organization: organization)
      visit admin_organization_organization_interests_path(organization)

      expect(page).to have_selector "input[type=checkbox]", count: 3
      expect(page).to have_selector "input[type=checkbox][checked]", count: 2
    end

  end

  describe "Update" do
    let!(:lobby) { create(:user, :lobby) }
    let!(:interest) { create(:interest, name: "Super interesting interest") }
    let!(:organization) { create(:organization, user: lobby) }

    scenario 'Should show update notice when agent is valid' do
      login_as(lobby)
      organization_interests = create_list(:organization_interest, 2, organization: organization)
      visit admin_organization_organization_interests_path(organization)

      expect(page).to have_selector "input[type=checkbox]", count: 3
      expect(page).to have_selector "input[type=checkbox][checked]", count: 2
      check "Super interesting interest"
      click_button "Guardar"

      expect(page).to have_content "Registro actualizado correctamente"
      visit admin_organization_organization_interests_path(organization)
      expect(page).to have_selector "input[type=checkbox][checked]", count: 3
    end

  end

end
