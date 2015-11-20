require 'serverspec'

set :backend, :exec

describe "graphite" do
  it "is listening on port 8888" do
    expect(port(8888)).to be_listening
  end
  it "has graphite running" do
    expect(service("graphite-raintank")).to be_running
  end
  it "has graphite enabled" do
    expect(service("graphite-raintank")).to be_enabled
  end
end
