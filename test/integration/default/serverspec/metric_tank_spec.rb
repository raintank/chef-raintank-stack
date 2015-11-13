require 'serverspec'

set :backend, :exec

describe "metric_tank" do
  it "has metric_tank running" do
    expect(service("metric_tank")).to be_running
  end
  it "has metric_tank enabled" do
    expect(service("metric_tank")).to be_enabled
  end
end
