require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    context 'correct credentials' do
      it 'returns the record corresponding to given credentials' do
        user = create(:user, email: 'david@notify.dev', password: '12345678')
        credentials = { email: user.email, password: '12345678' }
        post(:create, session: credentials)

        user.reload
        expect(json_response[:auth_token]).to eq(user.auth_token)
      end

      it 'responds with 200' do
        user = create(:user, email: 'david@notify.dev', password: '12345678')
        credentials = { email: user.email, password: '12345678' }
        post(:create, session: credentials)

        is_expected.to(respond_with(200))
      end
    end

    context 'incorrect credentials' do
      it 'returns json with an error' do
        user = create(:user, email: 'david@notify.dev', password: '12345678')
        credentials = { email: user.email, password: 'fail' }
        post(:create, session: credentials)

        expect(json_response[:errors]).to eq('Invalid email or password')
      end

      it 'responds with 422' do
        user = create(:user, email: 'david@notify.dev', password: '12345678')
        credentials = { email: user.email, password: 'fail' }
        post(:create, session: credentials)

        is_expected.to(respond_with(422))
      end
    end
  end
end
