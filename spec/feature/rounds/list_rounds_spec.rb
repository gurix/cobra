RSpec.describe 'listing rounds' do
  let(:tournament) { create(:tournament) }

  before do
    sign_in tournament.user
    visit tournament_rounds_path(tournament)
  end

  it 'is successful' do
    expect(page).to have_http_status :ok
  end
end
