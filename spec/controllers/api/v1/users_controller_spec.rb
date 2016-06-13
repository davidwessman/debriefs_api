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

  describe 'POST #create' do
    context 'successfully created' do
      it 'renders the json-representation for the user record created' do
        attributes = {email: 'david@notify.dev',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes, format: :json)

        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq('david@notify.dev')
      end

      it 'responds with 201' do
        attributes = {email: 'david@notify.dev',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes, format: :json)

        is_expected.to(respond_with(201))
      end
    end

    context 'not created' do
      it 'renders and json of errors' do
        attributes = {email: '',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes, format: :json)

        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it 'responds with 422' do
        attributes = {email: '',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes, format: :json)

        is_expected.to(respond_with(422))
      end
    end
  end
end
