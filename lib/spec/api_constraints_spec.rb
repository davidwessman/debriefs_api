require 'spec_helper'
require 'api_constraints'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe "matches?" do

    it "returns true when the version matches the 'Accept' header" do
      api_constraint = ApiConstraints.new(version: 1)
      request = double(host: 'api.debriefs.dev',
                       headers: {"Accept" => "application/vnd.debriefs.v1"})
      expect(api_constraint.matches?(request)).to be_truthy
    end

    it "returns the default version when 'default' option is specified" do
      api_constraint = ApiConstraints.new(version: 1, default: true)
      request = double(host: 'api.debriefs.dev')
      expect(api_constraint.matches?(request)).to be_truthy
    end
  end
end
