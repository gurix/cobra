RSpec.describe Stage do
  let(:tournament) { create(:tournament) }
  let(:stage) { create(:stage, tournament: tournament) }

  describe '#pair_new_round!' do
    it 'creates new round with pairings' do
      expect do
        round = stage.pair_new_round!

        expect(
          round.pairings.map(&:players).flatten
        ).to match_array(tournament.players)
      end.to change(stage.rounds, :count).by(1)
    end

    describe 'round numbers' do
      it 'creates first with number 1' do
        expect(stage.pair_new_round!.number).to eq(1)
      end

      it 'adds to previous highest' do
        round = create(:round, stage: stage, number: 4)

        expect(stage.pair_new_round!.number).to eq(5)
      end
    end
  end

  describe '#standings' do
    let(:standings) { instance_double('Standings') }

    before do
      allow(Standings).to receive(:new).and_return(standings)
    end

    it 'returns standings object' do
      expect(stage.standings).to eq(standings)
      expect(Standings).to have_received(:new).with(stage)
    end
  end

  describe '#players', :skip do
    it 'only returns players from this stage' do
    end
  end

  describe '#eligible_pairings' do
    let(:round1) { create(:round, stage: stage, completed: true) }
    let(:round2) { create(:round, stage: stage, completed: false) }
    let!(:pairing1) { create(:pairing, round: round1) }
    let!(:pairing2) { create(:pairing, round: round2) }

    it 'only returns pairings from completed rounds' do
      expect(stage.eligible_pairings).to eq([pairing1])
    end
  end
end
