require 'rails_helper'

RSpec.describe User, type: :model do
  #before { @user = FactoryGirl.build(:user) }
  let(:user) { build(:user) }
  
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value("rood@rood.com").for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email, created_at and token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('ab123xyzTOKEN')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: ab123xyzTOKEN")  
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('ab123xyzTOKEN')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('ab123xyzTOKEN')
    end

    it 'generates another auth token when the current auth token already has been taken' do
    existing_user = create(:user, auth_token: 'ab123xyzTOKEN')
    allow(Devise).to receive(:friendly_token).and_return('ab123xyzTOKEN', 'abc123XYZ')
    user.generate_authentication_token!

    expect(user.auth_token).not_to eq(existing_user.auth_token)
    
  end
end

end
