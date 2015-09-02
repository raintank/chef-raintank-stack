include_recipe "nsq::nsqd"
include_recipe "nsq::nsqadmin"

# nsq channels need to be created on launch, per 
# https://groups.google.com/forum/#!topic/nsq-users/zPhM9Nky_qM. However, is
# that just first launch, or all launches?
