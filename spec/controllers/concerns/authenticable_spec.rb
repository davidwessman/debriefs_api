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
end
