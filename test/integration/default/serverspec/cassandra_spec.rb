require 'serverspec'

set :backend, :exec

describe "cassandra" do
  it "is listening on port 9042" do
    expect(port(9042)).to be_listening
  end
  # raintank-stack still uses cassandra in a docker instance, so don't d
  # other tests for now.
end

describe package("cassandra") do
  it { should be_installed.with_version('2.1.9') }
end
