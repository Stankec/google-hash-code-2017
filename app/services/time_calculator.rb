##
# Handles calculating of the time required for a team to solve a task
#
class TimeCalculator
  attr_reader :team
  attr_reader :task

  def initialize(team, task)
    @team = team
    @task = task
  end

  ##
  # Returns the time required to solve a given task.
  #
  def call
    return if team.nil? || task.nil?
    return if task.development_time.nil? || task.test_time.nil?
    return if team.development_efficiency_multiplier.nil?
    return if team.qa_efficiency_multiplier.nil?

    development_time =
      team.development_efficiency_multiplier * task.development_time
    test_time = team.qa_efficiency_multiplier * task.test_time
    development_time + test_time
  end
end
