require 'serverspec'

set :backend, :exec

describe "metric_tank" do
  it "has metric_tank running" do
    expect(service("metric_tank")).to be_running
  end
  it "has metric_tank enabled" do
    expect(service("metric_tank")).to be_enabled
  end
    it "is listening on port 18763" do
    expect(port(18763)).to be_listening
  end
end
