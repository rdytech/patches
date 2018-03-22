# Usage

## Initial Setup

Add patches to the project Gemfile

```ruby
gem 'patches', '~> 2.3.0'
```

Install the database migration

```bash
bundle exec rake patches:install:migrations
```

Migrate database

```bash
bundle exec rake db:migrate
```

## Configuration

If you would like to run the patches asynchronously, or would like them to notify your hipchat room when they fail or succeed, you need to set up an initializer to set those options.

```Ruby
Patches::Config.configure do |config|
  config.use_sidekiq = true

  config.use_hipchat = true
  config.hipchat_options = {
    api_token: ENV['HIPCHAT_TOKEN'],
    room: ENV['HIPCHAT_ROOM'],
    user: ENV['HIPCHAT_USERNAME'], # maximum of 15 characters
    api_version: 'v1', # optional
  }
end
```

### Running patches in parallel for tenants

If you are using the Apartment gem, you can run the patches for each tenant in parallel. Just set the config ```sidekiq_parallel``` to ```true``` and you're good to go.

```
Patches::Config.configure do |config|
  config.use_sidekiq = true
  config.sidekiq_parallel = true
end
```

*Note:* Make sure your sidekiq queue is able to process concurrent jobs. You can use ```config.sidekiq_options``` to customise it.

## Creating Patches

Generate a patch

```
bundle exec rails g patches:patch PreferenceUpdate
```

Which will result in a file like below

```ruby
class PreferenceUpdate < Patches::Base
  def run
    # Code goes here
  end
end
```

update the run method and then execute

Generate patch with specs

```
bundle exec rails g patches:patch PreferenceUpdate --specs=true
```


```bash
bundle exec rake patches:run
```

Patches will only ever run once, patches will run in order of creation date.

To run patches on deployment using Capistrano, edit your Capfile and add

```ruby
require 'patches/capistrano'
```

And then in your deploy.rb

```ruby
after 'last_task_you_want_to_run' 'patches:run'
```

If you are using sidekiq and restarting the sidekiq process on the box as a part of the deploy process, please make sure that the patches run task runs after sidekiq restarts, otherwise there is no guarentee the tasks will run.

## Multitenant

Patches will detect if `Apartment` gem is installed and if there are any tenants and run the patches for each tenant
