require 'rails_helper'

RSpec.shared_examples "organizations file generator" do |file|

  it "Should generate event export file at #{file}" do
    File.delete(file) if File.exist?(file)

    work = OrganizationsExportWorker.new
    work.perform

    expect(File.exist?(file)).to be(true)
  end
end

describe OrganizationsExportWorker do

  before do
    Sidekiq::Testing.inline!
  end

  after do
    Sidekiq::Testing.fake!
  end

  it_behaves_like "organizations file generator", Rails.root.join('public', 'export', 'lobbies.csv')
  it_behaves_like "organizations file generator", Rails.root.join('public', 'export', 'lobbies.xls')
  it_behaves_like "organizations file generator", Rails.root.join('public', 'export', 'lobbies.json')
end
