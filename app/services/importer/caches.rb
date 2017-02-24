class Importer
  class Caches
    attr_reader :input_file_path

    def initialize(input_file_path:)
      @input_file_path = input_file_path
    end

    def call
      puts 'PARSING CACHES'
      (0...cache_count).map do |id|
        Cache.new(id: id, size: cache_size)
      end
    end

    private

    def cache_count
      @cache_count ||= first_line_components.last(2).first.to_i
    end

    def cache_size
      @cache_size ||= first_line_components.last(2).last.to_i
    end

    def first_line_components
      @first_line_components ||= File.foreach(input_file_path).first.split(' ')
    end
  end
end
