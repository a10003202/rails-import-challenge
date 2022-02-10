require_relative 'boot'

require 'rails/all'

# Load application ENV vars and merge with existing ENV vars. Loaded here so can use values in initializers.
ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsStarter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    APP_CONFIG = YAML.load_file(Rails.root.join('config/application.yml'))[Rails.env]
    config.action_mailer.default_url_options = {host: APP_CONFIG['default_url']}
    Rails.application.routes.default_url_options[:host] = APP_CONFIG['default_url']
    config.action_mailer.smtp_settings = {
      :user_name => APP_CONFIG['smtp']['user_name'],
      :password => APP_CONFIG['smtp']['password'],
      :address => APP_CONFIG['smtp']['address'],
      :domain => APP_CONFIG['smtp']['domain'],
      :port => APP_CONFIG['smtp']['port'],
      :authentication => APP_CONFIG['smtp']['authentication']
      #:enable_starttls_auto => APP_CONFIG['smtp']['enable_starttls_auto'],
      #:openssl_verify_mode => APP_CONFIG['smtp']['openssl_verify_mode'],
      #:ssl => APP_CONFIG['smtp']['ssl'],
      #:tls => APP_CONFIG['smtp']['tls']
    }
  end
end
