require 'rails_helper'

describe Question do

  let(:question) { build(:question) }

  it "Should be valid" do
    expect(question).to be_valid
  end

  it "should not be valid without title defined" do
    question.title = nil

    expect(question).not_to be_valid
  end

  it "should not be valid without answer defined" do
    question.answer = nil

    expect(question).not_to be_valid
  end

  describe "#set_position" do

    it "Should set position with maximum position + 1" do
      expect(question.position).to eq 1
    end

  end
end
