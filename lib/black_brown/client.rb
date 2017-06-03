require 'faraday'
require 'faraday_middleware'
require 'json'
module BlackBrown
  class Client
    END_POINT = "https://api.line.me"
    PUSH_PATH = "/v2/bot/message/push"
    attr_accessor :channel_access_token

    def initialize
      yield(self) if block_given?
    end

    #todo: implementation other than text
    def push(user_id, message)
      http_client.post do |request|
        request.url(PUSH_PATH)
        request.headers = default_post_header
        request.body = {
          to: user_id,
          messages: [{
            type: "text",
            text: message
          }]
        }
      end
    end

    private

    def http_client
      Faraday.new(:url => END_POINT) do |config|
        config.request :json
        config.response :logger
        config.adapter Faraday.default_adapter
      end
    end

    def default_post_header
      {
        "Authorization" => "Bearer #{channel_access_token}"
      }
    end
  end
end