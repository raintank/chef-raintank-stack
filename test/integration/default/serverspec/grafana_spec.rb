require 'serverspec'

set :backend, :exec

describe "grafana" do
  it "is listening on port 3000" do
    expect(port(3000)).to be_listening
  end
  it "has grafana running" do
    expect(service("grafana-server")).to be_running
  end
  it "has grafana enabled" do
    expect(service("grafana-server")).to be_enabled
  end
end
describe "grafana configuration" do
  describe file("/etc/grafana/grafana.ini") do
    it { should be_file }
    its(:content) { should match(/portal.raintank.local/) }
    its(:content) { should match(/welcome_email_on_sign_up = false/) }
  end
  describe file("/etc/nginx/sites-enabled/grafana") do
    it { should be_symlink }
    its(:content) { should match(/portal.raintank.local/) }
  end
end
