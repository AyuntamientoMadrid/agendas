require 'spec_helper'

describe "export:organizations" do

  include_context "rake"

  it "check files existence a files contents" do
    subject.invoke

    csv_file = File.open(Rails.root.to_s + '/public/export/lobbies.csv')
    json_file = File.open(Rails.root.to_s + '/public/export/lobbies.json')
    xls_file = File.open(Rails.root.to_s + '/public/export/lobbies.xls')

    expect(File).to exist(csv_file)
    expect(File).to exist(json_file)
    expect(File).to exist(xls_file)
  end

  it "check csv contents" do
    o = create(:organization)
    o.save!

    subject.invoke
    csv_file = File.open(Rails.root.to_s + '/public/export/lobbies.csv').read.scrub

    csv = CSV.parse(csv_file, headers: true, col_sep: ';')
    expect(csv.first.to_hash.values[0]).to eq(o.reference)
  end

  it "check json contents" do
    o = create(:organization)
    o.save!

    subject.invoke
    json_file = File.open(Rails.root.to_s + '/public/export/lobbies.json')

    parsed_json = ActiveSupport::JSON.decode(json_file.read)
    expect(parsed_json.first.values.first).to eq(o.reference)
  end

  it "check xsl contents" do
    o = create(:organization)
    o.save!

    subject.invoke
    xls_file = File.open(Rails.root.to_s + '/public/export/lobbies.xls')

    require 'spreadsheet'
    book = Spreadsheet.open(xls_file)
    sheet = book.worksheets[0]
    expect(sheet.rows[1][0]).to eq(o.reference)
  end

end

describe "export:agendas" do

  include_context "rake"

  it "check files existence a files contents" do
    subject.invoke

    csv_file = File.open(Rails.root.to_s + '/public/export/agendas.csv')
    json_file = File.open(Rails.root.to_s + '/public/export/agendas.json')
    xls_file = File.open(Rails.root.to_s + '/public/export/agendas.xls')

    expect(File).to exist(csv_file)
    expect(File).to exist(json_file)
    expect(File).to exist(xls_file)
  end

  it "check csv contents" do
    o = create(:event)
    o.save!

    subject.invoke
    csv_file = File.open(Rails.root.to_s + '/public/export/agendas.csv').read.scrub

    csv = CSV.parse(csv_file, headers: true, col_sep: ';')
    expect(csv.first.to_hash.values[0]).to eq(o.title)
  end

  it "check json contents" do
    o = create(:event)
    o.save!

    subject.invoke
    json_file = File.open(Rails.root.to_s + '/public/export/agendas.json')

    parsed_json = ActiveSupport::JSON.decode(json_file.read)
    expect(parsed_json.first.values.first).to eq(o.title)
  end

  it "check xsl contents" do
    o = create(:event)
    o.save!

    subject.invoke
    xls_file = File.open(Rails.root.to_s + '/public/export/agendas.xls')

    require 'spreadsheet'
    book = Spreadsheet.open(xls_file)
    sheet = book.worksheets[0]
    expect(sheet.rows[1][0]).to eq(o.title)
  end

end
