require 'rails_helper'

RSpec.shared_examples "events file generator" do |file|

  it "Should generate event export file at #{file}" do
    File.delete(file) if File.exist?(file)

    work = AgendasExportWorker.new
    work.perform

    expect(File.exist?(file)).to be(true)
  end
end

describe AgendasExportWorker do

  before do
    Sidekiq::Testing.inline!
  end

  after do
    Sidekiq::Testing.fake!
  end

  it_behaves_like "events file generator", Rails.root.join('public', 'export', 'agendas.csv')
  it_behaves_like "events file generator", Rails.root.join('public', 'export', 'agendas.xls')
  it_behaves_like "events file generator", Rails.root.join('public', 'export', 'agendas.json')
end
