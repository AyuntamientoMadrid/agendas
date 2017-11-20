namespace :db do
  desc "Resets the database and loads test data from db/test_seeds.rb"
  task test_seeds: :environment do
    load(Rails.root.join("db", "test_seeds.rb"))
  end
end
