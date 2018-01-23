require 'rake'

feature 'Maintenance page' do

  let!(:some_urls) { [] }
  before do
    Agendas::Application.load_tasks
    Rake::Task['maintenance:start'].invoke
    some_urls << root_path
    some_urls << visitors_path
    some_urls << organizations_path
  end

  after do
    Rake::Task['maintenance:end'].invoke
  end

  scenario "Should be renderer for any incoming request" do
    some_urls.each do |url|
      visit root_path

      expect(page).to have_content "Aplicación en mantenimiento"
    end
  end

end