# Optional: an application that sets config.use_slack adds slack-notifier to its
# own Gemfile. Patches runs without it, and send_slack_message's `defined?(Slack)`
# guard - which could never be false while this require was unconditional - now
# does its job.
begin
  require 'slack-notifier'
rescue LoadError
  nil
end

class Patches::Notifier
  class << self
    def notify_success(patches)
      send_slack_message(success_message(patches), 'good')
    end

    def notify_failure(patch_path, error)
      send_slack_message(failure_message(patch_path, error), 'danger')
    end

    def success_message(patches)
      message(patches.count, "patches succeeded")
    end

    def failure_message(patch_path, error)
      message("Error applying patch:", Pathname.new(patch_path).basename, "failed with error:", error)
    end

    def message(*args)
      [notification_prefix, *args, notification_suffix].compact.join(" ")
    end

    def notification_prefix
      prefix = config.notification_prefix.presence || environment_prefix
      "[#{prefix}]" if prefix.present?
    end

    def environment_prefix
      Rails.env.upcase
    end

    def notification_suffix
      config.notification_suffix.presence || tenant_suffix
    end

    def tenant_suffix
      "for tenant: #{Apartment::Tenant.current}" if defined?(Apartment)
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
