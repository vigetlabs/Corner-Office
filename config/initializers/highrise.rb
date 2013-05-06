module CornerOffice
  if Rails.env.production?
    HIGHRISE_CONFIG = {
      "site"     => ENV['HIGHRISE_SITE'],
      "client_id" => ENV['HIGHRISE_CLIENT_ID'],
      "client_secret" => ENV['HIGHRISE_CLIENT_SECRET'],
      "authorize_url" => ENV['HIGHRISE_AUTHORIZE_URL'],
      "token_url"     => ENV['HIGHRISE_TOKEN_URL'],
    }
  else
    HIGHRISE_CONFIG = YAML.load_file(Rails.root.join('config','highrise.yml'))[Rails.env]
  end
end