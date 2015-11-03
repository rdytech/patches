class Patches::Notifier
  class << self
    def notify_success(patches)
      send_hipchat_message(success_message(patches), color: 'green')
    end

    def notify_failure(patch_path, error)
      send_hipchat_message(failure_message(patch_path, error), color: 'red')
    end

    def success_message(patches)
      message = "#{environment_prefix}#{patches.count} patches succeeded"
      append_tenant_message(message)
    end

    def failure_message(patch_path, error)
      message = "#{environment_prefix}Error applying patch:"\
        " #{Pathname.new(patch_path).basename} failed with error: #{error}"
      append_tenant_message(message)
    end

    def environment_prefix
      "[#{Rails.env.upcase}] " if defined?(Rails)
    end

    def append_tenant_message(message)
      message = message + " for tenant: #{Apartment::Tenant.current}" if defined?(Apartment)
      message
    end

    private

    def send_hipchat_message(message, options)
      if defined?(HipChat) && Patches::Config.use_hipchat
        HipChat::Client.new(Patches::Config.hipchat_options[:api_token])[Patches::Config.hipchat_options[:room]].send(Patches::Config.hipchat_options[:user], message, options)
      end
    end
  end
end
