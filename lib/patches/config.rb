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
        attr_accessor :use_sidekiq, :sidekiq_queue, :sidekiq_options, :use_hipchat,
          :hipchat_options, :sidekiq_parallel, :use_slack, :slack_options

        def initialize
          @sidekiq_queue = 'default'
        end

        def sidekiq_options
          @sidekiq_options ||= { retry: false, queue: sidekiq_queue }
        end

        def hipchat_api_token
          hipchat_options[:api_token]
        end

        def hipchat_init_options
          hipchat_options.except(:api_token, :room, :user)
        end

        def hipchat_room
          hipchat_options[:room]
        end

        def hipchat_user
          hipchat_options[:user]
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
