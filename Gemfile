source 'https://rubygems.org'

gemspec

# rails, sqlite3, concurrent-ruby and sidekiq are declared here rather than in
# the gemspec so that CI can vary them across the support matrix in README.md.
# Reproduce any CI cell locally by setting the same variables:
#
#   RAILS_VERSION="~> 7.0.0" SQLITE3_VERSION="~> 1.4" bundle install
#   bundle exec rspec
#
# An unset *or empty* value falls back to the default, because GitHub Actions
# passes an empty string for matrix keys a given cell doesn't define.
def version_requirement(name, default = nil)
  value = ENV.fetch(name, '').strip
  value.empty? ? default : value
end

# Unset, this resolves to the newest Rails the running Ruby allows. The gemspec
# floor stays at railties >= 3.2; see Compatibility in README.md for the range
# CI verifies.
gem 'rails', version_requirement('RAILS_VERSION', '>= 7.1')

# Rails pins its sqlite3 adapter: <= 7.0 needs `~> 1.4`, 7.1 accepts either,
# 8.0+ needs `>= 2.1`. Unset, bundler picks the newest 2.x.
gem 'sqlite3', version_requirement('SQLITE3_VERSION', '>= 1.4')

# Rails < 7.1 predates concurrent-ruby 1.3.5 removing the Logger constant that
# ActiveSupport::LoggerThreadSafeLevel expects.
concurrent_ruby = version_requirement('CONCURRENT_RUBY_VERSION')
gem 'concurrent-ruby', concurrent_ruby if concurrent_ruby

# Sidekiq is an optional integration, not a runtime dependency. SIDEKIQ_VERSION
# =none leaves it out entirely so the `defined?(Sidekiq)` guards get exercised.
# The library itself still supports older Sidekiq through
# Patches.sidekiq_job_module; this default only picks what the suite runs
# against by default.
sidekiq = version_requirement('SIDEKIQ_VERSION')
gem 'sidekiq', *[sidekiq].compact unless sidekiq == 'none'
