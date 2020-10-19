require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lvfp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.web_console.whiny_requests = false

    # Adding custom fonts
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = {
      api_token: "95612744-b9e3-4af2-9de2-746693b28d21"
    }
  end
end
