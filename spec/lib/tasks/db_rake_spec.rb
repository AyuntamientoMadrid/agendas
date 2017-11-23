describe "db:test_seeds" do
  include_context "rake"

  it "Generates dummy test data for local development" do
    subject.invoke
    expect(Area.count).to eq(3)
    expect(User.count).to eq(15)
    expect(Holder.count).to eq(4)
    expect(Position.count).to eq(6)
    expect(Event.count).to eq(4)
    expect(Participant.count).to eq(5)
    expect(Manage.count).to eq(2)
    expect(Attendee.count).to eq(3)
    expect(Attachment.count).to eq(2)
    expect(Organization.count).to eq(11)
  end
end
