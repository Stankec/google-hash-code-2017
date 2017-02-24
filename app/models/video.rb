class Video < BaseModel
  include Equalizer.new(:size, :requests, :id)

  attr_accessor :id, :size, :requests

  def initialize(**args)
    super
    @requests ||= []
  end
end
