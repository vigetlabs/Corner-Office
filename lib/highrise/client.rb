require 'oauth2/strategies/web_server'

module Highrise
  class Client < OAuth2::Client
    def initialize
      super(
        CornerOffice::HIGHRISE_CONFIG["client_id"],
        CornerOffice::HIGHRISE_CONFIG["client_secret"],
        {
          :authorize_url => CornerOffice::HIGHRISE_CONFIG["authorize_url"],
          :token_url     => CornerOffice::HIGHRISE_CONFIG["token_url"],
          :site          => 'https://launchpad.37signals.com/'
        }
      )
    end
  end
end
