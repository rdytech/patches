# Usage

## Initial Setup

Add patches to the project Gemfile

```ruby
gem 'patches', '~> 1.0'
```

Install the database migration

```bash
bundle exec rake patches:install:migrations
```

Migrate database

```bash
bundle exec rake db:migrate
```

If you would like to run the patches asynchronously, or would like them to notify your hipchat room when they fail or succeed, you need to set up an initializer to set those options.

```Ruby
Patches::Config.configure do |config|
  config.use_sidekiq = true

  config.use_hipchat = true
  config.hipchat_options = {
    api_token: HIPCHATAPITOKEN,
    room: HIPCHATROOMNAME,
    user: HIPCHATUSER #maximum of 15 characters
  }
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


```bash
bundle exec rake patches:run
```

Patches will only ever run once, patches will run in order of creation date.

To run patches after db:migrate on deployment edit Capfile and add

```ruby
require 'patches/capistrano'
```

## Multitenant

Patches will detect if `Apartment` gem is installed and if there are any tenants and run the patches for each tenant
