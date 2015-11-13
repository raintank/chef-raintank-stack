require 'serverspec'

set :backend, :exec

describe "cassandra" do
  it "is listening on port 9042" do
    expect(port(9042)).to be_listening
  end
end

describe package("cassandra") do
  it { should be_installed }
  its(:version) { should eq '2.1.9' }
end
