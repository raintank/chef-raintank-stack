require 'serverspec'

set :backend, :exec

describe "nsq_metrics_to_elasticsearch" do
  it "has nsq_metrics_to_elasticsearch running" do
    expect(service("nsq_metrics_to_elasticsearch")).to be_running
  end
  it "has nsq_metrics_to_elasticsearch enabled" do
    expect(service("nsq_metrics_to_elasticsearch")).to be_enabled
  end
end
