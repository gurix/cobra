class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :rounds, dependent: :destroy

  enum format: {
    swiss: 0,
    double_elim: 1
  }

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
    end
  end

  def standings
    Standings.new(self)
  end

  def players
    @players ||= tournament.players
  end

  def eligible_pairings
    rounds.complete.map(&:pairings).flatten
  end
end
