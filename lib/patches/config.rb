module Patches
  class Config
    class << self
      class_attribute :use_sidekiq, :sidekiq_queue, :sidekiq_options, :use_hipchat, :hipchat_options

      def sidekiq_queue
        @sidekiq_queue ||= 'default'
      end

      def sidekiq_options
        @sidekiq_options ||= { retry: false, queue: Patches::Config.sidekiq_queue }
      end

      def configure
        yield self
      end
    end
  end
end