require 'serverspec'

set :backend, :exec

describe "rabbitmq" do
  it "is listening on port 5672" do
    expect(port(5672)).to be_listening
  end
  it "has rabbitmq running" do
    expect(service("rabbitmq")).to be_running
  end
end
