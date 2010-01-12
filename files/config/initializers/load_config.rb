APP_CONFIG = YAML.load(File.open("#{RAILS_ROOT}/config/config.yml"))[RAILS_ENV]

require "smtp_tls" if RUBY_VERSION == "1.8.6"

ActionMailer::Base.smtp_settings = {
  :address              => APP_CONFIG['smtp']['address'],
  :port                 => APP_CONFIG['smtp']['port'],
  :authentication       => APP_CONFIG['smtp']['authentication'].to_sym,
  :enable_starttls_auto => APP_CONFIG['smtp']['enable_starttls_auto'],
  :user_name            => APP_CONFIG['smtp']['user_name'],
  :password             => APP_CONFIG['smtp']['password'],
}

S3_CONFIG = APP_CONFIG['s3']

GMAPS_API_KEY = APP_CONFIG['gmaps']['api_key']

HoptoadNotifier.configure do |config|
  config.api_key = APP_CONFIG['hoptoad']['api_key']
end