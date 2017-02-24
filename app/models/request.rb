class Request < BaseModel
  include Equalizer.new(:video, :endpoint, :count)

  attr_accessor :video, :endpoint, :count
end
