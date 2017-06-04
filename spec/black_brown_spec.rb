require "spec_helper"

RSpec.describe BlackBrown do
  it "has a version number" do
    expect(BlackBrown::VERSION).not_to be nil
  end

  it "'parse_messages' method works correctly when the argument is a character string " do
    string_ary = BlackBrown::Client.new.send(:parse_messages, "hello world")
    expect(string_ary).to eq [{type: "text", text: "hello world"}]
  end

  it "'parse_messages' method works correctly when the argument is a array " do
    string_ary = BlackBrown::Client.new.send(:parse_messages, ["hello world", "shit"])
    expect(string_ary).to eq [{type: "text", text: "hello world"}, {type: "text", text: "shit"}]
  end
end
