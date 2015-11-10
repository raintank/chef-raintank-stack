require 'serverspec'

set :backend, :exec

def grafana_db_exists
  <<-EOF
  /usr/bin/mysql \
  -h localhost \
  -P 3306 \
  -u root \
  -prootpass \
  -e "SHOW DATABASES;" \
  --skip-column-names
  EOF

end

def grafana_user_exists
  <<-EOF
  /usr/bin/mysql \
  -h localhost \
  -P 3306 \
  -u root \
  -prootpass \
  -e "SELECT Host,User FROM mysql.user WHERE User='grafana' AND Host='localhost';" \
  --skip-column-names
  EOF
end

describe "mariadb" do
  it "is listening on port 3306" do
    expect(port(3306)).to be_listening
  end
  it "has mariadb running" do
    expect(service("mysql")).to be_running
  end
  it "has mariadb enabled" do
    expect(service("mysql")).to be_enabled
  end
end

describe command(grafana_db_exists) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/grafana/) }
end

describe command(grafana_user_exists) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/| localhost | grafana |/) }
end
