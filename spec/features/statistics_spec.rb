feature 'Statistics' do

  describe 'Index' do
    scenario 'Shouls show statistics section headers' do
      visit statistics_path

      expect(page).to have_content I18n.t 'statistics.description'
      expect(page).to have_content I18n.t 'statistics.description'

      expect(page).to have_content I18n.t 'statistics.category_lobbies'
      expect(page).to have_content I18n.t 'statistics.interest_lobbies'
      expect(page).to have_content I18n.t 'statistics.description_lobbies'
      expect(page).to have_content I18n.t 'statistics.public_agendas'
      expect(page).to have_content I18n.t 'statistics.category_lobbies'
    end

    describe 'Categories' do

      scenario 'Should show categories sorted by name asc' do
        create(:category, name: "Abcd")
        category2 = create(:category, name: "Bcde")
        category3 = create(:category, name: "Cdef")

        visit statistics_path

        within ".lobbies-categories" do
          expect(category1.name).to appear_before(category2.name)
          expect(category2.name).to appear_before(category3.name)
        end
      end

      scenario 'Should show all categories organizations amount' do
        create(:category, name: "Abcd")
        category2 = create(:category, name: "Bcde")
        category3 = create(:category, name: "Cdef")
        create_list(:organization, 3, category: category2)
        create_list(:organization, 2, category: category3)

        visit statistics_path

        within ".lobbies-categories" do
          expect("0").to appear_before("3")
          expect("3").to appear_before("2")
        end
      end
    end

    describe 'Interests' do
      scenario 'Should show interests sorted by name asc' do
        interest1 = create(:interest, name: "Abcd")
        interest2 = create(:interest, name: "Bcde")
        interest3 = create(:interest, name: "Cdef")

        visit statistics_path

        within ".lobbies-interests" do
          expect(interest1.name).to appear_before(interest2.name)
          expect(interest2.name).to appear_before(interest3.name)
        end
      end

      scenario 'Should show all interests organizations amount' do
        create(:interest, name: "Abcd")
        interest2 = create(:interest, name: "Bcde")
        interest3 = create(:interest, name: "Cdef")
        create_list(:organization, 3, interests: [interest2])
        create_list(:organization, 2, interests: [interest3])

        visit statistics_path

        within ".lobbies-interests" do
          expect("0").to appear_before("3")
          expect("3").to appear_before("2")
        end
      end

    end

    describe 'Lobbies' do
      scenario 'Should show total amount of active lobbies' do
        create(:organization, entity_type: :lobby)
        create(:organization, entity_type: :lobby, invalidated_at: Time.current, invalidated_reasons: "Bla bla bla..")
        create(:organization, entity_type: :lobby, canceled_at: Time.current)
        create(:organization, entity_type: :association)
        create(:organization, entity_type: :federation)

        visit statistics_path

        within ".active-lobbies" do
          expect(page).to have_content "1"
        end
      end

      scenario 'Should show total amount of self employed lobbies and employee lobbies' do
        organizations = create_list(:organization, 3,  entity_type: :lobby)
        create(:represented_entity, organization: organizations.first)

        visit statistics_path

        within ".self-employed-count" do
          expect(page).to have_content "2"
        end
        within ".employed-count" do
          expect(page).to have_content "1"
        end
      end

      scenario 'Should show active agents count' do
        organization = create(:organization, invalidated_at: Time.current, invalidated_reasons: "Bla bla bla..")
        create(:agent, organization: organization)
        organization = create(:organization, canceled_at: Time.current)
        create(:agent, organization: organization)
        create(:agent)
        create(:agent, to: Date.tomorrow)
        create(:agent, to: Date.yesterday)

        visit statistics_path

        within ".active-agents-count" do
          expect(page).to have_content "2"
        end
      end

    end

    describe "Events" do

      scenario 'Should show total amount of active holders' do
        create_list(:holder, 2)

        visit statistics_path

        within ".holders-count" do
          expect(page).to have_content "2"
        end
      end

      scenario 'Should show total amount of published events' do
        create(:event)
        create(:event, published_at: Date.tomorrow)
        create(:event, published_at: Date.yesterday)

        visit statistics_path

        within ".events-count" do
          expect(page).to have_content "2"
        end
      end

      scenario 'Should show total amount of published events' do
        create(:event)
        create(:event, lobby_activity: true)

        visit statistics_path

        within ".lobby-activity" do
          expect(page).to have_content "1"
        end
      end

    end
  end

end
