require 'serverspec'

set :backend, :exec

describe "nsq_probe_events_to_elasticsearch" do
  it "has nsq_probe_events_to_elasticsearch running" do
    expect(service("nsq_probe_events_to_elasticsearch")).to be_running
  end
  it "has nsq_probe_events_to_elasticsearch enabled" do
    expect(service("nsq_probe_events_to_elasticsearch")).to be_enabled
  end
end
