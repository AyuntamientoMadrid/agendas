# config valid only for current version of Capistrano
lock '3.4.1'

def deploysecret(key)
  @deploy_secrets_yml ||= YAML.load_file('config/deploy-secrets.yml')[fetch(:stage).to_s]
  @deploy_secrets_yml[key.to_s]
end

set :rails_env, fetch(:stage)
#set :rvm_ruby_version, '2.3.5'
set :rvm_type, :user

set :application, 'agendas'
set :server_name, deploysecret(:server_name)
set :full_app_name, fetch(:application)
# If ssh access is restricted, probably you need to use https access
set :repo_url, 'https://github.com/AyuntamientoMadrid/agendas.git'

set :scm, :git
set :revision, `git rev-parse --short #{fetch(:branch)}`.strip

set :log_level, :info
set :pty, true
set :use_sudo, false

set :linked_files, %w{config/database.yml config/secrets.yml config/sunspot.yml}
set :linked_dirs, %w{log tmp public/system public/assets public/export}

set :keep_releases, 10

set :local_user, ENV['USER']

# Run test before deploy
set :tests, ["spec"]

set :whenever_roles, [:export, :cron]
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Config files should be copied by deploy:setup_config
set(:config_files, %w(
  log_rotation
  database.yml
  secrets.yml
  unicorn.rb
  sunspot.yml
))

namespace :deploy do
  # Check right version of deploy branch
  # before :deploy, "deploy:check_revision"

  # Run test aund continue only if passed
  # before :deploy, "deploy:run_tests"

  # Compile assets locally and then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :maintenance do
  desc "Maintenance mode start"
  task :start do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'maintenance:start reason="Estamos realizando tareas de mantenimiento"'
        end
      end
    end
  end

  desc "Maintenance mode stop"
  task :stop do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'maintenance:end'
        end
      end
    end
  end
end
