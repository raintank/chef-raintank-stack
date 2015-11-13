require 'serverspec'

set :backend, :exec

describe "nginx" do
  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end
  it "has nginx running" do
    expect(service("nginx")).to be_running
  end
  it "has nginx enabled" do
    expect(service("nginx")).to be_enabled
  end
end
