class Solver
  attr_reader :videos
  attr_reader :caches

  def initialize(videos:, caches:)
    @videos = videos
    @caches = caches
  end

  def call
    return if videos.nil? || caches.nil?
    initialize_internal_values

    available_videos.count.times do
      assignemnts = assign_video_to_cache_from(caches_available)
      require 'pry'; binding.pry
      assignemnts.map { |assignemnt| assign(assignemnt, timestamp) }
      require 'pry'; binding.pry
    end
    result
  end

  protected

  attr_reader :available_videos
  attr_reader :assigned
  attr_reader :unassigned

  private

  def initialize_internal_values
    @available_videos = videos.dup
    @assigned = []
    @unassigned = []
  end

  def caches_available
    caches - full_caches
  end

  def full_caches
    video_sizes = videos.map(&:size)

    cache_free_space = {}

    assigned.each do |assignment|
      cache_free_space[assignment.cache] ||= assignment.cache.size
      cache_free_space[assignment.cache] -= assignment.video.size
    end

    cache_free_space.map do |cache, free_space|
      free = false
      video_sizes.each do |size|
        free ||= free_space >= size
      end

      free ? cache : nil
    end.compact
  end

  def assign_video_to_cache_from(caches)
    Assigner.new(caches, available_videos).call
  end

  def assign(assignemnt)
    if !assignemnt.valid?(assigned)
      unassigned << assignemnt
      return
    end
    assigned << assignemnt
    available_videos.delete(assignemnt.video)
  end

  def result
    {
      assigned: assigned,
      unassigned: unassigned
    }
  end
end
