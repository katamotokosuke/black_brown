require 'faraday'
require 'faraday_middleware'
require 'json'
module BlackBrown
  class Client
    END_POINT = "https://api.line.me"
    PUSH_PATH = "/v2/bot/message/push"
    REPLY_PATH = "/v2/bot/message/reply"

    attr_accessor :channel_access_token, :channel_secret

    def initialize
      yield(self) if block_given?
    end

    #user_id(require type: string): The id of the user you want to send to message
    #messages(requre: array or string): Contents of the message to be sent
    def push(user_id, messages)
      http_client.post do |request|
        request.url(PUSH_PATH)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
        request.body = {
          to: user_id,
          messages: parse_messages(messages)
        }
      end.success?
    end

    def reply(reply_token, messages)
      http_client.post do |request|
        request.url(REPLY_PATH)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
        request.body = {
          replyToken: reply_token,
          messages: parse_messages(messages)
        }
      end.success?
    end

    private

    def http_client
      Faraday.new(:url => END_POINT) do |config|
        config.request :json
        config.response :logger
        config.adapter Faraday.default_adapter
      end
    end

    def parse_messages(messages)
      res = []
      if messages.is_a?(Array)
        messages.each do |item|
          res << { type: "text", text: item }
        end
      else
        res << { type: "text", text: messages.to_s }
      end
      res
    end
  end
end