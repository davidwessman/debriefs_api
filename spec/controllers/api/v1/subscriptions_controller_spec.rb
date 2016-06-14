require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  describe 'GET #show' do
    it 'returns information about subscription as hash' do
      user = create(:user, :auth)
      provider = create(:provider, title: 'Google')
      subscription = create(:subscription, user: user, provider: provider)
      api_authorization_header(user.auth_token)

      get(:show, id: subscription.to_param)
      expect(json_response[:provider][:title]).to eq('Google')
      is_expected.to(respond_with(200))
    end
  end

  describe 'GET #index' do
    it 'returns subscriptions belonging to user' do
      user = create(:user, :auth)
      api_authorization_header(user.auth_token)
      other = create(:user, :auth)
      create(:subscription, user: user)
      create(:subscription, user: user)
      create(:subscription, user: user)
      create(:subscription, user: other)

      get(:index)
      expect(json_response.length).to eq(3)
      is_expected.to(respond_with(200))
    end
  end

  describe 'POST #create' do
    context 'successfully created' do
      it 'renders the json-representation for the subscription record created' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        provider = create(:provider, title: 'Google')
        expect do
          post(:create, subscription: { provider_id: provider.to_param })
        end.to change(Subscription, :count).by(1)

        expect(json_response[:provider][:title]).to eq('Google')
      end

      it 'responds with 201' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        provider = create(:provider, title: 'Google')
        post(:create, subscription: { provider_id: provider.to_param })

        is_expected.to(respond_with(201))
      end
    end

    context 'not created' do
      it 'renders and json of errors' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        post(:create, subscription: { provider: nil })

        subscription_response = json_response
        expect(subscription_response).to have_key(:errors)
        expect(subscription_response[:errors][:provider]).to include("can't be blank")
      end

      it 'responds with 422' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        post(:create, subscription: { provider: nil })

        is_expected.to(respond_with(422))
      end
    end
  end

  describe 'PATCH #update' do
    context 'successfully updated' do
      it 'renders json represenation of updated subscription' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        subscription = create(:subscription, active: false, user: user)
        patch(:update, id: subscription.to_param,
              subscription: { active: true })

        expect(json_response[:active]).to be_truthy
      end

      it 'responds with 200' do
        user = create(:user, :auth)
        api_authorization_header(user.auth_token)
        subscription = create(:subscription, active: false, user: user)
        patch(:update, id: subscription.to_param,
              subscription: { active: true })

        is_expected.to(respond_with(200))
      end
    end

    context 'not updated' do
      it 'renders and errors json' do
        pending('Not enough logic for a failing test yet')
        user = create(:user, :auth)
        subscription = create(:subscription, active: false, user: user)
        api_authorization_header(user.auth_token)
        patch(:update, id: subscription.to_param,
              subscription: { user_id: nil })

        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it 'responds with 422' do
        pending('Not enough logic for a failing test yet')
        user = create(:user, :auth)
        subscription = create(:subscription, active: false, user: user)
        api_authorization_header(user.auth_token)
        patch(:update, id: subscription.to_param,
              subscription: { user_id: '' })

        is_expected.to(respond_with(422))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with 204' do
      user = create(:user, :auth)
      api_authorization_header(user.auth_token)
      subscription = create(:subscription, user: user)
      delete(:destroy, id: subscription.to_param)

      is_expected.to(respond_with(204))
    end
  end
end
