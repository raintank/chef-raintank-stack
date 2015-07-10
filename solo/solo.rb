node_name "all-in-one.raintank.io"
cookbook_path [ "~/.berkshelf/cookbooks" ]
solo true
syntax_check_cache_path "/tmp/chef-syntax"
file_backup_path "/tmp/chef/backup"
file_cache_path "/tmp/chef/cache"
environment_path "./examples"
log_level :info
log_location STDOUT
sandbox_path "/tmp/sandbox"
