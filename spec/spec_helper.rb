$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    require 'simplecov'
    SimpleCov.start
  end
end

require 'bundler/setup'
require 'rails/all'
require 'active_model'
require 'active_record'
require 'patches'
require 'pry'
require 'webmock/rspec'

# Sidekiq 7+ enables strict argument checking by default, and some consumers
# turn it off. Job arguments must work either way, so CI runs both.
if ENV['SIDEKIQ_STRICT_ARGS'] && !ENV['SIDEKIQ_STRICT_ARGS'].strip.empty?
  require 'sidekiq'
  Sidekiq.strict_args!(ENV['SIDEKIQ_STRICT_ARGS'] == 'false' ? false : :raise)
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: 'test.db')

unless ActiveRecord::Base.connection.table_exists?('patches_patches')
  ActiveRecord::Base.connection.execute("CREATE TABLE patches_patches (path VARCHAR, created_at TIMESTAMP, updated_at TIMESTAMP);")
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding perf: true
  config.order = 'random'
end
