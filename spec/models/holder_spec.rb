require 'rails_helper'

describe Holder do

  let(:holder) { build(:holder) }

  it "Should be valid" do
    expect(holder).to be_valid
  end

  it "Should not be valid without first_name" do
    holder.first_name = nil

    expect(holder).not_to be_valid
  end

  it "Should not be valid without last_name" do
    holder.last_name = nil

    expect(holder).not_to be_valid
  end

  it "Should not be valid without position on updates" do
    holder.save

    expect(holder).not_to be_valid
  end

  describe "#current_position" do
    it "Should return first of all current positions" do
      create(:position, holder: holder, to: Time.current)
      position2 = create(:position, holder: holder)
      create(:position, holder: holder)

      expect(holder.current_position).to eq(position2)
    end
  end

  describe "#size_current_position" do
    it "Should return quantity of current positions" do
      create(:position, holder: holder, to: Time.current)
      create_list(:position, 2, holder: holder)

      expect(holder.size_current_position).to eq(2)
    end
  end

  describe ".by_manages" do
    let(:user)            { create(:user, :user) }
    let(:managed_holder1) { create(:manage, user: user) }
    let(:managed_holder2) { create(:manage, user: user) }
    let(:manage)          { create(:manage) }

    it "Should return all holder managed by given user" do
      expect(Holder.by_manages(user)).to include(managed_holder1.holder)
      expect(Holder.by_manages(user)).to include(managed_holder2.holder)
      expect(Holder.by_manages(user)).not_to include(manage.holder)
    end
  end

  describe "#full_name" do
    it "Should return first_name and last_name" do
      expect(holder.full_name).to eq(holder.first_name + " " + holder.last_name)
    end
  end

  describe "#full_name_comma" do
    it "Should return last name + semicolon + first_name" do
      expect(holder.full_name_comma).to eq(holder.last_name + ", " + holder.first_name)
    end
  end

  describe ".by_name" do
    let!(:holder1) { create(:holder, first_name: "John", last_name: "Doe") }
    let!(:holder2) { create(:holder, first_name: "Max", last_name: "Payne") }

    it "Should return all holders containing first_name or first_name part" do
      expect(Holder.by_name("joh")).to eq([holder1])
      expect(Holder.by_name("john")).to eq([holder1])
    end

    it "Should return all holders containing last_name or last_name part" do
      expect(Holder.by_name("do")).to eq([holder1])
      expect(Holder.by_name("doe")).to eq([holder1])
    end

    it "Should return all holders containing given fullname" do
      expect(Holder.by_name("Max Payne")).to eq([holder2])
      expect(Holder.by_name("John Doe")).to eq([holder1])
    end
  end

end
