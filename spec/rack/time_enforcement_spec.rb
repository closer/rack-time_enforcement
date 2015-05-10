require 'spec_helper'

require 'rack/lint'
require 'rack/mock'

describe Rack::TimeEnforcement do
  let(:base_app) do
    -> env { [200, {"Content-Type" => "text/plain"}, [Time.now.to_s] ] }
  end

  let(:app) { Rack::TimeEnforcement.new(base_app) }

  let(:uri) { "/" }

  let(:opts) { {} }

  def request
    app.call Rack::MockRequest.env_for uri, opts
  end

  context "default" do
    subject { request }

    it { expect(subject[1]).to include "Time-Enforcement-Available" => "true" }
    it { expect(subject[1]).to_not include "Time-Enforcement-Enabled" => "true" }
    it { expect(subject[2]).to include Time.now.to_s }
  end

  context "enforcement" do
    let(:time) { Time.new(1994, 1, 1) }
    let(:opts) { { "Time-Enforcement-At" => time.to_s } }
    subject { request }

    it { expect(subject[1]).to include "Time-Enforcement-Available" => "true" }
    it { expect(subject[1]).to include "Time-Enforcement-Enabled" => "true" }
    it { expect(subject[2]).to include time.to_s }
  end

  context "enforcement failure" do
    let(:opts) { { "Time-Enforcement-At" => "XXXXXXXXXX" } }
    subject { request }

    it { expect(subject[1]).to include "Time-Enforcement-Available" => "true" }
    it { expect(subject[1]).to include "Time-Enforcement-Enabled" => "false" }
    it { expect(subject[2]).to include Time.now.to_s }
  end
end
