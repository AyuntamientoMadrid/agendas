describe User do

  before(:each) { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:full_name) }
  it { should respond_to(:full_name_comma) }

  it "should be active when created" do
    expect(@user.active).to be
  end

  it "should have user role when created" do
    expect(@user.role.to_sym).to be :user
  end

  it "should have full name composed by first and last name" do
    expect(@user.full_name).to eq(@user.first_name+' '+@user.last_name)
  end

  it "should have full name comma composed by first and last name" do
    expect(@user.full_name_comma).to eq(@user.last_name+', '+@user.first_name)
  end

  it "should have name composed by first and last name" do
    expect(@user.name).to eq(@user.last_name+', '+@user.first_name)
  end

  it "should have be valid when created from uweb data array" do
    data = FactoryGirl.build(:uweb_user)

    user = User.create_from_uweb(:user, data)

    expect { user.save }.to change { User.count }.from(1).to(2)
  end

  it "should have be valid when created from uweb data array and user exists by user_key" do
    data = FactoryGirl.build(:uweb_user)
    @user.update(user_key: data["CLAVE_IND"] )

    user = User.create_from_uweb(:user, data)

    expect { user.save }.not_to change { User.count }
  end

  it "should not be allowed assign holder more than once to user" do
  end

end
