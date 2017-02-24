class Cache < BaseModel
  include Equalizer.new(:size, :id)

  attr_accessor :latencies, :id, :size

  def initialize(**args)
    super
    @latencies ||= []
  end

  def weight_for_video(video)
    latencies.map do |latency|
      time = latency.time
      request = latency.endpoint.requests.select { |r| r.video == video }.first

      if request
        time * request.count
      else
        0
      end
    end.inject(&:+)
  end
end
