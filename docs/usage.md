# Usage

## Initial Setup

Add patches to the project Gemfile

```ruby
gem 'patches', '~> 2.4.0'
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

If you would like to run the patches asynchronously, or would like them to notify
your Slack channel when they fail or succeed, you need to set up
an initializer to set those options.

```ruby
Patches::Config.configure do |config|
  config.use_sidekiq = true

  config.use_slack = true
  config.slack_options = {
    webhook_url: ENV['SLACK_WEBHOOK_URL'],
    channel: ENV['SLACK_CHANNEL'],
    username: ENV['SLACK_USER']
  }
end
```

Additionally, you can override the default prefix and suffix of the
notification message in the patches config:

```ruby
  # for example
  config.notification_prefix = "#{Tenant.current.name}-#{Rails.env}"  # => [READYTECH-STAGING]
  config.notification_suffix = Tenant.current.name  # => ... patches succeeded for Readytech
```

### Running patches in parallel for tenants

If you are using the Apartment gem, you can run the patches for each tenant in parallel.
Just set the config ```sidekiq_parallel``` to ```true``` and you're good to go.

```ruby
Patches::Config.configure do |config|
  config.use_sidekiq = true
  config.sidekiq_parallel = true
end
```

*Note:* Make sure your sidekiq queue is able to process concurrent jobs.
You can use ```config.sidekiq_options``` to customise it.

### Skipping tenants when running patches for multiple tenants

If you are using the Apartment gem, the patches will run across all tenants by default. If you wish to only run patches against a subset of tenants, you can use the `ONLY_TENANTS` env var, like so

```bash
# This will only run for my_tenant and other_tenant, provided they are listed as tenants by the Apartment gem
ONLY_TENANTS=my_tenant,other_tenant bundle exec rake patches:run
```

Similarly if you want to run patches against all tenants _except_ for a select few, you can use the `SKIP_TENANTS` env var, like so

```bash
# This will run for all tenants EXCEPT my_tenant and other_tenant
SKIP_TENANTS=my_tenant,other_tenant bundle exec rake patches:run
```

If you specify both env vars, the `ONLY_TENANTS` env var will take precedence

### Application version verification

In environments where a rolling update of sidekiq workers is performed during the deployment, multiple versions of the application run at the same time. If a Patches job is scheduled by the new application version during the rolling update, there is a possibility that it can be executed by the old application version, which will not have all the required patch files.

To prevent this case, set the application version in the config:

```ruby
Patches::Config.configure do |config|
  revision_file_path = Rails.root.join('REVISION')

  if File.exist?(revision_file_path)
    config.application_version = File.read(revision_file_path)
    config.retry_after_version_mismatch_in = 1.minute
  end
end
```

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

```bash
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

If you are using sidekiq and restarting the sidekiq process on the box
as a part of the deploy process, please make sure that the patches run task runs
after sidekiq restarts, otherwise there is no guarentee the tasks will run.

## File Download

If a patch requires data assets, you could use S3 to store the file.
If credentials are defined in env vars, as per https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#id1

```ruby
require 'aws-sdk-s3'
Aws::S3::Client.new.get_object(bucket: @bucket_name, key: filename, response_target: destination)
```

## Multitenant

Patches will detect if `Apartment` gem is installed and if there are any tenants
and run the patches for each tenant
