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

    expect(page.html).to include('<link rel="alternate" type="application/atom+xml" title="ATOM" href="/visitors.atom" />')
    expect(page.html).to include('<link rel="alternate" type="application/rss+xml" title="RSS" href="/visitors.rss" />')
  end
end
