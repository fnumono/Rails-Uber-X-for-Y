rails_env = new_resource.environment["RAILS_ENV"]

# start workers
execute "start workers" do
  cwd release_path
  command "sudo start workers"
  environment 'RAILS_ENV' => rails_env
end
