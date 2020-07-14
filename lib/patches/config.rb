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
