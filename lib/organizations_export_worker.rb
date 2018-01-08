class OrganizationsExportWorker
  include Sidekiq::Worker

  sidekiq_options queue: :agendas_queue

  def perform
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times
    Agendas::Application.load_tasks
    Rake::Task['export:organizations'].reenable
    Rake::Task['export:organizations'].invoke
  end
end