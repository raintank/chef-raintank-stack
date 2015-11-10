require 'serverspec'

set :backend, :exec

describe "kairosdb" do
  it "is listening on port 8080" do
    expect(port(8080)).to be_listening
  end
  it "has kairosdb running" do
    expect(service("kairosdb")).to be_running
  end
  it "has kairosdb enabled" do
    expect(service("kairosdb")).to be_enabled
  end
end
