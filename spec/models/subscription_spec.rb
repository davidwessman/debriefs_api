require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { build_stubbed(:subscription) }
  subject { Subscription.new }

  it 'has valid factory' do
    expect(subscription).to be_valid
  end

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:provider) }
  it { is_expected.to respond_to(:active) }
  it { is_expected.to belong_to(:provider) }
  it { is_expected.to belong_to(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:provider) }
  end

  it 'is active' do
    expect(Subscription.new.active).to be_truthy
  end
end
