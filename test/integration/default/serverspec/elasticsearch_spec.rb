require 'serverspec'

set :backend, :exec

describe "elasticsearch" do
  it "is listening on port 8080" do
    expect(port(9200)).to be_listening
  end
  it "has elasticsearch running" do
    expect(service("elasticsearch")).to be_running
  end
  it "has elasticsearch enabled" do
    expect(service("elasticsearch")).to be_enabled
  end
end
