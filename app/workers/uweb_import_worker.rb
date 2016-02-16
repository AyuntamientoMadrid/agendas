class UwebImportWorker

  include Sidekiq::Worker

  sidekiq_options :queue => :agendas_queue

  def perform
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Agendas::Application.load_tasks
    Rake::Task['madrid:import'].reenable
    Rake::Task['madrid:import'].invoke
  end

end
