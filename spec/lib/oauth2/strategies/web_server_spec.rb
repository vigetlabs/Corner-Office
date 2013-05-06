require "spec_helper"

describe OAuth2::Strategy::WebServer do
  describe "#authorize_params" do
    let(:client){ double }
    let(:web_server_strategy){ OAuth2::Strategy::WebServer.new(client) }
    before { client.stub(:id){ "client_id" } }

    it "returns a merged params hash" do
      web_server_strategy.authorize_params('test_param' => 'test_value').should ==
        { 'type' => 'web_server', 'client_id' => 'client_id', 'test_param' => 'test_value' }
    end
  end
end