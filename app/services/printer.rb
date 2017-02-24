##
# Handles printing an Array of Assignments as a table
#
class Printer
  COLUMN_MAPPINGS = {
    team: 'TEAM',
    local_time: 'Local time',
    utc_time: 'UTC time',
    task_id: 'TASK №'
  }.freeze
  SEPARATOR = ' | '.freeze

  attr_reader :assignments

  def initialize(assignments)
    @assignments = assignments.sort_by(&:start_time)
  end

  ##
  # Prints out the table
  #
  def call
    build_table
    calculate_padding

    puts
    puts 'SCHEDULE'
    print_header
    table.each do |row|
      print_row(row)
    end
    puts
  end

  protected

  attr_accessor :table
  attr_accessor :padding

  private

  ##
  # Converts the array of assignments into an Array of Hashes.
  # The Hash contains only strings as values.
  #
  def build_table
    @table = assignments.each_with_object([]) do |assignment, table|
      table << {
        team: assignment.team.city,
        local_time: local_time_for(assignment),
        utc_time: utc_time_for(assignment),
        task_id: assignment.task.id
      }
    end
  end

  ##
  # Converts local time to the desired format
  #
  def local_time_for(assignment)
    format_time_range(assignment.start_time, assignment.end_time)
  end

  ##
  # Converts local time to UTC and the formats it
  #
  def utc_time_for(assignment)
    format_time_range(assignment.start_time.utc, assignment.end_time.utc)
  end

  ##
  # Formats the start and end time to the following format:
  #   9am-1pm
  #
  def format_time_range(start_time, end_time)
    "#{start_time.strftime('%l%P')}-#{end_time.strftime('%l%P')}".gsub(/\s/, '')
  end

  ##
  # Calculats and memoizes the padding for each column
  #
  def calculate_padding
    @padding = {
      team: max_length_of_attribute_in_table(:team),
      local_time: max_length_of_attribute_in_table(:local_time),
      utc_time: max_length_of_attribute_in_table(:utc_time),
      task_id: max_length_of_attribute_in_table(:task_id)
    }
  end

  ##
  # Returns the max lengts of a string that will appear in a given column
  #
  def max_length_of_attribute_in_table(attribute)
    values = table.map { |row| row[attribute].length }
    values << COLUMN_MAPPINGS[attribute].length
    values.max
  end

  ##
  # Prints out the header
  #
  def print_header
    header = padded_string_from_row(COLUMN_MAPPINGS)
    puts '-' * header.length
    puts header
    puts '-' * header.length
  end

  ##
  # Prints out a single row
  #
  def print_row(row)
    puts padded_string_from_row(row)
  end

  ##
  # Convers each value of the row into a padded string and concatenates them
  # using the separator
  #
  def padded_string_from_row(row)
    row.map do |key, title|
      format("%-#{padding[key]}s", title)
    end.join(SEPARATOR)
  end
end
