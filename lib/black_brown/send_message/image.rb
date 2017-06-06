module BlackBrown
  module SendMessage
    class Image
      attr_accessor :original_content_url, :preview_image_url

      def get_hash
        {
          type: "image",
          original_content_url: self.original_content_url.to_s,
          preview_image_url: self.preview_image_url,
        }
      end
    end
  end
end