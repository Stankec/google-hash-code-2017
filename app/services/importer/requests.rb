class Importer
  class Requests
    attr_reader :input_file_path, :videos, :endpoints

    def initialize(input_file_path:, videos:, endpoints:)
      @input_file_path = input_file_path
      @videos = videos
      @endpoints = endpoints
    end

    def call
      puts 'PARSING REQUESTS'
      counter = -1
      requests = []

      File.foreach(input_file_path) do |line|
        counter += 1
        next unless counter >= 2
        components = line.split(' ')
        next unless components.count < 3
        requests << build_request(components)
      end

      requests
    end

    private

    def build_request(components)
      video_id = components[0].to_i
      endpoint_id = components[1].to_i
      count = components[2].to_i

      video = videos[video_id]
      endpoint = endpoints[endpoint_id]

      request = Request.new(
        video: video,
        endpoint: endpoint,
        count: count
      )

      video.requests << request
      endpoint.requests << request

      request
    end
  end
end
