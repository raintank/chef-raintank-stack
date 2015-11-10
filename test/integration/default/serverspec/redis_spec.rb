require 'serverspec'

set :backend, :exec

describe "redis-server" do
  it "is listening on port 6379" do
    expect(port(6379)).to be_listening
  end
  it "has redis-server running" do
    expect(service("redis-server")).to be_running
  end
end
