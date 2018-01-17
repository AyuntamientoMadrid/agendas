feature 'Question' do

  describe 'User admin' do
    background do
      user_admin = create(:user, :admin)
      login_as user_admin

      @question1 = create(:question, position: 1)
      @question2 = create(:question, position: 2)
      @question3 = create(:question, position: 3)
    end

    scenario 'Visit admins question index' do
      visit admin_path

      expect(page).to have_link I18n.t 'backend.faq.questions'
      click_link I18n.t 'backend.faq.questions'

      expect(page).to have_content "Preguntas frecuentes (3)"
    end

    scenario 'Questions appear in the right order' do
      visit admin_questions_path

      expect(page.body.index(@question1.title)).to be < page.body.index(@question2.title)
    end

    scenario 'Create new question' do
      visit admin_questions_path

      click_link I18n.t 'backend.faq.new_question'

      expect(page).to have_content I18n.t 'backend.faq.new_question'

      page.fill_in :question_title, with: 'Título de nueva pregunta'
      page.fill_in :question_answer, with: 'Respuesta a la nueva pregunta'
      click_button('Enviar')

      expect(page).to have_content "Preguntas frecuentes (4)"
      expect(page).to have_content 'Título de nueva pregunta'
    end

    scenario 'Edit question' do
      visit edit_admin_question_path(@question1)

      old_title = @question1.title

      page.fill_in :question_title, with: 'Nuevo título de pregunta'

      click_button('Enviar')

      expect(page).to have_content 'Nuevo título de pregunta'
      expect(page).to_not have_content old_title
    end

  end

end
