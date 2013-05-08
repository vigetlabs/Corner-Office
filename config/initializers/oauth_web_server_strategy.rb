require 'oauth2/strategies/web_server'

# Required to use OAuth2 gem for the outdated oauth2 spec to which 37signals conforms
module OAuth2
  class Client
     def web_server
      @web_server ||= OAuth2::Strategy::WebServer.new(self)
    end
  end
end