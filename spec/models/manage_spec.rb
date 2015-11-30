require 'rails_helper'

RSpec.describe Manage, type: :model do

  before do
    @holder = FactoryGirl.create(:holder)
    @user = FactoryGirl.create(:user)
  end


  it "should not be allowed assign holder more than once to user" do
    manage = FactoryGirl.create(:manage, holder: @holder, user: @user)
    expect(manage).to be_valid
    manage2 = FactoryGirl.build(:manage, holder: @holder, user: @user)
    expect(manage2).not_to be_valid

  end
end
