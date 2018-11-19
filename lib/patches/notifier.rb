require 'slack-notifier'

class Patches::Notifier
  class << self
    def notify_success(patches)
      send_slack_message(success_message(patches), 'good')
    end

    def notify_failure(patch_path, error)
      send_slack_message(failure_message(patch_path, error), 'danger')
    end

    def success_message(patches)
      message = "#{environment_prefix}#{patches.count} patches succeeded"
      append_tenant_message(message)
    end

    def failure_message(patch_path, error)
      details = "#{Pathname.new(patch_path).basename} failed with error: #{error}"
      message = "#{environment_prefix}Error applying patch: #{details}"
      append_tenant_message(message)
    end

    def environment_prefix
      "[#{Rails.env.upcase}] " if defined?(Rails)
    end

    def append_tenant_message(message)
      message = message + " for tenant: #{Apartment::Tenant.current}" if defined?(Apartment)
      message
    end

    def send_slack_message(message, color)
      return unless defined?(Slack) && config.use_slack

      notifier = Slack::Notifier.new(
        config.slack_webhook_url,
        channel: config.slack_channel,
        username: config.slack_username)

      payload = { icon_emoji: ":dog:", attachments: [{ color: color, text: message }] }

      notifier.post payload
    end

    private

    def config
      Patches::Config.configuration
    end
  end
end
