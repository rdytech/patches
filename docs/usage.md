
mkdir db/patches

```ruby
class PreferenceUpdate < Patches::Patch
  def perform
  end
end
```

```bash
bundle exec rake db:patch
```
