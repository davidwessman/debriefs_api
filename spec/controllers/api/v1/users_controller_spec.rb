require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    request.headers['Accept'] = 'application/vnd.notify.v1'
  end

  describe 'GET #show' do
    it 'returns the information about a reporter on a hash' do
      user = create(:user, email: 'david@notify.dev')
      get(:show, id: user.to_param, format: :json)

      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq('david@notify.dev')
    end

    it 'responds with 200' do
      user = create(:user, email: 'david@notify.dev')
      get(:show, id: user.to_param, format: :json)

      is_expected.to(respond_with(200))
    end
  end
end
