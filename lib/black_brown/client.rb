require 'faraday'
require 'faraday_middleware'
require 'json'
module BlackBrown
  class Client
    END_POINT = "https://api.line.me"
    PUSH_PATH = "/v2/bot/message/push"
    REPLY_PATH = "/v2/bot/message/reply"
    MULTICAST_PATH = "/v2/bot/message/multicast"
    PROFILE_PATH = "/v2/bot/profile"

    attr_accessor :channel_access_token, :channel_secret

    def initialize
      yield(self) if block_given?
    end

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


    def profile(user_id)
      profile_path = PROFILE_PATH + "/" + user_id.to_s
      response = http_client.get do |request|
        request.url(profile_path)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
      end
      BlackBrown::ProfileResult.new(JSON.parse(response.body))
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
      http_client.get do |request|
        request.url(profile_path)
        request.headers["Authorization"] = "Bearer #{channel_access_token}"
        request.headers["User-Agent"] = "BlackBrown v#{BlackBrown::VERSION}"
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

    def parse_messages(messages)
      return messages.kind_of?(Hash) ? messages : messages.get_hash
    end
  end
end
