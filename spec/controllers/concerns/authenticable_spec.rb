require 'rails_helper'

class Authentication
  include Authenticable

  def request
    nil
  end

  def response
    nil
  end

  # Mocking render based on inputs from Module
  def render(json:, status:)
    response.body = json.to_json
    response.status = status
  end
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_user' do
    it 'returns the user from authorization header' do
      user = create(:user, auth_token: 'uniquetoken1337')
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request).and_return(request)

      expect(authentication.current_user.auth_token).to eq('uniquetoken1337')
    end
  end

  describe '#authenticate_with_token!' do
    it 'renders a json error message' do
      allow(authentication).to receive(:current_user) { nil }
      allow(authentication).to receive(:response) { response }

      authentication.authenticate_with_token!

      expect(json_response[:errors]).to eq('Not authenticated')
      is_expected.to(respond_with(401))
    end
  end

  describe '#user_signed_in?' do
    context 'when there is user on session' do
      it 'expects true from user_signed_in' do
        user = build_stubbed(:user)
        allow(authentication).to receive(:current_user) { user }

        expect(authentication.user_signed_in?).to be_truthy
      end
    end

    context 'when there is no user on session' do
      it 'expects false from user_signed_in' do
        allow(authentication).to receive(:current_user) { nil }

        expect(authentication.user_signed_in?).to be_falsey
      end
    end
  end
end
