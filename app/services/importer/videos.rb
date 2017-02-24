class Importer
  class Videos
    attr_reader :input_file_path

    def initialize(input_file_path:)
      @input_file_path ||= input_file_path
    end

    def call
      puts 'PARSING VIDEOS'
      video_sizes.each_with_index.map do |size, index|
        ::Video.new(id: index, size: size.to_i)
      end
    end

    def video_sizes
      video_sizes = File.foreach(input_file_path).first(2).last
      video_sizes.split(' ')
    end
  end
end
