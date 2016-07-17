rails_env = new_resource.environment["RAILS_ENV"]
shared_path = "#{new_resource.deploy_to}/shared"

# stop workers
execute "stop workers" do
  cwd release_path
  command "sudo stop workers"
  ignore_failure true
  environment 'RAILS_ENV' => rails_env
end

file "#{release_path}/config/settings.local.yml" do
  owner 'deploy'
  group 'www-data'
  mode 0755
  content ::File.open("#{shared_path}/config/settings.local.yml").read
  action :create
end
