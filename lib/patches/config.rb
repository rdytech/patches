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
        include FileDownloaderConfigConcern

        attr_accessor :use_sidekiq, :sidekiq_queue, :sidekiq_options, :use_hipchat, :hipchat_options

        attr_reader :file_downloader

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
      end
    end
  end
end
