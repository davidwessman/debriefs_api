require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET #show' do
    it 'returns the information about a reporter on a hash' do
      user = create(:user, email: 'david@notify.dev')
      get(:show, id: user.to_param)

      user_response = json_response
      expect(user_response[:email]).to eq('david@notify.dev')
    end

    it 'responds with 200' do
      user = create(:user, email: 'david@notify.dev')
      get(:show, id: user.to_param)

      is_expected.to(respond_with(200))
    end
  end

  describe 'POST #create' do
    context 'successfully created' do
      it 'renders the json-representation for the user record created' do
        attributes = {email: 'david@notify.dev',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes)

        user_response = json_response
        expect(user_response[:email]).to eq('david@notify.dev')
      end

      it 'responds with 201' do
        attributes = {email: 'david@notify.dev',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes)

        is_expected.to(respond_with(201))
      end
    end

    context 'not created' do
      it 'renders and json of errors' do
        attributes = {email: '',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes)

        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it 'responds with 422' do
        attributes = {email: '',
                      password: '12345678',
                      password_confirmation: '12345678'}
        post(:create, user: attributes)

        is_expected.to(respond_with(422))
      end
    end
  end

  describe 'PATCH #update' do
    context 'successfully updated' do
      it 'renders json represenation of updated user' do
        user = create(:user, email: 'david@notify.dev')
        api_authorization_header(user.auth_token)
        patch(:update, id: user.to_param,
                       user: { email: 'arthur@notify.dev' })

       user_response = json_response
       expect(user_response[:email]).to eq('arthur@notify.dev')
      end

      it 'responds with 200' do
        user = create(:user, email: 'david@notify.dev')
        api_authorization_header(user.auth_token)
        patch(:update, id: user.to_param,
                       user: { email: 'arthur@notify.dev' })

        is_expected.to(respond_with(200))
      end
    end

    context 'not updated' do
      it 'renders and errors json' do
        user = create(:user, email: 'david@notify.dev')
        api_authorization_header(user.auth_token)
        patch(:update, id: user.to_param,
                       user: { email: '' })

       user_response = json_response
       expect(user_response).to have_key(:errors)
       expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it 'responds with 422' do
        user = create(:user, email: 'david@notify.dev')
        api_authorization_header(user.auth_token)
        patch(:update, id: user.to_param,
                       user: { email: '' })

        is_expected.to(respond_with(422))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with 204' do
      user = create(:user, auth_token: 'sounique')
      api_authorization_header(user.auth_token)
      delete(:destroy, id: user.to_param)

      is_expected.to(respond_with(204))
    end
  end
end
