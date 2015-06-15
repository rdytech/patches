namespace :deploy do
  desc 'Runs rake patches:run'
  task :patches do
     on primary fetch(:migration_role) do
        within release_path do
           with rails_env: fetch(:rails_env) do
              execute :rake, "patches:run"
           end
        end
     end
  end
  after 'deploy:migrate', 'deploy:patches'
end
