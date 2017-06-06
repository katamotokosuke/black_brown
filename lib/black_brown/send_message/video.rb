module Video
  module SendMessage
    class Video
      attr_accessor :original_content_url, :preview_image_url

      def get_hash
        {
          type: "video",
          original_content_url: self.original_content_url.to_s,
          preview_image_url: self.preview_image_url,
        }
      end
    end
  end
end