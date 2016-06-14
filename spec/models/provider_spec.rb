require 'rails_helper'

RSpec.describe Provider, type: :model do
  let(:provider) { build(:provider) }
  subject { provider }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:active) }
  it { is_expected.to respond_to(:description) }

  it 'is not active' do
    expect(provider.active).to be_falsey
  end
end
