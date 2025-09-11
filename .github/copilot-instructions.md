# AI Coding Guidelines for Patches

## Overview

Patches is a Rails engine gem that provides a framework for running one-off database migration tasks (patches) in Rails applications. It supports both synchronous and asynchronous execution via Sidekiq, multi-tenant environments using the Apartment gem, Slack notifications, and application version validation.

## Architecture

### Core Components

1. **Patches Engine** (`lib/patches/engine.rb`)
   - Rails engine that integrates Patches into host applications
   - Provides database migrations and generators

2. **Base Patch Class** (`lib/patches/base.rb`)
   - Abstract base class that all patches inherit from
   - Defines the contract for patch execution

3. **Configuration System** (`lib/patches/config.rb`)
   - Centralized configuration management
   - Supports Sidekiq, Slack, and application version settings

4. **Execution Framework**
   - **Runner** (`lib/patches/runner.rb`) - Main execution engine for patches
   - **TenantRunner** (`lib/patches/tenant_runner.rb`) - Multi-tenant patch execution
   - **Worker** (`lib/patches/worker.rb`) - Sidekiq background job wrapper
   - **TenantWorker** (`lib/patches/tenant_worker.rb`) - Multi-tenant Sidekiq wrapper

5. **Notification System** (`lib/patches/notifier.rb`)
   - Slack integration for patch execution notifications
   - Configurable success/failure messaging

6. **Utilities**
   - **Patch** (`lib/patches/patch.rb`) - Patch metadata and validation
   - **Pending** (`lib/patches/pending.rb`) - Tracks unrun patches
   - **ApplicationVersionValidation** - Ensures patches run on correct app version

## Key Design Patterns

### Execution Flow
1. Patches are discovered from `db/patches/` directory
2. Only unrun patches are executed (tracked in `patches_patches` table)
3. Patches run in chronological order based on filename timestamp
4. Each patch inherits from `Patches::Base` and implements a `run` method

### Multi-Tenant Support
- Automatically detects Apartment gem presence
- Runs patches across all tenants when `sidekiq_parallel` is enabled
- Uses `TenantRunConcern` for shared tenant iteration logic

### Asynchronous Execution
- Optional Sidekiq integration via `use_sidekiq` configuration
- Application version validation prevents version mismatches during deployments
- Configurable retry logic for version mismatches

## Host Application Requirements

### Database Setup
```ruby
# Run migration installer
bundle exec rake patches:install:migrations
bundle exec rake db:migrate
```

### Configuration (Initializer)
```ruby
Patches::Config.configure do |config|
  # Optional: Asynchronous execution
  config.use_sidekiq = true
  config.sidekiq_parallel = true  # For multi-tenant parallel execution

  # Optional: Slack notifications
  config.use_slack = true
  config.slack_options = {
    webhook_url: ENV['SLACK_WEBHOOK_URL'],
    channel: ENV['SLACK_CHANNEL'],
    username: ENV['SLACK_USER']
  }

  # Optional: Application version validation
  config.application_version = File.read(Rails.root.join('REVISION'))
  config.retry_after_version_mismatch_in = 1.minute
end
```

### Patch Creation
```ruby
# Generate patch
bundle exec rails g patches:patch PatchName

# Generated patch structure
class PatchName < Patches::Base
  def run
    # Implementation goes here
  end
end
```