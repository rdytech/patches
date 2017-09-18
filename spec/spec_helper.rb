$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "codeclimate-test-reporter"
require 'simplecov'

CodeClimate::TestReporter.start
SimpleCov.start

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
]

SimpleCov.configure do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'rails/all'
require 'database_cleaner'
require 'active_model'
require 'active_record'
require 'patches'
require 'pry'
require 'webmock/rspec'

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

