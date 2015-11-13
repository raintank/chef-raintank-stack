http_request "createMetricsTopic" do
  action :post
  url "http://127.0.0.1:4151/topic/create?topic=metrics"
  notifies :create, "ruby_block[nsqd_metrics_topic_created_flag]", :immediately
  notifies :post, "http_request[createKairosChannel]", :immediately
  notifies :post, "http_request[createElasticsearchChannel]", :immediately
  not_if { node.attribute?("nsqd_metrics_topic_created_flag") }
  subscribes :run, "service[nsqd]", :delayed
  retry_delay 10
  retries 6
end
ruby_block "nsqd_metrics_topic_created_flag" do
  block do
    node.set['nsqd_metrics_topic_created_flag'] = true
    unless Chef::Config[:solo]
      node.save
    end
  end
  action :nothing
end

http_request "createKairosChannel" do
  action :post
  url "http://127.0.0.1:4151/channel/create?topic=metrics&channel=kairos"
  notifies :create, "ruby_block[nsqd_kairos_channel_created_flag]", :immediately
  not_if { node.attribute?("nsqd_kairos_channel_created_flag") }
  subscribes :run, "service[nsqd]", :delayed
  retry_delay 10
  retries 6
end
ruby_block "nsqd_kairos_channel_created_flag" do
  block do
    node.set['nsqd_kairos_channel_created_flag'] = true
    unless Chef::Config[:solo]
      node.save
    end
  end
  action :nothing
end
http_request "createElasticsearchChannel" do
  action :post
  url "http://127.0.0.1:4151/channel/create?topic=metrics&channel=elasticsearch"
  notifies :create, "ruby_block[nsqd_elasticsearch_channel_created_flag]", :immediately
  not_if { node.attribute?("nsqd_elasticsearch_channel_created_flag") }
  subscribes :run, "service[nsqd]", :delayed
  retry_delay 10
  retries 6
end
ruby_block "nsqd_elasticsearch_channel_created_flag" do
  block do
    node.set['nsqd_elasticsearch_channel_created_flag'] = true
    unless Chef::Config[:solo]
      node.save
    end 
  end
  action :nothing
end
