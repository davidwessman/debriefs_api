require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:auth_token) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('example@domain.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      user = create(:user)
      allow(Devise).to receive(:friendly_token).and_return('uniquetoken1337')

      user.generate_authentication_token!
      expect(user.auth_token).to eq('uniquetoken1337')
    end

    it 'generates different than current' do
      user = create(:user, auth_token: 'notuniquetoken1337')
      allow(Devise).to receive(:friendly_token).and_return('notuniquetoken1337', 'uniquetoken1337')

      user.generate_authentication_token!
      expect(user.auth_token).to eq('uniquetoken1337')
      begin
        self.auth_token = Devise.friendly_token
      end while self.class.exists?(auth_token: auth_token)
    end
  end
end
