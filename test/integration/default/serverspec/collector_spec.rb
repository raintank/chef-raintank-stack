require 'serverspec'

set :backend, :exec

describe "raintank-collector" do
  it "is listening on port 9090" do
    expect(port(8080)).to be_listening
  end
  it "has raintank-collector running" do
    expect(service("raintank-collector")).to be_running
  end
  it "has raintank-collector enabled" do
    expect(service("raintank-collector")).to be_enabled
  end
end
