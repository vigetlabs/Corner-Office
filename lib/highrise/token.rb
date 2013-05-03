require 'oauth2/strategies/web_server'

module Highrise
  class Token
    def self.authorize_url
      client.web_server.authorize_url({
        :redirect_uri  => Rails.application.routes.url_helpers.authorize_url
      })
    end

    def initialize(authorization_code)
      @token = self.class.client.web_server.get_token(authorization_code,
        {
          "type"         => "web_server",
          "redirect_uri" => Rails.application.routes.url_helpers.authorize_url
        }
      )
    end

    def secret
      @token.token
    end

    private

    def self.client
      Highrise::Client.new
    end
  end
end
