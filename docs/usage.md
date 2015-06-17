# Usage

Install the migration

```
bundle exec rake patches:install:migrations
```

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

Patches will only ever run once, patches will run in order.

To run patches after db:migrate on deployment edit Capfile and add

```ruby
require 'patches/capistrano'
```
