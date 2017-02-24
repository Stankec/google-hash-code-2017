class Assigner
  attr_reader :caches
  attr_reader :videos

  def initialize(caches, videos)
    @caches = caches
    @videos = videos
  end

  def call
    return [] if caches.nil? || videos.nil?
    build_matrix
    munkres = Munkres.new(matrix)
    pairings = munkres.find_pairings
    build_assignments_from_pairings(pairings)
  end

  protected

  attr_accessor :matrix

  private

  def build_matrix
    size = [caches.count, videos.count].max
    @matrix = (0...size).map do |y|
      (0...size).map do |x|
        cache = caches[y]
        video = videos[x]
        cache && video ? cache.weight_for_video(video) : 0
      end
    end
  end

  def build_assignments_from_pairings(pairings)
    pairings.map do |y, x|
      cache = caches[y]
      video = videos[x]
      next if cache.nil? || video.nil?
      Assignment.new(cache: cache, video: video)
    end.compact
  end
end
