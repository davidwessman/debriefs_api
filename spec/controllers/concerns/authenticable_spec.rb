require 'rails_helper'

class Authentication
  include Authenticable

  def request
    nil
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
end
