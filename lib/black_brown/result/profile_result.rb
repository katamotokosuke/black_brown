module BlackBrown
  class ProfileResult
    attr_accessor :display_name, :user_id, :picture_url, :status_message

    #todo: The key must be snake_case
    def initialize(options={})
      options.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end

    #todo: make success? method
    def success?
    end

  end
end