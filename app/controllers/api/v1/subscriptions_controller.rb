class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_with_token!

  def show
    render(json: current_user.subscriptions.find(params[:id]))
  end

  def index
    render(json: current_user.subscriptions)
  end

  def create
    subscription = current_user.subscriptions.build(create_params)
    if subscription.save
      render(json: subscription, status: 201, location: [:api, subscription])
    else
      render(json: { errors: subscription.errors }, status: 422)
    end
  end

  def update
    subscription = current_user.subscriptions.find(params[:id])
    if subscription.update(update_params)
      render(json: subscription, status: 200, location: [:api, subscription])
    else
      render(json: { errors: subscription.errors }, status: 422)
    end
  end

  def destroy
    current_user.subscriptions.find(params[:id]).destroy!

    head 204
  end

  private

  def create_params
    params.require(:subscription).permit(:provider_id)
  end

  def update_params
    params.require(:subscription).permit(:active)
  end
end
