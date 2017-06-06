module BlackBrown
  module SendMessage
    class Text
      attr_accessor :text

      def get_hash
        {
          type: "text",
          text: self.text
        }
      end
    end
  end
end