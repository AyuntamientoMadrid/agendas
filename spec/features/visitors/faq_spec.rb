feature 'FAQ' do

  background do
    @question1 = create(:question, position: 1)
    @question2 = create(:question, position: 2)
    @question3 = create(:question, position: 3)
  end

  scenario 'Visit the faq page' do
    visit faq_path

    expect(page).to have_content @question1.title
    expect(page).to have_content @question2.title
    expect(page).to have_content @question3.title

    expect(page.body.index(@question1.title)).to be < page.body.index(@question2.title)
    expect(page.body.index(@question2.title)).to be < page.body.index(@question3.title)
  end
end
