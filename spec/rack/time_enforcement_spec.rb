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

  context "called" do
    subject { request }

    it { expect(subject[1]).to include "TimeEnforcement-Available" => "true" }
    it { expect(subject[1]).to_not include "TimeEnforcement-Enabled" => "true" }
    it { expect(subject[2]).to include Time.now.to_s }
  end

  context "called" do
    let(:time) { Time.new(1994, 1, 1) }
    let(:opts) { { "TimeEnforcement-At" => time.to_s } }
    subject { request }

    it { expect(subject[1]).to include "TimeEnforcement-Available" => "true" }
    it { expect(subject[1]).to include "TimeEnforcement-Enabled" => "true" }
    it { expect(subject[2]).to include time.to_s }
  end
end
