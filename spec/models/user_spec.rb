require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:sessions) }
  it { should have_many(:game_events) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:full_name) }

  context '#calculate_streak' do
    let(:subject) { User.make! }

    it 'should not find a streak' do
      expect(subject.calculate_streak).to eq(0)
    end

    context 'with game events' do
      let!(:game_event) { GameEvent.make!(game: Game.make!(category: :math), user: subject, occurred_at: Time.current - 1.day) }
      let!(:game_event2) { GameEvent.make!(game: Game.make!(category: :reading), user: subject, occurred_at: Time.current - 2.day) }
      let!(:game_event3) { GameEvent.make!(game: Game.make!(category: :writing), user: subject, occurred_at: Time.current - 4.day) }
      let!(:game_event4) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 5.day) }
      let!(:game_event5) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 6.day) }
      let!(:game_event6) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 7.day) }

      it 'should find a streak' do
        expect(subject.calculate_streak).to eq(2)
      end
    end
  end

  context '#stats_by_category' do
    let(:subject) { User.make! }

    it 'should not find a stats' do
      expect(subject.stats_by_category).to be_empty
    end

    context 'with game events' do
      let!(:game_event) { GameEvent.make!(game: Game.make!(category: :math), user: subject, occurred_at: Time.current - 1.day) }
      let!(:game_event2) { GameEvent.make!(game: Game.make!(category: :reading), user: subject, occurred_at: Time.current - 2.day) }
      let!(:game_event3) { GameEvent.make!(game: Game.make!(category: :writing), user: subject, occurred_at: Time.current - 4.day) }
      let!(:game_event4) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 5.day) }
      let!(:game_event5) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 6.day) }
      let!(:game_event6) { GameEvent.make!(game: Game.make!(category: :speaking), user: subject, occurred_at: Time.current - 7.day) }

      it 'should find a stats' do
        expect(subject.stats_by_category).to include("math"=>1, "reading"=>1, "speaking"=>3, "writing"=>1)
      end
    end
  end

end
