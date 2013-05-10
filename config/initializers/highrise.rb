require 'highrise'

module CornerOffice
  highrise_config_path = Rails.root.join('config','highrise.yml')

  if File.file?(highrise_config_path)
    HIGHRISE_CONFIG = YAML.load_file(highrise_config_path)[Rails.env]
  else
    HIGHRISE_CONFIG = {
      "site"     => ENV['HIGHRISE_SITE'],
      "client_id" => ENV['HIGHRISE_CLIENT_ID'],
      "client_secret" => ENV['HIGHRISE_CLIENT_SECRET'],
      "authorize_url" => ENV['HIGHRISE_AUTHORIZE_URL'],
      "token_url"     => ENV['HIGHRISE_TOKEN_URL'],
    }
  end

  ActiveResource::Base.site = CornerOffice::HIGHRISE_CONFIG["site"]
end
