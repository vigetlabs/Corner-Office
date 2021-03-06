# Required to use OAuth2 gem for the outdated oauth2 spec to which 37signals conforms
module OAuth2
  module Strategy
    class WebServer < AuthCode
      def authorize_params(params={})
        params.merge('type' => 'web_server', 'client_id' => @client.id)
      end
    end
  end
end
