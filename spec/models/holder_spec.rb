require 'rails_helper'

RSpec.describe Holder, type: :model do

  before do
    @holder = FactoryGirl.create(:holder)
  end

  it 'should get full name from first and last name' do
    expect(@holder.full_name).to eq(@holder.first_name + ' ' + @holder.last_name)
  end

  it 'should get full name comma from first and last name' do
    expect(@holder.full_name_comma).to eq(@holder.last_name + ', ' + @holder.first_name)
  end


end
