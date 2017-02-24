class Importer
  class Latencies
    attr_reader :input_file_path, :endpoints, :caches

    def initialize(input_file_path:, endpoints:, caches:)
      @input_file_path = input_file_path
      @endpoints = endpoints
      @caches = caches
    end

    def call
      puts 'PARSING LATENCIES'
      parsing_latencies = false
      latency_counter = 0
      counter = -1
      endpoint_id = -1
      latencies = []

      File.foreach(input_file_path) do |line|
        counter += 1
        next unless counter >= 2
        components = line.split(' ')
        next if components.count > 2
        parsing_latencies = false if latency_counter <= 0
        latency_counter = components.last.to_i unless parsing_latencies
        unless parsing_latencies
          endpoint_id += 1
          parsing_latencies = true
          next
        end
        latency_counter -= 1 if parsing_latencies
        latencies << build_latency(components, endpoint_id)
      end

      latencies
    end

    private

    def build_latency(components, endpoint_id)
      cache_id = components.first.to_i
      time = components.last.to_i

      cache = caches[cache_id]
      endpoint = endpoints[endpoint_id]

      latency = Latency.new(
        endpoint: endpoint,
        cache: cache,
        time: time
      )

      cache.latencies << latency
      endpoint.latencies << latency

      latency
    end
  end
end
