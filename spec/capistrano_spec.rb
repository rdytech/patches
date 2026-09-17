require 'spec_helper'
require 'rake'

# Loaded the way a Capfile loads it - nothing else in the suite requires this
# file, so neither the deprecation nor the task definition was exercised.
describe 'patches/capistrano' do
  let(:capistrano_path) { File.expand_path('../lib/patches/capistrano.rb', __dir__) }

  around do |example|
    original_application = Rake.application
    original_behavior = Patches.deprecator.behavior
    Rake.application = Rake::Application.new
    @messages = []
    Patches.deprecator.behavior = ->(message, *) { @messages << message }
    example.run
  ensure
    Patches.deprecator.behavior = original_behavior
    Rake.application = original_application
  end

  it 'warns that the integration is removed in 4.0' do
    load capistrano_path

    expect(@messages.join).to include('patches/capistrano is deprecated')
    expect(@messages.join).to include('rake patches:run')
  end

  it 'defines the deploy task' do
    load capistrano_path

    expect(Rake::Task.task_defined?('patches:run')).to be(true)
  end
end
