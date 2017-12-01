require 'rails_helper'

describe Attachment do

  let(:attachment) { build(:attachment) }

  it "should be invalid if no title" do
    attachment.title = nil

    expect(attachment).not_to be_valid
  end

  it "should be invalid if no checked public boolean" do
    attachment.public = nil

    expect(attachment).not_to be_valid
  end
end
