require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should allow_value('someone@example.com').for(:email) }
  it { should_not allow_value('someoneexample.com').for(:email) }
  it {should validate_length_of(:password). is_at_least(8)}
  it {should validate_length_of(:username). is_at_least(5).on(:update)}
  it {should_not validate_length_of(:username). is_at_least(5).on(:create)}
  let!(:user) { create(:user) }

  it 'set_username' do
    expect(user.username).to be_present
  end

  it 'create_reset_digest' do
    user = create(:user)
    user.create_reset_digest
    expect(user.reset_digest).to be_present
    expect(user.reset_sent_at).to be_present
  end
end
