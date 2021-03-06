require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano-rbenv'

set :rbenv_ruby_version, open(File.expand_path('../../.ruby-version', __FILE__)).read.strip
set :rbenv_install_dependencies, false

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'

set :deploy_to, '/home/app/app'
set :user, 'app'

set :application, 'futurekids'
set :rails_env, 'production'

set :deploy_via, :remote_cache
set :scm, :git
set :default_run_options, pty: true
set :repository, 'git@github.com:panterch/future_kids.git'
set :ssh_options, forward_agent: true
set :use_sudo, false

after 'deploy', 'deploy:cleanup'

namespace :deploy do
  desc 'Restart Application'
  task :restart, roles: :app, except: { no_release: true } do
    run "RAILS_ENV=#{rails_env} $HOME/bin/unicorn_wrapper restart"
  end
end

task :update_config_links, roles: [:app] do
  run "mv #{release_path}/config/secrets.yml #{release_path}/config/secrets.dev.yml"
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after 'deploy:update_code', :update_config_links
