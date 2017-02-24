class Latency < BaseModel
  include Equalizer.new(:endpoint, :cache, :time)

  attr_accessor :endpoint, :cache, :time

  def initialize(**args)
    super
    @requests ||= []
  end
end
