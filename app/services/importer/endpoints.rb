class Importer
  class Endpoints
    attr_reader :input_file_path

    def initialize(input_file_path:)
      @input_file_path = input_file_path
    end

    def call
      puts 'PARSING ENDPOINTS'
      parsing_latencies = false
      latency_counter = 0
      counter = -1
      endpoint_id = -1
      endpoints = []

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

          endpoints << build_endpoint(components, endpoint_id)
          next
        end
        latency_counter -= 1 if parsing_latencies
      end

      endpoints
    end

    private

    def build_endpoint(components, endpoint_id)
      Endpoint.new(
        id: endpoint_id,
        datacenter_latency: components.first.to_i
      )
    end
  end
end
