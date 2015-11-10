require 'serverspec'

set :backend, :exec

describe "nsq_metrics_to_kairos" do
  it "has nsq_metrics_to_kairos running" do
    expect(service("nsq_metrics_to_kairos")).to be_running
  end
  it "has nsq_metrics_to_kairosdb enabled" do
    expect(service("nsq_metrics_to_kairos")).to be_enabled
  end
end
