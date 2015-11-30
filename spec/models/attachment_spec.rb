require 'rails_helper'

RSpec.describe Attachment, type: :model do

  before do
    @attachment = FactoryGirl.build(:attachment, title: nil)
  end

  it "should be invalid if no title" do
    expect(@attachment).not_to be_valid
  end
end
