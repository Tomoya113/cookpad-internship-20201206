class Poll
  attr_reader :title, :candidates, :votes, :voters, :deadline

  class InvalidCandidateError < StandardError
  end

  class InvalidVoterError < StandardError
  end

  class InvalidVoteTimeError < StandardError
  end

  def initialize(title, candidates, deadline = nil)
    @title = title
    @candidates = candidates
    @votes = []
    @voters = []
    @deadline = deadline
  end

  def add_vote(vote)
    unless candidates.include?(vote.candidate)
      raise InvalidCandidateError
    end

    if voters.include?(vote.voter)
      raise InvalidVoterError
    end

    if deadline != nil && Time.now.to_i > deadline
      raise InvalidVoteTimeError
    end

    @votes.push(vote)
    @voters.push(vote.voter)

  end
end
