class Vote
  attr_reader :voter, :candidate, :deadline
  def initialize(voter, candidate, deadline = nil)
    @voter = voter
    @candidate = candidate
    @deadline = deadline
  end
end