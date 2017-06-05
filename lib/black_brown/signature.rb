module BlackBrown
  class Signature
    def self.is_signature_valid?(line_channel_signature, channel_secret, request_body)
      signature = Base64.strict_encode64(OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, channel_secret, request_body))
      line_channel_signature == signature
    end
  end
end