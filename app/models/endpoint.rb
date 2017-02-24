class Endpoint < BaseModel
  include Equalizer.new(:datacenter_latency, :id)

  attr_accessor :id, :requests, :latencies, :datacenter_latency

  def initialize(**args)
    super
    @requests ||= []
    @latencies ||= []
  end
end
