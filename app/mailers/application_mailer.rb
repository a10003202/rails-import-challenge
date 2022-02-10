class ApplicationMailer < ActionMailer::Base
  APP_CONFIG = YAML.load_file(Rails.root.join('config/application.yml'))[Rails.env]
  default from: APP_CONFIG['smtp']['from']
  layout 'mailer'
end
