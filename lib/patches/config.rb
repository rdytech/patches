require 'patches/deprecation'

module Patches
  class Config
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configuration=(config)
        @configuration = config
      end

      def configure
        yield configuration
      end

      class Configuration
        attr_accessor \
          :application_version,
          :notification_prefix,
          :notification_suffix,
          :retry_after_version_mismatch_in,
          :sidekiq_options,
          :sidekiq_parallel,
          :sidekiq_queue,
          :slack_options,
          :use_sidekiq,
          :use_slack

        def initialize
          @sidekiq_queue = 'default'
        end

        # Warns only for applications that enable Slack, and only the first time
        # - an initializer that reloads, or configures twice, should not repeat
        # the notice.
        def use_slack=(enabled)
          if enabled && !@warned_about_slack_notifier
            @warned_about_slack_notifier = true
            Patches.warn_slack_notifier_dependency_removed_in_4_0
          end

          @use_slack = enabled
        end

        def sidekiq_options
          @sidekiq_options ||= { retry: false, queue: sidekiq_queue }
        end

        def retry_after_version_mismatch_in
          @retry_after_version_mismatch_in ||= 1.minute
        end

        def slack_channel
          slack_options[:channel]
        end

        def slack_username
          slack_options[:username]
        end

        def slack_webhook_url
          slack_options[:webhook_url]
        end
      end
    end
  end
end
