require 'faraday'
require 'faraday_middleware'
require 'json'
module BlackBrown
  class Client
    END_POINT = "https://api.line.me"
    PUSH_PATH = "/v2/bot/message/push"
    MULTICAST_PATH = "/v2/bot/message/multicast"
    PROFILE_PATH = "/v2/bot/profile"

    attr_accessor :channel_access_token

    def initialize
      yield(self) if block_given?
    end

    def multicast(to_ary, messages)
      http_client.post do |request|
        request.url(MULTICAST_PATH)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
        request.body ={
            to: to_ary,
            messages: parse_messages(messages)
        }
      end.success?
    end

    def profile(user_id)
      profile_path = PROFILE_PATH + "/" + user_id.to_s
      response = http_client.get do |request|
        request.url(profile_path)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
      end
      BlackBrown::ProfileResult.new(JSON.parse(response.body))
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