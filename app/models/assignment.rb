class Assignment < BaseModel
  include Equalizer.new(:cache, :video)

  attr_accessor :cache, :video

  def valid?(assignments)
    return if cache.nil? || video.nil?

    full = 0
    assignments.each do |assignment|
      if assignment.cache == cache
        full += video.size
      end
    end

    full <= cache.size
  end
end
