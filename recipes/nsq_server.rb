include_recipe "nsq::nsqd"

nsqds = find_nsqd(4151)
node.override['nsq']['nsqadmin']['nsqd_http_address'] = nsqds

include_recipe "nsq::nsqadmin"

# nsq channels need to be created on launch, per 
# https://groups.google.com/forum/#!topic/nsq-users/zPhM9Nky_qM. However, is
# that just first launch, or all launches?
