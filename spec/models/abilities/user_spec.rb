require 'rails_helper'
require 'cancan/matchers'


feature "Abilities::User" do

  before(:each) do
    load "#{Rails.root}/db/test_seeds.rb"
  end

  background do
    @user_without_holders = User.find_by first_name: 'Pepe', last_name: 'Perez'

    @user_with_holders = User.find_by first_name: 'Catalina', last_name: 'Perez'
    @registration_offices = Event.find_by title: 'Oficinas de registro'
    @online_registration = Event.find_by title: 'Registro Electrónico'
    @political_transparency = Event.find_by title: 'Transparencia política'

    @holder_several_positions = Holder.find_by first_name: 'Pilar', last_name:'Lopez'

  end

  describe "manage holder" do
    subject(:ability) { Ability.new(@user_with_holders) }

    it { should_not be_able_to(:index, Users) }
    it { should_not be_able_to(:show, @user_with_holders) }
    it { should_not be_able_to(:edit, @user_with_holders) }
    it { should_not be_able_to(:destroy, @user_with_holders) }

    it { should_not be_able_to(:index, Holder) }
    it { should_not be_able_to(:show, @holder_several_positions) }
    it { should_not be_able_to(:edit, @holder_several_positions) }
    it { should_not be_able_to(:destroy, @holder_several_positions) }

    it { should be_able_to(:index, Event, id: Event.by_manages(@user_with_holders.id)) }
    it { should be_able_to(:new, @registration_offices) }
    it { should be_able_to(:show, @registration_offices) }
    it { should be_able_to(:edit, @registration_offices) }
    it {
      @registration_offices.scheduled = Time.now + 2.days
      should be_able_to(:destroy, @registration_offices)
      @registration_offices.scheduled = Time.now - 2.days
      should_not be_able_to(:destroy, @registration_offices)
    }

    it { should be_able_to(:index, Event, id: Event.by_manages(@user_with_holders.id)) }
    it { should be_able_to(:new, Event) }
    it { should be_able_to(:show, @political_transparency) }
    it { should_not be_able_to(:edit, @political_transparency) }
    it { should_not be_able_to(:destroy, @political_transparency) }

    it { should_not be_able_to(:index, @online_registration) }
    it { should be_able_to(:new, Event) }
    it { should_not be_able_to(:show, @online_registration) }
    it { should_not be_able_to(:edit, @online_registration) }
    it { should_not be_able_to(:destroy, @online_registration) }

  end

  describe "without manage holders " do
    subject(:ability) { Ability.new(@user_without_holders) }

    it { should_not be_able_to(:index, Users) }
    it { should_not be_able_to(:show, @user_without_holders) }
    it { should_not be_able_to(:edit, @user_without_holders) }
    it { should_not be_able_to(:destroy, @user_without_holders) }

    it { should_not be_able_to(:index, Holder) }
    it { should_not be_able_to(:show, @holder_several_positions) }
    it { should_not be_able_to(:edit, @holder_several_positions) }
    it { should_not be_able_to(:destroy, @holder_several_positions) }

    it { should_not be_able_to(:index, @registration_offices) }
    it { should be_able_to(:new, Event) }
    it { should_not be_able_to(:show, @registration_offices) }
    it { should_not be_able_to(:edit, @registration_offices) }
    it { should_not be_able_to(:destroy, @registration_offices) }

  end
end