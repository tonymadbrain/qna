RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:like_user) { create(:user) }
  let(:dislike_user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym, user: user) }
  let!(:first_vote) { create(:vote, user: first_user, votable: votable) }
  let!(:second_vote) { create(:vote, user: second_user, votable: votable) }

  describe 'user votes' do
    it 'like' do
      expect{ votable.vote(like_user, 1) }.to change(votable.votes, :count).by(1)
    end

    it 'dislike' do
      expect{ votable.vote(dislike_user, -1) }.to change(votable.votes, :count).by(1)
    end
  end

  describe 'user un-votes' do
    it 'denies' do
      expect{ votable.disvote(first_user) }.to change(votable.votes, :count).by(-1)
    end
  end

  describe 'user checks' do
    it 'voted by?' do
      expect( votable.voted_by?(first_user) ).to be true
      expect( votable.voted_by?(second_user) ).to be true
    end
  end

  describe 'rating' do
    it "counts rating" do
      expect(votable.total_votes).to eq 2
    end
  end
end