require 'pathname'

class Importer
  attr_reader :input_file_path

  def initialize(input:)
    @input_file_path = input
  end

  def call
    result = cached_result
    return result if result

    result = {
      videos: videos,
      endpoints: endpoints,
      caches: caches,
      requests: requests,
      latencies: latencies
    }

    cache_result(result)
    result
  end

  private

  def videos
    @videos ||= Videos.new(input_file_path: input_file_path).call
  end

  def endpoints
    @endpoints ||= Endpoints.new(input_file_path: input_file_path).call
  end

  def caches
    @caches ||= Caches.new(input_file_path: input_file_path).call
  end

  def requests
    @requests ||= Requests.new(
      input_file_path: input_file_path,
      videos: videos,
      endpoints: endpoints
    ).call
  end

  def latencies
    @latencies ||= Latencies.new(
      input_file_path: input_file_path,
      caches: caches,
      endpoints: endpoints
    ).call
  end

  def cached_result
    return unless File.exist?(dump_file_path)
    Marshal.load(File.binread(dump_file_path))
  end

  def cache_result(result)
    File.open(dump_file_path, 'wb') do |f|
      f.write(Marshal.dump(result))
    end
  end

  def dump_file_path
    @dump_file_path ||= begin
      path = Pathname.new(input_file_path)
      basename = path.basename
      digest = Digest::MD5.file(input_file_path)
      dump_file_name = "#{digest}-#{basename}.rb_object_dump"
      path = Pathname.new(path.dirname)
      path = path + dump_file_name
      path
    end
  end
end
