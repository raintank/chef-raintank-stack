require 'serverspec'

set :backend, :exec

describe "nsqd" do
  it "is listening on port 4150" do
    expect(port(4150)).to be_listening
  end
  it "is listening on port 4151" do
    expect(port(4151)).to be_listening
  end
  it "has nsqd running" do
    expect(service("nsqd")).to be_running
  end
  it "has nsqd enabled" do
    expect(service("nsqd")).to be_enabled
  end
end

describe command("/usr/local/bin/nsqd --version") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/0.3.5/) }
end

describe command("curl 'http://localhost:4151/stats'") do
  its(:stdout) { should match(/metrics\s/) }
  its(:stdout) { should match(/metrics-lowprio/) }
  its(:stdout) { should match(/probe_events/) }
end

describe "nsqadmin" do
  it "is listening on port 4171" do
    expect(port(4171)).to be_listening
  end
  it "has nsqadmin running" do
    expect(service("nsqadmin")).to be_running
  end
  it "has nsqadmin enabled" do
    expect(service("nsqadmin")).to be_enabled
  end
end
